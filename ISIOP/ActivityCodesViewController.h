//
//  ActivityCodesViewController.h
//  TestTabController1
//
//  Created by LRich on 12/5/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>

@class ActivityCodesViewController;

@protocol ActivityCodesPickerDelegate <NSObject>
- (void)itemCodeSelected:(NSString *)activityCodeItem activityCodeType:(NSString *)aCodeType;
@end

@interface ActivityCodesViewController : UITableViewController

@property (nonatomic, weak) id <ActivityCodesPickerDelegate> delegate;
@property (nonatomic,strong) NSString *codeType;

@end
