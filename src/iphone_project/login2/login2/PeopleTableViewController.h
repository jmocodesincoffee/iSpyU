//
//  PeopleTableViewController.h
//  login2
//
//  Created by Jason Moseley on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface PeopleTableViewController : UITableViewController


@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (retain, nonatomic) NSArray *allPeople;


@end
