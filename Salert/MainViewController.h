//
//  MainViewController.h
//  Salert
//
//  Created by Mark on 11/18/14.
//  Copyright (c) 2014 MEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

@interface MainViewController : UIViewController

- (id)initWithBeacon:(ESTBeacon *)beacon;

// distance label
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
