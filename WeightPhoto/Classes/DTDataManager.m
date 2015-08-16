//
//  DTDataManager.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTDataManager.h"
#import "NSDate+Extend.h"
#import "DTFileManager.h"
#import "DTWeightRecord.h"
#import "DTUserDefaults.h"

NSString * const DTICloudIsReadyNotification = @"DTICloudIsReadyNotification";
NSString * const DTICloudNotReadyNotification = @"DTICloudNotReadyNotification";
NSString * const DTPersistentStoreIsReadyNotification = @"DTPersistentStoreIsReadyNotification";
NSString * const DTPersistentStoreNotReadyNotification = @"DTPersistentStoreNotReadyNotification";

@interface DTDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation DTDataManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.status = DTDataManagerStatusInit;
    }
    return self;
}

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)initializeCoreDataWithiCloudOrNot {
    self.status = DTDataManagerStatusInit;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WeightPhoto" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    self.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [self.moc setPersistentStoreCoordinator:psc];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSPersistentStore *store = nil;
        NSError *error = nil;
        
        NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        
        NSURL *iCloudStoreURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"WeightPhoto-iCloud.sqlite"];
        NSURL *localStoreURL = [[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"WeightPhoto.sqlite"];
        
        if ([[DTUserDefaults sharedInstance] isICloud]) {
            NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
            if (cloudURL) {
                options[NSPersistentStoreUbiquitousContentNameKey] = @"TransactionLogs";
                options[NSPersistentStoreUbiquitousContentURLKey] = [cloudURL URLByAppendingPathComponent:@"WeightPhotoLibrary"];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergePersistentStoreContentChanges:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:self.moc.persistentStoreCoordinator];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initializeCoreDataWithiCloudOrNot) name:NSUbiquityIdentityDidChangeNotification object:nil];
                self.status = DTDataManagerStatusICloudIsReady;
                [[NSNotificationCenter defaultCenter] postNotificationName:DTICloudIsReadyNotification object:nil];
                
                if ([fileManager fileExistsAtPath:[localStoreURL path]]) {
                    NSMutableDictionary *migrateOptions = [[NSMutableDictionary alloc] init];
                    migrateOptions[NSMigratePersistentStoresAutomaticallyOption] = @YES;
                    migrateOptions[NSInferMappingModelAutomaticallyOption] = @YES;
                    store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localStoreURL options:migrateOptions error:&error];
                    if (store) {
                        store = [psc migratePersistentStore:store toURL:iCloudStoreURL options:options withType:NSSQLiteStoreType error:&error];
                        if(![fileManager removeItemAtPath:[localStoreURL path] error:&error]) {
                            store = nil;
                        }
                    }
                } else {
                    store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:iCloudStoreURL options:options error:&error];
                }
            } else {
                self.status = DTDataManagerStatusICloudNotReady;
                [[NSNotificationCenter defaultCenter] postNotificationName:DTICloudNotReadyNotification object:nil];
            }
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:self.moc.persistentStoreCoordinator];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUbiquityIdentityDidChangeNotification object:nil];
            store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:localStoreURL options:options error:&error];
        }
        if (store) {
            self.status = DTDataManagerStatusPersistentStoreIsReady;
            [[NSNotificationCenter defaultCenter] postNotificationName:DTPersistentStoreIsReadyNotification object:nil];
        } else {
            NSLog(@"Error adding persistent store to coordinator %@\n%@", [error localizedDescription], [error userInfo]);
            self.status = DTDataManagerStatusPersistentStoreNotReady;
            [[NSNotificationCenter defaultCenter] postNotificationName:DTPersistentStoreNotReadyNotification object:nil];
        }
    });
}

- (NSFetchedResultsController *)fetchedResultsControllerForWeight {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weight"];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO]];
    fetchRequest.propertiesToFetch = @[@"createDate", @"weight"];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.moc
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    return fetchedResultsController;
}

- (void)addWeightRecordWithDate:(NSDate *)createTime {
    NSManagedObject *weightObject = [NSEntityDescription insertNewObjectForEntityForName:@"Weight" inManagedObjectContext:self.moc];
    [weightObject setValue:createTime forKey:@"createDate"];
    [weightObject setValue:[createTime formatDayOfYear] forKey:@"date"];
    [weightObject setValue:[createTime formatMonthOfYear] forKey:@"month"];
    NSError *error = nil;
    if(![self.moc save:&error]) {
        NSLog(@"new weight record for date %@ error: %@", createTime, error);
    }
}

- (void)updateWeightRecordWithDate:(NSDate *)createTime weight:(float)weight {
    NSManagedObject *weightObject = [self findWeightRecordByDate:createTime];
    if (weightObject) {
        [weightObject setValue:@(weight) forKey:@"weight"];
        NSError *error = nil;
        if(![self.moc save:&error]) {
            NSLog(@"update weight record`s weight for date %@ error: %@", createTime, error);
        }
    }
}

- (void)updateWeightRecordWithDate:(NSDate *)createTime image:(NSData *)image {
    NSManagedObject *weightObject = [self findWeightRecordByDate:createTime];
    if (weightObject) {
        [weightObject setValue:image forKey:@"image"];
        NSError *error = nil;
        if(![self.moc save:&error]) {
            NSLog(@"update weight record`s image for date %@ error: %@", createTime, error);
        }
    }
}

- (void)removeWeightRecordWithDate:(NSDate *)createTime {
    NSManagedObject *weightObject = [self findWeightRecordByDate:createTime];
    if (weightObject) {
        [self.moc deleteObject:weightObject];
        NSError *error = nil;
        if(![self.moc save:&error]) {
            NSLog(@"remove weight record for date %@ error: %@", createTime, error);
        }
    }
}

- (NSData *)imageForWeightRecordWithDate:(NSDate *)createTime {
    NSManagedObject *weightObject = [self findWeightRecordByDate:createTime];
    return [weightObject valueForKey:@"image"];
}

- (BOOL)existedWeightRecordByDate:(NSDate *)date {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weight"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date == %@", [date formatDayOfYear]];
    NSError *error = nil;
    NSUInteger count = [self.moc countForFetchRequest:fetchRequest error:&error];
    return (count != NSNotFound && count > 0) ? YES : NO;
}

- (NSArray *)weightRecordsByMonth:(NSDate *)date {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weight"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"month == %@", [date formatMonthOfYear]];
    fetchRequest.propertiesToFetch = @[@"createDate", @"weight"];
    NSError *error = nil;
    return [self.moc executeFetchRequest:fetchRequest error:&error];
}

- (NSManagedObject *)findWeightRecordByDate:(NSDate *)date {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Weight"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date == %@", [date formatDayOfYear]];
    fetchRequest.propertiesToFetch = @[@"createDate", @"weight"];
    fetchRequest.fetchLimit = 1;
    NSError *error = nil;
    NSArray *array = [self.moc executeFetchRequest:fetchRequest error:&error];
    return (array && [array count] > 0) ? [array objectAtIndex:0] : nil;
}

#pragma mark - Private Helper Method

- (void)mergePersistentStoreContentChanges:(NSNotification*)notification {
    [self.moc performBlock:^{
        [self.moc mergeChangesFromContextDidSaveNotification:notification];
    }];
}

@end