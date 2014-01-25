//
//  ResultViewController.m
//  login2
//
//  Created by Jason Moseley on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ResultViewController.h"
#import "AppDelegate.h"


@interface ResultViewController ()

@end


@implementation ResultViewController
@synthesize logoutButton;
@synthesize myAppDelegate;
@synthesize username = _username;
@synthesize facesFromPhoto;
//@synthesize dictionary;
//@synthesize profilePhotoData;






- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setLogoutButton:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return facesFromPhoto.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    myAppDelegate.photoArray = [facesFromPhoto mutableCopy];
    myAppDelegate.dictionary = [myAppDelegate.photoArray objectAtIndex:indexPath.row];
    
    //id personid = [dictionary objectForKey:@"persons_personid"];
    //NSString *personType = @"";
    //        if(personid != [NSNull null])
    //    {
    //        personType = (NSString *)personid;
    //        label.text = personType;
    //    } else {
    //        label.text = @"Unknown";
    //    }
    
    
    NSString *fn = [myAppDelegate.dictionary objectForKey:@"firstnm"];
    NSString *ln = [myAppDelegate.dictionary objectForKey:@"lastnm"];
    
    NSString *fullName = [[[[NSString alloc] initWithString:fn] stringByAppendingString:@" "] stringByAppendingString:ln];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:5];
    
    label.text = fullName;
    
    
    
    NSString *photoName = [myAppDelegate.dictionary objectForKey:@"preview_path"];
    NSString *imageURLString = [[[NSString alloc] initWithString:kImageURL] stringByAppendingString:photoName];
    
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    
    NSLog(@"full url path for photo is: %@", imageURL);
    
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];

    UIImage *myCellImage = [UIImage imageWithData:imageData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 2, 40, 40)];
    imageView.image = myCellImage;
    [cell.contentView addSubview:imageView];
    
    
    
    
    //save image
    NSData *data = UIImagePNGRepresentation(myCellImage);
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:photoName];
    [fileManager createFileAtPath:fullPath contents:data attributes:nil];
	
    
    
    
    
    return cell;
    //[self.tableView reloadRowsAtIndexPaths:facesFromPhoto withRowAnimation:UITableViewRowAnimationTop];
    //[self.tableView setNeedsDisplay];
    
}






#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Navigation logic may go here. Create and push another view controller.
    
    //UserProfileViewController *detailViewController = [[UserProfileViewController alloc] init];
    // ...
    // Pass the selected object to the new view controller.
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    myAppDelegate.arrayIndex = indexPath;
    //[self.navigationController pushViewController:detailViewController animated:YES];
    
    
    [self performSegueWithIdentifier:@"SegueToPersonDetails" sender:indexPath];
    
}

- (IBAction)logout:(UIBarButtonItem *)sender {
    
    [self performSegueWithIdentifier:@"LogoutSegue" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"SegueToPersonDetails"]) {
        
        
    }
}




- (void)viewDidAppear:(BOOL)animated{
    
    
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    _username = myAppDelegate.name;
    
    NSString *jsonUrlString = [[[[NSString alloc] initWithString:kJsonURL] stringByAppendingString:_username] stringByAppendingString:@".json"];
    
    NSURL *jsonUrl = [NSURL URLWithString:jsonUrlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: jsonUrl];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    
    
}


- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    
    
    if (facesFromPhoto == nil) {
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    myAppDelegate.photoArray = [[NSMutableArray alloc] initWithArray:myAppDelegate.photoArray];
        NSError* error;
    NSDictionary* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions 
                          error:&error];
    
    facesFromPhoto = [json objectForKey:@"photos"]; //2
    
    NSLog(@"photos from appdel: %@", myAppDelegate.photoArray); //3
    NSLog(@"photos from local var: %@", facesFromPhoto); //3
    } else {
        facesFromPhoto = [myAppDelegate.photoArray mutableCopy];
    }


    
    [self.tableView reloadData];
    
    
    
}






/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




@end
