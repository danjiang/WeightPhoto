//
//  DTURLManager.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-10.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTURLManager.h"

NSString * const DTToken = @"token";

@interface DTURLManager ()

@property (nonatomic, strong, readonly) NSURL *baseURL;

@end

@implementation DTURLManager

- (id)init {
    self = [super init];
    if (self) {
        _baseURL = [NSURL URLWithString:@"http://danthought.com"];
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

- (NSString *)listKnowledgesURL {
    return [[NSURL URLWithString:@"api/v1/knowledges.json" relativeToURL:self.baseURL] absoluteString];
}

- (NSString *)showKnowledgeURL:(int)knowledgeId {
    return [[NSURL URLWithString:[NSString stringWithFormat:@"knowledges/%d", knowledgeId] relativeToURL:self.baseURL] absoluteString];
}

@end