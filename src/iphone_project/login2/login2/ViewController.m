//
//  ViewController.m
//  login2
//
//  Created by Jason Moseley on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UploadViewController.h"
#import "AppDelegate.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize loginButton = _loginButton;
@synthesize myAppDelegate;
@synthesize scrollView = _scrollView;
@synthesize activeField = _activeField;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib. 
    
    
    [self registerForKeyboardNotifications];
    
}

- (void)viewDidUnload
{
    [self setUsernameField:nil];
    [self setPasswordField:nil];
    [self setLoginButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)login:(UIButton *)sender {
    
    _loginButton.enabled = FALSE;
    
    
    
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    myAppDelegate.name = _usernameField.text;
    
    NSString *post =[NSString stringWithFormat:@"username=%@&password=%@",_usernameField.text, _passwordField.text];
    
    NSString *hostStr = [kHostURL stringByAppendingString:post];
    NSData *dataURL =  [NSData dataWithContentsOfURL: [ NSURL URLWithString: hostStr ]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    
    NSLog(@"%@", serverOutput);
    
    //change back to yes after completing the testing
    if([serverOutput isEqualToString:@"Yes"]){
        
        
        //        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Congrats" message:@"You are authorized"
        //                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //        
        //        [alertsuccess show];
        
        [self performSegueWithIdentifier:@"AppTabBarController" sender:self];
        
    } else {
        UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password Incorrect"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertsuccess show];            
        _loginButton.enabled = TRUE;
    }
}

- (IBAction)hideKeyboard:(UITextField *)sender {
    
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(UIControl *)sender {
    
    [self.view endEditing:YES];
}






- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y-(kbSize.height-15));
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}
















@end
