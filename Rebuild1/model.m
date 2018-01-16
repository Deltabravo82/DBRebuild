//
//  model.m
//  drep
//
//  Created by William Langenbach on 8/20/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "model.h"



@implementation model





- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) setup
{
    _medialAngle=0;
    _medialOffset=0;
    _medialTargetAngle=0;
    _sagittalAngle=0;
    _sagittalOffset=0;
    _sagittalTargetAngle=0;
    _degreeRange=100;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAngles:) name:@"updateAngles" object:nil];
    
    
}

-(void)setAngles: (NSNotification *)notificaiton
{
    NSMutableArray *newValues= [NSMutableArray arrayWithArray: (NSMutableArray *) notificaiton.object];
    [self setNewToolCoordwithX:[(NSNumber *)[newValues objectAtIndex:0] floatValue]  Y:[(NSNumber *)[newValues objectAtIndex:1] floatValue]];
}
-(void)setMedialAngle:(float)medialAngle
{
    _medialAngle=medialAngle-_medialOffset;
}
-(void)setSagittalAngle:(float)sagittalAngle
{
    _sagittalAngle=sagittalAngle-_sagittalOffset;
}

-(void)setNewToolCoordwithX:(float)x Y:(float)y
{
    [self setMedialAngle:x];
    [self setSagittalAngle:y];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Tool Moved" object:self];
    
}





-(void) setNewTargetWithX:(float)x Y:(float) y
{
    [self setMedialTargetAngle:x];
    [self setSagittalTargetAngle:y];
    
        //Right now arbitrarily setting the width of angle to display after being set. In the future it should likely be handled by the ViewController and scale based on the aspect ratio of the graph View
    if(x==0.0)
    {
        [self setDegreeRange:120];
    }
    else [self setDegreeRange:20];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"TargetChanged" object: self];
    
    
}
-(void)setMedialTargetAngle:(float)medialTargetAngle
{
    _medialTargetAngle=medialTargetAngle-_medialOffset;

    
}
-(void)setSagittalTargetAngle:(float)sagittalTargetAngle
{
    _sagittalTargetAngle=sagittalTargetAngle-_sagittalOffset;
    
}



@end
