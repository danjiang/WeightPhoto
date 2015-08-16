//
//  DTWeightInputView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-2.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTWeightInputView.h"
#import "DTRulerView.h"
#import "DTUserDefaults.h"
#import "DTUnitConverter.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

static const CGFloat DTWeightInputViewHeight = 200;

@interface DTWeightInputView () <DTRulerViewDelegate>

@property (nonatomic) CGRect showedFrame;
@property (nonatomic) CGRect hiddenFrame;
@property (nonatomic, weak) UILabel *label;
@property (nonatomic, strong) UIImageView *blurImageView;

@end

@implementation DTWeightInputView

- (instancetype)initWithView:(UIView *)view weight:(float)weight blurImage:(UIImage *)blurImage {
    CGRect showedFrame = CGRectMake(0, CGRectGetHeight(view.frame) - DTWeightInputViewHeight, CGRectGetWidth(view.frame), DTWeightInputViewHeight);
    CGRect hiddenFrame = CGRectMake(0, CGRectGetHeight(view.frame) + DTWeightInputViewHeight, CGRectGetWidth(view.frame), DTWeightInputViewHeight);
    self = [super initWithFrame:hiddenFrame];
    if (self) {
        self.weight = weight;
        weight = [self convertedWeight];
        
        self.showedFrame = showedFrame;
        self.hiddenFrame = hiddenFrame;
        self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
        
        self.blurImageView = [[UIImageView alloc] initWithImage:blurImage];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [cancelButton setImage:[[UIImage imageNamed:@"cancel-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *cancelButtonTop = [NSLayoutConstraint
                                         constraintWithItem:cancelButton
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                         constant:0];
        NSLayoutConstraint *cancelButtonLeading = [NSLayoutConstraint
                                             constraintWithItem:cancelButton
                                             attribute:NSLayoutAttributeLeading
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                             attribute:NSLayoutAttributeLeading
                                             multiplier:1.0
                                             constant:0];
        
        UIButton *doneButton = [[UIButton alloc] init];
        doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        doneButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [doneButton setImage:[[UIImage imageNamed:@"done-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *doneButtonTop = [NSLayoutConstraint
                                               constraintWithItem:doneButton
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:NSLayoutAttributeTop
                                               multiplier:1.0
                                               constant:0];
        NSLayoutConstraint *doneButtonTrailing = [NSLayoutConstraint
                                                   constraintWithItem:doneButton
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:0];
        
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        label.font = [[DTThemeManager sharedInstance] weightInputViewTextFont];
        [self reloadLabelWithWeight:weight];
        NSLayoutConstraint *labelHorizontalCenter = [NSLayoutConstraint
                                                       constraintWithItem:label
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                       constant:0];
        NSLayoutConstraint *labelTop = [NSLayoutConstraint
                                                constraintWithItem:label
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeTop
                                                multiplier:1.0
                                                constant:35];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"pointer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        NSLayoutConstraint *imageViewHorizontalCenter = [NSLayoutConstraint
                                                     constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                     multiplier:1.0
                                                     constant:0];
        NSLayoutConstraint *imageViewTop = [NSLayoutConstraint
                                        constraintWithItem:imageView
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:label
                                        attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                        constant:72];
        
        self = [super initWithFrame:CGRectMake(0, 0, 320, 63)];

        CGFloat rulerViewHeight = 63;
        DTRulerView *rulerView = [[DTRulerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), rulerViewHeight) weight:weight];
        rulerView.translatesAutoresizingMaskIntoConstraints = NO;
        rulerView.rulerViewDelegate = self;
        NSLayoutConstraint *fixedHeight = [NSLayoutConstraint
                                           constraintWithItem:rulerView
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeHeight
                                           multiplier:0
                                           constant:rulerViewHeight];
        [rulerView addConstraint:fixedHeight];
        NSLayoutConstraint *rulerViewLeading = [NSLayoutConstraint
                                        constraintWithItem:rulerView
                                        attribute:NSLayoutAttributeLeading
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                        attribute:NSLayoutAttributeLeading
                                        multiplier:1.0
                                        constant:0];
        NSLayoutConstraint *rulerViewBottom = [NSLayoutConstraint
                                        constraintWithItem:rulerView
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                        attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                        constant:0];
        NSLayoutConstraint *rulerViewTrailing = [NSLayoutConstraint
                                        constraintWithItem:rulerView
                                        attribute:NSLayoutAttributeTrailing
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                        attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0
                                        constant:0];
        
        [self addSubview:cancelButton];
        [self addSubview:doneButton];
        [self addSubview:label];
        [self addSubview:imageView];
        [self addSubview:rulerView];
        [self addConstraints:@[cancelButtonTop, cancelButtonLeading, doneButtonTop, doneButtonTrailing, labelHorizontalCenter, labelTop, imageViewHorizontalCenter, imageViewTop, rulerViewLeading, rulerViewBottom, rulerViewTrailing]];
    }
    return self;
}

- (void)show {
    [self.superview insertSubview:self.blurImageView belowSubview:self];
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.55f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.showedFrame;
        self.alpha = 0.9f;
    } completion:nil];
}

#pragma mark - Ruler View Delegate

- (void)rulerViewDidChange:(DTRulerView *)rulerView weight:(float)weight {
    if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
        self.weight = weight;
    } else {
        self.weight = [[DTUnitConverter sharedInstance] kiloWithPound:weight];
    }
    [self reloadLabelWithWeight:[self convertedWeight]];
}

#pragma mark - Private Helper Method

- (void)cancel {
    [self.blurImageView removeFromSuperview];
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.55f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.hiddenFrame;
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)done {
    [self.blurImageView removeFromSuperview];
    [self removeFromSuperview];
    [self.delegate weightInputViewDidDone:self];
}

- (void)reloadLabelWithWeight:(float)weight {
    NSString *unit = @"kg";
    if (![[DTUserDefaults sharedInstance] isUnitStandard]) {
        unit = @"lbs";
    }
    self.label.text = [NSString stringWithFormat:@"%0.1f %@", weight, unit];
}

- (float)convertedWeight {
    if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
        return self.weight;
    } else {
        return [[DTUnitConverter sharedInstance] poundWithKilo:self.weight];
    }
}

@end
