//
//  NSDate+Extend.m
//  WeightPhoto
//
//  Created by 但 江 on 13-8-13.
//  Copyright (c) 2013年 Dan Thought Studio. All rights reserved.
//

#import "NSDate+Extend.h"

@implementation NSDate (Extend)

+ (NSArray *)weekdaySymbols {
    static NSDateFormatter* formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    return [formatter shortWeekdaySymbols];
}

- (BOOL)sameDay:(NSDate *)anotherDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDate *date1 = [calendar dateFromComponents:[calendar components:comps fromDate: self]];
    NSDate *date2 = [calendar dateFromComponents:[calendar components:comps fromDate: anotherDate]];
    return [date1 compare:date2] == NSOrderedSame;
}

- (NSString *)localDate {
    static NSDateFormatter* formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    return [formatter stringFromDate:self];
}

- (NSString *)localMonth {
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MMMM yyyy" options:0 locale:[NSLocale currentLocale]];
    return [self formatDate:dateFormat];
}

- (NSString *)relativeDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
    NSDate *today = [calendar dateFromComponents:[calendar components:comps fromDate:[NSDate new]]];
    NSDate *current = [calendar dateFromComponents:[calendar components:comps fromDate:self]];
    
    NSTimeInterval elapsed = [current timeIntervalSinceDate:today];
    if (elapsed <= 0) {
        elapsed *= -1;
        if (elapsed == 0) {
            return NSLocalizedString(@"Today", @"Today Text");
        } else if (elapsed == DT_DAY) {
            return NSLocalizedString(@"Yesterday", @"Yesterday Text");
        } else if (elapsed < DT_WEEK) {
            int days = (int)(elapsed/DT_DAY);
            return [NSString stringWithFormat:NSLocalizedString(@"XDaysAgo", @"%d Days Ago"), days];
        } else if (elapsed < 2 * DT_WEEK) {
            return NSLocalizedString(@"OneWeekAgo", @"One Week Ago Text");
        } else if (elapsed < DT_MONTH) {
            int weeks = (int)(elapsed/DT_WEEK);
            return [NSString stringWithFormat:NSLocalizedString(@"XWeeksAgo", @"%d Weeks Ago"), weeks];
        } else if (elapsed < 2 * DT_MONTH) {
            return NSLocalizedString(@"OneMonthAgo", @"One Month Ago Text");
        } else if (elapsed < DT_YEAR) {
            int months = (int)(elapsed/DT_MONTH);
            return [NSString stringWithFormat:NSLocalizedString(@"XMonthsAgo", @"%d Months Ago"), months];
        } else if (elapsed < 2 * DT_YEAR) {
            return NSLocalizedString(@"OneYearAgo", @"One Year Ago Text");
        } else {
            int years = (int)(elapsed/DT_YEAR);
            return [NSString stringWithFormat:NSLocalizedString(@"XYearsAgo", @"%d Years Ago"), years];
        }
    } else {
        return NSLocalizedString(@"Future", @"Future Text");
    }
}

- (NSString *)formatDayOfYear {
    return [self formatDate:@"yyyyMMdd"];
}

- (NSString *)formatMonthOfYear {
    return [self formatDate:@"yyyyMM"];
}

- (NSString *)formatDate:(NSString*)format {
    static NSDateFormatter* formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

- (NSDate *)yesterday {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)tomorrow {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)previousMonth {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];

}

- (NSDate *)nextMonth {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    return [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:self options:0];

}

- (NSDate *)firstDayOfMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:self];
    [dateComponents setDay:1];
    return [calendar dateFromComponents:dateComponents];
}

- (NSDate *)lastDayOfMonth {
    return self.firstDayOfMonth.nextMonth.yesterday;
}

- (BOOL)isToday {
    NSDate *today = [NSDate new];
    return [self sameDay:today];
}

@end