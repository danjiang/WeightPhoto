//
//  DTTheme.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@interface DTTheme : NSObject

@property (nonatomic, readonly) UIStatusBarStyle statusBarStyle;
@property (nonatomic, copy, readonly) NSString *actionButtonImage;
@property (nonatomic, strong, readonly) UIColor *cardBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *cardBorderColor;
@property (nonatomic, strong, readonly) UIColor *cardMajorTextColor;
@property (nonatomic, strong, readonly) UIColor *cardMinorTextColor;
@property (nonatomic, strong, readonly) UIColor *temporaryViewBackgroundColor;
@property (nonatomic, strong, readonly) UIColor *temporaryViewTextColor;
@property (nonatomic, strong, readonly) UIColor *temporaryViewHighlightColor;
@property (nonatomic, strong, readonly) UIColor *blurColor;
@property (nonatomic, strong, readonly) UIColor *temporaryViewTextInverseColor;

- (instancetype)initStatusBarStyle:(UIStatusBarStyle)statusBarStyle actionButtonImage:(NSString *)actionButtonImage cardBackgroundColor:(UIColor *)cardBackgroundColor cardBorderColor:(UIColor *)cardBorderColor cardMajorTextColor:(UIColor *)cardMajorTextColor cardMinorTextColor:(UIColor *)cardMinorTextColor temporaryViewBackgroundColor:(UIColor *)temporaryViewBackgroundColor temporaryViewTextColor:(UIColor *)temporaryViewTextColor temporaryViewHighlightColor:(UIColor *)temporaryViewHighlightColor blurColor:(UIColor *)blurColor temporaryViewTextInverseColor:(UIColor *)temporaryViewTextInverseColor;

@end
