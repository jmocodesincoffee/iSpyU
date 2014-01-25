//
//  VerifyPhotoViewController.h
//  login2
//
//  Created by Jason Moseley on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface VerifyPhotoViewController : UIViewController



@property (retain, nonatomic) AppDelegate *myAppDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicView;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextView *noteField;





- (IBAction)verifyUserAct:(UIButton *)sender;
- (IBAction)changeUserAct:(UIButton *)sender;



@end
