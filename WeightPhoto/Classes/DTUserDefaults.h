//
//  DTUserDefaults.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTThemeManager.h"

extern NSString * const DTUserDefaultsUnitAndHeightChangedNotification;
extern NSString * const DTUserDefaultsThemeChangedNotification;

@interface DTUserDefaults : NSObject

+ (instancetype)sharedInstance;
- (void)setUnitToDefaultBaseOnLanguage;
- (BOOL)isUnitStandard;
- (void)setUnitToStandard;
- (void)setUnitToMetric;
- (BOOL)isICloud;
- (void)enableICloud;
- (void)disableICloud;
- (float)getHeight;
- (void)saveHeight:(float)height;
- (void)setThemeStyleToDefault;
- (void)setThemeStyle:(DTThemeStyle)style;
- (DTThemeStyle)getThemeStyle;
- (NSDate *)getSignificantTime;
- (void)setSignificantTime:(NSDate *)time;

@end
