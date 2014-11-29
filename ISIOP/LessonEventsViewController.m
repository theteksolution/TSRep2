//
//  LessonEventsViewController.m
//  TestTabController1
//
//  Created by LRich on 1/11/13.
//  Copyright (c) 2013 LR
//

#import "LessonEventsViewController.h"
#import "DBHelper.h"
#import "VariableStore.h"
#import "ObservationInformation.h"

@interface LessonEventsViewController ()

@end

@implementation LessonEventsViewController
{
    NSMutableArray *items;
    
}


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
    
//    [items addObject:@"Lesson Event #1"];
//    [items addObject:@"Lesson Event #2"];
//    [items addObject:@"Lesson Event #3"];
//    [items addObject:@"Lesson Event #4"];
//    [items addObject:@"Lesson Event #5"];
//    [items addObject:@"Lesson Event #6"];
    
    
    VariableStore *vs = [VariableStore sharedInstance];
    
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",vs.gObservationID];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email=%@",@"lrich@edc.org"];
    
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    
    NSArray *eventItems = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    //NSMutableArray *observations = [[NSMutableArray alloc]init];
    
    
    for (ObservationInformation *oi in eventItems)
    {
               
        [items addObject:oi.lessonEventName];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(190.0, 140.0);
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
    
    NSString *i1 = [items objectAtIndex:indexPath.row];
    
    cell.textLabel.text = i1;
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
               
        NSString *oi = [items objectAtIndex:indexPath.row];
        [self.delegate lessonEventSelected:oi];
    }
}

@end
