//
//  DTMenuView.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-25.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTMenuView;

@protocol DTMenuViewDelegate <NSObject>

- (void)menuViewDidChooseSetting:(DTMenuView *)menuView;
- (void)menuViewDidChooseSocial:(DTMenuView *)menuView;
- (void)menuViewDidChooseToday:(DTMenuView *)menuView;
- (void)menuViewDidChooseCalendar:(DTMenuView *)menuView;
- (void)menuViewDidChooseRemove:(DTMenuView *)menuView;
- (void)menuViewDidChooseCamera:(DTMenuView *)menuView;
- (void)menuViewDidChooseWeight:(DTMenuView *)menuView;

@end

@interface DTMenuView : UIView

@property (nonatomic, weak) id<DTMenuViewDelegate> delegate;
- (instancetype)initWithView:(UIView *)view;
- (void)show;

@end
