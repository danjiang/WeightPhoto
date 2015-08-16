//
//  NSDate+Extend.h
//  WeightPhoto
//
//  Created by 但 江 on 13-8-13.
//  Copyright (c) 2013年 Dan Thought Studio. All rights reserved.
//

#define DT_MINUTE 60
#define DT_HOUR   (60 * DT_MINUTE)
#define DT_DAY    (24 * DT_HOUR)
#define DT_5_DAYS (5 * DT_DAY)
#define DT_WEEK   (7 * DT_DAY)
#define DT_MONTH  (30 * DT_DAY)
#define DT_YEAR   (365 * DT_DAY)

@interface NSDate (Extend)

+ (NSArray *)weekdaySymbols;
- (BOOL)sameDay:(NSDate *)anotherDate;
- (NSString *)localDate;
- (NSString *)localMonth;
- (NSString *)relativeDate;
- (NSString *)formatDayOfYear;
- (NSString *)formatMonthOfYear;
- (NSDate *)yesterday;
- (NSDate *)tomorrow;
- (NSDate *)previousMonth;
- (NSDate *)nextMonth;
- (NSDate *)firstDayOfMonth;
- (NSDate *)lastDayOfMonth;
- (BOOL)isToday;

@end