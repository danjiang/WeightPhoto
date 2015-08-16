//
//  DTRulerViewScale.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-2.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

extern const CGFloat DTRulerScaleBlockWidth;
extern const CGFloat DTRulerScaleGap;

@interface DTRulerViewScale : UIView

@property (nonatomic) int weight;
- (id)initWithWeight:(int)weight frameHeight:(CGFloat)height;

@end
