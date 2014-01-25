//
//  VerificationViewTableViewController.m
//  login2
//
//  Created by Jason Moseley on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VerificationViewTableViewController.h"
#import "AppDelegate.h"

@interface VerificationViewTableViewController ()

@end

@implementation VerificationViewTableViewController
@synthesize myAppDelegate;
@synthesize unverified;


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
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{

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
    return unverified.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"verifyingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    myAppDelegate.unverifiedArray = [unverified mutableCopy];
    myAppDelegate.nonConfirmedPerson = [myAppDelegate.unverifiedArray objectAtIndex:indexPath.row];
    
    NSString *fn = [myAppDelegate.nonConfirmedPerson objectForKey:@"firstnm"];
    NSString *ln = [myAppDelegate.nonConfirmedPerson objectForKey:@"lastnm"];
    
    NSString *fullName = [[[[NSString alloc] initWithString:fn] stringByAppendingString:@" "] stringByAppendingString:ln];
    UILabel *label = (UILabel*)[cell.contentView viewWithTag:3];
    
    label.text = fullName;
    
    
    
    NSString *photoName = [myAppDelegate.nonConfirmedPerson objectForKey:@"preview_path"];
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
}










- (void)viewDidAppear:(BOOL)animated{
    
    
    
    myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSString *post =[NSString stringWithFormat:@"username=%@", myAppDelegate.name];

    NSString *finalURL = [kVerifyURL stringByAppendingString:post];
    NSLog(@"name of stupid url: %@", finalURL);

    NSData *dataURL =  [NSData dataWithContentsOfURL: [NSURL URLWithString: finalURL]];    
    NSString *serverOutput = [[NSString alloc] initWithData:dataURL encoding: NSASCIIStringEncoding];
    NSLog(@"finalURL is %@", finalURL);
    NSLog(@"serverOutput is: %@", serverOutput);
    
    
    NSString *jsonUrlString = [[[[NSString alloc] initWithString:kVerifyJson] stringByAppendingString:myAppDelegate.name] stringByAppendingString:@"_verification.json"];
    
    NSURL *jsonUrl = [NSURL URLWithString:jsonUrlString];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL: jsonUrl];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
    
    
    
}


- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    
    
    if (unverified == nil) {
        myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        myAppDelegate.unverifiedArray = [[NSMutableArray alloc] initWithArray:myAppDelegate.unverifiedArray];
        NSError* error;
        NSDictionary* json = [NSJSONSerialization 
                              JSONObjectWithData:responseData //1
                              
                              options:kNilOptions 
                              error:&error];
        
        unverified = [json objectForKey:@"verify"]; //2
        
        //NSLog(@"photos from appdel: %@", myAppDelegate.photoArray); //3
        //NSLog(@"photos from local var: %@", facesFromPhoto); //3
    } else {
        unverified = [myAppDelegate.unverifiedArray mutableCopy];
    }
    
    
    
    [self.tableView reloadData];
    
    
    
}




#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
