//
//  ObservationSequences.h
//  TestTabController1
//
//  Created by LRich on 1/27/13.
//  Copyright (c) 2013 LR
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ObservationSequences : NSManagedObject

@property (nonatomic, retain) NSNumber * userIDSequence;
@property (nonatomic, retain) NSNumber * observationIDSequence;

@end
