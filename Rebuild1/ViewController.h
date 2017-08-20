//
//  ViewController.h
//  Rebuild1
//
//  Created by William Langenbach on 8/17/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CorePlot.h"

@interface ViewController : UIViewController
{
    AppDelegate *delegate;
    NSTimer *sessionTimer;
    int secondsCount;
}

@property (weak,nonatomic) IBOutlet UIButton *calibrateZero;
@property (weak,nonatomic) IBOutlet UILabel *rollLabel;
@property (weak,nonatomic) IBOutlet UILabel *pitchLabel;
@property (weak,nonatomic) IBOutlet UILabel *targetRoll;
@property (weak,nonatomic) IBOutlet UILabel *targetPitch;

@property (weak,nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet CPTGraphHostingView *hostView;

@property (nonatomic, strong) NSTimer *myTimer;

@end

