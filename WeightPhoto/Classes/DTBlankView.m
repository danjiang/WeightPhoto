//
//  DTBlankView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-9.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTBlankView.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

@implementation DTBlankView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].cardBackgroundColor;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sticky-note-full"]];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        UILabel *titleLabel = [UILabel new];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        titleLabel.font = [[DTThemeManager sharedInstance] blankTitleLabelFont];
        titleLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMajorTextColor;
        titleLabel.text = title;
        UILabel *descriptionLabel = [UILabel new];
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:description attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
        descriptionLabel.font = [[DTThemeManager sharedInstance] blankDescriptionLabelFont];
        descriptionLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMinorTextColor;
        descriptionLabel.numberOfLines = 5;
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
                                            toItem:self
                                            attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                            constant:153];
        NSLayoutConstraint *titleLabelHorizontalCenter = [NSLayoutConstraint
                                                          constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                          constant:0];
        NSLayoutConstraint *titleLabelTop = [NSLayoutConstraint
                                             constraintWithItem:titleLabel
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:imageView
                                             attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                             constant:15];
        NSLayoutConstraint *descriptionLabelHorizontalCenter = [NSLayoutConstraint
                                                                constraintWithItem:titleLabel
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                                attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0
                                                                constant:0];
        NSLayoutConstraint *descriptionLabelTop = [NSLayoutConstraint
                                                   constraintWithItem:descriptionLabel
                                                   attribute:NSLayoutAttributeTop
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:titleLabel
                                                   attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0
                                                   constant:28];
        NSLayoutConstraint *descriptionLabelLeading = [NSLayoutConstraint
                                                       constraintWithItem:descriptionLabel
                                                       attribute:NSLayoutAttributeLeading
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                       constant:15];
        NSLayoutConstraint *descriptionLabelTrailing = [NSLayoutConstraint
                                                        constraintWithItem:descriptionLabel
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                        attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                        constant:-15];
        [self addSubview:imageView];
        [self addSubview:titleLabel];
        [self addSubview:descriptionLabel];
        [self addConstraints:@[imageViewHorizontalCenter, imageViewTop, titleLabelHorizontalCenter, titleLabelTop,
                               descriptionLabelHorizontalCenter, descriptionLabelTop, descriptionLabelLeading, descriptionLabelTrailing]];
    }
    return self;
}

@end

