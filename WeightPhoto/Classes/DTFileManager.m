//
//  DTFileManager.m
//  WeightPhoto
//
//  Created by 但 江 on 13-8-18.
//  Copyright (c) 2013年 Dan Thought Studio. All rights reserved.
//

#import "DTFileManager.h"

@implementation DTFileManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (NSURL *)documentDirectoryAppendingFilePath:(NSString *)file {
    return [self documentDirectoryAppendingPathComponent:file isDirectory:NO];
}

- (BOOL)removeItemAtURL:(NSURL *)url {
    NSError *error;
    if ([[NSFileManager defaultManager] removeItemAtURL:url error:&error]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Private Helper Method

- (NSURL *)documentDirectoryAppendingPathComponent:(NSString *)path isDirectory:(BOOL)isDirectory {
    return [[self documentDirectory] URLByAppendingPathComponent:path isDirectory:isDirectory];
}

- (NSURL *)documentDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
