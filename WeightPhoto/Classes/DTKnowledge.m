//
//  DTKnowledge.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-10.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTKnowledge.h"

@interface DTKnowledge ()

@property (nonatomic) int identifier;
@property (nonatomic, copy) NSString *title;

@end

@implementation DTKnowledge

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _identifier = ((NSNumber *)dictionary[@"id"]).intValue;
        _title = dictionary[@"title"];
    }
    return self;
}

@end