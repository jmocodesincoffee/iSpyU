//
//  UserProfileViewController.h
//  login2
//
//  Created by Jason Moseley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewController.h"

@class AppDelegate;

@interface UserProfileViewController : UIViewController




@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *personDetailsLabels;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;
@property (weak, nonatomic) NSString *personid;
@property (weak, nonatomic) IBOutlet UIButton *revertButton;
@property (strong, nonatomic) UIImage *myCellImage;
@property (weak, nonatomic) NSString *photoName;

@property (weak, nonatomic) NSString *savedFirstName;
@property (weak, nonatomic) NSString *savedLastName;
@property (weak, nonatomic) NSString *savedAge;
@property (weak, nonatomic) NSString *savedLocation;
@property (weak, nonatomic) NSString *savedNotes;

@property (assign, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) NSString *returnScrollPoint;



@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UISwitch *myswitch;



- (IBAction)toggleSwitch:(UISwitch *)sender;

- (IBAction)submitChanges:(UIButton *)sender;

- (IBAction)logout:(UIBarButtonItem *)sender;

- (IBAction)revertAction:(UIButton *)sender;


- (IBAction)hideKeyboard:(UITextField *)sender;
- (IBAction)backgroundTouched:(UIControl *)sender;




@end
