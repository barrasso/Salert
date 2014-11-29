//
//  MainViewController.m
//  Salert
//
//  Created by Mark on 11/18/14.
//  Copyright (c) 2014 MEB. All rights reserved.
//

#import "MainViewController.h"
#import "ESTBeaconManager.h"

@interface MainViewController () <ESTBeaconManagerDelegate>

// estimote beacon properties
@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

@end

@implementation MainViewController

#pragma mark - Initialization

- (id)initWithBeacon:(ESTBeacon *)beacon
{
    self = [super init];
    if (self)
    {
        self.beacon = beacon;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* setup estimote beacon manager */
    
    // create beacon manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    //self.beaconManager.avoidUnknownStateBeacons = YES;
    
    // request always authorization
    // Check location manager for iOS 8
    if ([self.beaconManager respondsToSelector:@selector(requestAlwaysAuthorization)])
        [self.beaconManager requestAlwaysAuthorization];
    
    NSUUID *myUUID = [[NSUUID alloc] initWithUUIDString:@"b9407f30-f5f8-466e-aff9-25556b57fe6d"];
    NSNumber* major = @8799;
    NSNumber* minor = @48808;
    
    // setup beacon region
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:myUUID
                                                                 major:[major unsignedIntegerValue]
                                                                 minor:[minor unsignedIntegerValue]                                                         identifier:@"RegionIdentifier"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didEnterRegion:
    // and beaconManager:didExitRegion: invoked
    [self.beaconManager startMonitoringForRegion:self.beaconRegion];
    
    [self.beaconManager requestStateForRegion:self.beaconRegion];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"ENTER";
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    NSLog(@"Entered region.");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"EXIT";
    notification.soundName = UILocalNotificationDefaultSoundName;

    NSLog(@"Exited region.");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
        
        // calculate and set new y position
        switch (self.beacon.proximity)
        {
            case CLProximityUnknown:
                self.distanceLabel.text = @"Unknown region";
                break;
            case CLProximityImmediate:
                self.distanceLabel.text = @"Immediate region";
                break;
            case CLProximityNear:
                self.distanceLabel.text = @"Near region";
                break;
            case CLProximityFar:
                self.distanceLabel.text = @"Far region";
                break;
                
            default:
                break;
        }
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
