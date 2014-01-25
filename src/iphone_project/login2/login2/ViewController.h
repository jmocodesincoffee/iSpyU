//
//  ViewController.h
//  login2
//
//  Created by Jason Moseley on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AppDelegate;

@interface ViewController : UIViewController



@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) UITextField *activeField;



- (IBAction)login:(UIButton *)sender;

- (IBAction)hideKeyboard:(UITextField *)sender;
- (IBAction)backgroundTouched:(UIControl *)sender;


@end
