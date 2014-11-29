//
//  ScienceContentViewController.m
//  TestTabController1
//
//  Created by LRich on 11/14/12.
//  Copyright (c) 2012 LR
//

#import "ScienceContentViewController.h"
#import "ObservationQuestion.h"
#import "PostObservations.h"
#import "VariableStore.h"
#import "DBHelper.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface ScienceContentViewController ()

@end

@implementation ScienceContentViewController
{
    NSMutableArray *listOfItems;
    ButtonControlExt *selectedButton;
    NSString *observationID;
    NSString *userID;
    BOOL bDataSaved;
    BOOL bIsModified;
}

@synthesize questionForBool;
@synthesize questionForDrop;
@synthesize answer;
@synthesize dropdown;
@synthesize questionPicker = _questionPicker;
@synthesize questionsPickerPopover = _questionsPickerPopover;
@synthesize navItem = _navItem;



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
    self.tabBarController.delegate = self;
}


+ (ScienceContentViewController *)sharedInstance
{
    // the instance of this class is stored here
    static ScienceContentViewController *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self loadQuestions];
    
    
    VariableStore *vs = [VariableStore sharedInstance];
    
    if ([vs.gClassID isEqualToString:@""])
    {
        self.navItem.title = @"Post-Observation: High School Science Content";
    }
    else
    {
        NSMutableString *myString = [NSMutableString stringWithString:vs.gClassID];
        [myString appendString:@" - "];
        [myString appendString:@"Post-Observation: High School Science Content"];
        self.navItem.title = myString;
    }
    
    bDataSaved = NO;
    
    // Get the ObservationID  and load Observation data
    
    observationID = vs.gObservationID;
    userID = vs.gUserID;
    [self loadPreviousObservation];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)loadQuestions
{
    listOfItems = [[NSMutableArray alloc] init];
    
    
    ObservationQuestion *o1 = [[ObservationQuestion alloc]init];
    o1.questionText = @"The cell: e.g., structure, functions (especially DNA, photosynthesis), cellular growth and differentiation";
    o1.questionType = @"bool";
    o1.questionID = [NSNumber numberWithInt:19];
    o1.questionResult = @"NO";
    
    ObservationQuestion *o2 = [[ObservationQuestion alloc]init];
    o2.questionText = @"Molecular basis of heredity: e.g., role of chromosomes in reproduction, mutations";
    o2.questionType = @"bool";
    o2.questionID = [NSNumber numberWithInt:20];
    o2.questionResult = @"NO";
    
    ObservationQuestion *o3 = [[ObservationQuestion alloc]init];
    o3.questionText = @"Biological evolution: e.g., factors influencing it, role of natural selection, classification schemes";
    o3.questionType = @"bool";
    o3.questionID = [NSNumber numberWithInt:21];
    o3.questionResult = @"NO";
    
    ObservationQuestion *o4 = [[ObservationQuestion alloc]init];
    o4.questionText = @"The interdependencies of organisms in ecosystems and energy flow in ecosystems";
    o4.questionType = @"bool";
    o4.questionID = [NSNumber numberWithInt:22];
    o4.questionResult = @"NO";
    
    
    ObservationQuestion *o5 = [[ObservationQuestion alloc]init];
    o5.questionText = @"Matter, energy, and organizations in living systems";
    o5.questionType = @"bool";
    o5.questionID = [NSNumber numberWithInt:23];
    o5.questionResult = @"NO";
    
    
    
    ObservationQuestion *o6 = [[ObservationQuestion alloc]init];
    o6.questionText = @"Biological governance of organisms behavior: e.g., nervous systems, role of internal and externalstimuli";
    o6.questionType = @"bool";
    o6.questionID = [NSNumber numberWithInt:24];
    o6.questionResult = @"NO";
    
    
    ObservationQuestion *o7 = [[ObservationQuestion alloc]init];
    o7.questionText = @"Overall Rating: Extent that the lesson addressed these, or other, Life Science concepts";
    o7.questionType = @"drop";
    o7.questionID = [NSNumber numberWithInt:25];
    o7.questionResult = @"Select Item";
    
    
    NSArray *questions1Array = [NSArray arrayWithObjects:o1, o2,o3,o4,o5,o6,o7, nil];
    NSDictionary *questions1Dict = [NSDictionary dictionaryWithObject:questions1Array forKey:@"Questions"];
    
    
    [listOfItems addObject:questions1Dict];
}


-(void)loadPreviousObservation
{
    //Here load observations for a given email address
    // [[VariableStore sharedInstance] gEmail];
    
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@",observationID,@"ScienceContent"];
    
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    
    NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([items count] > 0)
    {
        bDataSaved = YES;
    }
    
    for (PostObservations *ob in items)
    {
        NSDictionary *dictionary = [listOfItems objectAtIndex:0];
        NSArray *array = [dictionary objectForKey:@"Questions"];
        
        for (ObservationQuestion *oq in array)
        {
            if ([ob.poqID isEqualToNumber:oq.questionID])
            {
                oq.questionResult = ob.answer;
            }
        }
               
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [listOfItems count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Questions"];
    
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    static NSInteger intTag;
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"Questions"];
    ObservationQuestion *oq = [array objectAtIndex:indexPath.row];
    //questionForBool.text = oq.questionText;
    
    
    
    if ([oq.questionType isEqualToString:@"bool"] == YES)
    {
        CellIdentifier = @"QuestionBool";
        intTag = 1001;
        
    }
    else
    {
        CellIdentifier = @"QuestionDrop";
        intTag = 1002;
        
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *questionLabel = (UILabel *)[cell viewWithTag:intTag];
    
    
    if ([oq.questionType isEqualToString:@"bool"] == YES)
    {
        SegmentedControlExt *questionBool = (SegmentedControlExt *) [cell viewWithTag:1003];
        questionBool.row = indexPath.row;
        questionBool.section = indexPath.section;
        if ([oq.questionResult isEqualToString:@"YES"])
        {
            questionBool.selectedSegmentIndex = 0;
        }
        else
        {
            questionBool.selectedSegmentIndex = 1;
        }
        [questionBool addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    }
    else
    {
        ButtonControlExt *questionDropdown = (ButtonControlExt *) [cell viewWithTag:1004];
        questionDropdown.bRow = indexPath.row;
        questionDropdown.bSection = indexPath.section;
        questionDropdown.titleLabel.text = oq.questionResult;
        [questionDropdown addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        
    }
    
    questionLabel.text = oq.questionText;
    
    
    // [cell.answer addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 70;
    } else {
        return 70;
    }
}



- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc
{
    // When we have needed fields this will be implemented
    
    if ([self isDataValid] == NO)
    {
        return NO;
    }
    else
    {
        if (bDataSaved == NO || bIsModified == YES)
        {
            UIAlertView *saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"Save this Science Content Information?";
            [saveAlert addButtonWithTitle:@"OK"];
            [saveAlert addButtonWithTitle:@"Cancel"];
            saveAlert.tag = 1;
            
            [saveAlert show];
            
            return NO;
        }
        else
        {
            return YES;
        }
        
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
        return @"Life Sciences";
    
}

-(void)segmentAction:(SegmentedControlExt *)sender
{
    bIsModified = YES;
    
    SegmentedControlExt *sc = (SegmentedControlExt *)sender;
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:sc.section];
    NSArray *array = [dictionary objectForKey:@"Questions"];
    ObservationQuestion *oq = [array objectAtIndex:sc.row];
    if (sc.selectedSegmentIndex == 0)
    {
        oq.questionResult = @"YES";
    }
    else
    {
        oq.questionResult = @"NO";
    }
    
}



-(void)itemSelected:(NSString *)questionItem
{
    NSString *subStr;
    
    subStr = [[questionItem substringToIndex:1]substringFromIndex:0 ];
    selectedButton.titleLabel.text = subStr;
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:selectedButton.bSection];
    NSArray *array = [dictionary objectForKey:@"Questions"];
    ObservationQuestion *oq = [array objectAtIndex:selectedButton.bRow];
    
    oq.questionResult = subStr;
    
    selectedButton = nil;
    
    [self.questionsPickerPopover dismissPopoverAnimated:YES];
}

-(void)buttonAction:(ButtonControlExt *)sender
{
    bIsModified = YES;
       
    if (self.questionPicker == nil) {
        self.questionPicker = [[QuestionDropdownViewController alloc]
                               initWithStyle:UITableViewStylePlain];
        self.questionPicker.delegate = self;
        
        if (selectedButton == nil)
        {
            selectedButton = [[ButtonControlExt alloc]init];
            //selectedButton = sender;
        }
        
        
        self.questionsPickerPopover = [[UIPopoverController alloc]
                                       initWithContentViewController:self.questionPicker];
        
        
    }
    
     selectedButton = sender;
    [self.questionsPickerPopover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
       
}



-(IBAction)reset
{
    self.view = nil;
    
    self.tabBarController.selectedIndex = 0;
    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self save];
        }
    }
    if (actionSheet.tag == 2)
    {
        
        
    }
}




-(IBAction)save
{
    if ([self isDataValid] == YES)
    {
        DBHelper *db = [[DBHelper alloc] init];
        
        BOOL bNoError = YES;
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate *date = [NSDate date];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        NSDictionary *dictionary = [listOfItems objectAtIndex:0];
        NSArray *array = [dictionary objectForKey:@"Questions"];
        
        for (ObservationQuestion *oq in array)
        {
            
            if (bDataSaved == NO)
            {
                
                // Add our default user object in Core Data
                PostObservations *ob = (PostObservations *)[NSEntityDescription insertNewObjectForEntityForName:@"PostObservations" inManagedObjectContext:db.managedObjectContext];
                
                [ob setObservationID:observationID];
                [ob setUserID:userID];
                [ob setPoqType:oq.questionType];
                [ob setPoqID:oq.questionID];
                [ob setAnswer:oq.questionResult];
                [ob setSectionName:@"ScienceContent"];
                
                [ob setDateAdded:formattedDate];
                
                
            }
            else
            {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@ and poqID=%@",observationID,@"ScienceContent",oq.questionID];
                
                
                [fetchRequest setEntity:entity];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setFetchLimit:1];
                
                NSError *error;
                NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                
                PostObservations *po = nil;
                
                po = [items objectAtIndex:0];
                
                if ([items count]>0)
                {
                    po.answer = oq.questionResult;
                    po.lastEdit = formattedDate;
                    po.dataSync = nil;
                }
            }
            
            
            // Commit to core data
            NSError *error;
            if (![db.managedObjectContext save:&error])
            {
                NSLog(@"Failed to add default user with error: %@", [error domain]);
            }
            else
            {
                // Check for network connection
                if([self connectedToNetwork] == YES)
                {
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
                    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
                    
                    
                    //save to web service
                    NSURL *baseURL = [NSURL URLWithString:[settings objectForKey:@"WebServiceURL"]];
                    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
                    NSMutableDictionary *parms  = [[NSMutableDictionary alloc] init];
                    [parms setObject:[settings objectForKey:@"UsageID"] forKey:@"UsageID"];
                    [parms setObject:[settings objectForKey:@"UsageCode"] forKey:@"UsageCode"];
                    [parms setObject:observationID  forKey:@"ObservationID"];
                    [parms setObject:userID forKey:@"UserID"];
                    [parms setObject:[oq.questionID stringValue] forKey:@"POQID"];
                    [parms setObject:oq.questionType forKey:@"POQType"];
                    [parms setObject:oq.questionResult forKey:@"Answer"];
                    [parms setObject:@"ScienceContent" forKey:@"SectionName"];
                    [parms setObject:@"" forKey:@"SubSectionName"];
                    [parms setObject:formattedDate forKey:@"DateAdded"];
                    [parms setObject:formattedDate forKey:@"LastEdit"];
                    if (bDataSaved == NO)
                    {
                        [parms setObject:@"YES" forKey:@"IsNew"];
                    }
                    else
                    {
                        [parms setObject:@"NO" forKey:@"IsNew"];
                    }
                    
                    
                    
                    //NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"radius",nil];
                    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[settings objectForKey:@"WebService_PostObservationAnswers"] parameters:parms];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         NSString *response = [operation responseString];
                         NSLog(@"response: [%@]",response);
                         
                         if ([response rangeOfString:@"SUCCESS"].location != NSNotFound)
                         {
                             
                             NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                             NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                             
                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@ and poqID=%@",observationID,@"ScienceContent",oq.questionID];
                             
                             
                             [fetchRequest setEntity:entity];
                             [fetchRequest setPredicate:predicate];
                             [fetchRequest setFetchLimit:1];
                             
                             NSError *error;
                             NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                             
                             PostObservations *po = nil;
                             
                             if ([items count]>0)
                             {
                                 po = [items objectAtIndex:0];
                                 po.dataSync = formattedDate;
                                 if (![db.managedObjectContext save:&error])
                                 {
                                     NSLog(@"Failed to add default user with error: %@", [error domain]);
                                 }
                                 
                             }
                         }
                         
                     }
                                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
                     {
                         NSLog(@"error: %@", [operation error]);
                     }];
                    
                    [operation start];
                }
            }
        }
        
        
        if (bNoError == YES)
        {
            UIAlertView * saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"The Science Content data has been saved.";
            [saveAlert addButtonWithTitle:@"OK"];
            
            [saveAlert show];
            
            bDataSaved = YES;
            bIsModified = NO;
        }
    }
    
}


-(BOOL) connectedToNetwork
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	Reachability *r = [Reachability reachabilityWithHostName:[settings objectForKey:@"NetworkConnectURL"]];	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

-(BOOL)isDataValid
{
    
    BOOL bIsValid = YES;
    
    NSDictionary *dictionary = [listOfItems objectAtIndex:0];
    NSArray *array = [dictionary objectForKey:@"Questions"];
    
    for (ObservationQuestion *oq in array)
    {
        if ([oq.questionType isEqualToString:@"drop"] && [oq.questionResult isEqualToString:@"Select Item"])
        {
            bIsValid = NO;
        }
    }
    
//    dictionary = [listOfItems objectAtIndex:1];
//    array = [dictionary objectForKey:@"Questions"];
//    
//    for (ObservationQuestion *oq in array)
//    {
//        if ([oq.questionType isEqualToString:@"drop"] && [oq.questionResult isEqualToString:@"Select Item"])
//        {
//            bIsValid = NO;
//        }
//    }
    
    if (bIsValid == NO)
    {
        UIAlertView * saveAlert = [[UIAlertView alloc] init];
        saveAlert.delegate = self;
        saveAlert.title = @"ISIOP";
        saveAlert.message = @"The ratings fields must be completed.";
        saveAlert.tag = 2;
        [saveAlert addButtonWithTitle:@"OK"];
        
        [saveAlert show];
        
    }
    
    return bIsValid;
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


@end
