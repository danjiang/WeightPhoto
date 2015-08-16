//
//  DTCameraMenuView.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-5.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTCameraMenuView;

@protocol DTCameraMenuViewDelegate <NSObject>

- (void)cameraMenuViewDidChoose:(DTCameraMenuView *)cameraMenuView camera:(BOOL)camera;

@end

@interface DTCameraMenuView : UIView

@property (nonatomic, weak) id<DTCameraMenuViewDelegate> delegate;
- (instancetype)initWithView:(UIView *)view blurImage:(UIImage *)blurImage;
- (void)show;

@end
