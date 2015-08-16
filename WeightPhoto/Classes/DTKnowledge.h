//
//  DTKnowledge.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-10.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@interface DTKnowledge : NSObject

@property (nonatomic, readonly) int identifier;
@property (nonatomic, copy, readonly) NSString *title;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end