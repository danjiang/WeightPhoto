//
//  DTRulerView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-2.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTRulerView.h"
#import "DTRulerView.h"
#import "DTRulerViewScale.h"

static const int DTRulerScaleBlockNumber = 5;
static const int DTRulerMinScale = 9;
static const int DTRulerMaxScale = 999;

@interface DTRulerView ()

@property BOOL isAnimating;
@property (strong, nonatomic) NSMutableArray *weights;
@property (strong, nonatomic) NSMutableArray *rulerScales;
@property (strong, nonatomic) NSMutableArray *reusedRulerScales;
@property (strong, nonatomic) UIView *container;

@end

@implementation DTRulerView

- (instancetype)initWithFrame:(CGRect)frame weight:(float)weight {
    self = [super initWithFrame:frame]; // frame is necessary for caculating scale position
    if (self) {
        self.contentSize = CGSizeMake(DTRulerScaleBlockWidth * DTRulerScaleBlockNumber, self.frame.size.height);
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        
        _container = [[UIView alloc] init];
        _container.frame = CGRectMake(0, 0, self.contentSize.width, self.frame.size.height);
        _container.userInteractionEnabled = NO;
        [self addSubview:_container];
        
        _weights = [[NSMutableArray alloc] init];
        _rulerScales = [[NSMutableArray alloc] init];
        _reusedRulerScales = [[NSMutableArray alloc] init];
        
        int weightInt = roundf(weight * 10);
        int weightDecimal = weightInt % 10; // get weight`s decimal
        weightInt = weightInt / 10;
        int offsetGapNumber = 0;
        if (weightDecimal <= 4) {
            offsetGapNumber = weightDecimal + 5;
        } else {
            offsetGapNumber = weightDecimal - 5;
            weightInt++;
        }
        CGFloat startX = CGRectGetMidX(self.frame) - DTRulerScaleGap / 2; // point to middle scale block`s first scale
        startX -= offsetGapNumber * DTRulerScaleGap; // first scale with right gap offset
        
        int indexs[DTRulerScaleBlockNumber] = {0, -1, -2, 1, 2};
        for (int i = 0; i < DTRulerScaleBlockNumber; i++) {
            int index = indexs[i];
            [self placeWeight:((index == 0) ? [NSNumber numberWithInt:weightInt] : nil)
                orNewPrevious:(index < 0)
               calculateFrame:^CGRect(CGRect frame) {
                   frame.origin.x += startX + frame.size.width * index;
                   return frame;
               }];
        }
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    CGRect visibleBounds = [self visibleBounds];
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileChildrensFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}

- (void)recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0;
    CGFloat distanceFromCenterSign =  currentOffset.x - centerOffsetX;
    CGFloat distanceFromCenter = fabs(distanceFromCenterSign);
    if (distanceFromCenter > centerOffsetX) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        // move content by the same amount so it appears to stay still
        [self moveAllChildrensWithOffsetX:-distanceFromCenterSign animation:NO];
    }
}

- (void)moveAllChildrensWithOffsetX:(CGFloat)offsetX animation:(BOOL)animation{
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            for (DTRulerViewScale *rulerScale in self.rulerScales) {
                rulerScale.center = CGPointMake(rulerScale.center.x + offsetX, rulerScale.center.y);
            }
        }];
    } else {
        for (DTRulerViewScale *rulerScale in self.rulerScales) {
            rulerScale.center = CGPointMake(rulerScale.center.x + offsetX, rulerScale.center.y);
        }
    }
}

- (CGRect)visibleBounds {
    return [self convertRect:[self bounds] toView:self.container];
}

- (void)placeWeight:(NSNumber *)weight orNewPrevious:(BOOL)previous calculateFrame:(CGRect (^)(CGRect frame))calculateFrame {
    DTRulerViewScale *rulerScale = self.reusedRulerScales.lastObject;
    if (!rulerScale) {
        rulerScale = [[DTRulerViewScale alloc] initWithWeight:0 frameHeight:self.frame.size.height];
    }
    if (!weight && !previous) {
        weight = [self nextWeight];
    }
    if (!previous) {
        [_weights addObject:weight];
        [_rulerScales addObject:rulerScale];
        [_container addSubview:rulerScale];
    } else {
        weight = [self previousWeight];
        [_weights insertObject:weight atIndex:0];
        [_rulerScales insertObject:rulerScale atIndex:0];
        [_container insertSubview:rulerScale atIndex:0];
    }
    rulerScale.weight = weight.intValue;
    rulerScale.frame = calculateFrame(rulerScale.frame);
}

- (NSNumber *)previousWeight {
    NSNumber *weight = [self.weights objectAtIndex:0];
    if (weight.intValue > DTRulerMinScale) {
        return [NSNumber numberWithInt:weight.intValue - 1];
    } else {
        return [NSNumber numberWithInt:DTRulerMaxScale];
    }
}

- (NSNumber *)nextWeight {
    NSNumber *weight = self.weights.lastObject;
    if (weight.intValue < DTRulerMaxScale) {
        return [NSNumber numberWithInt:weight.intValue + 1];
    } else {
        return [NSNumber numberWithInt:DTRulerMinScale];
    }
}

- (void)tileChildrensFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX {
    // add child that are missing on right side
    DTRulerViewScale *last = self.rulerScales.lastObject;
    CGFloat rightEdge = CGRectGetMaxX(last.frame);
    if(rightEdge < maximumVisibleX) {
        [self placeWeight:nil orNewPrevious:NO calculateFrame:^CGRect(CGRect frame) {
            frame.origin.x = rightEdge;
            return frame;
        }];
    }
    
    // add child that are missing on left side
    DTRulerViewScale *first = [self.rulerScales objectAtIndex:0];
    CGFloat leftEdge = CGRectGetMinX(first.frame);
    if (leftEdge > minimumVisibleX) {
        [self placeWeight:nil orNewPrevious:YES calculateFrame:^CGRect(CGRect frame) {
            frame.origin.x = leftEdge - frame.size.width;
            return frame;
        }];
    }
    
    if(self.rulerScales.count > DTRulerScaleBlockNumber){
        // remove child that have fallen off right edge
        last = self.rulerScales.lastObject;
        leftEdge = CGRectGetMinX(last.frame);
        if (last && leftEdge > maximumVisibleX) {
            [self.reusedRulerScales addObject:last];
            [self.weights removeLastObject];
            [self.rulerScales removeLastObject];
            [last removeFromSuperview];
        }
        // remove child that have fallen off left edge
        first = [self.rulerScales objectAtIndex:0];
        rightEdge = CGRectGetMaxX(first.frame);
        if (first && rightEdge < minimumVisibleX) {
            [self.reusedRulerScales addObject:first];
            [self.weights removeObjectAtIndex:0];
            [self.rulerScales removeObjectAtIndex:0];
            [first removeFromSuperview];
        }
    }
}

- (float)weightPointedToWithRevise:(BOOL)revise {
    float weightFloat = 0.0;
    CGFloat middleVisibleX = CGRectGetMidX([self visibleBounds]);
    for (int i = 0; i < self.rulerScales.count; i++) {
        DTRulerViewScale *rulerScale = [self.rulerScales objectAtIndex:i];
        CGFloat rulerScaleMinX = CGRectGetMinX(rulerScale.frame);
        CGFloat rulerScaleMaxX = CGRectGetMaxX(rulerScale.frame);
        // point to which scale block
        if (rulerScaleMinX <= middleVisibleX && middleVisibleX < rulerScaleMaxX) {
            NSNumber *weight = [self.weights objectAtIndex:i];
            for (int j = 0; j < 10; j++) {
                CGFloat rulerSingleScaleMinX = rulerScaleMinX + j * DTRulerScaleGap;
                CGFloat rulerSingleScaleMidX = rulerSingleScaleMinX + DTRulerScaleGap/2;
                CGFloat rulerSingleScaleMaxX = rulerScaleMinX + (j + 1) * DTRulerScaleGap;
                // point to which scale block`s single scale
                if (rulerSingleScaleMinX <= middleVisibleX && middleVisibleX < rulerSingleScaleMaxX) {
                    weightFloat = weight.intValue + (j - 5) * 0.1;
                    // point to scale without offset
                    if (revise) {
                        [self moveAllChildrensWithOffsetX:middleVisibleX - rulerSingleScaleMidX animation:YES];
                    }
                    break;
                }
            }
            break;
        }
    }
    return weightFloat;
}

- (BOOL)isEnoughTimeElapsed {
    static NSTimeInterval lastTime = 0;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    BOOL isEnough = NO;
    if (lastTime == 0) {
        isEnough = YES;
    } else {
        isEnough = currentTime - lastTime > 0.016; // 16.67 milliseconds per frame
    }
    lastTime = currentTime;
    return isEnough;
}

#pragma mark - Delegate Method

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self.rulerViewDelegate rulerViewDidChange:(DTRulerView *)scrollView weight:[self weightPointedToWithRevise:YES]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.rulerViewDelegate rulerViewDidChange:(DTRulerView *)scrollView weight:[self weightPointedToWithRevise:YES]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self isEnoughTimeElapsed]) {
        [self.rulerViewDelegate rulerViewDidChange:(DTRulerView *)scrollView weight:[self weightPointedToWithRevise:NO]];
    }
}

@end
