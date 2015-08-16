//
//  DTUserDefaults.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTUserDefaults.h"

NSString * const DTUserDefaultsUnitAndHeightChangedNotification = @"DTUserDefaultsUnitAndHeightChangedNotification";
NSString * const DTUserDefaultsThemeChangedNotification = @"DTUserDefaultsThemeChangedNotification";

static NSString * const DTHeightKey = @"height";
static NSString * const DTThemeStyleKey = @"theme";
static NSString * const DTUnitKey = @"unit";
static NSString * const DTICloudKey = @"icloud";
static const NSInteger DTUnitStandardValue = 1;
static const NSInteger DTUnitMetricValue = 2;
static NSString * const DTSignificantTimeKey = @"significanttime";

@implementation DTUserDefaults

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setUnitToDefaultBaseOnLanguage {
    if([[NSUserDefaults standardUserDefaults] integerForKey:DTUnitKey] == 0) {
        NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
        if ([language isEqualToString:@"zh-Hans"]) {
            [self setUnitToStandard];
        } else {
            [self setUnitToMetric];
        }
    }
}

- (BOOL)isUnitStandard {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DTUnitKey] == DTUnitStandardValue;
}

- (void)setUnitToStandard {
    [[NSUserDefaults standardUserDefaults] setInteger:DTUnitStandardValue forKey:DTUnitKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DTUserDefaultsUnitAndHeightChangedNotification object:nil];
}

- (void)setUnitToMetric {
    [[NSUserDefaults standardUserDefaults] setInteger:DTUnitMetricValue forKey:DTUnitKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DTUserDefaultsUnitAndHeightChangedNotification object:nil];
}

- (BOOL)isICloud {
    return [[NSUserDefaults standardUserDefaults] boolForKey:DTICloudKey];
}

- (void)enableICloud {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DTICloudKey];
}

- (void)disableICloud {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DTICloudKey];
}

- (float)getHeight {
    return [[NSUserDefaults standardUserDefaults] floatForKey:DTHeightKey];
}

- (void)saveHeight:(float)height {
    if ([self getHeight] != height) {
        [[NSUserDefaults standardUserDefaults] setFloat:height forKey:DTHeightKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:DTUserDefaultsUnitAndHeightChangedNotification object:nil];
    }
}

- (void)setThemeStyleToDefault {
    if([self getThemeStyle] == 0) {
        [self setThemeStyle:DTThemeLightStyle];
    }
}

- (void)setThemeStyle:(DTThemeStyle)style {
    [[NSUserDefaults standardUserDefaults] setInteger:style forKey:DTThemeStyleKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:DTUserDefaultsThemeChangedNotification object:nil];
}

- (DTThemeStyle)getThemeStyle {
    return [[NSUserDefaults standardUserDefaults] integerForKey:DTThemeStyleKey];
}

- (NSDate *)getSignificantTime {
    return [[NSUserDefaults standardUserDefaults] objectForKey:DTSignificantTimeKey];
}

- (void)setSignificantTime:(NSDate *)time {
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:DTSignificantTimeKey];
}

@end
