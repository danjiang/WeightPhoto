//
//  DTRulerView.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-2.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTRulerView;

@protocol DTRulerViewDelegate

- (void)rulerViewDidChange:(DTRulerView *)rulerView weight:(float)weight;

@end

@interface DTRulerView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id<DTRulerViewDelegate> rulerViewDelegate;
- (instancetype)initWithFrame:(CGRect)frame weight:(float)weight;

@end
