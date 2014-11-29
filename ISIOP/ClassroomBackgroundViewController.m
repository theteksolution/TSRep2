//
//  ClassroomBackgroundViewController.m
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import "ClassroomBackgroundViewController.h"
#import "DBHelper.h"
#import "ObservationBackgrounds.h"
#import "ObservationSequences.h"
#import "VariableStore.h"
#import "Reachability.h"
#import "AFNetworking.h"


@interface ClassroomBackgroundViewController ()

@end

@implementation ClassroomBackgroundViewController
{
    NSString *observationID;
    BOOL bDataSaved;
    BOOL bIsModified;
}


@synthesize startTime = _startTime;
@synthesize endTime = _endTime;
@synthesize classDate = _classDate;
@synthesize classId = _classId;
@synthesize startingNumFemales = _startingNumFemales;
@synthesize startingNumMales = _startingNumMales;
@synthesize endingNumFemales = _endingNumFemales;
@synthesize endingNumMales = _endingNumMales;
@synthesize additionalNotes = _additionalNotes;
@synthesize instructionalArtifacts = _instructionalArtifacts;
@synthesize codingCopy = _codingCopy;
@synthesize navItem = _navItem;

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
	// Do any additional setup after loading the view.
    
    VariableStore *vs = [VariableStore sharedInstance];
    // Get the ObservationID  and load Observation data
    // If new, the ObservationID will be 0, no load
    bDataSaved = NO;
    
    if ([vs.gClassID isEqualToString:@""])
    {
         self.navItem.title = @"Classroom Background Information";
    }
    else
    {
        NSMutableString *myString = [NSMutableString stringWithString:vs.gClassID];
        [myString appendString:@" - "];
        [myString appendString:@"Classroom Background Information"];
        self.navItem.title = myString;
    }
    
   
    if (![vs.gObservationID isEqualToString:@""])
    {
        observationID = vs.gObservationID;
        [self loadPreviousObservation];
    }
    else
    {
              
        
        DBHelper *db = [[DBHelper alloc] init];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationSequences"                                                                                                            inManagedObjectContext:db.managedObjectContext];
        
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"observationIDSequence" ascending:NO]];
        [fetchRequest setEntity:entity];
       
        [fetchRequest setFetchLimit:1];
        
        NSError *error;
        ObservationSequences *ob = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error].lastObject;
        
        //Now set the new unique key value
                
        int value = [ob.observationIDSequence intValue];
        int nextSequence = value + 1;
        
        
        [ob setObservationIDSequence:[NSNumber numberWithInt:nextSequence]];
        
        if (![db.managedObjectContext save:&error])
        {
            NSLog(@"Failed to add default user with error: %@", [error domain]);
        }
        
        
        NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        
        // Convert UUID to string and output result
        NSLog(@"UDID: %@", udid);
        
        NSMutableString *newObservationID = [NSMutableString stringWithString:udid];
        [newObservationID appendString:@"_"];
        [newObservationID appendString:[NSString stringWithFormat:@"%d", nextSequence]];
        
        
        //observationID = [NSNumber numberWithInt:value + 1];
        vs.gObservationID = newObservationID;
        observationID = newObservationID;
        
        // Convert UUID to string and output result
       // NSLog(@"UDID: %@", newObservationID);
        
    }
    
    
    bIsModified = NO;
    
    [self.classDate addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.classId addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.startTime addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.endTime addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.startingNumFemales addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.startingNumMales addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.endingNumFemales addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.endingNumMales addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    [self.additionalNotes addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.instructionalArtifacts addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.codingCopy addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.delegate = self;
    
    
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


-(void)segmentAction:(UISegmentedControl *)sender
{
    bIsModified = YES;
    //NSLog(@"the toggle selected");
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        
    bIsModified = YES;
    //NSLog(@"the text changed");
}

//+ (ClassroomBackgroundViewController *)sharedInstance
//{
//    // the instance of this class is stored here
//    static ClassroomBackgroundViewController *myInstance = nil;
//    
//    // check to see if an instance already exists
//    if (nil == myInstance) {
//        myInstance  = [[[self class] alloc] init];
//        // initialize variables here
//    }
//    // return the instance of this class
//    return myInstance;
//}

-(void)loadPreviousObservation
{
       
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationBackgrounds"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",observationID];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error;
    NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    ObservationBackgrounds *ob = nil;
    
    if ([items count]>0)
    {
        ob = [items objectAtIndex:0];
        
        self.classDate.text = ob.observationDate;
        self.classId.text = ob.classID;
        self.startingNumMales.text = [NSString stringWithFormat:@"%d", [ob.startingNumMales integerValue]];
        self.startingNumFemales.text = [NSString stringWithFormat:@"%d",[ob.startingNumFemales integerValue]];
        self.endingNumMales.text = [NSString stringWithFormat:@"%d",[ob.endingNumMales integerValue]];
        self.endingNumFemales.text = [NSString stringWithFormat:@"%d",[ob.endingNumFemales integerValue]];
        self.startTime.text = ob.classStartTime;
        self.endTime.text = ob.classEndTime;
        self.additionalNotes.text = ob.notes;
        if ([ob.useInstructionalArtifiacts isEqualToString:@"YES"])
        {
            self.instructionalArtifacts.selectedSegmentIndex = 0;
        }
        else
        {
            self.instructionalArtifacts.selectedSegmentIndex = 1;
        }
        
        if ([ob.obtainedArtifactsCopy isEqualToString:@"YES"])
        {
            self.codingCopy.selectedSegmentIndex = 0;
        }
        else
        {
            self.codingCopy.selectedSegmentIndex = 1;
        }
        
        bDataSaved = YES;
    }
}


- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc
{
   
    
    BOOL bValid = YES;
   
    bValid = [self isDataValid];
    
    if (bValid == YES)
    {
        if (bDataSaved == NO || bIsModified == YES)
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
        return  NO;
    }
                    
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    
    if (actionSheet.tag == 1)
    {
         if (buttonIndex == 0)
         {
             [self save];
         }
    }
   
}
                        

-(IBAction)classStartTime:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    self.startTime.text = formattedDate;

}
    

-(IBAction)classEndTime:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    self.endTime.text = formattedDate;
}

-(IBAction)classDate:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    self.classDate.text = formattedDate;
}


-(IBAction)reset
{
    self.view = nil;
    
    self.tabBarController.selectedIndex = 0;
}


-(IBAction)save
{
    
    //Validate Data here
    BOOL isValid;
    
    isValid = [self isDataValid];
 
    if (isValid == YES)
    {
        VariableStore *vs = [VariableStore sharedInstance];
        
        DBHelper *db = [[DBHelper alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate *date = [NSDate date];
        [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        
        
        //NSLog(@"date %@", formattedDate);
        
       
        vs.gEndTime = self.endTime.text;
               
        if (bDataSaved == NO)
        {
            
             // Add our default user object in Core Data
            ObservationBackgrounds *ob = (ObservationBackgrounds *)[NSEntityDescription insertNewObjectForEntityForName:@"ObservationBackgrounds" inManagedObjectContext:db.managedObjectContext];

            [ob setObservationID:observationID];
            [ob setUserID:vs.gUserID];
            [ob setClassID:self.classId.text];
            [ob setObservationDate:self.classDate.text];
            
            [ob setClassStartTime:self.startTime.text];
            [ob setClassEndTime:self.endTime.text];
            
            [ob setStartingNumMales:[NSNumber numberWithInteger:[self.startingNumMales.text integerValue]]];
            [ob setStartingNumFemales:[NSNumber numberWithInteger:[self.startingNumFemales.text integerValue]]];
            [ob setEndingNumMales:[NSNumber numberWithInteger:[self.endingNumMales.text integerValue]]];
            [ob setEndingNumFemales:[NSNumber numberWithInteger:[self.endingNumFemales.text integerValue]]];
            
            
            [ob setUseInstructionalArtifiacts:self.instructionalArtifacts.selected ? @"YES" : @"NO"];
            [ob setObtainedArtifactsCopy:self.codingCopy.selected ? @"YES" : @"NO"];
            [ob setNotes:self.additionalNotes.text];
            [ob setDateAdded:formattedDate];
            [ob setLastEdit:formattedDate];
            [ob setEmail:vs.gEmail];
        }
        else
        {
            /*
             01/23/2013
             
             Note we mark this as unsynced during the edit save
             
             
             after the network ws save we can mark it as synced
             
             */
            
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationBackgrounds"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                        
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",observationID];
            
            [fetchRequest setEntity:entity];
            [fetchRequest setPredicate:predicate];
            [fetchRequest setFetchLimit:1];
            
            NSError *error;
            NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            
            ObservationBackgrounds *ob = nil;
            
            if ([items count]>0)
            {
                ob = [items objectAtIndex:0];
                
                ob.observationDate = self.classDate.text;
                ob.classID = self.classId.text;
                ob.startingNumMales = [NSNumber numberWithInt:[self.startingNumMales.text integerValue]];
                ob.startingNumFemales = [NSNumber numberWithInt:[self.startingNumFemales.text integerValue]];
                ob.endingNumMales = [NSNumber numberWithInt:[self.endingNumMales.text integerValue]];
                ob.endingNumFemales = [NSNumber numberWithInt:[self.endingNumFemales.text integerValue]];
                
                ob.classStartTime = self.startTime.text;
                ob.classEndTime = self.endTime.text;
                ob.notes = self.additionalNotes.text;
                
                if (self.instructionalArtifacts.selectedSegmentIndex == 0)
                {
                    ob.useInstructionalArtifiacts = @"YES";
                }
                else
                {
                    ob.useInstructionalArtifiacts = @"NO";
                }
                
                
                if (self.codingCopy.selectedSegmentIndex == 0)
                {
                    ob.obtainedArtifactsCopy = @"YES";
                }
                else
                {
                    ob.obtainedArtifactsCopy = @"NO";
                }
                
                ob.lastEdit = formattedDate;
                ob.dataSync = nil;
                
                               
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
            saveAlert.message = @"The Classroom Background data has been saved.";
            [saveAlert addButtonWithTitle:@"OK"];
            
            [saveAlert show];
            
            
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
                [parms setObject:vs.gUserID forKey:@"UserID"];
                [parms setObject:self.startingNumFemales.text forKey:@"StartingNumberOfFemales"];
                [parms setObject:self.endingNumFemales.text forKey:@"EndingNumberOfFemales"];
                [parms setObject:self.startingNumMales.text forKey:@"StartingNumberOfMales"];
                [parms setObject:self.endingNumMales.text forKey:@"EndingNumberOfMales"];
                
                if (self.codingCopy.selectedSegmentIndex == 0)
                {
                    [parms setObject:@"YES" forKey:@"ObtainedArtifactsCopy"];
                }
                else
                {
                    [parms setObject:@"NO" forKey:@"ObtainedArtifactsCopy"];
                }
                
                
                if (self.instructionalArtifacts.selectedSegmentIndex == 0)
                {
                    [parms setObject:@"YES" forKey:@"UseInstructionalArtifacts"];
                }
                else
                {
                    [parms setObject:@"NO" forKey:@"UseInstructionalArtifacts"];
                }
                
                [parms setObject:self.classId.text forKey:@"ClassID"];
                [parms setObject:self.classDate.text forKey:@"ObservationDate"];
                [parms setObject:self.startTime.text forKey:@"ClassStartTime"];
                [parms setObject:self.endTime.text forKey:@"ClassEndTime"];
                [parms setObject:self.additionalNotes.text forKey:@"Notes"];
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
                NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[settings objectForKey:@"WebService_ObservationBackgrounds"] parameters:parms];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                 {
                     
                     NSString *response = [operation responseString];
                     NSLog(@"response: [%@]",response);
                     
                     if ([response rangeOfString:@"SUCCESS"].location != NSNotFound)
                     {
                         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                         
                         NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationBackgrounds"                                                                                                            inManagedObjectContext:db.managedObjectContext];
                         
                         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"observationID=%@",observationID];
                         
                         [fetchRequest setEntity:entity];
                         [fetchRequest setPredicate:predicate];
                         [fetchRequest setFetchLimit:1];
                         
                         NSError *error;
                         NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                         
                         ObservationBackgrounds *ob = nil;
                         
                         if ([items count]>0)
                         {
                             ob = [items objectAtIndex:0];
                             ob.dataSync = formattedDate;
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

        }
        
        bDataSaved = YES;
        bIsModified = NO;
    }
  
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


//-(BOOL)isEndTimeValid
//{
//    if ([self.endTime.text isEqualToString:@""] || self.endTime.text == nil)
//    {
//        UIAlertView * alert = [[UIAlertView alloc] init];
//        
//        alert.delegate = self;
//        alert.title = @"ISIOP";
//        alert.message = @"Please enter End Time and Save this Observation";
//        [alert addButtonWithTitle:@"OK"];
//        alert.tag = 2;
//        
//        [alert show];
//        
//        return NO;
//    }
//    return YES;
//}

-(BOOL)isDataValid
{
    VariableStore *vs = [VariableStore sharedInstance];
    
    if ([self.startTime.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc] init];
        
        alert.delegate = self;
        alert.title = @"ISIOP";
        alert.message = @"Please enter Start Time";
        [alert addButtonWithTitle:@"OK"];
        alert.tag = 2;
        
        [alert show];
        
        return NO;
    }
    
    
    
    if ([vs.gNeedEndTime isEqualToString:@"YES"])
    {
        
        if ([self.endTime.text isEqualToString:@""])
        {
            UIAlertView * alert = [[UIAlertView alloc] init];
        
            alert.delegate = self;
            alert.title = @"ISIOP";
            alert.message = @"Please enter End Time";
            [alert addButtonWithTitle:@"OK"];
            alert.tag = 2;
        
            [alert show];
        
            return NO;
        }
    }
       
    if ([self.classId.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc] init];
        
        alert.delegate = self;
        alert.title = @"ISIOP";
        alert.message = @"Please enter Class ID";
        [alert addButtonWithTitle:@"OK"];
        alert.tag = 2;
        
        [alert show];
        
        return NO;
    }
    
    if ([self.classDate.text isEqualToString:@""])
    {
        UIAlertView * alert = [[UIAlertView alloc] init];
        
        alert.delegate = self;
        alert.title = @"ISIOP";
        alert.message = @"Please enter Class Date";
        [alert addButtonWithTitle:@"OK"];
        alert.tag = 2;
        
        [alert show];
        
        return NO;

    }
    
    if (![self isIntegerNumber:self.startingNumFemales.text])
        return NO;

    if (![self isIntegerNumber:self.startingNumMales.text])
        return NO;

    if (![self isIntegerNumber:self.endingNumFemales.text])
        return NO;

    if (![self isIntegerNumber:self.endingNumMales.text])
        return NO;

    return YES;
}


- (BOOL) isIntegerNumber: (NSString*)input
{
    return [input integerValue] != 0 || [input isEqualToString:@"0"] || [input isEqualToString:@""];
}

@end
