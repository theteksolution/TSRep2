//
//  StudentDirectedViewController.m
//  TestTabController1
//
//  Created by LRich on 11/14/12.
//

#import "StudentDirectedViewController.h"
#import "ObservationQuestion.h"
#import "PostObservations.h"
#import "DBHelper.h"
#import "VariableStore.h"
#import "Reachability.h"
#import "AFNetworking.h"

@interface StudentDirectedViewController ()

@end

@implementation StudentDirectedViewController
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    [self loadQuestions];
    
    VariableStore *vs = [VariableStore sharedInstance];
    // Get the ObservationID  and load Observation data
    
    if ([vs.gClassID isEqualToString:@""])
    {
        self.navItem.title = @"Investigation Experiences (Student)";
    }
    else
    {
        NSMutableString *myString = [NSMutableString stringWithString:vs.gClassID];
        [myString appendString:@" - "];
        [myString appendString:@"Investigation Experiences (Student)"];
        self.navItem.title = myString;
    }
    
    bDataSaved = NO;
    bIsModified = NO;
          
    observationID = vs.gObservationID;
    userID = vs.gUserID;
    [self loadPreviousObservation];
   
    
}

-(void)loadPreviousObservation
{
    
    //Here load observations for a given email address
    // [[VariableStore sharedInstance] gEmail];
       
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@",observationID,@"StudentDirected"];
    
       
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
        
        dictionary = [listOfItems objectAtIndex:1];
        array = [dictionary objectForKey:@"Questions"];
        
        for (ObservationQuestion *oq in array)
        {
            if ([ob.poqID isEqualToNumber:oq.questionID])
            {
                oq.questionResult = ob.answer;
            }
        }
        
    }
    
    
}


-(void)loadQuestions
{
    
    
    listOfItems = [[NSMutableArray alloc] init];
    
    
    ObservationQuestion *o1 = [[ObservationQuestion alloc]init];
    o1.questionText = @"Students research what is already known from existing resources to generate ideas to investigate";
    o1.questionType = @"bool";
    o1.questionID = [NSNumber numberWithInt:1];
    o1.questionResult = @"NO";
    
    ObservationQuestion *o2 = [[ObservationQuestion alloc]init];
    o2.questionText = @"Students generate investigation questions";
    o2.questionType = @"bool";
    o2.questionID = [NSNumber numberWithInt:2];
    o2.questionResult = @"NO";
    
    
    ObservationQuestion *o3 = [[ObservationQuestion alloc]init];
    o3.questionText = @"Teacher helps students figure out what will make a good investigation question (i.e. testable, empirical)";
    o3.questionType = @"bool";
    o3.questionID = [NSNumber numberWithInt:3];
    o3.questionResult = @"NO";
    
    ObservationQuestion *o4 = [[ObservationQuestion alloc]init];
    o4.questionText = @"Students make their own predictions or formulate hypothesis as part of an investigation";
    o4.questionType = @"bool";
    o4.questionID = [NSNumber numberWithInt:4];
    o4.questionResult = @"NO";
    
    ObservationQuestion *o5 = [[ObservationQuestion alloc]init];
    o5.questionText = @"Emphasis Rating: How much of the instructional time was spent on these questions/exploration activities?";
    o5.questionType = @"drop";
    o5.questionID = [NSNumber numberWithInt:5];
    o5.questionResult = @"Select Item";
    
    NSArray *questions1Array = [NSArray arrayWithObjects:o1, o2,o3,o4,o5, nil];
    NSDictionary *questions1Dict = [NSDictionary dictionaryWithObject:questions1Array forKey:@"Questions"];
    
    
    ObservationQuestion *o6 = [[ObservationQuestion alloc]init];
    o6.questionText = @"Students design ways to investigate research questions including choosing appropriate variables, techniques, and tools to gather, record, and analyze data";
    o6.questionType = @"bool";
    o6.questionID = [NSNumber numberWithInt:6];
    o6.questionResult = @"NO";
    
    
    ObservationQuestion *o7 = [[ObservationQuestion alloc]init];
    o7.questionText = @"Teacher discusses with students the role of variables and controls in investigation designs";
    o7.questionType = @"bool";
    o7.questionID = [NSNumber numberWithInt:7];
    o7.questionResult = @"NO";
    
    ObservationQuestion *o8 = [[ObservationQuestion alloc]init];
    o8.questionText = @"Students identify treatment and control variables";
    o8.questionType = @"bool";
    o8.questionID = [NSNumber numberWithInt:8];
    o8.questionResult = @"NO";
    
    ObservationQuestion *o9 = [[ObservationQuestion alloc]init];
    o9.questionText = @"Emphasis Rating: How much of the instructional time was spent on these questions/exploration activities?";
    o9.questionType = @"drop";
    o9.questionID = [NSNumber numberWithInt:9];
    o9.questionResult = @"Select Item";
    
    
    NSArray *questions2Array = [NSArray arrayWithObjects:o6, o7,o8,o9, nil];
    NSDictionary *questions2Dict = [NSDictionary dictionaryWithObject:questions2Array forKey:@"Questions"];
    
    [listOfItems addObject:questions1Dict];
    [listOfItems addObject:questions2Dict];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
        Segment*ontrolExt *questionBool = (Segment*ontrolExt *) [cell viewWithTag:1003];
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
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 62;
    } else {
        return 62;
    }
}





-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section ==0)
    {
        return @"Questioning/Exploration";
    }
    else
    {
        return @"Design";
    }
}

-(void)segmentAction:(Segment*ontrolExt *)sender
{
   
    bIsModified = YES;
    
    Segment*ontrolExt *sc = (Segment*ontrolExt *)sender;
       
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
            saveAlert.message = @"Save this Student Directed Information?";
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



//+ (StudentDirectedViewController *)sharedInstance
//{
//    // the instance of this class is stored here
//    static StudentDirectedViewController *myInstance = nil;
//    
//    // check to see if an instance already exists
//    if (nil == myInstance) {
//        myInstance  = [[[self class] alloc] init];
//        // initialize variables here
//    }
//    // return the instance of this class
//    return myInstance;
//}
//

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
                [ob setSectionName:@"StudentDirected"];
                [ob setSubSectionName:@"Questioning/Exploration"];
                [ob setDateAdded:formattedDate];
                [ob setLastEdit:formattedDate];
                
            }
            else
            {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@ and poqID=%@",observationID,@"StudentDirected",oq.questionID];
                
                
                [fetchRequest setEntity:entity];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setFetchLimit:1];
                
                NSError *error;
                NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                
                PostObservations *po = nil;
                
                if ([items count]>0)
                {
                    po = [items objectAtIndex:0];
                    
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
                bNoError = NO;
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
                    [parms setObject:observationID forKey:@"ObservationID"];
                    [parms setObject:userID forKey:@"UserID"];
                    [parms setObject:[oq.questionID stringValue] forKey:@"POQID"];
                    [parms setObject:oq.questionType forKey:@"POQType"];
                    [parms setObject:oq.questionResult forKey:@"Answer"];
                    [parms setObject:@"StudentDirected" forKey:@"SectionName"];
                    [parms setObject:@"Questioning/Exploration" forKey:@"SubSectionName"];
                    [parms setObject:formattedDate forKey:@"DateAdded"];
                    [parms setObject:formattedDate forKey:@"LastEdit"];
                    if (bDataSaved == NO)
                    {
                        [parms setObject:@"Y" forKey:@"IsNew"];
                    }
                    else
                    {
                        [parms setObject:@"N" forKey:@"IsNew"];
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
                             
                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@ and poqID=%@",observationID,@"StudentDirected",oq.questionID];
                             
                             
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
        
        dictionary = [listOfItems objectAtIndex:1];
        array = [dictionary objectForKey:@"Questions"];
        
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
                [ob setSectionName:@"StudentDirected"];
                [ob setSubSectionName:@"Design"];
                
                [ob setDateAdded:formattedDate];
            }
            else
            {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@ and poqID=%@",observationID,@"StudentDirected",oq.questionID];
                
                
                [fetchRequest setEntity:entity];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setFetchLimit:1];
                
                NSError *error;
                NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                
                PostObservations *po = nil;
                
                if ([items count]>0)
                {
                    po = [items objectAtIndex:0];
                    
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
                bNoError = NO;
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
                    [parms setObject:observationID forKey:@"ObservationID"];
                    [parms setObject:userID forKey:@"UserID"];
                    [parms setObject:[oq.questionID stringValue] forKey:@"POQID"];
                    [parms setObject:oq.questionType forKey:@"POQType"];
                    [parms setObject:oq.questionResult forKey:@"Answer"];
                    [parms setObject:@"StudentDirected" forKey:@"SectionName"];
                    [parms setObject:@"Design" forKey:@"SubSectionName"];
                    [parms setObject:formattedDate forKey:@"DateAdded"];
                    [parms setObject:formattedDate forKey:@"LastEdit"];
                    if (bDataSaved == NO)
                    {
                        [parms setObject:@"Y" forKey:@"IsNew"];
                    }
                    else
                    {
                        [parms setObject:@"N" forKey:@"IsNew"];
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
                             
                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and sectionName=%@ and poqID=%@",observationID,@"StudentDirected",oq.questionID];
                             
                             
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
        
        if(bNoError == YES)
        {
            UIAlertView * saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"The Student Directed data has been saved.";
            [saveAlert addButtonWithTitle:@"OK"];
            
            [saveAlert show];
            
            bDataSaved = YES;
            bIsModified = NO;
        }
    }
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
        
    dictionary = [listOfItems objectAtIndex:1];
    array = [dictionary objectForKey:@"Questions"];
        
    for (ObservationQuestion *oq in array)
    {
        if ([oq.questionType isEqualToString:@"drop"] && [oq.questionResult isEqualToString:@"Select Item"])
        {
            bIsValid = NO;
        }
    }
    
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


-(BOOL) connectedToNetwork
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    
	Reachability *r = [Reachability reachabilityWithHostName:[settings objectForKey:@"NetworkConnectURL"]];

	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
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
