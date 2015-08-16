//
//  DTWeightInputView.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-2.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTWeightInputView;

@protocol DTWeightInputViewDelegate <NSObject>

- (void)weightInputViewDidDone:(DTWeightInputView *)weightInputView;

@end

@interface DTWeightInputView : UIView

@property (nonatomic, weak) id<DTWeightInputViewDelegate> delegate;
@property (nonatomic) float weight;
- (instancetype)initWithView:(UIView *)view weight:(float)weight blurImage:(UIImage *)blurImage;
- (void)show;

@end
