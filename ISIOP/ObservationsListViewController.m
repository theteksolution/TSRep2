//
//  ObervationsListViewController.m
//  ISIOP
//
//  Created by LRich on 11/6/12.
//  Copyright (c) 2012 LR
//


#import "ObservationsListViewController.h"
#import "ObservationListItem.h"


@interface ObservationsListViewController ()

@end

@implementation ObservationsListViewController

@synthesize observations = _observations;
@synthesize delegate = _delegate;

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
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(180.0, 140.0);
    
    ObservationListItem *oi = [[ObservationListItem alloc]init];
    
    self.observations = [oi getObservationList];
    
    
    //ObservationListItem *o1i = [self.observations objectAtIndex:0];
    
   // NSLog(@"classID%@", [o1i classRoomID]);
    

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Returselfn the number of rows in the section.
    return [self.observations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //ObservationItem *oi = [[ObservationItem alloc]init];
    
    ObservationListItem *oi = [self.observations objectAtIndex:indexPath.row];
    
    //NSString *observation = [observationItems objectAtIndex:indexPath.row];
    cell.textLabel.text = [oi classRoomID];
    
    NSMutableString *myString = [NSMutableString stringWithString:oi.observationDate];
    [myString appendString:@" "];
    [myString appendString:oi.startTime];
    
    cell.detailTextLabel.text = myString;
                                  
    return cell;
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate != nil) {
       // NSString *observation = [self.observations objectAtIndex:indexPath.row];
        
        
        
//        ObservationListItem *o1i = [self.observations objectAtIndex:0];
//        
//        NSLog(@"classID%@", [o1i classRoomID]);
//        
//        
//        NSLog(@"row%d",indexPath.row );
        
        
        
          ObservationListItem *oi = [self.observations objectAtIndex:indexPath.row];
        
        [self.delegate observationSelected:[oi observationID] classID:[oi classRoomID]];
    }
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
