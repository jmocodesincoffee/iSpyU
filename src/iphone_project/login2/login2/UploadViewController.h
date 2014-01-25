//
//  UploadViewController.h
//  login2
//
//  Created by Jason Moseley on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppDelegate;

@interface UploadViewController : UIViewController

@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *theImage;
@property (weak, nonatomic) IBOutlet UIButton *choosePhoto;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *process;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (strong, nonatomic) NSString *username;


- (IBAction)getPhoto:(UIButton *)sender;
- (IBAction)processPhoto:(UIButton *)sender;
- (IBAction)logout:(UIBarButtonItem *)sender;


@end
