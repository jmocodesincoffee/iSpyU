//
//  AppDelegate.h
//  login2
//
//  Created by Jason Moseley on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kJsonURL @"http://localhost/~jason/jason.dev/json/"
#define kImageURL @"http://localhost/~jason/jason.dev/images/face_library/"
#define kHostURL @"http://localhost/~jason/jason.dev/m.login.php?"
#define kUploadURL @"http://localhost/~jason/jason.dev/upload.php"
#define kVerifyURL @"http://localhost/~jason/jason.dev/verification.php?"
#define kUpdateURL @"http://localhost/~jason/jason.dev/update.php"
#define kVerifyJson @"http://localhost/~jason/jason.dev/json/"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (strong, nonatomic) NSIndexPath *arrayIndex;
@property (strong, nonatomic) NSDictionary *dictionary;
@property (strong, nonatomic) NSMutableArray *profileImageData;
@property (strong, nonatomic) NSMutableArray *unverifiedArray;
@property (strong, nonatomic) NSDictionary *nonConfirmedPerson;
@property (strong, nonatomic) NSMutableArray *globalAllPersonArray;
@property (strong, nonatomic) NSDictionary *globalSelectedPerson;







@end
