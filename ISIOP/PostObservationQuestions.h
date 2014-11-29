//
//  PostObservationQuestions.h
//  TestTabController1
//
//  Created by LRich on 12/10/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PostObservationQuestions : NSManagedObject

@property (nonatomic, retain) NSString * poqType;
@property (nonatomic, retain) NSString * questionText;
@property (nonatomic, retain) NSString * questionType;
@property (nonatomic, retain) NSNumber * poqID;
@property (nonatomic, retain) NSNumber * active;

@end
