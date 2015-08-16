//
//  DTCameraMenuView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-5.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTCameraMenuView.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

static const CGFloat DTCameraMenuViewHeight = 140;

@interface DTCameraMenuView ()

@property (nonatomic) CGRect showedFrame;
@property (nonatomic) CGRect hiddenFrame;
@property (nonatomic, strong) UIImageView *blurImageView;

@end

@implementation DTCameraMenuView

- (instancetype)initWithView:(UIView *)view blurImage:(UIImage *)blurImage {
    CGRect showedFrame = CGRectMake(0, CGRectGetHeight(view.frame) - DTCameraMenuViewHeight, CGRectGetWidth(view.frame), DTCameraMenuViewHeight);
    CGRect hiddenFrame = CGRectMake(0, CGRectGetHeight(view.frame) + DTCameraMenuViewHeight, CGRectGetWidth(view.frame), DTCameraMenuViewHeight);
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
        
        UIButton *cameraButton = [[UIButton alloc] init];
        cameraButton.translatesAutoresizingMaskIntoConstraints = NO;
        [cameraButton addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
        cameraButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [cameraButton setImage:[[UIImage imageNamed:@"camera-big-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *cameraButtonLeading = [NSLayoutConstraint
                                             constraintWithItem:cameraButton
                                             attribute:NSLayoutAttributeLeading
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                             attribute:NSLayoutAttributeLeading
                                             multiplier:1.0
                                             constant:51];
        NSLayoutConstraint *cameraButtonBottom = [NSLayoutConstraint
                                                  constraintWithItem:cameraButton
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                  constant:-32];
        
        UIButton *photoButton = [[UIButton alloc] init];
        photoButton.translatesAutoresizingMaskIntoConstraints = NO;
        [photoButton addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
        photoButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [photoButton setImage:[[UIImage imageNamed:@"photo-big-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *photoButtonTrailing = [NSLayoutConstraint
                                                   constraintWithItem:photoButton
                                                   attribute:NSLayoutAttributeTrailing
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeTrailing
                                                   multiplier:1.0
                                                   constant:-51];
        NSLayoutConstraint *photoButtonBottom = [NSLayoutConstraint
                                                  constraintWithItem:photoButton
                                                  attribute:NSLayoutAttributeBottom
                                                  relatedBy:NSLayoutRelationEqual
                                                  toItem:self
                                                  attribute:NSLayoutAttributeBottom
                                                  multiplier:1.0
                                                  constant:-32];
        
        UIView *line = [[UIView alloc] init];
        line.translatesAutoresizingMaskIntoConstraints = NO;
        line.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        NSLayoutConstraint *fixedHeight = [NSLayoutConstraint
                                           constraintWithItem:line
                                           attribute:NSLayoutAttributeHeight
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeHeight
                                           multiplier:0
                                           constant:60];
        NSLayoutConstraint *fixedWidth = [NSLayoutConstraint
                                           constraintWithItem:line
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeWidth
                                           multiplier:0
                                           constant:2];
        [line addConstraints:@[fixedHeight, fixedWidth]];
        NSLayoutConstraint *lineHorizontalCenter = [NSLayoutConstraint
                                                       constraintWithItem:line
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterX
                                                       multiplier:1.0
                                                       constant:0];
        NSLayoutConstraint *lineBottom = [NSLayoutConstraint
                                                 constraintWithItem:line
                                                 attribute:NSLayoutAttributeBottom
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeBottom
                                                 multiplier:1.0
                                                 constant:-28];
        [self addSubview:cancelButton];
        [self addSubview:cameraButton];
        [self addSubview:photoButton];
        [self addSubview:line];
        [self addConstraints:@[cancelButtonTop, cancelButtonLeading, cameraButtonLeading, cameraButtonBottom, photoButtonTrailing, photoButtonBottom, lineHorizontalCenter, lineBottom]];
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

- (void)camera {
    [self.blurImageView removeFromSuperview];
    [self removeFromSuperview];
    [self.delegate cameraMenuViewDidChoose:self camera:YES];
}

- (void)photo {
    [self.blurImageView removeFromSuperview];
    [self removeFromSuperview];
    [self.delegate cameraMenuViewDidChoose:self camera:NO];
}

@end
