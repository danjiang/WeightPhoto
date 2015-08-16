//
//  DTThemeManager.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTThemeManager.h"
#import "DTTheme.h"

@interface DTThemeManager ()

@property (nonatomic) DTThemeStyle style;
@property (nonatomic, strong) DTTheme *theme;

@end


@implementation DTThemeManager

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setThemeStyle:(DTThemeStyle)themeStyle {
    if (self.style != themeStyle || !self.theme) {
        self.style = themeStyle;
        if (self.style == DTThemeLightStyle) {
            self.theme = [[DTTheme alloc] initStatusBarStyle:UIStatusBarStyleDefault
                                           actionButtonImage:@"sun-line"
                                         cardBackgroundColor:[UIColor whiteColor]
                                             cardBorderColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]
                                          cardMajorTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]
                                          cardMinorTextColor:[UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1.0]
                                temporaryViewBackgroundColor:[self orangeColor]
                                      temporaryViewTextColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]
                                 temporaryViewHighlightColor:[UIColor colorWithRed:0.95 green:0.71 blue:0.40 alpha:1.0]
                                                   blurColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:0.6]
                               temporaryViewTextInverseColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]];
        } else if (self.style == DTThemeDarkStyle) {
            self.theme = [[DTTheme alloc] initStatusBarStyle:UIStatusBarStyleLightContent
                                           actionButtonImage:@"moon-line"
                                         cardBackgroundColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]
                                             cardBorderColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]
                                          cardMajorTextColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]
                                          cardMinorTextColor:[UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.0]
                                temporaryViewBackgroundColor:[self darkGreenColor]
                                      temporaryViewTextColor:[UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0]
                                 temporaryViewHighlightColor:[UIColor colorWithRed:0.00 green:0.62 blue:0.26 alpha:1.0]
                                                   blurColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:0.6]
                               temporaryViewTextInverseColor:[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0]];
        }
    }
}

- (DTTheme *)currentTheme {
    return self.theme;
}

- (UIColor *)greenColor {
    return [UIColor colorWithRed:0.42 green:0.74 blue:0.47 alpha:1.0];
}

- (UIColor *)orangeColor {
    return [UIColor colorWithRed:0.95 green:0.60 blue:0.11 alpha:1.0];
}

- (UIColor *)darkGreenColor {
    return [UIColor colorWithRed:0.00 green:0.42 blue:0.18 alpha:1.0];
}

- (UIColor *)darkGrayColor {
    return [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0];
}

- (UIColor *)lightGrayColor {
    return [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
}

- (UIFont *)menuViewItemTextFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
}

- (UIFont *)weightInputViewTextFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:48];
}

- (UIFont *)rulerScaleTextFont {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
}

- (UIFont *)pickerLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIFont *)blankTitleLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:20.0f];
}

- (UIFont *)blankDescriptionLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
}

- (UIFont *)feedbackLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
}

- (UIFont *)calendarWeekdayLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
}

- (UIFont *)calendarDayLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
}

- (UIFont *)calendarMonthLabelFont {
    return [UIFont fontWithName:@"HelveticaNeue" size:30.0f];
}

@end