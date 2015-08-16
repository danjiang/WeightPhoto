//
//  DTCalendarView.h
//  WeightPhoto
//
//  Created by 但 江 on 14-5-18.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@class DTCalendarView;

@protocol DTCalendarViewDataSource <NSObject>

- (NSArray *)calendarView:(DTCalendarView *)calendarView objectsInMonth:(NSDate *)date;

@end

@protocol DTCalendarViewDelegate <NSObject>

- (void)calendarViewDidChoose:(DTCalendarView *)calendarView object:(NSManagedObject *)object date:(NSDate *)date;

@end

@interface DTCalendarView : UIView

- (instancetype)initWithView:(UIView *)view blurImage:(UIImage *)blurImage date:(NSDate *)date;
- (void)show;
- (void)update;
@property (nonatomic, weak) id<DTCalendarViewDataSource> dataSource;
@property (nonatomic, weak) id<DTCalendarViewDelegate> delegate;

@end