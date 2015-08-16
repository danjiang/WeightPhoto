//
//  DTCalendarViewItem.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-18.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

extern const CGFloat DTCalendarViewItemWidth;
extern const CGFloat DTCalendarViewItemHeight;

@interface DTCalendarViewItem : UIView

- (instancetype)initWithOrigin:(CGPoint)origin date:(NSDate *)date title:(NSString *)title object:(NSManagedObject *)object today:(BOOL)today;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSManagedObject *object;

@end
