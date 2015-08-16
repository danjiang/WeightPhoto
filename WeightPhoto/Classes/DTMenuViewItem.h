//
//  DTMenuViewItem.h
//  WeightPhoto
//
//  Created by 但 江 on 14-4-28.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTMenuViewItem;

@protocol DTMenuViewItemDelegate <NSObject>

- (void)menuViewItemDidTap:(DTMenuViewItem *)item;

@end

@interface DTMenuViewItem : UIView

- (instancetype)initWithImageName:(NSString *)imageName text:(NSString *)text index:(NSInteger)index;
@property (nonatomic, weak) id<DTMenuViewItemDelegate> delegate;
@property (nonatomic) NSInteger index;

@end
