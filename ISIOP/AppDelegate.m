//
//  AppDelegate.m
//  TestTabController1
//
//  Created by LRich on 11/10/12.
//  Copyright (c) 2012 LR
//

#import "AppDelegate.h"
#import "Observers.h"
#import "DBHelper.h"
#import "VariableStore.h"
#import "ObservationBackgrounds.h"
#import "ObservationInformation.h"
#import "PostObservations.h"
#import "Observers.h"
#import "AFNetworking.h"
#import "Reachability.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Get a reference to the stardard user defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    // Check if the app has run before by checking a key in user defaults
    if ([prefs boolForKey:@"hasRunBefore"] != YES)
    {
        // Set flag so we know not to run this next time
        [prefs setBool:YES forKey:@"hasRunBefore"];
        [prefs synchronize];
        
        DBHelper *db = [[DBHelper alloc] init];
        
        // Add our default user object in Core Data
        Observers *user = (Observers *)[NSEntityDescription insertNewObjectForEntityForName:@"Observers" inManagedObjectContext:db.managedObjectContext];
        [user setLastName:@"Smith"];
        [user setFirstName:@"Biff"];
        [user setEmail:@"Test@test.com"];
        [user setUserID:@"TEST123"];
        
        // Commit to core data
        NSError *error;
        if (![db.managedObjectContext save:&error])
            NSLog(@"Failed to add default user with error: %@", [error domain]);
    }
    
    if ([prefs objectForKey:@"gEmail"] != nil)
    {
        VariableStore *vs = [VariableStore sharedInstance];
        vs.gObservationID = [prefs objectForKey:@"gObservationID"];
        vs.gClassID = [prefs objectForKey:@"gClassID"];
        vs.gFirstName = [prefs objectForKey:@"gFirstName"];
        vs.gLastName = [prefs objectForKey:@"gLastName"];
        vs.gEmail = [prefs objectForKey:@"gEmail"];
        vs.gUserID = [prefs objectForKey:@"gUserID"];
    }
    
    
    // Here we need to check if there is any unsynced data, if so sync it up
    
    [self checkDataSync];
    
    
    
    return YES;    
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // Get a reference to the stardard user defaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    VariableStore *vs = [VariableStore sharedInstance];
    
    // Set flag so we know not to run this next time
    [prefs setObject:vs.gObservationID forKey:@"gObservationID"];
    [prefs setObject:vs.gClassID forKey:@"gClassID"];
    [prefs setObject:vs.gFirstName forKey:@"gFirstName"];
    [prefs setObject:vs.gLastName forKey:@"gLastName"];
    [prefs setObject:vs.gEmail forKey:@"gEmail"];
    [prefs setObject:vs.gUserID forKey:@"gUserID"];
    [prefs synchronize];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    VariableStore *vs = [VariableStore sharedInstance];
    
    // Set flag so we know not to run this next time
    [prefs setObject:vs.gObservationID forKey:@"gObservationID"];
    [prefs setObject:vs.gClassID forKey:@"gClassID"];
    [prefs setObject:vs.gFirstName forKey:@"gFirstName"];
    [prefs setObject:vs.gLastName forKey:@"gLastName"];
    [prefs setObject:vs.gEmail forKey:@"gEmail"];
    [prefs setObject:vs.gUserID forKey:@"gUserID"];
    
    [prefs synchronize];

}


-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

-(void)checkDataSync
{
    DBHelper *db = [[DBHelper alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
   
    //Observation Backgrounds
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationBackgrounds"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dataSync=%@",@""];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
        
    NSError *error;
    NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (ObservationBackgrounds *ob in items)
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
            [parms setObject:ob.observationID forKey:@"ObservationID"];
            [parms setObject:ob.userID forKey:@"UserID"];
            [parms setObject:ob.startingNumFemales forKey:@"StartingNumberOfFemales"];
            [parms setObject:ob.endingNumFemales forKey:@"EndingNumberOfFemales"];
            [parms setObject:ob.startingNumMales forKey:@"StartingNumberOfMales"];
            [parms setObject:ob.endingNumMales forKey:@"EndingNumberOfMales"];
            [parms setObject:ob.obtainedArtifactsCopy forKey:@"ObtainedArtifactsCopy"];
            [parms setObject:ob.useInstructionalArtifiacts forKey:@"UseInstructionalArtifacts"];
            
            [parms setObject:ob.classID forKey:@"ClassID"];
            [parms setObject:ob.observationDate forKey:@"ObservationDate"];
            [parms setObject:ob.classStartTime forKey:@"ClassStartTime"];
            [parms setObject:ob.classEndTime forKey:@"ClassEndTime"];
            [parms setObject:ob.notes forKey:@"Notes"];
            [parms setObject:ob.dateAdded forKey:@"DateAdded"];
            [parms setObject:ob.lastEdit forKey:@"LastEdit"];
            
            if ([ob.dateAdded isEqualToString:ob.lastEdit])
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
                     ob.dataSync = formattedDate;
                   
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
    
    NSLog(@"Ob BK Sync");
    
    
    //Observation Information
    
     entity = [NSEntityDescription entityForName:@"ObservationInformation"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
     predicate = [NSPredicate predicateWithFormat:@"dataSync=%@",@""];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    
    items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (ObservationInformation *oi in items)
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
            [parms setObject:oi.observationID forKey:@"observationID"];
            //[parms setObject:oi. forKey:@"UserID"];
            [parms setObject:[oi.acknowledge stringValue] forKey:@"AcknowledgeCount"];
            [parms setObject:[oi.apply stringValue] forKey:@"ApplyCount"];
            [parms setObject:[oi.correct stringValue] forKey:@"CorrectCount"];
            [parms setObject:[oi.directions stringValue] forKey:@"DirectionsCount"];
            [parms setObject:[oi.explain stringValue] forKey:@"ExplainCount"];
            [parms setObject:[oi.facts stringValue] forKey:@"FactsCount"];
            [parms setObject:[oi.foreshadow stringValue] forKey:@"ForeshadowCount"];
            [parms setObject:[oi.giveInfo stringValue] forKey:@"GiveInfoCount"];
            [parms setObject:[oi.itinerary stringValue] forKey:@"ItineraryCount"];
            [parms setObject:[oi.meta stringValue] forKey:@"MetaCount"];
            [parms setObject:[oi.newAndOld stringValue] forKey:@"NewAndOldCount"];
            [parms setObject:[oi.praise stringValue] forKey:@"PraiseCount"];
            [parms setObject:[oi.procedural stringValue] forKey:@"ProceduralCount"];
            [parms setObject:[oi.reflect stringValue] forKey:@"ReflectCount"];
            [parms setObject:[oi.rephrase stringValue] forKey:@"RephraseCount"];
            [parms setObject:[oi.situate stringValue] forKey:@"SituateCount"];
            [parms setObject:[oi.suggest stringValue] forKey:@"SuggestCount"];
            [parms setObject:[oi.summarize stringValue] forKey:@"SummarizeCount"];
            [parms setObject:[oi.thinkAloud stringValue] forKey:@"ThinkAloudCount"];
            [parms setObject:oi.classActivityCode forKey:@"ClassActivityCode"];
            [parms setObject:oi.classOrganizationCode forKey:@"ClassOrganizationCode"];
            [parms setObject:oi.studentDisengagementCode forKey:@"StudentDisengagementCode"];
            [parms setObject:oi.lessonEventName forKey:@"LessonEventName"];
            [parms setObject:oi.notes forKey:@"Notes"];
            [parms setObject:oi.dateAdded forKey:@"DateAdded"];
            [parms setObject:oi.lastEdit forKey:@"LastEdit"];
            if ([oi.dateAdded isEqualToString:oi.lastEdit])
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
                     oi.dataSync = formattedDate;
                     
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
    
     NSLog(@"Ob in Sync");    
    
    //Post Observation Answers
    
    entity = [NSEntityDescription entityForName:@"PostObservations"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    predicate = [NSPredicate predicateWithFormat:@"dataSync=%@",@""];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    
    items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (PostObservations *po in items)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        
        //save to web service
        NSURL *baseURL = [NSURL URLWithString:[settings objectForKey:@"WebServiceURL"]];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
        NSMutableDictionary *parms  = [[NSMutableDictionary alloc] init];
        [parms setObject:[settings objectForKey:@"UsageID"] forKey:@"UsageID"];
        [parms setObject:[settings objectForKey:@"UsageCode"] forKey:@"UsageCode"];
        [parms setObject:po.observationID forKey:@"ObservationID"];
        [parms setObject:po.userID forKey:@"UserID"];
        [parms setObject:[po.poqID stringValue] forKey:@"POQID"];
        [parms setObject:po.poqType forKey:@"POQType"];
        [parms setObject:po.answer forKey:@"Answer"];
        [parms setObject:po.sectionName forKey:@"SectionName"];
        [parms setObject:po.subSectionName forKey:@"SubSectionName"];
        [parms setObject:po.dateAdded forKey:@"DateAdded"];
        [parms setObject:po.lastEdit forKey:@"LastEdit"];
        if ([po.dateAdded isEqualToString:po.lastEdit])
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
                 po.dataSync = formattedDate;
                 
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
    
     NSLog(@"Ob ans Sync");
    
    
    //Observers
    
    entity = [NSEntityDescription entityForName:@"Observers"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    predicate = [NSPredicate predicateWithFormat:@"dataSync=%@",@""];
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    
    items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (Observers *o in items)
    {
        if ([self connectedToNetwork] == YES)
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
            NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
            
            NSURL *baseURL = [NSURL URLWithString:[settings objectForKey:@"WebServiceURL"]];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
            NSMutableDictionary *parms  = [[NSMutableDictionary alloc] init];
            [parms setObject:[settings objectForKey:@"UsageID"] forKey:@"UsageID"];
            [parms setObject:[settings objectForKey:@"UsageCode"] forKey:@"UsageCode"];
            [parms setObject:o.userID forKey:@"UserID"];
            [parms setObject:o.firstName forKey:@"FirstName"];
            [parms setObject:o.lastName forKey:@"LastName"];
            [parms setObject:o.email forKey:@"EmailAddress"];
            [parms setObject:[UIDevice currentDevice].identifierForVendor.UUIDString forKey:@"DeviceIdentifier"];
            [parms setObject:o.dateAdded forKey:@"DateAdded"];
                        
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" path:[settings objectForKey:@"WebService_Observer"]  parameters:parms];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
             {
                 NSString *response = [operation responseString];
                 
                 //check response then if OK update dataSync
                 
                 NSLog(@"response: [%@]",response);
                 if ([response rangeOfString:@"SUCCESS"].location != NSNotFound)
                 {
                     [o setDataSync:formattedDate];
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
    
     NSLog(@"Ob obs Sync");    
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



//
//-(void)toggleTabBarHidden{
//    for(UIView *view in self.window.subviews)
//    {
//        if([view isKindOfClass:[UITabBar class]])
//        {
//            if(view.hidden){
//                view.hidden = NO;
//                break;
//            }
//            view.hidden = YES;
//        }
//    }
//}


@end
