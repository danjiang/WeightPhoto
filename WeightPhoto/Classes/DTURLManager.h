//
//  DTURLManager.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-10.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

extern NSString * const DTToken;

@interface DTURLManager : NSObject

+ (instancetype)sharedInstance;
- (NSString *)listKnowledgesURL;
- (NSString *)showKnowledgeURL:(int)knowledgeId;

@end
