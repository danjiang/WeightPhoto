//
//  DTCalendarViewItem.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-18.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTCalendarViewItem.h"
#import "DTCircleView.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

const CGFloat DTCalendarViewItemWidth = 44;
const CGFloat DTCalendarViewItemHeight = 44;

static const CGFloat DTCalendarViewItemBigCircleRadius = 30;
static const CGFloat DTCalendarViewItemSmallCircleRadius = 6;

@implementation DTCalendarViewItem

- (instancetype)initWithOrigin:(CGPoint)origin date:(NSDate *)date title:(NSString *)title object:(NSManagedObject *)object today:(BOOL)today {
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, DTCalendarViewItemWidth, DTCalendarViewItemHeight)];
    if (self) {
        self.date = date;
        self.object = object;

        if (today) {
            DTCircleView *circle = [[DTCircleView alloc] initWithColor:[[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor];
            circle.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *circleFixedWidth = [NSLayoutConstraint
                                                    constraintWithItem:circle
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:nil
                                                    attribute:NSLayoutAttributeWidth
                                                    multiplier:0
                                                    constant:DTCalendarViewItemBigCircleRadius];
            NSLayoutConstraint *circleFixedHeight = [NSLayoutConstraint
                                                     constraintWithItem:circle
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                     multiplier:0
                                                     constant:DTCalendarViewItemBigCircleRadius];
            [circle addConstraints:@[circleFixedWidth, circleFixedHeight]];
            NSLayoutConstraint *circleHorizontalCenter = [NSLayoutConstraint
                                                         constraintWithItem:circle
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                         constant:0];
            NSLayoutConstraint *circleVerticalCenter = [NSLayoutConstraint
                                                       constraintWithItem:circle
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self
                                                       attribute:NSLayoutAttributeCenterY
                                                       multiplier:1.0
                                                       constant:0];
            [self addSubview:circle];
            [self addConstraints:@[circleHorizontalCenter, circleVerticalCenter]];
        }
        
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        if (today) {
            label.textColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextInverseColor;
        } else {
            label.textColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        }
        label.font = [DTThemeManager sharedInstance].calendarDayLabelFont;
        label.text = title;
        NSLayoutConstraint *labelHorizontalCenter = [NSLayoutConstraint
                                                             constraintWithItem:label
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                             constant:0];
        NSLayoutConstraint *labelVerticalCenter = [NSLayoutConstraint
                                                     constraintWithItem:label
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                     toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                     multiplier:1.0
                                                     constant:0];
        [self addSubview:label];
        [self addConstraints:@[labelHorizontalCenter, labelVerticalCenter]];
        
        if (object) {
            DTCircleView *circle = [[DTCircleView alloc] initWithColor:[[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor];
            circle.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *circleFixedWidth = [NSLayoutConstraint
                                                           constraintWithItem:circle
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                           attribute:NSLayoutAttributeWidth
                                                           multiplier:0
                                                           constant:DTCalendarViewItemSmallCircleRadius];
            NSLayoutConstraint *circleFixedHeight = [NSLayoutConstraint
                                                    constraintWithItem:circle
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                    toItem:nil
                                                    attribute:NSLayoutAttributeHeight
                                                    multiplier:0
                                                    constant:DTCalendarViewItemSmallCircleRadius];
            [circle addConstraints:@[circleFixedWidth, circleFixedHeight]];
            NSLayoutConstraint *circleBottom = [NSLayoutConstraint
                                                   constraintWithItem:circle
                                                   attribute:NSLayoutAttributeBottom
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeBottom
                                                   multiplier:1.0
                                                   constant:0];
            NSLayoutConstraint *circleHorizontalCenterWithLabel = [NSLayoutConstraint
                                             constraintWithItem:circle
                                             attribute:NSLayoutAttributeCenterX
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:label
                                             attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                             constant:0];
            [self addSubview:circle];
            [self addConstraints:@[circleBottom, circleHorizontalCenterWithLabel]];
        }
    }
    return self;
}

@end
