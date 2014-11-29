//
//  ObservationItem.h
//  ISIOP
//
//  Created by LRich on 11/6/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>

@interface ObservationListItem : NSObject

@property (nonatomic, retain) NSString *observationID;
@property (nonatomic, retain) NSString *observationDate;
@property (nonatomic, retain) NSString *classRoomID;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *observerID;

-(NSMutableArray *)getObservationList;

@end
