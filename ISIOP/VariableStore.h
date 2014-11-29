//
//  VariableStore.h
//  TestTabController1
//
//  Created by LRich on 12/27/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>

@interface VariableStore : NSObject 
{
    NSString *gLastName;
    NSString *gFirstName;
    NSString *gEmail;
    NSString *gObservationID;
    NSString *gClassID;
    NSString *gUserID;
    
    NSString *gEndTime;
    NSString *gNeedEndTime;
    
}

@property (nonatomic,retain) NSString *gLastName;
@property (nonatomic,retain) NSString *gFirstName;
@property (nonatomic,retain) NSString *gEmail;
@property (nonatomic,retain) NSString *gObservationID;
@property (nonatomic,retain) NSString *gClassID;
@property (nonatomic,retain) NSString *gUserID;

@property (nonatomic, retain) NSString *gNeedEndTime;
@property (nonatomic, retain) NSString *gEndTime;

+ (VariableStore *)sharedInstance;

@end
