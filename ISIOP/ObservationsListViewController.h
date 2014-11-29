//
//  ObervationsListViewController.h
//  ISIOP
//
//  Created by LRich on 11/6/12.
//  Copyright (c) 2012 LR
//

#import <UIKit/UIKit.h>

@class ObservationsListViewController;

@protocol ObservationsPickerDelegate <NSObject>
- (void)observationSelected:(NSString *)observation classID:(NSString *)cID;
@end


@interface ObservationsListViewController : UITableViewController



@property (nonatomic, strong) NSMutableArray *observations;
@property (nonatomic, weak) id <ObservationsPickerDelegate> delegate;


@end
