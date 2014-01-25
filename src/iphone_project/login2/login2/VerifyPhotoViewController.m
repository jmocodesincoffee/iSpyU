//
//  VerifyPhotoViewController.m
//  login2
//
//  Created by Jason Moseley on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerifyPhotoViewController.h"
#import "AppDelegate.h"

@interface VerifyPhotoViewController ()

@end

@implementation VerifyPhotoViewController
@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize ageField = _ageField;
@synthesize locationField = _locationField;
@synthesize noteField = _noteField;
@synthesize myAppDelegate = _myAppDelegate;
@synthesize profilePicView = _profilePicView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
   // _noteField.layer.borderWidth = 1;
   // _noteField.layer.borderColor = [[UIColor grayColor] CGColor];
   // _noteField.layer.cornerRadius = 8;
    
    
    _firstNameField.enabled = NO;
    _lastNameField.enabled = NO;
    _ageField.enabled = NO;
    _locationField.enabled = NO;
    _noteField.editable = NO;
    
    _firstNameField.textColor = [UIColor lightGrayColor];
    _lastNameField.textColor = [UIColor lightGrayColor];
    _ageField.textColor = [UIColor lightGrayColor];
    _locationField.textColor = [UIColor lightGrayColor];
    _noteField.textColor = [UIColor lightGrayColor];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)verifyUserAct:(UIButton *)sender {
}

- (IBAction)changeUserAct:(UIButton *)sender {
}
@end
