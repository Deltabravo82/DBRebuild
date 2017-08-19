//
//  DeviceListTVC.m
//  Rebuild1
//
//  Created by William Langenbach on 8/18/17.
//  Copyright © 2017 William Langenbach. All rights reserved.
//

#import "DeviceListTVC.h"

@interface DeviceListTVC ()
{
    AppDelegate *delegate;
    
}
@end

@implementation DeviceListTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate=(AppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.beanManager=[[PTDBeanManager alloc] initWithDelegate:delegate];
    delegate.beanlist=[NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"UpdateTableNotification" object:nil];
}



-(void)updateTable:(NSNotification *)notification
{
    NSLog(@"TVC received update table");
    [self.tableView reloadData];
}

- (IBAction)SearchButton:(id)sender
{
    [self scanForBeans:delegate.beanManager];
}
#pragma mark - Bean manager stuff

//TODO: Migrate to datamodel

-(void)scanForBeans: (PTDBeanManager *) manager
{
    
    
    NSError *err;
    // Adapted code from lines 82-92 from DygreeAppAlpha
    [delegate.beanlist removeAllObjects];
    [self.tableView reloadData];
    
    [manager startScanningForBeans_error:&err];
    //_statusLabel.text = @"Scanning";
    if (err)
    {
        //  _statusLabel.text = [err localizedDescription];
    }
    //    }
    //    else
    //    {
    //        _statusLabel.text = @"Bean Manager not powered on";
    //    }
    
}
#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [delegate.beanlist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeanCell" forIndexPath:indexPath];
    
    // Dequeue or create a cell of the appropriate type.
    
    //UITableViewCell *cell = [_availableBeanTable dequeueReusableCellWithIdentifier:availableBeanCellIdentifier];
    
    //    if (cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:availableBeanCellIdentifier];
    //    }
    
    PTDBean *currentBean = [delegate.beanlist objectAtIndex:[indexPath row]];
    NSString *beanName = [currentBean name];
    NSUUID *beanID = [currentBean identifier];
    //NSNumber *voltage=[currentBean batteryVoltage];
    [[cell textLabel] setText:beanName];
    [[cell detailTextLabel] setText:[beanID UUIDString]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"You touched row %ld", (long)[indexPath row]);
    //
    //    if (self.bean.state == BeanState_ConnectedAndValidated)
    //    {
    //        NSError *err;
    //        [self.beanManager disconnectBean:self.bean error:&err];
    //        if (err)
    //        {
    //            _statusLabel.text = [err localizedDescription];
    //        }
    //
    //        [_connectionButton setTitle:@"Disconnected" forState:UIControlStateNormal];
    //    }
    
    [delegate.beanManager connectToBean:[delegate.beanlist objectAtIndex:[indexPath row]] error:nil];
    delegate.bean=[delegate.beanlist objectAtIndex:[indexPath row]];
    
    [delegate.bean setDelegate:delegate];
    [self.splitViewController setPreferredDisplayMode:UISplitViewControllerDisplayModePrimaryHidden];
    
    //Eventually add in code to minimize the sidebar
    // Currently looking within the UISpitView controller documentation. Currently I am setting it up with setPreferredDisplayMode function from the splitview controller. As soon as didSelectRowAtIndexPath is called, it minimizes the master view controller without a transition. The default behavior is for the master view controller to overlay on top of the detail, which for now works as intended. The user can pull it back up by swiping right and minimize it by swiping left, both involving animations. However there is no UI indication that it can be controlled as such.
    //TODO: add in more obvious and apparent indications that the sidebar can be brought up and down.
    // Add in code to stop scanning and any sort of discovery methods to save power and programing tme
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
