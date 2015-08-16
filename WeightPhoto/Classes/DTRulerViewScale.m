//
//  DTRulerViewScale.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-2.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTRulerViewScale.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

const CGFloat DTRulerScaleBlockWidth = 100;
const CGFloat DTRulerScaleGap = 10;

@implementation DTRulerViewScale

- (id)initWithWeight:(int)weight frameHeight:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0.0, 0.0, DTRulerScaleBlockWidth, height)];
    if (self) {
        self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
        _weight = weight;
    }
    return self;
}

- (void)setWeight:(int)weight {
    if (_weight != weight) {
        _weight = weight;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self doScaleWithWeight:self.weight rect:rect context:context];
}

- (void)doScaleWithWeight:(int)weight rect:(CGRect)rect context:(CGContextRef)context {
    CGFloat startX = CGRectGetMidX(rect) + DTRulerScaleGap / 2;
    CGFloat startY = CGRectGetMinY(rect);
    [[[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor setStroke];
    
    NSString *weightLabel = [NSString stringWithFormat:@"%d", weight];
    NSDictionary *attributes = @{NSFontAttributeName: [[DTThemeManager sharedInstance] rulerScaleTextFont],
                                 NSForegroundColorAttributeName: [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor};
    
    CGSize textSize = [weightLabel sizeWithAttributes:attributes];
    [weightLabel drawInRect:CGRectMake(startX - textSize.width / 2, startY + self.frame.size.height * 0.46875 + 4, textSize.width, textSize.height)
             withAttributes:attributes];
    
    CGContextSetLineWidth(context, 2.0);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, startX, self.frame.size.height * 0.46875);
    CGContextDrawPath(context, kCGPathStroke);
    
    [self doScaleFromMidToEgdeWithStartX:startX startY:startY counter:4 plus:YES context:context];
    [self doScaleFromMidToEgdeWithStartX:startX startY:startY counter:5 plus:NO context:context];
}

- (void)doScaleFromMidToEgdeWithStartX:(CGFloat)startX startY:(CGFloat)startY counter:(int)counter plus:(BOOL)plus context:(CGContextRef)context {
    CGContextSetLineWidth(context, 1);
    for (int i = 0; i < counter; i++) {
        if (plus) {
            startX += DTRulerScaleGap;
        } else {
            startX -= DTRulerScaleGap;
        }
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX, self.frame.size.height * 0.3125);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
