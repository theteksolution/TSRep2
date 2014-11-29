//
//  ClassroomBackgroundViewController.h
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>

@interface ClassroomBackgroundViewController : UIViewController <UITabBarControllerDelegate,UIAlertViewDelegate>


@property (nonatomic,weak) IBOutlet UITextField *startTime;
@property (nonatomic,weak) IBOutlet UITextField *endTime;
@property (nonatomic,weak) IBOutlet UITextField *classDate;
@property (nonatomic,weak) IBOutlet UITextField *classId;
@property (nonatomic,weak) IBOutlet UITextField *startingNumMales;
@property (nonatomic,weak) IBOutlet UITextField *startingNumFemales;
@property (nonatomic,weak) IBOutlet UITextField *endingNumMales;
@property (nonatomic,weak) IBOutlet UITextField *endingNumFemales;
@property (nonatomic,weak) IBOutlet UITextView *additionalNotes;
@property (nonatomic,weak) IBOutlet UISegmentedControl *instructionalArtifacts;
@property (nonatomic,weak) IBOutlet UISegmentedControl *codingCopy;

@property (nonatomic,weak) IBOutlet UINavigationItem *navItem;


-(IBAction)classStartTime:(id)sender;

-(IBAction)classEndTime:(id)sender;

-(IBAction)classDate:(id)sender;

-(IBAction)save;

-(IBAction)reset;

-(BOOL)isEndTimeValid;



+ (ClassroomBackgroundViewController *)sharedInstance;


@end
