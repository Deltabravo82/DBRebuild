//
//  ViewController.m
//  Rebuild1
//
//  Created by William Langenbach on 8/17/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //CorePlot graph setup
    
    // Create a CPTGraph object and add to hostView
    CPTGraph* graph = [[CPTXYGraph alloc] initWithFrame:_hostView.bounds];
    _hostView.hostedGraph = graph;
    
    // Get the (default) plotspace from the graph so we can set its x/y ranges
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    
    // Note that these CPTPlotRange are defined by START and LENGTH (not START and END) !!
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:-8.0] length:[NSNumber numberWithFloat:-16.0]]];
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:[NSNumber numberWithFloat:-8.0] length:[NSNumber numberWithFloat:-16.0]]];
    //[plotSpace set]
    // Create the plot (we do not define actual x/y values yet, these will be supplied by the datasource...)
    CPTScatterPlot* plot = [[CPTScatterPlot alloc] initWithFrame:CGRectZero];
    
    // Let's keep it simple and let this class act as datasource (therefore we implemtn <CPTPlotDataSource>)
    //plot.dataSource = self;
    
    // Finally, add the created plot to the default plot space of the CPTGraph object we created before
    [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
    
    //TODO: Add in graph formattting options
    
    // Do any additional setup after loading the view, typically from a nib.
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectViewUpdate:) name:@"disconnectViewUpdate" object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnect:) name:@"BeanConnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( labelUpdate:)name:@"updateLabels" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"UpdateTableNotification" object:nil];
    
}

-(void)updateTable:(NSNotification *)notification
{
    NSLog(@"VC received update table");

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calibrate:(id)sender
{
    delegate.rollOffset=delegate.rollAngle;
    delegate.pitchOffset=delegate.pitchAngle;
    
}

- (IBAction)setTarget:(id)sender
{
    NSString *roll= [NSString stringWithFormat:@"%1.1f", (delegate.rollAngle-delegate.rollOffset)];
    NSString *pitch=[NSString stringWithFormat:@"%1.1f", (delegate.pitchAngle-delegate.pitchOffset)];
    //Update so that it still shows the correct angle type with the pitch or yaw. Do something with appending string to existing string. Potentially have the text blank and have it as a text set in the view did load script

    [self.targetRoll setText:roll];
    [self.targetPitch setText:pitch];
}
-(void) timerReadScratch:(NSTimer *)timer
{
    [delegate.bean readScratchBank:1];

}

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
        _myTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerReadScratch:) userInfo:nil repeats:YES];
        
    }
    else
    {
        [_myTimer invalidate];
    }
}

-(void)disconnectViewUpdate:(NSNotification *)notification
{
    _statusLabel.text= @"Tool disconnected";
    [self.rollLabel setText:@""];
    [self.pitchLabel setText:@"Awaiting Data"];
    
    //Update timer
    [_myTimer invalidate];

}
-(void) labelUpdate:(NSNotification *)notification
{
    NSString *roll= [NSString stringWithFormat:@"%1.1f",(delegate.rollAngle-delegate.rollOffset)];
    NSString *pitch=[NSString stringWithFormat:@"%1.1f",(delegate.pitchAngle-delegate.pitchOffset)];
    
    NSString *axis1= @"Medial:    ";
    NSString *axis2= @"Sagittal:    ";
    
    [self.rollLabel setText:[axis1 stringByAppendingString:roll]];
    [self.pitchLabel setText:[axis2 stringByAppendingString:pitch]];
}

@end
