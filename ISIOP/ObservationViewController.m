//
//  observationViewController.m
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import "ObservationViewController.h"
#import "DBHelper.h"
#import "ObservationInformation.h"
#import "Variablestore.h"
#import "Reachability.h"
#import "AFNetworking.h"


@interface ObservationViewController ()

@end

@implementation ObservationViewController
{
    NSString *observationID;
    BOOL bDataSaved;
    BOOL bNewLessonEvent;
    BOOL bCounterOK;
    BOOL bIsModified;
    
    ObservationInformation *obSave;
    UIButton *selectLessonEvent;
    
}


@synthesize classActivityCode = _classActivityCode;
@synthesize classOrganizationCode = _classOrganizationCode;
@synthesize studentDisengagementCode = _studentDisengagementCode;
@synthesize activityCodesPicker = _activityCodesPicker;
@synthesize activityCodesPopover = _activityCodesPopover;
@synthesize lessonEventsPicker = _lessonEventsPicker;
@synthesize lessonEventsPopover = _lessonEventsPopover;
@synthesize notes = _notes;
@synthesize navItem = _navItem;
@synthesize currentLessonEvent = _currentLessonEvent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.delegate = self;
    
    [self.notes addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    VariableStore *vs = [VariableStore sharedInstance];
    // Get the observationID  and load observation data
    
    if ([vs.gClassID isEqualToString:@""])
    {
        self.navItem.title = @"Observation";
    }
    else
    {
        NSMutableString *myString = [NSMutableString stringWithString:vs.gClassID];
        [myString appendString:@" - "];
        [myString appendString:@"Observation"];
        self.navItem.title = myString;
    }
    
    bNewLessonEvent = YES;
    bCounterOK = NO;
    bIsModified = NO;
    observationID = vs.gObservationID;
    
    [self loadPreviousobservation:@"Lesson Event #1"];
    
        
    
}


-(void)loadPreviousobservation:(NSString *)ev
{
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and lessonEventName=%@",observationID,ev];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error;
    NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    ObservationInformation *oi = nil;
    
    if ([items count]>0)
    {
        bDataSaved = YES;
        
        oi = [items objectAtIndex:0];
        
        UILabel *theLabel = (UILabel*)[self.view viewWithTag:[@"4001" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.solicit integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4002" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.facts integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4003" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.procedural integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4004" intValue]];
        theLabel.text  = [NSString stringWithFormat:@"%d", [oi.explain integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4005" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.apply integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4006" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.meta integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4007" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.newAndOld integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4008" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.itinerary integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4009" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.directions integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4010" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.foreshadow integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4011" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.situate integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4012" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.acknowledge integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4013" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.rephrase integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4014" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.correct integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4015" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.praise integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4016" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.giveInfo integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4017" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.suggest integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4018" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.thinkAloud integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4019" intValue]];
        theLabel.text = [NSString stringWithFormat:@"%d", [oi.reflect integerValue]];
        theLabel = (UILabel*)[self.view viewWithTag:[@"4020" intValue]];
        theLabel.text  = [NSString stringWithFormat:@"%d", [oi.summarize integerValue]];
        
        
        self.classActivityCode.titleLabel.text = oi.classActivityCode;
        self.studentDisengagementCode.titleLabel.text = oi.studentDisengagementCode;
        self.classOrganizationCode.titleLabel.text = oi.classOrganizationCode;
        self.notes.text = oi.notes;
        
        bNewLessonEvent = NO;
        bCounterOK = NO;
        
    }
}



-(IBAction)save:(id)sender
{
    
    BOOL bIsValid;
    
    bIsValid =  [self isDataValid];
    
    if (bIsValid == YES)
    {
        VariableStore *vs = [VariableStore sharedInstance];
        
        DBHelper *db = [[DBHelper alloc] init];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate *date = [NSDate date];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        
        
        if (bDataSaved == NO || bNewLessonEvent == YES)
        {
            
            obSave = (ObservationInformation *)[NSEntityDescription insertNewObjectForEntityForName:@"ObservationInformation" inManagedObjectContext:db.managedObjectContext];
            
            [obSave setObservationID:vs.gObservationID];
            [obSave setUserID:vs.gUserID];
            
            UILabel *theLabel = (UILabel*)[self.view viewWithTag:[@"4001" intValue]];
            [obSave setSolicit:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4002" intValue]];
            [obSave setFacts:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4003" intValue]];
            [obSave setProcedural:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4004" intValue]];
            [obSave setExplain:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4005" intValue]];
            [obSave setApply:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4006" intValue]];
            [obSave setMeta:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4007" intValue]];
            [obSave setNewAndOld:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4008" intValue]];
            [obSave setItinerary:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4009" intValue]];
            [obSave setDirections:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4010" intValue]];
            [obSave setForeshadow:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4011" intValue]];
            [obSave setSituate:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4012" intValue]];
            [obSave setAcknowledge:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4013" intValue]];
            [obSave setRephrase:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4014" intValue]];
            [obSave setCorrect:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4015" intValue]];
            [obSave setPraise:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4016" intValue]];
            [obSave setGiveInfo:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4017" intValue]];
            [obSave setSuggest:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4018" intValue]];
            [obSave setThinkAloud:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4019" intValue]];
            [obSave setReflect:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            theLabel = (UILabel*)[self.view viewWithTag:[@"4020" intValue]];
            [obSave setSummarize:[NSNumber numberWithInteger:[theLabel.text integerValue]]];
            
            [obSave setClassActivityCode:self.classActivityCode.titleLabel.text];
            [obSave setStudentDisengagementCode:self.studentDisengagementCode.titleLabel.text];
            [obSave setClassOrganizationCode:self.classOrganizationCode.titleLabel.text];
            [obSave setLessonEventName:self.currentLessonEvent.text];
            
            [obSave setNotes:self.notes.text];
            
            [obSave setDateAdded:formattedDate];
            [obSave setLastEdit:formattedDate];
            
        }
        else
        {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and lessonEventName=%@",observationID,self.currentLessonEvent.text];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchLimit:1];
            
            NSError *error;
            NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            obSave = nil;
            
            if ([items count]>0)
            {
                
                obSave = [items objectAtIndex:0];
                
                UILabel *theLabel = (UILabel*)[self.view viewWithTag:[@"4001" intValue]];
                obSave.solicit = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                
                theLabel = (UILabel*)[self.view viewWithTag:[@"4002" intValue]];
                obSave.facts = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4003" intValue]];
                obSave.procedural = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4004" intValue]];
                obSave.explain = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4005" intValue]];
                obSave.apply = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4006" intValue]];
                obSave.meta = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4007" intValue]];
                obSave.newAndOld =[NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4008" intValue]];
                obSave.itinerary = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4009" intValue]];
                obSave.directions = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4010" intValue]];
                obSave.foreshadow = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4011" intValue]];
                obSave.situate = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4012" intValue]];
                obSave.acknowledge = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4013" intValue]];
                obSave.rephrase = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4014" intValue]];
                obSave.correct = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4015" intValue]];
                obSave.praise = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4016" intValue]];
                obSave.giveInfo = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4017" intValue]];
                obSave.suggest = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4018" intValue]];
                obSave.thinkAloud = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4019" intValue]];
                obSave.reflect = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                theLabel = (UILabel*)[self.view viewWithTag:[@"4020" intValue]];
                obSave.summarize = [NSNumber numberWithInteger:[theLabel.text integerValue]];
                
                obSave.classActivityCode = self.classActivityCode.titleLabel.text;
                obSave.studentDisengagementCode = self.studentDisengagementCode.titleLabel.text;
                obSave.classOrganizationCode = self.classOrganizationCode.titleLabel.text;
                
                obSave.notes = self.notes.text;
                
                obSave.lastEdit = formattedDate;
                obSave.dataSync = nil;
                
                
                
                
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
            
            UIAlertView * saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"The Classroom Information data has been saved.";
            [saveAlert addButtonWithTitle:@"OK"];
            
            [saveAlert show];
            
            
            // Check for network connection
            if([self connectedToNetwork] == YES && obSave != nil)
            {
                
                NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
                NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
                
                
                //save to web service
                NSURL *baseURL = [NSURL URLWithString:[settings objectForKey:@"WebServiceURL"]];
                AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
                NSMutableDictionary *parms  = [[NSMutableDictionary alloc] init];
                [parms setObject:[settings objectForKey:@"UsageID"] forKey:@"UsageID"];
                [parms setObject:[settings objectForKey:@"UsageCode"] forKey:@"UsageCode"];
                [parms setObject:obSave.observationID forKey:@"observationID"];
                [parms setObject:vs.gUserID forKey:@"UserID"];
                [parms setObject:[obSave.acknowledge stringValue] forKey:@"AcknowledgeCount"];
                [parms setObject:[obSave.apply stringValue] forKey:@"ApplyCount"];
                [parms setObject:[obSave.correct stringValue] forKey:@"CorrectCount"];
                [parms setObject:[obSave.directions stringValue] forKey:@"DirectionsCount"];
                [parms setObject:[obSave.explain stringValue] forKey:@"ExplainCount"];
                [parms setObject:[obSave.facts stringValue] forKey:@"FactsCount"];
                [parms setObject:[obSave.foreshadow stringValue] forKey:@"ForeshadowCount"];
                [parms setObject:[obSave.giveInfo stringValue] forKey:@"GiveInfoCount"];
                [parms setObject:[obSave.itinerary stringValue] forKey:@"ItineraryCount"];
                [parms setObject:[obSave.meta stringValue] forKey:@"MetaCount"];
                [parms setObject:[obSave.newAndOld stringValue] forKey:@"NewAndOldCount"];
                [parms setObject:[obSave.praise stringValue] forKey:@"PraiseCount"];
                [parms setObject:[obSave.procedural stringValue] forKey:@"ProceduralCount"];
                [parms setObject:[obSave.reflect stringValue] forKey:@"ReflectCount"];
                [parms setObject:[obSave.rephrase stringValue] forKey:@"RephraseCount"];
                [parms setObject:[obSave.situate stringValue] forKey:@"SituateCount"];
                [parms setObject:[obSave.suggest stringValue] forKey:@"SuggestCount"];
                [parms setObject:[obSave.summarize stringValue] forKey:@"SummarizeCount"];
                [parms setObject:[obSave.thinkAloud stringValue] forKey:@"ThinkAloudCount"];
                [parms setObject:obSave.classActivityCode forKey:@"ClassActivityCode"];
                [parms setObject:obSave.classOrganizationCode forKey:@"ClassOrganizationCode"];
                [parms setObject:obSave.studentDisengagementCode forKey:@"StudentDisengagementCode"];
                [parms setObject:obSave.lessonEventName forKey:@"LessonEventName"];
                [parms setObject:obSave.notes forKey:@"Notes"];
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
                
                
                
                //NSDictionary *params = [NSDictionary dictionaryWithobjectsAndKeys:@"1",@"radius",nil];
                NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[settings objectForKey:@"WebService_ObservationInformation"] parameters:parms];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseobject)
                 {
                     
                     
                     NSString *response = [operation responseString];
                     NSLog(@"response: [%@]",response);
                     
                     if ([response rangeOfString:@"SUCCESS"].location != NSNotFound)
                     {
                         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                         NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                         
                         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@ and lessonEventName=%@",observationID,self.currentLessonEvent.text];
                         
                         [fetchRequest setEntity:entity];
                         [fetchRequest setPredicate:predicate];
                         [fetchRequest setFetchLimit:1];
                         
                         NSError *error;
                         NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                         
                         if ([items count]>0)
                         {
                             obSave = [items objectAtIndex:0];
                             obSave.dataSync = formattedDate;
                         }
                         // Commit to core data
                         
                         if (![db.managedObjectContext save:&error])
                         {
                             NSLog(@"Failed to add default user with error: %@", [error domain]);
                         }
                         
                         
                     }
                     
                     
                     
                     
                     
                 }
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error)
                 {
                     NSLog(@"error: %@", [operation error]);
                 }];
                
                [operation start];
                
            }
            
            bDataSaved = YES;
            bIsModified = NO;
        }
    }
    
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


-(IBAction)createLessonEvent:(id)sender
{
    
    if ([self isDataValid] == YES)
    {
        
        if (bIsModified == YES)
        {
            UIAlertView *saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"Lesson data has been altered, create a new Lesson Event?";
            [saveAlert addButtonWithTitle:@"Save Data Then Create New Lesson Event"];
            [saveAlert addButtonWithTitle:@"Just Create New Lesson Event"];
            [saveAlert addButtonWithTitle:@"Cancel"];
            saveAlert.tag = 4;
            
            [saveAlert show];
        }
        else
        {
            UIAlertView *saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"Create a new Lesson Event?";
            [saveAlert addButtonWithTitle:@"OK"];
            [saveAlert addButtonWithTitle:@"Cancel"];
            saveAlert.tag = 2;
    
            [saveAlert show];

        }
        
    }
    
}

-(IBAction)selectLessonEvent:(id)sender
{
   
    if ([self isDataValid] == YES)
    {
        if (bIsModified == YES)
        {
            selectLessonEvent = (UIButton *)sender;
            
            UIAlertView *saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"Lesson data has been altered, select the Lesson Event?";
            [saveAlert addButtonWithTitle:@"Save Data Then Select Lesson Event"];
            [saveAlert addButtonWithTitle:@"Just Select Lesson Event"];
            [saveAlert addButtonWithTitle:@"Cancel"];
            saveAlert.tag = 5;
            
            [saveAlert show];
        }
        else
        {
            UIButton *button = (UIButton *)sender;
    
            if (self.lessonEventsPicker == nil) {
                self.lessonEventsPicker = [[LessonEventsViewController alloc] init];
        
                self.lessonEventsPicker.delegate = self;
                self.lessonEventsPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:self.lessonEventsPicker];
            }
   
            bNewLessonEvent = NO;
            bIsModified = NO;
    
            [self.lessonEventsPopover presentPopoverFromRect:[button bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
    }
}


- (IBAction)incrementButtonClicked:(id)sender {
    
    
    NSString *theTag = [NSString stringWithFormat:@"%d", [sender tag]];
    NSString *subStr = [[theTag substringToIndex:4]substringFromIndex:1 ];
    subStr = [@"4" stringByAppendingString:subStr];
    UILabel *theLabel = (UILabel*)[self.view viewWithTag:[subStr intValue]];
    NSInteger theNewValue = [theLabel.text intValue] + 1;
    theLabel.text = [NSString stringWithFormat:@"%d", theNewValue];
    bIsModified = YES;
    
}


- (IBAction)decrementButtonClicked:(id)sender {
    
    NSString *theTag = [NSString stringWithFormat:@"%d", [sender tag]];
    NSString *subStr = [[theTag substringToIndex:4]substringFromIndex:1 ];
    subStr = [@"4" stringByAppendingString:subStr];
    UILabel *theLabel = (UILabel*)[self.view viewWithTag:[subStr intValue]];
    if(![theLabel.text isEqualToString:@"0"])
    {
        NSInteger theNewValue = [theLabel.text intValue] - 1;
        theLabel.text = [NSString stringWithFormat:@"%d", theNewValue];
        bIsModified = YES;
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    bIsModified = YES;
    //NSLog(@"the text changed");
}


-(void)practiceCodeSelected:(NSString *)practiceCode
{
    
    [self.practiceCodesPopover dismissPopoverAnimated:YES];

}

-(void)lessonEventSelected:(NSString *)lessonEventItem
{
    self.currentLessonEvent.text = lessonEventItem;
    
    [self loadPreviousobservation:lessonEventItem];
    
    bIsModified = NO;
    
    [self.lessonEventsPopover dismissPopoverAnimated:YES];
    self.lessonEventsPicker = nil;
}

-(void)itemCodeSelected:(NSString *)activityCodeItem activityCodeType:(NSString *)aCodeType
{
    if ([aCodeType isEqualToString:@"AC"])
    {
         self.classActivityCode.titleLabel.text = activityCodeItem;
    }
    else if ([aCodeType isEqualToString:@"OC"])
    {
         self.classOrganizationCode.titleLabel.text = activityCodeItem;
    }
    else
    {
         self.studentDisengagementCode.titleLabel.text = activityCodeItem;
    }
    
   
    [self.activityCodesPopover dismissPopoverAnimated:YES];
    self.activityCodesPicker = nil;
    bIsModified = YES;
}



- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc {
    
    // When we have needed fields this will be implemented
    
    BOOL bValid = NO;
    
    bValid = [self isDataValid];
    
    if (bValid == YES)
    {
        if (bDataSaved == NO)
        {
            UIAlertView *saveAlert = [[UIAlertView alloc] init];
            saveAlert.delegate = self;
            saveAlert.title = @"ISIOP";
            saveAlert.message = @"Save this Background Information?";
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
    else
    {
        return NO;
    }
       
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    
    if (actionSheet.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self save:self];
        }
    }
    if (actionSheet.tag == 2)
    {
        
        if (buttonIndex == 0)
        {
            for (UIView* potentialLabel in self.view.subviews)
            {
                if ([potentialLabel isMemberOfClass: [UILabel class]])
                {
                    
                    NSString *theTag = [NSString stringWithFormat:@"%d", potentialLabel.tag];
                    NSString *subStr = [[theTag substringToIndex:1]substringFromIndex:0 ];
                    
                    if ([subStr isEqualToString:@"4"])
                    {
                        UILabel* actualButton = (UILabel *) potentialLabel;
                        actualButton.text =@"0";
                    }
                }
            }
            
            self.classActivityCode.titleLabel.text = @"Select";
            self.studentDisengagementCode.titleLabel.text = @"Select";
            self.classOrganizationCode.titleLabel.text = @"Select";
            self.notes.text = @"";
            
            DBHelper *db = [[DBHelper alloc] init];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",observationID];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            //[fetchRequest setFetchLimit:1];
            
            NSError *error;
            NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            
            NSInteger theNewValue = [items count] + 1;
            
            NSMutableString *myString = [NSMutableString stringWithString:@"Lesson Event #"];
                        
            [myString appendString:[NSMutableString stringWithString:[NSString stringWithFormat:@"%d", theNewValue]]];
            
            self.currentLessonEvent.text = myString;
            bNewLessonEvent = YES;
            bIsModified = NO;
        }
        
    }
    if (actionSheet.tag == 3)
    {
        if (buttonIndex == 0)
        {
            bCounterOK = YES;
            bIsModified = NO;
            [self save:self];
        }
    }
    
    if (actionSheet.tag == 4)
    {
        if (buttonIndex == 0)
        {
            bCounterOK = YES;
            bIsModified = NO;
            [self save:self];
            
            for (UIView* potentialLabel in self.view.subviews)
            {
                if ([potentialLabel isMemberOfClass: [UILabel class]])
                {
                    
                    NSString *theTag = [NSString stringWithFormat:@"%d", potentialLabel.tag];
                    NSString *subStr = [[theTag substringToIndex:1]substringFromIndex:0 ];
                    
                    if ([subStr isEqualToString:@"4"])
                    {
                        UILabel* actualButton = (UILabel *) potentialLabel;
                        actualButton.text =@"0";
                    }
                }
            }
            
            self.classActivityCode.titleLabel.text = @"Select";
            self.studentDisengagementCode.titleLabel.text = @"Select";
            self.classOrganizationCode.titleLabel.text = @"Select";
            self.notes.text = @"";
            
            DBHelper *db = [[DBHelper alloc] init];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",observationID];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            //[fetchRequest setFetchLimit:1];
            
            NSError *error;
            NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            
            NSInteger theNewValue = [items count] + 1;
            
            NSMutableString *myString = [NSMutableString stringWithString:@"Lesson Event #"];
            
            [myString appendString:[NSMutableString stringWithString:[NSString stringWithFormat:@"%d", theNewValue]]];
            
            self.currentLessonEvent.text = myString;
            bNewLessonEvent = YES;
            bIsModified = NO;
            
            
        }
        
        if (buttonIndex == 1)
        {
            for (UIView* potentialLabel in self.view.subviews)
            {
                if ([potentialLabel isMemberOfClass: [UILabel class]])
                {
                    
                    NSString *theTag = [NSString stringWithFormat:@"%d", potentialLabel.tag];
                    NSString *subStr = [[theTag substringToIndex:1]substringFromIndex:0 ];
                    
                    if ([subStr isEqualToString:@"4"])
                    {
                        UILabel* actualButton = (UILabel *) potentialLabel;
                        actualButton.text =@"0";
                    }
                }
            }
            
            self.classActivityCode.titleLabel.text = @"Select";
            self.studentDisengagementCode.titleLabel.text = @"Select";
            self.classOrganizationCode.titleLabel.text = @"Select";
            self.notes.text = @"";
            
            DBHelper *db = [[DBHelper alloc] init];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",observationID];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            //[fetchRequest setFetchLimit:1];
            
            NSError *error;
            NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            
            NSInteger theNewValue = [items count] + 1;
            
            NSMutableString *myString = [NSMutableString stringWithString:@"Lesson Event #"];
            
            [myString appendString:[NSMutableString stringWithString:[NSString stringWithFormat:@"%d", theNewValue]]];
            
            self.currentLessonEvent.text = myString;
            bNewLessonEvent = YES;
            bIsModified = NO;
        }
    }
    
    if (actionSheet.tag == 5)
    {
        if (buttonIndex == 0)
        {
            bCounterOK = YES;
            bIsModified = NO;
            [self save:self];
            
            if (self.lessonEventsPicker == nil) {
                self.lessonEventsPicker = [[LessonEventsViewController alloc] init];
                
                self.lessonEventsPicker.delegate = self;
                self.lessonEventsPopover = [[UIPopoverController alloc]
                                            initWithContentViewController:self.lessonEventsPicker];
            }
            
            bNewLessonEvent = NO;
            
            [self.lessonEventsPopover presentPopoverFromRect:[selectLessonEvent bounds] inView:selectLessonEvent permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];            
            
        }
        
        if (buttonIndex == 1)
        {
            
            if (self.lessonEventsPicker == nil) {
                self.lessonEventsPicker = [[LessonEventsViewController alloc] init];
                
                self.lessonEventsPicker.delegate = self;
                self.lessonEventsPopover = [[UIPopoverController alloc]
                                            initWithContentViewController:self.lessonEventsPicker];
            }
            
            bNewLessonEvent = NO;
            
            [self.lessonEventsPopover presentPopoverFromRect:[selectLessonEvent bounds] inView:selectLessonEvent permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

        }
        bIsModified = NO;
    }
    
}


- (IBAction)infoButtonClicked:(id)sender
{
    
    UIButton *button = (UIButton *)sender;
    NSString *theTag = [NSString stringWithFormat:@"%d", [sender tag]];
    
    if (self.practiceCodesPicker == nil) {
        self.practiceCodesPicker = [[PracticeCodesViewController alloc] init];
        self.practiceCodesPicker.delegate = self;
         
        self.practiceCodesPopover = [[UIPopoverController alloc]
                                       initWithContentViewController:self.practiceCodesPicker];
    }
    
    [self.practiceCodesPicker setPracticeCodeText:theTag];
    
    [self.practiceCodesPopover presentPopoverFromRect:[button bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    

}

-(IBAction)classActivityCodeClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
        
    if (self.activityCodesPicker == nil) {
        self.activityCodesPicker = [[ActivityCodesViewController alloc] init];
        
        self.activityCodesPicker.delegate = self;
        self.activityCodesPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:self.activityCodesPicker];
    }
    self.activityCodesPicker.codeType = @"AC";
    [self.activityCodesPopover presentPopoverFromRect:[button bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(IBAction)classOrganizationCodeClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (self.activityCodesPicker == nil) {
        self.activityCodesPicker = [[ActivityCodesViewController alloc] init];
        
        self.activityCodesPicker.delegate = self;
        self.activityCodesPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:self.activityCodesPicker];
    }
    self.activityCodesPicker.codeType = @"OC";
    [self.activityCodesPopover presentPopoverFromRect:[button bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(IBAction)studentDisengagementCodeClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (self.activityCodesPicker == nil) {
        self.activityCodesPicker = [[ActivityCodesViewController alloc] init];
        
        self.activityCodesPicker.delegate = self;
        self.activityCodesPopover = [[UIPopoverController alloc]
                                     initWithContentViewController:self.activityCodesPicker];
    }
    self.activityCodesPicker.codeType = @"DC";
    [self.activityCodesPopover presentPopoverFromRect:[button bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}

//+ (ObservationViewController *)sharedInstance
//{
//    // the instance of this class is stored here
//    static ObservationViewController *myInstance = nil;
//    
//    // check to see if an instance already exists
//    if (nil == myInstance) {
//        myInstance  = [[[self class] alloc] init];
//        // initialize variables here
//    }
//    // return the instance of this class
//    return myInstance;
//}

-(IBAction)reset
{
    self.view = nil;
    
    self.tabBarController.selectedIndex = 0;
    
}


-(BOOL)isDataValid
{
    
    if ([self.classActivityCode.titleLabel.text isEqualToString:@"Select"] || [self.studentDisengagementCode.titleLabel.text isEqualToString:@"Select"] || [self.classOrganizationCode.titleLabel.text isEqualToString:@"Select"])
    {
        UIAlertView * alert = [[UIAlertView alloc] init];
        
        alert.delegate = self;
        alert.title = @"ISIOP";
        alert.message = @"Please enter all Class/Student Codes";
        [alert addButtonWithTitle:@"OK"];
        //alert.tag = 2;
        
        
        [alert show];
        
        return NO;
    }
    
    if ([self checkCounters] == NO)
    {
        UIAlertView * alert = [[UIAlertView alloc] init];
        
        alert.delegate = self;
        alert.title = @"ISIOP";
        alert.message = @"None of the categories have any words observed. Are you sure you want to go on?";
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        alert.tag = 3;
        
        
        [alert show];
        
        return NO;

    }
        
    
    return YES;
}


-(BOOL)checkCounters
{
    
    int counterTotal = 0;
    
    
    for (UIView* potentialLabel in self.view.subviews)
    {
        if ([potentialLabel isMemberOfClass: [UILabel class]])
        {
            
            NSString *theTag = [NSString stringWithFormat:@"%d", potentialLabel.tag];
            NSString *subStr = [[theTag substringToIndex:1]substringFromIndex:0 ];
            
            if ([subStr isEqualToString:@"4"])
            {
                UILabel* actualButton = (UILabel *) potentialLabel;
                counterTotal = counterTotal + [actualButton.text integerValue];
            }
        }
    }
    
    if (counterTotal == 0 && bCounterOK == NO)
    {
        return NO;
    }
    
    
    return YES;
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




@end
