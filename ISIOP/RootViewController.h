//
//  RootViewController.h
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "ObservationsListViewController.h"
#import "ObservationSetupViewController.h"



@interface RootViewController : UIViewController <ObservationsPickerDelegate, ObservationLoginDelegate,UITabBarControllerDelegate>


@property (nonatomic, retain) ObservationsListViewController *observationsPicker;
@property (nonatomic, retain) UIPopoverController *observationsPickerPopover;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *userName;


-(IBAction)setObservationsListButtonTapped:(id)sender;
-(IBAction)setUser:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)newObservation:(id)sender;


-(IBAction)syncData:(id)sender;


@end
