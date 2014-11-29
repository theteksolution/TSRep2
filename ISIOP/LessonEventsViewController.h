//
//  LessonEventsViewController.h
//  TestTabController1
//
//  Created by LRich on 1/11/13.
//  Copyright (c) 2013 LR
//

#import <UIKit/UIKit.h>

@class LessonEventsViewController;

@protocol LessonEventsPickerDelegate <NSObject>
- (void)lessonEventSelected:(NSString *)lessonEventItem;
@end

@interface LessonEventsViewController : UITableViewController


@property (nonatomic, weak) id <LessonEventsPickerDelegate> delegate;


@end
