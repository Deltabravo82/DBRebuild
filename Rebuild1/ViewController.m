//
//  ViewController.m
//  Rebuild1
//
//  Created by William Langenbach on 8/17/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "ViewController.h"
#import <CorePlot.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectViewUpdate:) name:@"disconnectViewUpdate" object:nil] ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnect:) name:@"BeanConnected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector( labelUpdate:)name:@"updateLabels" object:nil];
    
    
    
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
    //  NSString *yaw=[NSString stringWithFormat:@"%1.2f",delegate.yawAngle];
    
    NSString *axis1= @"Medial:    ";
    NSString *axis2= @"Sagittal:    ";
    //  NSString *axis3= @"Yaw:    ";
    
    [self.rollLabel setText:[axis1 stringByAppendingString:roll]];
    [self.pitchLabel setText:[axis2 stringByAppendingString:pitch]];
}

@end
