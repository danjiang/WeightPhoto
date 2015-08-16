//
//  DTMenuView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-25.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTMenuView.h"
#import "DTMenuViewItem.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

static const CGFloat animationDuration = 0.4f;

@interface DTMenuView () <UIDynamicAnimatorDelegate, DTMenuViewItemDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation DTMenuView

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithFrame:view.frame];
    if (self) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
        self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
        
        NSArray *imageNames = @[@"wrench-line", @"share-line", @"bird-house-line", @"calendar-line", @"trash-line", @"camera-line", @"weights-line"];
        NSArray *texts = @[NSLocalizedString(@"MenuSetting", @"Menu Setting"),
                           NSLocalizedString(@"MenuSocial", @"Menu Social"),
                           NSLocalizedString(@"MenuToday", @"Menu Today"),
                           NSLocalizedString(@"MenuCalendar", @"Menu Calendar"),
                           NSLocalizedString(@"MenuRemove", @"Menu Remove"),
                           NSLocalizedString(@"MenuCamera", @"Menu Camera"),
                           NSLocalizedString(@"MenuWeight", @"Menu Weight")];
        for (int i = 0; i < imageNames.count; i++) {
            DTMenuViewItem *item = [[DTMenuViewItem alloc] initWithImageName:imageNames[i] text:texts[i] index:i];
            item.translatesAutoresizingMaskIntoConstraints = NO;
            item.delegate = self;
            CGFloat itemHeight = CGRectGetHeight(view.frame) > 480.0 ? 70.0 : 60.0;
            NSLayoutConstraint *fixedHeight = [NSLayoutConstraint
                                               constraintWithItem:item
                                               attribute:NSLayoutAttributeHeight
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:nil
                                               attribute:NSLayoutAttributeHeight
                                               multiplier:0
                                               constant:itemHeight];
            [item addConstraint:fixedHeight];
            UIView *underView = i > 0 ? self.subviews[i - 1] : self;
            NSLayoutAttribute underViewAttribute = i > 0 ? NSLayoutAttributeTop : NSLayoutAttributeBottom;
            NSLayoutConstraint *itemBottom = [NSLayoutConstraint
                                              constraintWithItem:item
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:underView
                                              attribute:underViewAttribute
                                              multiplier:1.0
                                              constant:0];
            NSLayoutConstraint *itemLeading = [NSLayoutConstraint
                                               constraintWithItem:item
                                               attribute:NSLayoutAttributeLeading
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:NSLayoutAttributeLeading
                                               multiplier:1.0
                                               constant:0];
            NSLayoutConstraint *itemTrailing = [NSLayoutConstraint
                                                constraintWithItem:item
                                                attribute:NSLayoutAttributeTrailing
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeTrailing
                                                multiplier:1.0
                                                constant:0];
            [self addSubview:item];
            [self addConstraints:@[itemBottom, itemLeading, itemTrailing]];
        }
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.translatesAutoresizingMaskIntoConstraints = NO;        
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [cancelButton setImage:[[UIImage imageNamed:@"cancel-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *buttonTop = [NSLayoutConstraint
                                         constraintWithItem:cancelButton
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                         attribute:NSLayoutAttributeTop
                                         multiplier:1.0
                                         constant:15];
        NSLayoutConstraint *buttonLeading = [NSLayoutConstraint
                                             constraintWithItem:cancelButton
                                             attribute:NSLayoutAttributeLeading
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:self
                                             attribute:NSLayoutAttributeLeading
                                             multiplier:1.0
                                             constant:0];
        [self addSubview:cancelButton];
        [self addConstraints:@[buttonTop, buttonLeading]];
    }
    return self;
}

- (void)show {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.animator.referenceView addSubview:self];
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:self.animator.referenceView.center];
    snapBehavior.damping = 0.8;
    [self.animator addBehavior:snapBehavior];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 0.98f;
    }];
}

#pragma mark - Menu View Item Delegate

- (void)menuViewItemDidTap:(DTMenuViewItem *)item {
    [self removeFromSuperview];
    switch (item.index) {
        case 0:
            [self.delegate menuViewDidChooseSetting:self];
            break;
        case 1:
            [self.delegate menuViewDidChooseSocial:self];
            break;
        case 2:
            [self.delegate menuViewDidChooseToday:self];
            break;
        case 3:
            [self.delegate menuViewDidChooseCalendar:self];
            break;
        case 4:
            [self.delegate menuViewDidChooseRemove:self];
            break;
        case 5:
            [self.delegate menuViewDidChooseCamera:self];
            break;
        case 6:
            [self.delegate menuViewDidChooseWeight:self];
            break;
    }
}

#pragma mark - Private Helper Method

- (void)cancel {
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self]];
    gravityBehaviour.gravityDirection = CGVectorMake(0, 10);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    [itemBehaviour addAngularVelocity:-M_PI_2 forItem:self];
    [self.animator addBehavior:itemBehaviour];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
