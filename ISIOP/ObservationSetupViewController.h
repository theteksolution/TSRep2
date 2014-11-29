//
//  ObservationSetupViewController.h
//  TestTabController1
//
//  Created by LRich on 11/15/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>


@class ObservationSetupViewController;

@protocol ObservationLoginDelegate <NSObject>
- (void)login:(NSString *)firstName lName:(NSString *)lastName em:(NSString *)email uid:(NSString *)userID nu:(BOOL)newUser;
@end


@interface ObservationSetupViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *pickerItems;
    NSMutableArray *pickerList;
    NSString *strFirstPickerView;

}

@property (nonatomic,strong) IBOutlet UITextField *firstName;
@property (nonatomic,strong) IBOutlet UITextField *lastName;
@property (nonatomic,strong) IBOutlet UITextField *email;
@property (nonatomic,strong) IBOutlet UIPickerView *userPicker;


@property (nonatomic, weak) id <ObservationLoginDelegate> delegate;

-(IBAction)userSelected:(id)sender;
-(IBAction)cancel:(id)sender;

@end
