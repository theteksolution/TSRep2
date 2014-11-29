//
//  RootViewController.m
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import "RootViewController.h"
#import "ObservationSetupViewController.h"
#import "Observers.h"
#import "ObservationSequences.h"
#import "DBHelper.h"
#import "VariableStore.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface RootViewController ()

@end

@implementation RootViewController


@synthesize observationsPicker = _observationsPicker;
@synthesize observationsPickerPopover = _observationsPickerPopover;
@synthesize userName = _userName;


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
    
    self.userName.title = @"";
    
        
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.delegate = self;
    VariableStore *vs = [VariableStore sharedInstance];
    
    
    if (![vs.gFirstName isEqualToString:@""] && vs.gFirstName != nil)
    {
        NSMutableString *myString = [NSMutableString stringWithString:vs.gFirstName];
        
        if (![vs.gClassID isEqualToString:@""] && vs.gClassID != nil)
        {
            [myString appendString:@" - "];
            [myString appendString:vs.gClassID];
        }
       
        self.userName.title = myString;
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)observationSelected:(NSString *)observation classID:(NSString *)cID {
    
    VariableStore *vs = [VariableStore sharedInstance];
    vs.gObservationID = observation;
    vs.gClassID = cID;
    
    NSMutableString *myString = [NSMutableString stringWithString:vs.gFirstName];
    [myString appendString:@" - "];
    [myString appendString:cID];
    
    
    
    self.userName.title = myString;
    

    //Reset the viewcontroller so ViewLoad is called
    for (UIViewController *viewController in self.tabBarController.viewControllers)
    {
        if (![viewController isKindOfClass:[RootViewController class]]) {
            viewController.view = nil;
        }
    }
    
    [self.observationsPickerPopover dismissPopoverAnimated:YES];
}



- (IBAction)setObservationsListButtonTapped:(id)sender {
    
    VariableStore *vs = [VariableStore sharedInstance];
    
    if (![vs.gClassID isEqualToString:@""] && vs.gClassID != nil && [vs.gEndTime isEqualToString:@""])
    {
        vs.gNeedEndTime = @"YES";
        
        UIAlertView * alert = [[UIAlertView alloc] init];
        
        alert.delegate = self;
        alert.title = @"ISIOP";
        alert.message = @"Please enter End Time and Save this Observation";
        [alert addButtonWithTitle:@"OK"];
        alert.tag = 2;
        
        [alert show];
        
        self.tabBarController.selectedIndex = 1;
    }
    else
    {
   
        self.observationsPicker = nil;
        self.observationsPicker = [[ObservationsListViewController alloc] initWithStyle:UITableViewStylePlain];
        self.observationsPicker.delegate = self;
        self.observationsPickerPopover = [[UIPopoverController alloc]                                                                         initWithContentViewController:self.observationsPicker];
    
    
        // NSLog(@"%d",[self.observationsPicker.observations  count]);
    
        if ([self.observationsPicker.observations  count] > 0)
        {
    
            [self.observationsPickerPopover presentPopoverFromBarButtonItem:sender
                                           permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            UIAlertView * credentialAlert = [[UIAlertView alloc] init];
        
            credentialAlert.delegate = self;
            credentialAlert.title = @"ISIOP";
            credentialAlert.message = @"There are no observations for this person";
            [credentialAlert addButtonWithTitle:@"OK"];
        
            [credentialAlert show];
        }
    }
   
        
}

- (void)login:(NSString *)firstName lName:(NSString *)lastName em:(NSString *)email uid:(NSString *)userID nu:(BOOL)newUser
{
    //set login credentials here and proceed
    
    NSMutableString *newObserverID;
       
    if (newUser == YES)
    {
        
        DBHelper *db = [[DBHelper alloc] init];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate *date = [NSDate date];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationSequences"                                                                                                            inManagedObjectContext:db.managedObjectContext];
        
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"userIDSequence" ascending:NO]];
        [fetchRequest setEntity:entity];
        
        [fetchRequest setFetchLimit:1];
        
        NSError *error;
        ObservationSequences *ob = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error].lastObject;
        
        //Now set the new unique key value
        
        int value = [ob.userIDSequence intValue];
        int nextSequence = value + 1;
        
        
        [ob setUserIDSequence:[NSNumber numberWithInt:nextSequence]];
        
        NSString *udid = [UIDevice currentDevice].identifierForVendor.UUIDString;
        
        // Convert UUID to string and output result
        NSLog(@"UDID: %@", udid);
        
        newObserverID = [NSMutableString stringWithString:udid];
        [newObserverID appendString:@"_"];
        [newObserverID appendString:[NSString stringWithFormat:@"%d", nextSequence]];
        
        
              
        // Add our default user object in Core Data
        Observers *user = (Observers *)[NSEntityDescription insertNewObjectForEntityForName:@"Observers" inManagedObjectContext:db.managedObjectContext];
        [user setFirstName:firstName];
        [user setLastName:lastName];
        [user setEmail:email];
        [user setDateAdded:formattedDate];
        [user setLastEdit:formattedDate];
        [user setUserID:newObserverID];
        [user setDeviceIdentifier:[UIDevice currentDevice].identifierForVendor.UUIDString];
        
        // Commit to core data
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
                
                NSURL *baseURL = [NSURL URLWithString:[settings objectForKey:@"WebServiceURL"]];
                AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
                NSMutableDictionary *parms  = [[NSMutableDictionary alloc] init];
                [parms setObject:[settings objectForKey:@"UsageID"] forKey:@"UsageID"];
                [parms setObject:[settings objectForKey:@"UsageCode"] forKey:@"UsageCode"];
                [parms setObject:newObserverID forKey:@"UserID"];
                [parms setObject:firstName forKey:@"FirstName"];
                [parms setObject:lastName forKey:@"LastName"];
                [parms setObject:email forKey:@"EmailAddress"];
                [parms setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"DeviceIdentifier"];
                [parms setObject:formattedDate forKey:@"DateAdded"];
                //[parms setObject:formattedDate forKey:@"LastEdit"];
                
                NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[settings objectForKey:@"WebService_Observer"]  parameters:parms];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                {
                    NSString *response = [operation responseString];
                
                    //check response then if OK update dataSync
                
                    NSLog(@"response: [%@]",response);
                    if ([response rangeOfString:@"SUCCESS"].location != NSNotFound)
                    {
                        [user setDataSync:formattedDate];
                        NSError *error2;
                        if (![db.managedObjectContext save:&error2])
                        {
                            NSLog(@"Failed to add default user with error: %@", [error2 domain]);
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
    
       
    VariableStore *vs = [VariableStore sharedInstance];
    
    vs.gFirstName = firstName;
    vs.gLastName = lastName;
    vs.gEmail = email;
    if ([userID isEqualToString:@""])
    {
        vs.gUserID = newObserverID;
    }
    else
    {
        vs.gUserID = userID;
    }
        
    vs.gObservationID = @"";
    vs.gClassID = @"";

    self.userName.title = firstName;
    
    
}

-(IBAction)setUser:(id)sender
{
    
    UIStoryboard *storyboard = self.storyboard;
    ObservationSetupViewController *svc = [storyboard instantiateViewControllerWithIdentifier:@"ObserverSetup"];
    // configure the new view controller explicitly here.
    
    svc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    svc.modalPresentationStyle = UIModalPresentationFormSheet;
    svc.delegate = self;
    
       
    [self presentViewController:svc animated:YES completion:Nil];
    
}

-(IBAction)newObservation:(id)sender
{
    
    //Reset the viewcontroller so ViewLoad is called
    for (UIViewController *viewController in self.tabBarController.viewControllers)
    {
        if (![viewController isKindOfClass:[RootViewController class]]) {
            viewController.view = nil;
        }
    }
    
    VariableStore *vs = [VariableStore sharedInstance];
    vs.gObservationID = @"";
    vs.gClassID = @"";
    
    UIAlertView * alert = [[UIAlertView alloc] init];
    
    alert.delegate = self;
    alert.title = @"ISIOP";
    alert.message = @"A New Observation has been created";
    [alert addButtonWithTitle:@"OK"];
    
    [alert show];
    
    self.tabBarController.selectedIndex = 1;
    
}

- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)vc
{
 
    VariableStore *vs = [VariableStore sharedInstance];
    
    if ([vs.gClassID isEqualToString:@""] || vs.gClassID == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
   
}



//-(IBAction)syncData:(id)sender
//{
//    if([self connectedToNetwork] != YES)
//	{
//		NSLog(@"No network connection found. An Internet connection is required for this application to work");
//							
//    }
//    
//}

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
