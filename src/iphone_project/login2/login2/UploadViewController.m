//
//  UploadViewController.m
//  login2
//
//  Created by Jason Moseley on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadViewController.h"
#import "AppDelegate.h"



@interface UploadViewController ()

@end

@implementation UploadViewController

@synthesize theImage = _theImage;
@synthesize choosePhoto = _choosePhoto;
@synthesize takePhoto = _takePhoto;
@synthesize process = _process;
@synthesize logoutButton = _logoutButton;
@synthesize username = _username;
@synthesize myAppDelegate;

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
    
    _process.enabled = NO;
    _process.alpha = .5;
    
	// Do any additional setup after loading the view.
    
}

- (void)viewDidUnload
{
    [self setTheImage:nil];
    [self setChoosePhoto:nil];
    [self setTakePhoto:nil];
    [self setProcess:nil];
    [self setLogoutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)getPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    
    if((UIButton *)sender == _choosePhoto)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else if((UIButton *)sender == _takePhoto)
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    
    [self presentModalViewController:picker animated:YES];
    
    _process.alpha = 1;
    _process.enabled = YES;
    
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissModalViewControllerAnimated:YES];
    
    _theImage.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savedImagePath = [NSString stringWithFormat:@"%@/savedImage.png", paths];
    UIImage *newImage = _theImage.image; // imageView is my image from camera
    NSData *imageData = UIImagePNGRepresentation(newImage);
    [imageData writeToFile:savedImagePath atomically:NO];
    
    
    double compressionRatio = 1;
    imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], compressionRatio);
    while ([imageData length] > 50000)
    {
        compressionRatio = compressionRatio * 0.5;
        imageData = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], compressionRatio);
    }
    
    UIImage *yourUIImage;
    yourUIImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    imageData = [NSKeyedArchiver archivedDataWithRootObject:yourUIImage];
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"bild"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIImageOrientation orientation = yourUIImage.imageOrientation;
        
    UIImage *finaltestimage = [self rotateImage:yourUIImage byOrientationFlag:orientation];
        
    NSData *imageData2 = UIImageJPEGRepresentation(finaltestimage, 90);
    
    
    NSString *compressedImagePath = [NSString stringWithFormat:@"%@/savedImage2.png", paths];
    [imageData2 writeToFile:compressedImagePath atomically:NO];
    
    
}



- (IBAction)processPhoto:(UIButton *)sender {
    
    NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *compressedImagePath = [NSString stringWithFormat:@"%@/savedImage2.png", paths];
    
    
    
    UIImage *storedImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:compressedImagePath]];
    NSData *procimage = UIImagePNGRepresentation(storedImage);
    
    NSString *urlString = kUploadURL;
    
    
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _username = myAppDelegate.name;
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *body = [NSMutableData data];
    
    // now lets create the body of the post
    NSString *content = [NSString stringWithFormat:@"Content-Disposition: attachment; name=\"uploadedfile\"; filename=\"_IMG.png\"\r\n", index];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithString:content] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:procimage]];
    [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];    
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:_username] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];  
    
    NSLog(@"%@", returnData);
    
    
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"LogoutSegue" sender:self];
    
    
}





- (UIImage*)rotateImage:(UIImage*)img byOrientationFlag:(UIImageOrientation)orient
{
    CGImageRef          imgRef = img.CGImage;
    CGFloat             width = CGImageGetWidth(imgRef);
    CGFloat             height = CGImageGetHeight(imgRef);
    CGAffineTransform   transform = CGAffineTransformIdentity;
    CGRect              bounds = CGRectMake(0, 0, width, height);
    CGSize              imageSize = bounds.size;
    CGFloat             boundHeight;
    
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        default:
            // image is not auto-rotated by the photo picker, so whatever the user
            // sees is what they expect to get. No modification necessary
            transform = CGAffineTransformIdentity;
            break;
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    
    if (orient == UIImageOrientationRight){
        // flip the coordinate space upside down
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -width);
    } else if (orient == UIImageOrientationLeft) {
        CGContextTranslateCTM(context, 0, 0);
    } else {
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}







@end
