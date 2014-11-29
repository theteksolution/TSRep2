//
//  ObservationSetupViewController.m
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import "ObservationSetupViewController.h"
#import "Observers.h"
#import "DBHelper.h"



@interface ObservationSetupViewController ()

@end

@implementation ObservationSetupViewController


@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize userPicker = _userPicker;
@synthesize delegate = _delegate;


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
    
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Observers" inManagedObjectContext:db.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    pickerItems = [[NSArray alloc]init];
    pickerList = [[NSMutableArray alloc]init];
    
    pickerItems = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];	// Do any additional setup after loading he view.
    
    
    strFirstPickerView = @"***********";
    
    [pickerList addObject:@"***********"];
    
    
    
    for (Observers *ob in pickerItems)
    {
                
        NSMutableString *myString = [NSMutableString stringWithString:ob.firstName];
        [myString appendString:@" "];
        [myString appendString:ob.lastName];
        [myString appendString:@" - "];
        [myString appendString:ob.email];
        [myString appendString:@" - "];
        [myString appendString:ob.userID];
        
        [pickerList addObject:myString];
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [pickerList count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    
   // Observers *ob = [self.pickerItems objectAtIndex:row];
    
     //NSLog(@"%@",ob.loginName);
    
    
    if (row == 0)
    {
        return [pickerList objectAtIndex:row];
    }
    else
    {
        NSArray *listItems = [[pickerList objectAtIndex:row] componentsSeparatedByString:@" - "];
    
        NSMutableString *myString = [NSMutableString stringWithString:[listItems objectAtIndex:0]];
        [myString appendString:@" - "];
        [myString appendString:[listItems objectAtIndex:1]];
       
        return myString;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
      
    
    strFirstPickerView = [pickerList objectAtIndex:row];
    
}




-(IBAction)userSelected:(id)sender
{
//    NSInteger row;
//    NSArray *repeatPickerData;
//    
//    row = [self.userPicker selectedRowInComponent:0];
//    self.userPicker = [repeatPickerData objectAtIndex:row];
    
    if ([strFirstPickerView isEqualToString:@"***********"] &&  ([self.firstName.text length] == 0 || [self.lastName.text length] == 0 || [self.email.text length] == 0) )
    {
        
        UIAlertView * credentialAlert = [[UIAlertView alloc] init];
        
        credentialAlert.delegate = self;
        credentialAlert.title = @"ISIOP Login error";
        credentialAlert.message = @"Enter Your Name and Password";
        [credentialAlert addButtonWithTitle:@"OK"];
        
        [credentialAlert show];
    }
    
    if ([strFirstPickerView isEqualToString:@"***********"] && ([self.firstName.text length] > 0 && [self.lastName.text length] > 0 && [self.email.text length] > 0))
    {
        if (self.delegate != nil)
        {
            // NSString *observation = [self.observations objectAtIndex:indexPath.row];
            
            [self.delegate login:self.firstName.text lName:self.lastName.text em:self.email.text uid:@"" nu:YES];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
   
    if(![strFirstPickerView isEqualToString:@"***********"] &&  ([self.firstName.text length] == 0 || [self.lastName.text length] == 0 || [self.email.text length] == 0))
    {
        if (self.delegate != nil)
        {
            // NSString *observation = [self.observations objectAtIndex:indexPath.row];
            
            NSArray *listItems = [strFirstPickerView componentsSeparatedByString:@" - "];            
            [self.delegate login:[listItems objectAtIndex:0]lName:[listItems objectAtIndex:0] em:[listItems objectAtIndex:1] uid:[listItems objectAtIndex:2] nu:NO];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}


-(IBAction)cancel:(id)sender
{
    
      [self dismissViewControllerAnimated:YES completion:nil];
}

@end
