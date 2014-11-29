//
//  ActivityCodesViewController.m
//  TestTabController1
//
//  Created by LRich on 12/5/12.
//  Copyright (c) 2012 LR
//

#import "ActivityCodesViewController.h"

@interface ActivityCodesViewController ()

@end

@implementation ActivityCodesViewController
{
    NSMutableArray *items;
    
}

@synthesize delegate;
@synthesize codeType = _codeType;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    items = [[NSMutableArray alloc] init];
    
    if ([[self codeType] isEqualToString:@"AC"])
    {
        [items addObject:@"INST"];
        [items addObject:@"DISC"];
        [items addObject:@"READ"];
        [items addObject:@"PRES"];
        [items addObject:@"WRIT"];
        [items addObject:@"LIT"];
        [items addObject:@"ASMT"];
        [items addObject:@"VID"];
        [items addObject:@"MODL"];
        [items addObject:@"DEMO"];
        [items addObject:@"SIM"];
        [items addObject:@"REP"];
        [items addObject:@"HANDS"];
        [items addObject:@"FIELD"];
        [items addObject:@"SEC"];
        [items addObject:@"STN"];
    }
    else if ([self.codeType isEqualToString:@"OC"])
    {
        [items addObject:@"I"];
        [items addObject:@"P"];
        [items addObject:@"G"];
        [items addObject:@"W"];
        
    }
    else
    {
        
        [items addObject:@"NONE"];
        [items addObject:@"FEW"];
        [items addObject:@"HALF"];
        [items addObject:@"MOST"];
        [items addObject:@"ALL"];
        [items addObject:@"NA"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(100.0, 140.0);
    
            
    
    
    
    
//    
//    

   
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //ObservationItem *oi = [[ObservationItem alloc]init];
    
    NSString *i1 = [items objectAtIndex:indexPath.row];
    
    //NSString *observation = [observationItems objectAtIndex:indexPath.row];
    cell.textLabel.text = i1;
    //    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:[oi observationDate]
    //                                                               dateStyle:NSDateFormatterShortStyle
    //                                                               timeStyle:NSDateFormatterFullStyle];
    
    
    // Configure the cell...
    
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
        
        NSString *oi = [items objectAtIndex:indexPath.row];
        [self.delegate itemCodeSelected:oi activityCodeType:self.codeType];
    }
}

@end
