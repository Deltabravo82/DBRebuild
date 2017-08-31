//
//  ViewController.m
//  Rebuild1
//
//  Created by William Langenbach on 8/17/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "ViewController.h"
#import "Marker.h"
#import "model.h"



@interface ViewController ()

@property (strong,nonatomic) Marker *toolMarker;
@property (strong,nonatomic) Marker *targetMarker;
@property   (strong,nonatomic) model *dataModel;

@property (nonatomic) float aspectRatio;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    //CorePlot graph setup
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:_hostView.bounds];
    _hostView.hostedGraph = graph;
    CPTTheme *newTheme= [CPTTheme themeNamed:kCPTStocksTheme];
    [graph applyTheme:newTheme];
    
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    _aspectRatio=_hostView.bounds.size.height / _hostView.bounds.size.width;
        //[plotSpace set]
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)[graph axisSet];
    
    // Set Range
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:-90.0*_aspectRatio] length:[NSNumber numberWithFloat:180.0*_aspectRatio]]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:-90.0] length:[NSNumber numberWithFloat:180.0]]];
    

    //Formatting
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineColor=[CPTColor whiteColor];

    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineColor=[CPTColor grayColor];
    majorGridLineStyle.lineWidth=0.5;
    
    NSNumberFormatter *axisFormatter = [[NSNumberFormatter alloc] init];
    [axisFormatter setMinimumIntegerDigits:1];
    [axisFormatter setMaximumFractionDigits:0];

    CPTXYAxis *xAxis = [axisSet xAxis];
    [xAxis setMajorIntervalLength:[NSNumber numberWithInteger:10]];
    [xAxis setMajorTickLineStyle:axisLineStyle];
    [xAxis setMinorTickLineStyle:nil];

    [xAxis setLabelFormatter:axisFormatter];
    [xAxis setMajorGridLineStyle:majorGridLineStyle];
    xAxis.orthogonalPosition=[NSNumber numberWithDouble:(0.0)];
    

    CPTXYAxis *yAxis = [axisSet yAxis];
    [yAxis setMajorIntervalLength:[NSNumber numberWithInteger:10]];
    [yAxis setMajorTickLineStyle:axisLineStyle];
    [yAxis setMinorTickLineStyle:nil];
    [yAxis setLabelFormatter:axisFormatter];
    [yAxis setMajorGridLineStyle:majorGridLineStyle];
    yAxis.orthogonalPosition=[NSNumber numberWithDouble:(0.0)];
    //Filling the background. Should work on finding a way to increase the area the actual plot takes up
    
    [graph setFill:[CPTFill fillWithColor:[CPTColor clearColor]]];
    //[graph setFill:[CPTFill fillWithGradient:[CPTGradient gradientWithBeginningColor:[CPTColor blueColor] endingColor:[CPTColor blackColor]]]];
    //TODO: Add in graph formattting options
    
    //Add Plot to Graph
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    [graph setAxisSet:axisSet];
    
    // Private property setup for UI objects
    
    _dataModel=[[model alloc] init];
    
    Marker *newTarget= [[Marker alloc] initWithFrame:CGRectMake(_hostView.center.x-100, _hostView.center.y-75, 200, 150)];
    [newTarget setFillColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.5]];
    [_hostView addSubview:newTarget];
    _targetMarker=newTarget;
    [_targetMarker setHidden:YES];
    
    _toolMarker= [[Marker alloc] initWithFrame:CGRectMake(_hostView.center.x, _hostView.center.y, 25, 25)];
    [_toolMarker setFillColor:[UIColor blackColor]];
    [_hostView addSubview:_toolMarker];
    
    // Do any additional setup after loading the view, typically from a nib.
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectViewUpdate:) name:@"disconnectViewUpdate" object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnect:) name:@"BeanConnected" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( labelUpdate:)name:@"updateLabels" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"UpdateTableNotification" object:nil];
    // Notifications related to Model commands
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(updateTarget:) name:@"TargetChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateToolPosition:) name:@"Tool Moved" object:nil];

}

-(void)updateTable:(NSNotification *)notification
{
    NSLog(@"VC received update table");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//change offset location storage to model, or tell delegate to send it to model
// Nice to have: set it so calibrate has a toggled behavior of "clear calibration". Refer to Lecture 2 or 3 from Stanford course to set this up. Should be a 1 hour job
- (IBAction)calibrate:(id)sender
{
    _dataModel.medialOffset=_dataModel.medialAngle;
    _dataModel.sagittalOffset=_dataModel.sagittalAngle;
    
}
//TODO: program centering behavior when set target is called

// Nice to have: set it so set Target has a toggled behavior of "clear target". Refer to Lecture 2 or 3 from Stanford course to set this up. Should be a 1 hour job
- (IBAction)setTarget:(id)sender
{
    NSString *roll= [NSString stringWithFormat:@"%1.1f", (delegate.rollAngle-delegate.rollOffset)];
    NSString *pitch=[NSString stringWithFormat:@"%1.1f", (delegate.pitchAngle-delegate.pitchOffset)];
    //Update so that it still shows the correct angle type with the pitch or yaw. Do something with appending string to existing string. Potentially have the text blank and have it as a text set in the view did load script

    //TODO: update and change to directly change model
    [self.targetRoll setText:roll];
    [self.targetPitch setText:pitch];
    
}
-(void) timerReadScratch:(NSTimer *)timer
{
    [delegate.bean readScratchBank:1];

}



#pragma mark - NS Notificaiton selectors
-(void)didConnect:(NSNotification *)notificaiton
{
    _statusLabel.text=@"Tool connected!";
    if(!delegate.bean)
    {
        NSLog(@"No tool connected");
        return;
    }
    if(![_myTimer isValid])
    {
        _myTimer=[NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(timerReadScratch:) userInfo:nil repeats:YES];
        
    }
    else
    {
        [_myTimer invalidate];
    }
}

-(void)disconnectViewUpdate:(NSNotification *)notification
{
    _statusLabel.text= @"Tool disconnected";
    [self.rollLabel setText:@"Awaiting Data"];
    [self.pitchLabel setText:@" "];
    
    //Update timer
    [_myTimer invalidate];

    
    //TODO:
    //Recenter axis to inital range
    //Hide tool marker
    //Hide target marker
    //Recenter both target
    //Set data model offset and coordinate to zero
    //return buttons to default state ( if there is a toggle feature included)
    //Disconnect from bean
    
    
}
//-(void) labelUpdate:(NSNotification *)notification
//{
//    NSString *medial= [NSString stringWithFormat:@"%1.1f",(_dataModel.medialAngle)];
//    NSString *sagittal=[NSString stringWithFormat:@"%1.1f",(_dataModel.sagittalAngle)];
//    
//    NSString *axis1= @"Medial  :    ";
//    NSString *axis2= @"Sagittal:    ";
//    
//    [self.rollLabel setText:[axis1 stringByAppendingString:medial]];
//    [self.pitchLabel setText:[axis2 stringByAppendingString:sagittal]];
//}
//TODO: Not yet implemented fully in separate test program
-(void) updateTarget:(NSNotification *) notification
{
    float range=_dataModel.degreeRange;
    float newXPos=_hostView.frame.size.width /range *(_dataModel.medialTargetAngle+0.5*range);
    float newYPos=_hostView.frame.size.height/range*(_dataModel.sagittalTargetAngle+0.25*range);
    
    [_targetMarker setCenter:CGPointMake(newXPos, newYPos)];
    NSLog(@" Notification received for target changed and calculated. 1.2%f", newXPos);
}


-(void) updateToolPosition:(NSNotification *) notification
{
    float range=_dataModel.degreeRange;
    float newXPos=_hostView.frame.size.width /range *(_dataModel.medialAngle+0.5*range);
    float newYPos=_hostView.frame.size.height/(range*_aspectRatio) *(_dataModel.sagittalAngle+0.5*range*_aspectRatio);
    //float newYPos=_movingview.center.y;
    
    [_toolMarker setCenter:CGPointMake(newXPos, newYPos)];
    NSLog(@" Tool Moved to X: %f", _toolMarker.center.x);
    NSLog(@" Range: %f", range);
    
    NSString *medial= [NSString stringWithFormat:@"%1.1f",(_dataModel.medialAngle)];
    NSString *sagittal=[NSString stringWithFormat:@"%1.1f",(_dataModel.sagittalAngle)];
    
    NSString *axis1= @"Medial Angle  :    ";
    NSString *axis2= @"Sagittal Angle:    ";
    
    [self.rollLabel setText:[axis1 stringByAppendingString:medial]];
    [self.pitchLabel setText:[axis2 stringByAppendingString:sagittal]];

}
//-(void)createTargetMarker
//{
//    CGRectMake(delegate.rollAngle, delegate.pitchAngle, 100, 100);
//    
//}

@end
