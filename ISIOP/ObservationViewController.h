//
//  ObservationViewController.h
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>
#import "PracticeCodesViewController.h"
#import "ActivityCodesViewController.h"
#import "LessonEventsViewController.h"


@interface ObservationViewController : UIViewController <PracticeCodesDelegate,ActivityCodesPickerDelegate, UITabBarControllerDelegate,UIAlertViewDelegate, LessonEventsPickerDelegate>


@property (nonatomic, retain) PracticeCodesViewController *practiceCodesPicker;
@property (nonatomic, retain) UIPopoverController *practiceCodesPopover;

@property (nonatomic, retain) ActivityCodesViewController *activityCodesPicker;
@property (nonatomic, retain) UIPopoverController *activityCodesPopover;

@property (nonatomic, retain) LessonEventsViewController *lessonEventsPicker;
@property (nonatomic, retain) UIPopoverController *lessonEventsPopover;

@property (nonatomic,weak) IBOutlet UINavigationItem *navItem;


-(IBAction)incrementButtonClicked:(id)sender;

-(IBAction)decrementButtonClicked:(id)sender;

-(IBAction)infoButtonClicked:(id)sender;

-(IBAction)classActivityCodeClicked:(id)sender;

-(IBAction)classOrganizationCodeClicked:(id)sender;

-(IBAction)studentDisengagementCodeClicked:(id)sender;

-(IBAction)createLessonEvent:(id)sender;

-(IBAction)selectLessonEvent:(id)sender;


-(IBAction)save:(id)sender;

-(IBAction)reset;



+ (ObservationViewController *)sharedInstance;


@property (nonatomic,weak) IBOutlet UIButton *classActivityCode;

@property (nonatomic,weak) IBOutlet UIButton *classOrganizationCode;

@property (nonatomic,weak) IBOutlet UIButton *studentDisengagementCode;

@property (nonatomic,weak) IBOutlet UITextView *notes;

@property (nonatomic,weak) IBOutlet UILabel *currentLessonEvent;



@end
