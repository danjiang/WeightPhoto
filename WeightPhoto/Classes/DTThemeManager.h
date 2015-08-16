//
//  DTThemeManager.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTTheme;

typedef NS_ENUM(NSInteger, DTThemeStyle) {
    DTThemeLightStyle,
    DTThemeDarkStyle
};

@interface DTThemeManager : NSObject

+ (instancetype)sharedInstance;
- (void)setThemeStyle:(DTThemeStyle)themeStyle;
- (DTTheme *)currentTheme;
- (UIColor *)greenColor;
- (UIColor *)orangeColor;
- (UIColor *)darkGreenColor;
- (UIColor *)darkGrayColor;
- (UIColor *)lightGrayColor;
- (UIFont *)menuViewItemTextFont;
- (UIFont *)weightInputViewTextFont;
- (UIFont *)rulerScaleTextFont;
- (UIFont *)pickerLabelFont;
- (UIFont *)blankTitleLabelFont;
- (UIFont *)blankDescriptionLabelFont;
- (UIFont *)feedbackLabelFont;
- (UIFont *)calendarWeekdayLabelFont;
- (UIFont *)calendarDayLabelFont;
- (UIFont *)calendarMonthLabelFont;

@end