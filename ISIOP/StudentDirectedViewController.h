//
//  StudentDirectedViewController.h
//  TestTabController1
//
//  Created by LRich on 11/14/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>
#import "SegmentedControlExt.h"
#import "ButtonControlExt.h"
#import "QuestionDropdownViewController.h"

@interface StudentDirectedViewController : UITableViewController <QuestionItemsPickerDelegate, UITabBarControllerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UILabel *questionForBool;

@property (nonatomic,strong) IBOutlet UILabel *questionForDrop;

@property (nonatomic,strong) IBOutlet SegmentedControlExt  *answer;

@property (nonatomic, strong) IBOutlet UIButton *dropdown;

@property (nonatomic, retain) QuestionDropdownViewController *questionPicker;
@property (nonatomic, retain) UIPopoverController *questionsPickerPopover;

@property (nonatomic,weak) IBOutlet UINavigationItem *navItem;

-(IBAction)save;

-(IBAction)reset;

+ (StudentDirectedViewController *)sharedInstance;

@end
