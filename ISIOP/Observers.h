//
//  Observers.h
//  TestTabController1
//
//  Created by LRich on 12/10/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Observers : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * dataSync;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * lastEdit;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * deviceIdentifier;


@end
