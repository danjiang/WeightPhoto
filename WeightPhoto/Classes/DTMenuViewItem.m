//
//  DTMenuViewItem.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-28.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTMenuViewItem.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

@implementation DTMenuViewItem

- (instancetype)initWithImageName:(NSString *)imageName text:(NSString *)text index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.index = index;
        UIView *topLine = [[UIView alloc] init];
        topLine.translatesAutoresizingMaskIntoConstraints = NO;
        topLine.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        label.font = [[DTThemeManager sharedInstance] menuViewItemTextFont];
        label.text = text;
        NSLayoutConstraint *fixedHeight = [NSLayoutConstraint
                                           constraintWithItem:topLine
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeHeight
                                           multiplier:0
                                           constant:1];
        [topLine addConstraint:fixedHeight];
        NSLayoutConstraint *topLineTop = [NSLayoutConstraint
                                                constraintWithItem:topLine
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeTop
                                                multiplier:1.0
                                                constant:0];
        NSLayoutConstraint *topLineLeading = [NSLayoutConstraint
                                              constraintWithItem:topLine
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeLeading
                                              multiplier:1.0
                                              constant:0];
        NSLayoutConstraint *topLineTrailing = [NSLayoutConstraint
                                              constraintWithItem:topLine
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:self
                                              attribute:NSLayoutAttributeTrailing
                                              multiplier:1.0
                                              constant:0];
        NSLayoutConstraint *imageViewVerticalCenter = [NSLayoutConstraint
                                                       constraintWithItem:imageView
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                       constant:0];
        NSLayoutConstraint *imageViewLeading = [NSLayoutConstraint
                                       constraintWithItem:imageView
                                       attribute:NSLayoutAttributeLeading
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                       attribute:NSLayoutAttributeLeading
                                       multiplier:1.0
                                       constant:96];
        NSLayoutConstraint *labelVerticalCenter = [NSLayoutConstraint
                                                       constraintWithItem:label
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                       constant:0];
        NSLayoutConstraint *labelLeading = [NSLayoutConstraint
                                                constraintWithItem:label
                                                attribute:NSLayoutAttributeLeading
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:imageView
                                                attribute:NSLayoutAttributeTrailing
                                                multiplier:1.0
                                                constant:20];
        [self addSubview:topLine];
        [self addSubview:imageView];
        [self addSubview:label];
        [self addConstraints:@[topLineTop, topLineLeading, topLineTrailing, imageViewVerticalCenter, imageViewLeading, labelVerticalCenter, labelLeading]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewHighlightColor;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
    [self.delegate menuViewItemDidTap:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
}

@end
