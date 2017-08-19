//
//  AppDelegate.m
//  Rebuild1
//
//  Created by William Langenbach on 8/17/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "AppDelegate.h"
#import "DeviceListTVC.h"



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Init stuff
    _beanManager= [[PTDBeanManager alloc] initWithDelegate:self];
    _beanlist = [NSMutableArray array];
    
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark Bean Delegate Methods

-(void) bean:(PTDBean *)bean didUpdateScratchBank:(NSInteger)bank data:(NSData *)data
{
    UInt8 buffer[20]; // Max size of a scratch characteristic
    [data getBytes:&buffer length:sizeof(buffer)];
    //[data getBytes:&fBbuffer length:12]; another method of doing the currently uncommented code
    
    //Need to add in input checking if I will be updating any other characteristic with data. This will probably be implemented with the use of the "bank" variable. As of now, the code checks each databank and selectively calls the label update function by passing the scratch characteristic that was updated. This is set up so that 3 characteristics are written and read from. It may be more power efficient to implement the commented code, as then there is only one scratch data transfer instead of 3
    
    
    
    //      Single scratch bank characteristic implementation.
    if(bank==1)
    {
        
        _rollAngle = *(float *)&buffer[0];  // _rollAngle = fBuffer[0];
        _pitchAngle= *(float *)&buffer[4];
        _yawAngle  = *(float *)&buffer[8];
        NSLog(@" Received Roll is %g ",_rollAngle);
        NSLog(@" Received Pitch is %g ",_pitchAngle);
        NSLog(@" Received Yaw is %g ",_yawAngle);
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateLabels" object:self];
    //[ labelUpdate:bank withValue:x];
    
    float number = *(float *)[data bytes];
    NSLog(@"Bean Scratch %ld is: %f", (long)bank, number);

}

#pragma mark Bean Manager delegate methods


//Bean Discovered

- (void)beanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)bean error:(NSError *)error
{
    if (error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    
    [_beanlist addObject:bean];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTableNotification" object:self];
    NSLog(@"Posted UpdateTableNotification");
    
}

// Bean connected
- (void)beanManager:(PTDBeanManager *)beanManager didConnectBean:(PTDBean *)bean error:(NSError *)error
{
    if (error)
    {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    //Broadcasts which bean object has been connected
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeanConnected" object:self];
}

// Bean Disconnected
-(void)beanManager:(PTDBeanManager *)beanManager didDisconnectBean:(PTDBean *)bean error:(NSError *)error
{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnectViewUpdate" object:self];
}

-(void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager
{
    if(self.beanManager.state == BeanManagerState_PoweredOn)
    {
        NSLog(@"Can use BT, powered on, proceed");
        [self.beanManager startScanningForBeans_error:nil];
    }
    else
    {
        // do something else
        NSLog(@"Out of luck!");
    }
}
@end
