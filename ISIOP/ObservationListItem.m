//
//  ObservationItem.m
//  ISIOP
//
//  Created by LRich on 11/6/12.
//  Copyright (c) 2012 LR
//

#import "ObservationListItem.h"
#import "DBHelper.h"
#import "VariableStore.h"
#import "ObservationBackgrounds.h"

@implementation ObservationListItem


-(NSMutableArray *)getObservationList{
    
    
    //Here load observations for a given email address
    // [[VariableStore sharedInstance] gEmail];
    
    VariableStore *vs = [VariableStore sharedInstance];
    
    DBHelper *db = [[DBHelper alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ObservationBackgrounds"                                                                                                            inManagedObjectContext:db.managedObjectContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email=%@",vs.gEmail];
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email=%@",@"lrich@edc.org"];
    
        
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    
    NSError *error;
    
    NSArray *items = [db.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSMutableArray *observations = [[NSMutableArray alloc]init];
    
    
    
    for (ObservationBackgrounds *ob in items)
    {
        ObservationListItem *oi = [[ObservationListItem alloc]init];
        oi.observationDate = ob.observationDate;
        oi.observationID = ob.observationID;
        oi.classRoomID = ob.classID;
        oi.startTime = ob.classStartTime;
        oi.endTime = ob.classEndTime;
        
        
        [observations addObject:oi];
    }
    
//    
    return observations;
    
}


@end
