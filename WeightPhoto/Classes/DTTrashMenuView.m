//
//  DTTrashMenuView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-7.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTTrashMenuView.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

static const CGFloat DTTrashMenuViewHeight = 140;

@interface DTTrashMenuView ()

@property (nonatomic) CGRect showedFrame;
@property (nonatomic) CGRect hiddenFrame;
@property (nonatomic, strong) UIImageView *blurImageView;

@end

@implementation DTTrashMenuView

- (instancetype)initWithView:(UIView *)view blurImage:(UIImage *)blurImage {
    CGRect showedFrame = CGRectMake(0, CGRectGetHeight(view.frame) - DTTrashMenuViewHeight, CGRectGetWidth(view.frame), DTTrashMenuViewHeight);
    CGRect hiddenFrame = CGRectMake(0, CGRectGetHeight(view.frame) + DTTrashMenuViewHeight, CGRectGetWidth(view.frame), DTTrashMenuViewHeight);
    self = [super initWithFrame:hiddenFrame];
    if (self) {
        
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
        
        UIButton *trashButton = [[UIButton alloc] init];
        trashButton.translatesAutoresizingMaskIntoConstraints = NO;
        [trashButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        trashButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [trashButton setImage:[[UIImage imageNamed:@"trash-big-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *trashButtonHorizontalCenter = [NSLayoutConstraint
                                                   constraintWithItem:trashButton
                                                   attribute:NSLayoutAttributeCenterX
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeCenterX
                                                   multiplier:1.0
                                                   constant:0];
        NSLayoutConstraint *trashButtonBottom = [NSLayoutConstraint
                                                 constraintWithItem:trashButton
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                 constant:-32];
        
        [self addSubview:cancelButton];
        [self addSubview:doneButton];
        [self addSubview:trashButton];
        [self addConstraints:@[cancelButtonTop, cancelButtonLeading, doneButtonTop, doneButtonTrailing, trashButtonHorizontalCenter, trashButtonBottom]];
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
    [self.delegate trashMenuViewDidConfirm:self];
}

@end
