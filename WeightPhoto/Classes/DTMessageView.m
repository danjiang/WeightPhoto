//
//  DTMessageView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-10.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTMessageView.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

@interface DTMessageView ()

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation DTMessageView

- (id)initWithFrame:(CGRect)frame messsage:(NSString *)message {
    self = [super initWithFrame:frame];
    if (self) {
        _messageLabel = [UILabel new];
        _messageLabel.font = [[DTThemeManager sharedInstance] feedbackLabelFont];
        _messageLabel.textColor = [[DTThemeManager sharedInstance] lightGrayColor];
        _messageLabel.text = message;
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint *containerHorizontalCenter = [NSLayoutConstraint
                                                         constraintWithItem:_messageLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                         constant:0];
        NSLayoutConstraint *containerVerticalCenter = [NSLayoutConstraint
                                                       constraintWithItem:_messageLabel
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                       constant:0];
        [self addSubview:_messageLabel];
        [self addConstraints:@[containerHorizontalCenter, containerVerticalCenter]];
    }
    return self;
}

@end