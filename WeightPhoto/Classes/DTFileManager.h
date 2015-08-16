//
//  DTFileManager.h
//  WeightPhoto
//
//  Created by 但 江 on 13-8-18.
//  Copyright (c) 2013年 Dan Thought Studio. All rights reserved.
//

@interface DTFileManager : NSObject

+ (instancetype)sharedInstance;
- (NSURL *)documentDirectoryAppendingFilePath:(NSString *)file;
- (BOOL)removeItemAtURL:(NSURL *)url;

@end
