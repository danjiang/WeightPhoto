//
//  DTWeightRecord.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTWeightRecord.h"
#import "DTFileManager.h"

@interface DTWeightRecord ()

@property (nonatomic, strong) NSDate *createTime;

@end

@implementation DTWeightRecord

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];
    if (self) {
        _createTime = date;
    }
    return self;
}

- (instancetype)initWithManagedObject:(NSManagedObject *)object {
    self = [super init];
    if (self) {
        _createTime = [object valueForKey:@"createDate"];
        _weight = ((NSNumber *)[object valueForKey:@"weight"]).floatValue;
    }
    return self;
}

@end
