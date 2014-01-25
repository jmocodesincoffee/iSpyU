//
//  ResultViewController.h
//  login2
//
//  Created by Jason Moseley on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppDelegate;


@interface ResultViewController : UITableViewController
                                                                                        

@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (strong, nonatomic) NSString *username;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (retain, nonatomic) NSArray *facesFromPhoto;
//@property (strong, nonatomic) NSDictionary *dictionary;
//@property (strong, nonatomic) NSArray *profilePhotoData;




- (IBAction)logout:(UIBarButtonItem *)sender;



@end
