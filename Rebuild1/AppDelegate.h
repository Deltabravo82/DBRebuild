//
//  AppDelegate.h
//  Rebuild1
//
//  Created by William Langenbach on 8/17/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDBean.h"
#import "PTDBeanManager.h"
#import "PTDBeanRadioConfig.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, PTDBeanManagerDelegate, PTDBeanDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PTDBeanManager *beanManager;
@property (strong, nonatomic) PTDBean *bean;

@property (nonatomic) float rollAngle;
@property (nonatomic) float pitchAngle;
@property (nonatomic) float yawAngle;
@property (nonatomic) float rollOffset;
@property (nonatomic) float pitchOffset;
@property (nonatomic) float yawOffset;

@property (nonatomic, strong) NSMutableArray *beanlist; //Lists all of the LBB that have been connected



@end

