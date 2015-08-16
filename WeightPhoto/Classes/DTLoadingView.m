//
//  DTLoadingView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-9.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTLoadingView.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

@interface DTLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *loadingLabel;

@end

@implementation DTLoadingView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _activityIndicatorView = [UIActivityIndicatorView new];
        _activityIndicatorView.color = [[DTThemeManager sharedInstance] greenColor];
        _activityIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingLabel = [UILabel new];
        _loadingLabel.font = [[DTThemeManager sharedInstance] feedbackLabelFont];
        _loadingLabel.textColor = [[DTThemeManager sharedInstance] lightGrayColor];
        _loadingLabel.text = NSLocalizedString(@"Loading", @"Loading Text");
        _loadingLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *containerHorizontalCenter = [NSLayoutConstraint
                                                         constraintWithItem:_loadingLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                         constant:0];
        NSLayoutConstraint *containerVerticalCenter = [NSLayoutConstraint
                                                       constraintWithItem:_loadingLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                       constant:0];
        NSLayoutConstraint *alignHorizontalCenter = [NSLayoutConstraint
                                                     constraintWithItem:_loadingLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:_activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0
                                                     constant:0];
        NSLayoutConstraint *tailing = [NSLayoutConstraint
                                       constraintWithItem:_activityIndicatorView
                                       attribute:NSLayoutAttributeTrailing
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:_loadingLabel
                                       attribute:NSLayoutAttributeLeading
                                       multiplier:1.0
                                       constant: -10];
        [self addSubview:_loadingLabel];
        [self addSubview:_activityIndicatorView];
        [self addConstraints:@[containerHorizontalCenter, containerVerticalCenter, alignHorizontalCenter, tailing]];
    }
    return self;
}

- (BOOL)isAnimating {
    return self.activityIndicatorView.isAnimating;
}

- (void)startAnimating {
    [self.activityIndicatorView startAnimating];    
}

- (void)stopAnimating {
    [self.activityIndicatorView stopAnimating];
}

@end