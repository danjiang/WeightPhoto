//
//  DTWeightRecord.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@interface DTWeightRecord : NSObject

@property (nonatomic, strong, readonly) NSDate *createTime;
@property (nonatomic) float weight;

- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithManagedObject:(NSManagedObject *)object;

@end
