//
//  UserProfileViewController.m
//  login2
//
//  Created by Jason Moseley on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserProfileViewController.h"
#import "AppDelegate.h"

@interface UserProfileViewController ()

@end



@implementation UIScrollView (AutoContentSize)

- (void) setAutosizeContent:(BOOL)autosizeContent {
    
    if (autosizeContent) {
        CGFloat contentWidth =
        self.frame.size.width == self.superview.frame.size.width ?
        self.superview.frame.size.width :
        self.frame.size.width - 10;
        CGFloat contentHeight = 
        self.frame.size.height == self.superview.frame.size.height ?
        self.superview.frame.size.height :
        self.frame.size.height + 250;
        self.contentSize = CGSizeMake(contentWidth, contentHeight);
    }
}

@end



@implementation UserProfileViewController
@synthesize myAppDelegate;
@synthesize personDetailsLabels;
@synthesize profilePicView;
@synthesize logoutButton = _logoutButton;
@synthesize firstNameField;
@synthesize lastNameField;
@synthesize ageField;
@synthesize locationField;
@synthesize noteField;
@synthesize scrollView = _scrollView;
@synthesize submitButton;
@synthesize myswitch;
@synthesize personid;
@synthesize revertButton;
@synthesize savedFirstName;
@synthesize savedLastName;
@synthesize savedAge;
@synthesize savedLocation;
@synthesize savedNotes;
@synthesize activeField = _activeField;
@synthesize returnScrollPoint = _returnScrollPoint;
@synthesize myCellImage;
@synthesize photoName;



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
    
    noteField.layer.borderWidth = 1;
    noteField.layer.borderColor = [[UIColor grayColor] CGColor];
    noteField.layer.cornerRadius = 8;
    
    firstNameField.enabled = NO;
    lastNameField.enabled = NO;
    ageField.enabled = NO;
    locationField.enabled = NO;
    noteField.editable = NO;
    
    firstNameField.textColor = [UIColor lightGrayColor];
    lastNameField.textColor = [UIColor lightGrayColor];
    ageField.textColor = [UIColor lightGrayColor];
    locationField.textColor = [UIColor lightGrayColor];
    noteField.textColor = [UIColor lightGrayColor];
    
    
    [self registerForKeyboardNotifications];
    
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setPersonDetailsLabels:nil];
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setAgeField:nil];
    [self setLocationField:nil];
    [self setProfilePicView:nil];
    [self setSubmitButton:nil];
    [self setSubmitButton:nil];
    [self setMyswitch:nil];
    [self setNoteField:nil];
    [self setRevertButton:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (IBAction)toggleSwitch:(UISwitch *)sender {
    
    if(myswitch.on)
    {
        firstNameField.enabled = YES;
        lastNameField.enabled = YES;
        ageField.enabled = YES;
        locationField.enabled = YES;
        noteField.editable = YES;
        
        firstNameField.textColor = [UIColor blackColor];
        lastNameField.textColor = [UIColor blackColor];
        ageField.textColor = [UIColor blackColor];
        locationField.textColor = [UIColor blackColor];
        noteField.textColor = [UIColor blackColor];
    } else {
        firstNameField.enabled = NO;
        lastNameField.enabled = NO;
        ageField.enabled = NO;
        locationField.enabled = NO;
        noteField.editable = NO;
        
        firstNameField.textColor = [UIColor lightGrayColor];
        lastNameField.textColor = [UIColor lightGrayColor];
        ageField.textColor = [UIColor lightGrayColor];
        locationField.textColor = [UIColor lightGrayColor];
        noteField.textColor = [UIColor lightGrayColor];
    }
    
}


- (IBAction)submitChanges:(UIButton *)sender {
    
    
    NSString *urlString = kUpdateURL;
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    
    // now lets create the body of the post
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"personid\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:personid] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"firstname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:firstNameField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lastname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:lastNameField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"age\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:ageField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:locationField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"notes\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:noteField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    NSLog(@"the firstname is %@ and the lastname is %@ and age is %@ and location is %@", firstNameField.text, lastNameField.text, ageField.text, locationField.text);
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];  
    
    NSLog(@"%@", returnData);
    
    savedFirstName = firstNameField.text;
    savedLastName = lastNameField.text;
    savedAge = ageField.text;
    savedLocation = locationField.text;
    savedNotes = noteField.text;
    
    
    
    
    //[myAppDelegate.dictionary objectForKey:@"firstnm"] = firstNameField.text;
    myAppDelegate.dictionary = [[NSMutableDictionary alloc] init];
    [myAppDelegate.dictionary setValue:firstNameField.text forKey:@"firstnm"];
    [myAppDelegate.dictionary setValue:lastNameField.text forKey:@"lastnm"];
    [myAppDelegate.dictionary setValue:ageField.text forKey:@"age"];
    [myAppDelegate.dictionary setValue:locationField.text forKey:@"location"];
    [myAppDelegate.dictionary setValue:noteField.text forKey:@"notes"];
    [myAppDelegate.dictionary setValue:personid forKey:@"persons_personid"];
    [myAppDelegate.dictionary setValue:photoName forKey:@"preview_path"];
    
    [myAppDelegate.photoArray replaceObjectAtIndex:myAppDelegate.arrayIndex.row withObject:myAppDelegate.dictionary];
    
    NSLog(@"output of submitted changes- array: %@", myAppDelegate.photoArray);
    
    
    UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Information has been updated."
                                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alertsuccess show];
    
    
    
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"LogoutSegue" sender:self];
    
    
}

- (IBAction)revertAction:(UIButton *)sender {
    
    firstNameField.text = savedFirstName;
    lastNameField.text = savedLastName;
    ageField.text = savedAge;
    locationField.text = savedLocation;
    noteField.text = savedNotes;
    
    
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, _activeField.frame.origin.y, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    //CGRect aRect = self.view.frame;
    CGRect aRect = self.scrollView.frame;
    aRect.size.height = 20;
    
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
    
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    CGPoint fieldReturn = CGPointFromString(_returnScrollPoint);
    [_scrollView setContentOffset:fieldReturn animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    _returnScrollPoint = [NSString stringWithFormat:@"%.1f", _activeField.frame.origin.y];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}




-(void) placeImage:(UIImage *)profileImage{
    
    profilePicView.image = profileImage;
    
}



- (void) viewWillAppear:(BOOL)animated{
    
    
    
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    myAppDelegate.dictionary = [myAppDelegate.photoArray objectAtIndex:myAppDelegate.arrayIndex.row];
    
    /*
     photoName = [myAppDelegate.dictionary objectForKey:@"preview_path"];
     NSString *imageURLString = [[[NSString alloc] initWithString:kImageURL] stringByAppendingString:photoName];
     NSURL *imageURL = [NSURL URLWithString:imageURLString];
     
     NSLog(@"preview path output at user profile: %@", imageURL);
     
     NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
     
     myCellImage = [UIImage imageWithData:imageData];
     */
    
    
    
    
    photoName = [myAppDelegate.dictionary objectForKey:@"preview_path"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:photoName]; 
    
    myCellImage = [UIImage imageWithContentsOfFile:fullPath];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self performSelectorOnMainThread:@selector(placeImage:) withObject:myCellImage waitUntilDone:YES];
    });
    
    //myCellImage = [UIImage imageWithContentsOfFile:fullPath];
    
    
    //profilePicView.image = myCellImage;
    
    firstNameField.text = [myAppDelegate.dictionary objectForKey:@"firstnm"];
    lastNameField.text = [myAppDelegate.dictionary objectForKey:@"lastnm"];
    ageField.text = [myAppDelegate.dictionary objectForKey:@"age"];
    locationField.text = [myAppDelegate.dictionary objectForKey:@"location"];
    noteField.text = [myAppDelegate.dictionary objectForKey:@"notes"];
    
    personid = [myAppDelegate.dictionary objectForKey:@"persons_personid"];
    
    
    
    savedFirstName = firstNameField.text;
    savedLastName = lastNameField.text;
    savedAge = ageField.text;
    savedLocation = locationField.text;
    savedNotes = noteField.text;
    
    
    
    
    
    
}














@end
