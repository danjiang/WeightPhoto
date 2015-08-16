//
//  DTDataManager.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTWeightRecord;

extern NSString * const DTICloudIsReadyNotification;
extern NSString * const DTICloudNotReadyNotification;
extern NSString * const DTPersistentStoreIsReadyNotification;
extern NSString * const DTPersistentStoreNotReadyNotification;

typedef NS_ENUM(NSInteger, DTDataManagerStatus) {
    DTDataManagerStatusInit,
    DTDataManagerStatusICloudIsReady,
    DTDataManagerStatusICloudNotReady,
    DTDataManagerStatusPersistentStoreIsReady,
    DTDataManagerStatusPersistentStoreNotReady
};

@interface DTDataManager : NSObject

@property (nonatomic) DTDataManagerStatus status;
+ (instancetype)sharedInstance;
- (void)initializeCoreDataWithiCloudOrNot;
- (NSFetchedResultsController *)fetchedResultsControllerForWeight;
- (void)addWeightRecordWithDate:(NSDate *)createTime;
- (void)updateWeightRecordWithDate:(NSDate *)createTime weight:(float)weight;
- (void)updateWeightRecordWithDate:(NSDate *)createTime image:(NSData *)image;
- (void)removeWeightRecordWithDate:(NSDate *)createTime;
- (NSData *)imageForWeightRecordWithDate:(NSDate *)createTime;
- (BOOL)existedWeightRecordByDate:(NSDate *)date;
- (NSArray *)weightRecordsByMonth:(NSDate *)date;
- (NSManagedObject *)findWeightRecordByDate:(NSDate *)date;

@end
