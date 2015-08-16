//
//  DTCircleView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-18.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTCircleView.h"

@interface DTCircleView ()

@property (nonatomic, strong) UIColor *color;

@end

@implementation DTCircleView

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.opaque = NO;
        self.color = color;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.color setFill];
    CGContextFillEllipseInRect(context, rect);
}

@end
