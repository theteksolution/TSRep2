//
//  PracticeCodesViewController.h
//  TestTabController1
//
//  Created by LRich on 12/5/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>


@class PracticeCodesViewController;


@protocol PracticeCodesDelegate <NSObject>
- (void)practiceCodeSelected:(NSString *)practiceCode;
@end

@interface PracticeCodesViewController : UIViewController


@property (nonatomic, weak) id <PracticeCodesDelegate> delegate;
//@property (nonatomic,strong) IBOutlet UITextField *practiceCode;


-(void)setPracticeCodeText:(NSString *)key;

@end
