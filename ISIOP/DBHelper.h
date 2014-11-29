//
//  DBHelper.h
//  TestTabController1
//
//  Created by LRich on 12/20/12.
//  Copyright (c) 2012 LR
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
