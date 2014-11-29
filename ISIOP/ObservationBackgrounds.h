//
//  ObservationBackgrounds.h
//  TestTabController1
//
//  Created by LRich on 12/10/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ObservationBackgrounds : NSManagedObject

@property (nonatomic, retain) NSString * observationID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * classID;
@property (nonatomic, retain) NSString * observationDate;
@property (nonatomic, retain) NSString * classStartTime;
@property (nonatomic, retain) NSString * classEndTime;
@property (nonatomic, retain) NSNumber * startingNumMales;
@property (nonatomic, retain) NSNumber * startingNumFemales;
@property (nonatomic, retain) NSNumber * endingNumMales;
@property (nonatomic, retain) NSNumber * endingNumFemales;
@property (nonatomic, retain) NSString * useInstructionalArtifiacts;
@property (nonatomic, retain) NSString * obtainedArtifactsCopy;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * dateAdded;
@property (nonatomic, retain) NSString * lastEdit;
@property (nonatomic, retain) NSString * dataSync;

@end
