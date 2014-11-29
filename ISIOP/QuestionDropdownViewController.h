//
//  QuestionDropdownViewController.h
//  TestTabController1
//
//  Created by LRich on 11/30/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>

@class QuestionDropdownViewController;

@protocol QuestionItemsPickerDelegate <NSObject>
- (void)itemSelected:(NSString *)questionItem;
@end

@interface QuestionDropdownViewController : UITableViewController

@property (nonatomic, weak) id <QuestionItemsPickerDelegate> delegate;

@end


