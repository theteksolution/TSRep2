//
//  PostObservations.h
//  TestTabController1
//
//  Created by LRich on 12/10/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PostObservations : NSManagedObject

@property (nonatomic, retain) NSString * observationID;
@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSString * subSectionName;
@property (nonatomic, retain) NSString * poqType;
@property (nonatomic, retain) NSNumber * poqID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * lastEdit;
@property (nonatomic, retain) NSString * dataSync;

@end
