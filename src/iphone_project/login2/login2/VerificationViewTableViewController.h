//
//  VerificationViewTableViewController.h
//  login2
//
//  Created by Jason Moseley on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppDelegate;

@interface VerificationViewTableViewController : UITableViewController


@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (retain, nonatomic) NSArray *unverified;





@end
