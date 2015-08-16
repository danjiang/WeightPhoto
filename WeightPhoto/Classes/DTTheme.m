//
//  DTTheme.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-21.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTTheme.h"

@interface DTTheme ()

@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic, copy) NSString *actionButtonImage;
@property (nonatomic, strong) UIColor *cardBackgroundColor;
@property (nonatomic, strong) UIColor *cardBorderColor;
@property (nonatomic, strong) UIColor *cardMajorTextColor;
@property (nonatomic, strong) UIColor *cardMinorTextColor;
@property (nonatomic, strong) UIColor *temporaryViewBackgroundColor;
@property (nonatomic, strong) UIColor *temporaryViewTextColor;
@property (nonatomic, strong) UIColor *temporaryViewHighlightColor;
@property (nonatomic, strong) UIColor *blurColor;
@property (nonatomic, strong) UIColor *temporaryViewTextInverseColor;

@end

@implementation DTTheme


- (instancetype)initStatusBarStyle:(UIStatusBarStyle)statusBarStyle actionButtonImage:(NSString *)actionButtonImage cardBackgroundColor:(UIColor *)cardBackgroundColor cardBorderColor:(UIColor *)cardBorderColor cardMajorTextColor:(UIColor *)cardMajorTextColor cardMinorTextColor:(UIColor *)cardMinorTextColor temporaryViewBackgroundColor:(UIColor *)temporaryViewBackgroundColor temporaryViewTextColor:(UIColor *)temporaryViewTextColor temporaryViewHighlightColor:(UIColor *)temporaryViewHighlightColor blurColor:(UIColor *)blurColor temporaryViewTextInverseColor:(UIColor *)temporaryViewTextInverseColor {
    self = [super init];
    if (self) {
        _statusBarStyle = statusBarStyle;
        _actionButtonImage = actionButtonImage;
        _cardBackgroundColor = cardBackgroundColor;
        _cardBorderColor = cardBorderColor;
        _cardMajorTextColor = cardMajorTextColor;
        _cardMinorTextColor = cardMinorTextColor;
        _temporaryViewBackgroundColor = temporaryViewBackgroundColor;
        _temporaryViewTextColor = temporaryViewTextColor;
        _temporaryViewHighlightColor = temporaryViewHighlightColor;
        _blurColor = blurColor;
        _temporaryViewTextInverseColor = temporaryViewTextInverseColor;
    }
    return self;
}

@end
