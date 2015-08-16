//
//  DTTrashMenuView.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-7.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTTrashMenuView;

@protocol DTTrashMenuViewDelegate <NSObject>

- (void)trashMenuViewDidConfirm:(DTTrashMenuView *)trashMenuView;

@end


@interface DTTrashMenuView : UIView

@property (nonatomic, weak) id<DTTrashMenuViewDelegate> delegate;
- (instancetype)initWithView:(UIView *)view blurImage:(UIImage *)blurImage;
- (void)show;

@end
