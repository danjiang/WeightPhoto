//
//  DTCalendarView.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-18.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTCalendarView.h"
#import "NSDate+Extend.h"
#import "DTCalendarViewItem.h"
#import "DTThemeManager.h"
#import "DTTheme.h"

static const CGFloat DTCalendarViewHeightMin = 337;
static const CGFloat DTCalendarViewHeightMax = 381;
static const CGFloat DTCalendarViewContainerWidth = 308;
static const CGFloat DTCalendarViewWeekdayWidth = 44;
static const CGFloat DTCalendarViewWeekdayHeight = 22;

@interface DTCalendarView ()

@property (nonatomic) CGRect superViewFrame;
@property (nonatomic) CGRect showedFrame;
@property (nonatomic) CGRect hiddenFrame;
@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSDate *firstDay;

@end

@implementation DTCalendarView

- (instancetype)initWithView:(UIView *)view blurImage:(UIImage *)blurImage date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.firstDay = date.firstDayOfMonth;
        self.superViewFrame = view.frame;
        
        self.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
        
        self.blurImageView = [[UIImageView alloc] initWithImage:blurImage];
        
        UIButton *cancelButton = [[UIButton alloc] init];
        cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
        [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [cancelButton setImage:[[UIImage imageNamed:@"cancel-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *cancelButtonTop = [NSLayoutConstraint
                                               constraintWithItem:cancelButton
                                               attribute:NSLayoutAttributeTop
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:NSLayoutAttributeTop
                                               multiplier:1.0
                                               constant:0];
        NSLayoutConstraint *cancelButtonLeading = [NSLayoutConstraint
                                                   constraintWithItem:cancelButton
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeLeading
                                                   multiplier:1.0
                                                   constant:0];
        [self addSubview:cancelButton];
        [self addConstraints:@[cancelButtonTop, cancelButtonLeading]];
        
        UIButton *leftButton = [[UIButton alloc] init];
        leftButton.translatesAutoresizingMaskIntoConstraints = NO;
        [leftButton addTarget:self action:@selector(previousMonth) forControlEvents:UIControlEventTouchUpInside];
        leftButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [leftButton setImage:[[UIImage imageNamed:@"arrow-left-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *leftButtonBottom = [NSLayoutConstraint
                                               constraintWithItem:leftButton
                                               attribute:NSLayoutAttributeBottom
                                               relatedBy:NSLayoutRelationEqual
                                               toItem:self
                                               attribute:NSLayoutAttributeBottom
                                               multiplier:1.0
                                               constant:0];
        NSLayoutConstraint *leftButtonLeading = [NSLayoutConstraint
                                                   constraintWithItem:leftButton
                                                   attribute:NSLayoutAttributeLeading
                                                   relatedBy:NSLayoutRelationEqual
                                                   toItem:self
                                                   attribute:NSLayoutAttributeLeading
                                                   multiplier:1.0
                                                   constant:0];
        [self addSubview:leftButton];
        [self addConstraints:@[leftButtonBottom, leftButtonLeading]];
        
        UIButton *rightButton = [[UIButton alloc] init];
        rightButton.translatesAutoresizingMaskIntoConstraints = NO;
        [rightButton addTarget:self action:@selector(nextMonth) forControlEvents:UIControlEventTouchUpInside];
        rightButton.tintColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        [rightButton setImage:[[UIImage imageNamed:@"arrow-right-line"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        NSLayoutConstraint *rightButtonBottom = [NSLayoutConstraint
                                                constraintWithItem:rightButton
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeBottom
                                                multiplier:1.0
                                                constant:0];
        NSLayoutConstraint *rightButtonTrailing = [NSLayoutConstraint
                                                 constraintWithItem:rightButton
                                                 attribute:NSLayoutAttributeTrailing
                                                 relatedBy:NSLayoutRelationEqual
                                                 toItem:self
                                                 attribute:NSLayoutAttributeTrailing
                                                 multiplier:1.0
                                                 constant:0];
        [self addSubview:rightButton];
        [self addConstraints:@[rightButtonBottom, rightButtonTrailing]];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.userInteractionEnabled = YES;
        self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
        self.containerView.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
        NSLayoutConstraint *containerViewFixedWidth = [NSLayoutConstraint
                                           constraintWithItem:self.containerView
                                           attribute:NSLayoutAttributeWidth
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                           attribute:NSLayoutAttributeWidth
                                           multiplier:0
                                           constant:DTCalendarViewContainerWidth];
        [self.containerView addConstraint:containerViewFixedWidth];
        NSLayoutConstraint *containerViewTop = [NSLayoutConstraint
                                                constraintWithItem:self.containerView
                                                attribute:NSLayoutAttributeTop
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:cancelButton
                                                attribute:NSLayoutAttributeBottom
                                                multiplier:1.0
                                                constant:0];
        NSLayoutConstraint *containerViewHorizontalCenter = [NSLayoutConstraint
                                                constraintWithItem:self.containerView
                                                attribute:NSLayoutAttributeCenterX
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeCenterX
                                                multiplier:1.0
                                                constant:0];
        [self addSubview:self.containerView];
        [self addConstraints:@[containerViewTop, containerViewHorizontalCenter]];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSArray *weekdaySymbols = [NSDate weekdaySymbols];
        for (int i = 0; i < weekdaySymbols.count; i++) {
            NSString *weekdaySymbol = weekdaySymbols[i];
            weekdaySymbol = [weekdaySymbol uppercaseString];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * DTCalendarViewWeekdayWidth, 0, DTCalendarViewWeekdayWidth, DTCalendarViewWeekdayHeight)];
            label.textColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
            label.font = [DTThemeManager sharedInstance].calendarWeekdayLabelFont;
            label.attributedText = [[NSAttributedString alloc] initWithString:weekdaySymbol attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [self.containerView addSubview:label];
        }
        
        self.monthLabel = [[UILabel alloc] init];
        self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.monthLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewTextColor;
        self.monthLabel.font = [DTThemeManager sharedInstance].calendarMonthLabelFont;
        NSLayoutConstraint *labelBottom = [NSLayoutConstraint
                                                constraintWithItem:self.monthLabel
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                                attribute:NSLayoutAttributeBottom
                                                multiplier:1.0
                                                constant:-6];
        NSLayoutConstraint *labelHorizontalCenter = [NSLayoutConstraint
                                                             constraintWithItem:self.monthLabel
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                             constant:0];
        [self addSubview:self.monthLabel];
        [self addConstraints:@[labelBottom, labelHorizontalCenter]];
    }
    return self;
}

- (void)show {
    self.frame = self.hiddenFrame;
    [self.superview insertSubview:self.blurImageView belowSubview:self];
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.55f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.showedFrame;
        self.alpha = 0.9f;
    } completion:nil];
}

- (void)update {
    [self updateDayOfMonth:[self.dataSource calendarView:self objectsInMonth:self.firstDay]];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    DTCalendarViewItem *item = [self itemInLocation:[touches.anyObject locationInView:self.containerView]];
    item.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewHighlightColor;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    DTCalendarViewItem *item = [self itemInLocation:[touches.anyObject locationInView:self.containerView]];
    item.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
    
    if (item) {
        [self.blurImageView removeFromSuperview];
        [self removeFromSuperview];
        [self.delegate calendarViewDidChoose:self object:item.object date:item.date];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    DTCalendarViewItem *item = [self itemInLocation:[touches.anyObject locationInView:self.containerView]];
    item.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].temporaryViewBackgroundColor;
}

#pragma mark - Private Helper Method

- (void)cancel {
    [self.blurImageView removeFromSuperview];
    [UIView animateWithDuration:0.5f delay:0.0f usingSpringWithDamping:0.55f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = self.hiddenFrame;
        self.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)previousMonth {
    self.firstDay = self.firstDay.previousMonth;
    [self update];
}

- (void)nextMonth {
    self.firstDay = self.firstDay.nextMonth;
    [self update];
}

- (void)updateDayOfMonth:(NSArray *)objects {
    self.monthLabel.text = self.firstDay.localMonth;

    for (DTCalendarViewItem *item in self.items) {
        [item removeFromSuperview];
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableArray *items = [NSMutableArray new];
    NSDateComponents *firstDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit) fromDate:self.firstDay];
    NSDate *nextDay = self.firstDay;
    NSDateComponents *nextDateComponents = firstDateComponents;
    while (nextDateComponents.month == firstDateComponents.month) {
        NSInteger index = nextDateComponents.day - 1 + firstDateComponents.weekday - 1;
        NSString *day = [NSString stringWithFormat:@"%d", (int)nextDateComponents.day];
        DTCalendarViewItem *item = [[DTCalendarViewItem alloc] initWithOrigin:CGPointMake((index % 7) * DTCalendarViewItemWidth, (index / 7) * DTCalendarViewItemHeight + DTCalendarViewWeekdayHeight) date:nextDay title:day object:[self existedInObjects:objects byDate:nextDay] today:[nextDay isToday]];
        [self.containerView addSubview:item];
        [items addObject:item];
        nextDay = nextDay.tomorrow;
        nextDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit) fromDate:nextDay];
    }
    self.items = items;
    
    NSDateComponents *lastDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSWeekdayCalendarUnit) fromDate:self.firstDay.lastDayOfMonth];
    NSInteger index = lastDateComponents.day - 1 + firstDateComponents.weekday - 1;
    CGFloat height = index / 7 > 4 ? DTCalendarViewHeightMax : DTCalendarViewHeightMin;
    self.showedFrame = CGRectMake(0, CGRectGetHeight(self.superViewFrame) - height, CGRectGetWidth(self.superViewFrame), height);
    self.hiddenFrame = CGRectMake(0, CGRectGetHeight(self.superViewFrame) + height, CGRectGetWidth(self.superViewFrame), height);
    self.frame = self.showedFrame;
}

- (NSManagedObject *)existedInObjects:(NSArray *)objects byDate:(NSDate *)date {
    for (NSManagedObject *object in objects) {
        NSDate *createTime = [object valueForKey:@"createDate"];
        if ([createTime sameDay:date]) {
            return object;
        }
    }
    return nil;
}

- (DTCalendarViewItem *)itemInLocation:(CGPoint)point {
    for (DTCalendarViewItem *item in self.items) {
        if (CGRectContainsPoint(item.frame, point)) {
            return item;
        }
    }
    return nil;
}

@end