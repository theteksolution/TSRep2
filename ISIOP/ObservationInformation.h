//
//  ObservationInformation.h
//  TestTabController1
//
//  Created by LRich on 12/10/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ObservationInformation : NSManagedObject

@property (nonatomic, retain) NSString * lessonEventName;
@property (nonatomic, retain) NSString * observationID;
@property (nonatomic, retain) NSNumber * solicit;
@property (nonatomic, retain) NSNumber * facts;
@property (nonatomic, retain) NSNumber * procedural;
@property (nonatomic, retain) NSNumber * explain;
@property (nonatomic, retain) NSNumber * apply;
@property (nonatomic, retain) NSNumber * meta;
@property (nonatomic, retain) NSNumber * newAndOld;
@property (nonatomic, retain) NSNumber * itinerary;
@property (nonatomic, retain) NSNumber * directions;
@property (nonatomic, retain) NSNumber * foreshadow;
@property (nonatomic, retain) NSNumber * situate;
@property (nonatomic, retain) NSNumber * acknowledge;
@property (nonatomic, retain) NSNumber * rephrase;
@property (nonatomic, retain) NSNumber * correct;
@property (nonatomic, retain) NSNumber * praise;
@property (nonatomic, retain) NSNumber * giveInfo;
@property (nonatomic, retain) NSNumber * suggest;
@property (nonatomic, retain) NSNumber * thinkAloud;
@property (nonatomic, retain) NSNumber * reflect;
@property (nonatomic, retain) NSNumber * summarize;
@property (nonatomic, retain) NSString * classActivityCode;
@property (nonatomic, retain) NSString * classOrganizationCode;
@property (nonatomic, retain) NSString * studentDisengagementCode;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * dataSync;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * lastEdit;
@property (nonatomic, retain) NSString * userID;


@end
