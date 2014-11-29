//
//  VariableStore.m
//  TestTabController1
//
//  Created by LRich on 12/27/12.
//  Copyright (c) 2012 LR
//

#import "VariableStore.h"
#import "DBHelper.h"

@implementation VariableStore

@synthesize gEmail;
@synthesize gFirstName;
@synthesize gLastName;
@synthesize gObservationID;
@synthesize gClassID;
@synthesize gUserID;

@synthesize gNeedEndTime;
@synthesize gEndTime;



+ (VariableStore *)sharedInstance
{
    // the instance of this class is stored here
    static VariableStore *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        // initialize variables here
    }
    // return the instance of this class
    return myInstance;
}


@end
