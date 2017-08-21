//
//  Marker.m
//  drep
//
//  Created by William Langenbach on 8/20/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "Marker.h"

@implementation Marker

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        [self setup];
    }
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    [self setFillColor:[UIColor whiteColor]];
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)setFillColor:(UIColor *)fillColor
{
    _fillColor=fillColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *elipse= [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    [_fillColor setFill];
    [elipse fill];
}



@end
