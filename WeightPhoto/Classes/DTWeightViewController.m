//
//  DTWeightViewController.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-29.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "NSDate+Extend.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Resize.h"
#import "DTWeightViewController.h"
#import "DTMenuView.h"
#import "DTWeightInputView.h"
#import "DTCameraMenuView.h"
#import "DTTrashMenuView.h"
#import "DTCalendarView.h"
#import "DTBlankView.h"
#import "DTFileManager.h"
#import "DTDataManager.h"
#import "DTUserDefaults.h"
#import "DTUnitConverter.h"
#import "DTThemeManager.h"
#import "DTTheme.h"
#import "DTWeightRecord.h"

static NSString * const DTWeightCellIdentifier = @"WeightCell";
static const NSInteger DTTemporaryViewTag = 10;

@interface DTWeightViewController () <UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DTMenuViewDelegate, DTWeightInputViewDelegate, DTCameraMenuViewDelegate, DTTrashMenuViewDelegate, DTCalendarViewDataSource, DTCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIButton *actionButton;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *objectChanges;
@property (nonatomic, strong) NSMutableArray *sectionChanges;
@property (nonatomic, strong) UIImage *blurImage;
@property (nonatomic, strong) DTBlankView *blankView;

@end

@implementation DTWeightViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DTPersistentStoreIsReadyNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DTUserDefaultsUnitAndHeightChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DTUserDefaultsThemeChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:[UIApplication sharedApplication]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customizeAppearanceBaseOnTheme];
    if ([DTDataManager sharedInstance].status == DTDataManagerStatusPersistentStoreIsReady) {
        [self initFetchedResultsController];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseToday)];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSocial)];
    [self.collectionView addGestureRecognizer:tapGestureRecognizer];
    [self.collectionView addGestureRecognizer:longPressGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initFetchedResultsController) name:DTPersistentStoreIsReadyNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsChanged) name:DTUserDefaultsUnitAndHeightChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeStyleChanged) name:DTUserDefaultsThemeChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(significantTimeChanged) name:UIApplicationSignificantTimeChangeNotification object:[UIApplication sharedApplication]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[DTUserDefaults sharedInstance] getHeight] == 0) {
        [self performSegueWithIdentifier:@"WeightToWelcome" sender:self];
    } else {
        [self becomeFirstResponder];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[DTThemeManager sharedInstance] currentTheme].statusBarStyle;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (IBAction)showMenu:(id)sender {
    if (![self.view viewWithTag:DTTemporaryViewTag]) {
        DTMenuView *menuView = [[DTMenuView alloc] initWithView:self.view];
        menuView.tag = DTTemporaryViewTag;
        menuView.delegate = self;
        [self snapshot];
        [menuView show];
    }
}

#pragma mark - Fetched Results Controller Delegate

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type) {
        case NSFetchedResultsChangeInsert: change[@(type)] = @(sectionIndex); break;
        case NSFetchedResultsChangeDelete: change[@(type)] = @(sectionIndex); break;
    }
    [self.sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type) {
        case NSFetchedResultsChangeInsert: change[@(type)] = newIndexPath; break;
        case NSFetchedResultsChangeDelete: change[@(type)] = indexPath; break;
        case NSFetchedResultsChangeUpdate: change[@(type)] = indexPath; break;
        case NSFetchedResultsChangeMove: change[@(type)] = @[indexPath, newIndexPath]; break;
    }
    [self.objectChanges addObject:change];
    
    if (type == NSFetchedResultsChangeDelete || type == NSFetchedResultsChangeUpdate) {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        if (previousIndexPath.row >= 0) {
            change = [NSMutableDictionary new];
            change[@(NSFetchedResultsChangeUpdate)] = previousIndexPath;
            [self.objectChanges addObject:change];
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([self.sectionChanges count] > 0) {
        [self.collectionView performBatchUpdates:^{
            for (NSDictionary *change in self.sectionChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert: [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]]; break;
                        case NSFetchedResultsChangeDelete: [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]]; break;
                        case NSFetchedResultsChangeUpdate: [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]]; break;
                    }
                }];
            }
        } completion:nil];
    }
    
    if ([self.objectChanges count] > 0 && [self.sectionChanges count] == 0) {
        [self.collectionView performBatchUpdates:^{
            for (NSDictionary *change in self.objectChanges) {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type) {
                        case NSFetchedResultsChangeInsert: [self.collectionView insertItemsAtIndexPaths:@[obj]]; break;
                        case NSFetchedResultsChangeDelete: [self.collectionView deleteItemsAtIndexPaths:@[obj]]; break;
                        case NSFetchedResultsChangeUpdate: [self.collectionView reloadItemsAtIndexPaths:@[obj]]; break;
                        case NSFetchedResultsChangeMove: [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]]; break;
                    }
                }];
            }
        } completion:nil];
        for (NSDictionary *change in self.objectChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                NSInteger count = [self.fetchedResultsController.sections.firstObject numberOfObjects];
                if (type == NSFetchedResultsChangeInsert && count > 1) {
                    NSIndexPath *indexPath = obj;
                    [self.collectionView scrollToItemAtIndexPath:obj atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                }
            }];
        }        
    }
    
    [self.sectionChanges removeAllObjects];
    [self.objectChanges removeAllObjects];
}

#pragma mark - Collection View Data Source and Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.fetchedResultsController.sections.firstObject numberOfObjects];
    if (count == 0) {
        if (!self.blankView) {
            self.blankView = [[DTBlankView alloc] initWithFrame:self.view.frame
                                                          title:NSLocalizedString(@"NoRecordsTitle", @"No Records Title")
                                                    description:NSLocalizedString(@"NoRecordsDescription", @"No Records Description")];
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseToday)];
            tapGestureRecognizer.numberOfTapsRequired = 2;
            [self.blankView addGestureRecognizer:tapGestureRecognizer];
        }
        if (!self.blankView.superview) {
            [self.view addSubview:self.blankView];
        }
    } else {
        [self.blankView removeFromSuperview];
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DTWeightCellIdentifier forIndexPath:indexPath];
    
    DTWeightRecord *weightRecord = [[DTWeightRecord alloc] initWithManagedObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    float weightChange =  0;
    float weight = weightRecord.weight;
    NSString *unit = @"kg";
    float bmi = 0.0;
    NSString *level = nil;
    if (weightRecord.weight > 0) {
        DTWeightRecord *nextWeightRecord = [self nextWeightRecord:indexPath];
        if (nextWeightRecord) {
            weightChange = weightRecord.weight - nextWeightRecord.weight;
            weightChange = [[DTUnitConverter sharedInstance] roundToOneDecimal:weightChange];
        }
        if (![[DTUserDefaults sharedInstance] isUnitStandard]) {
            weight = [[DTUnitConverter sharedInstance] poundWithKilo:weightRecord.weight];
            unit = @"lbs";
            weightChange = [[DTUnitConverter sharedInstance] poundWithKilo:weightChange];
        }
        bmi =  [[DTUnitConverter sharedInstance] bmiWithWeight:weightRecord.weight height:[[DTUserDefaults sharedInstance] getHeight]];
        if (bmi < 18.5) {
            level = NSLocalizedString(@"Thin", @"Thin Text");
        } else if (bmi < 23.9){
            level = NSLocalizedString(@"Health", @"Health Text");
        } else if (bmi < 27.9){
            level = NSLocalizedString(@"Overweight", @"Overweight Text");
        } else {
            level = NSLocalizedString(@"Fat", @"Fat Text");
        }
    }
    
    UIView *cardView = cell.contentView.subviews[0];
    UILabel *sinceLabel = cardView.subviews[0];
    UILabel *dateLabel = cardView.subviews[1];
    UIView *topLine = cardView.subviews[2];
    UIImageView *imageView = cardView.subviews[3];
    UIView *bottomLine = cardView.subviews[4];
    UILabel *weightLabel = cardView.subviews[5];
    UILabel *arrowLabel = cardView.subviews[6];
    UILabel *changeLabel = cardView.subviews[7];
    UILabel *bmiLabel = cardView.subviews[8];
    UILabel *levelLabel = cardView.subviews[9];
    UILabel *emptyPhotoLabel = cardView.subviews[10];
    UILabel *emptyWeightLabel = cardView.subviews[11];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [cardView addGestureRecognizer:tapGestureRecognizer];
    
    cell.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].cardBackgroundColor;
    cardView.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].cardBackgroundColor;
    cardView.layer.borderWidth = 2.0f;
    cardView.layer.cornerRadius = 6.0f;
    cardView.layer.borderColor = [[DTThemeManager sharedInstance] currentTheme].cardBorderColor.CGColor;
    sinceLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMajorTextColor;
    dateLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMinorTextColor;
    topLine.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].cardBorderColor;
    bottomLine.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].cardBorderColor;
    weightLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMajorTextColor;
    if (weightChange > 0) {
        arrowLabel.textColor = [[DTThemeManager sharedInstance] orangeColor];
        changeLabel.textColor = [[DTThemeManager sharedInstance] orangeColor];
    } else if (weightChange < 0) {
        arrowLabel.textColor = [[DTThemeManager sharedInstance] greenColor];
        changeLabel.textColor = [[DTThemeManager sharedInstance] greenColor];
    } else {
        changeLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMinorTextColor;
    }
    bmiLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMinorTextColor;
    levelLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMinorTextColor;
    emptyPhotoLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMajorTextColor;
    emptyWeightLabel.textColor = [[DTThemeManager sharedInstance] currentTheme].cardMajorTextColor;
    
    sinceLabel.text = weightRecord.createTime.relativeDate;
    dateLabel.text = weightRecord.createTime.localDate;
    NSData *image = [[DTDataManager sharedInstance] imageForWeightRecordWithDate:weightRecord.createTime];
    if (image) {
        imageView.hidden = NO;
        emptyPhotoLabel.hidden = YES;
        imageView.image = [UIImage imageWithData:image];
    } else {
        imageView.hidden = YES;
        emptyPhotoLabel.hidden = NO;
    }
    
    if (weightRecord.weight > 0) {
        weightLabel.hidden = NO;
        arrowLabel.hidden = NO;
        changeLabel.hidden = NO;
        bmiLabel.hidden = NO;
        levelLabel.hidden = NO;
        emptyWeightLabel.hidden = YES;
        
        weightLabel.text = [NSString stringWithFormat:@"%0.1f %@", weight, unit];
        if (weightChange > 0) {
            arrowLabel.hidden = NO;
            arrowLabel.text = @"↑";
            changeLabel.text = [NSString stringWithFormat:@"%0.1f", weightChange];
        } else if (weightChange < 0) {
            arrowLabel.hidden = NO;
            arrowLabel.text = @"↓";
            changeLabel.text = [NSString stringWithFormat:@"%0.1f", fabs(weightChange)];
        } else {
            arrowLabel.hidden = YES;
            changeLabel.text = @"0.0";
        }
        bmiLabel.text = [NSString stringWithFormat:@"BMI %0.1f", bmi];
        levelLabel.text = level;
    } else {
        weightLabel.hidden = YES;
        arrowLabel.hidden = YES;
        changeLabel.hidden = YES;
        bmiLabel.hidden = YES;
        levelLabel.hidden = YES;
        emptyWeightLabel.hidden = NO;
    }
    
    return cell;
}

#pragma mark - Major Action Method

- (void)chooseToday {
    if (![self.view viewWithTag:DTTemporaryViewTag]) {
        NSDate *today = [NSDate new];
        if ([[DTDataManager sharedInstance] existedWeightRecordByDate:today]) {
            NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:[[DTDataManager sharedInstance] findWeightRecordByDate:today]];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        } else {
            [[DTDataManager sharedInstance] addWeightRecordWithDate:today];
        }
    }
}

- (void)choosePhoto:(BOOL)snapshot {
    if (![self.view viewWithTag:DTTemporaryViewTag]) {
        if (snapshot) {
            [self snapshot];
        }
        DTCameraMenuView *cameraMenuView = [[DTCameraMenuView alloc] initWithView:self.view blurImage:self.blurImage];
        cameraMenuView.tag = DTTemporaryViewTag;
        cameraMenuView.delegate = self;
        [self.view addSubview:cameraMenuView];
        [cameraMenuView show];
    }
}

- (void)chooseWeight:(BOOL)snapshot {
    if (![self.view viewWithTag:DTTemporaryViewTag]) {
        if (snapshot) {
            [self snapshot];
        }
        float weight = 60.0;
        DTWeightRecord *weightRecord = [self currentWeightRecord];
        DTWeightRecord *nextWeightRecord = [self nextWeightRecord:[self indexPathForVisibleItem]];
        if (weightRecord.weight > 0) {
            weight = weightRecord.weight;
        } else if (nextWeightRecord.weight > 0) {
            weight = nextWeightRecord.weight;
        }
        
        DTWeightInputView *weightInputView = [[DTWeightInputView alloc] initWithView:self.view weight:weight blurImage:self.blurImage];
        weightInputView.tag = DTTemporaryViewTag;
        weightInputView.delegate = self;
        [self.view addSubview:weightInputView];
        [weightInputView show];
    }
}

- (void)chooseSocial {
    if (!self.presentedViewController && ![self.view viewWithTag:DTTemporaryViewTag]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[self indexPathForVisibleItem]];
        UIView *cardView = cell.contentView.subviews[0];
        UILabel *dateLabel = cardView.subviews[1];
        UIImageView *imageView = cardView.subviews[3];
        UILabel *weightLabel = cardView.subviews[5];
        UILabel *bmiLabel = cardView.subviews[8];
        UILabel *levelLabel = cardView.subviews[9];
        
        NSMutableArray *items = [NSMutableArray new];
        if (!imageView.hidden) {
            [items addObject:imageView.image];
        }
        if (!weightLabel.hidden) {
            [items addObject:[NSString stringWithFormat:NSLocalizedString(@"ShareContent", @"Share Content"), dateLabel.text, weightLabel.text, bmiLabel.text, levelLabel.text]];
        }
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
        
        [self presentViewController:activity animated:YES completion:nil];
    }
}

- (void)chooseRemove:(BOOL)snapshot {
    if (![self.view viewWithTag:DTTemporaryViewTag]) {
        if (snapshot) {
            [self snapshot];
        }
        DTTrashMenuView *trashMenuView = [[DTTrashMenuView alloc] initWithView:self.view blurImage:self.blurImage];
        trashMenuView.tag = DTTemporaryViewTag;
        trashMenuView.delegate = self;
        [self.view addSubview:trashMenuView];
        [trashMenuView show];
    }
}

- (void)chooseCalendar:(BOOL)snapshot {
    if (![self.view viewWithTag:DTTemporaryViewTag]) {
        if (snapshot) {
            [self snapshot];
        }
        DTWeightRecord *weightRecord = [self currentWeightRecord];
        DTCalendarView *calendarView = [[DTCalendarView alloc] initWithView:self.view blurImage:self.blurImage date:weightRecord.createTime];
        calendarView.dataSource = self;
        calendarView.delegate = self;
        calendarView.tag = DTTemporaryViewTag;
        [self.view addSubview:calendarView];
        [calendarView update];
        [calendarView show];
    }
}

#pragma mark - Gesture Shortcut

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    
    CGRect dateRect = CGRectMake(0, 0, CGRectGetWidth(view.bounds), 50);
    CGRect photoRect = CGRectMake(0, 50, CGRectGetWidth(view.bounds), 250);
    CGRect weightRect = CGRectMake(0, 300, CGRectGetWidth(view.bounds), 79);
    CGPoint location = [recognizer locationInView:view];
    
    if (CGRectContainsPoint(dateRect, location)) {
        [self chooseCalendar:YES];
    } else if (CGRectContainsPoint(photoRect, location)) {
        [self choosePhoto:YES];
    } else if (CGRectContainsPoint(weightRect, location)) {
        [self chooseWeight:YES];
    }
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        if (!self.presentedViewController) {
            [self chooseRemove:YES];
        }
    }
}

#pragma mark - Menu View Delegate

- (void)menuViewDidChooseSetting:(DTMenuView *)menuView {
    [self performSegueWithIdentifier:@"WeightToSetting" sender:nil];
}

- (void)menuViewDidChooseSocial:(DTMenuView *)menuView {
    [self chooseSocial];
}

- (void)menuViewDidChooseToday:(DTMenuView *)menuView {
    [self chooseToday];
}

- (void)menuViewDidChooseCalendar:(DTMenuView *)menuView {
    [self chooseCalendar:NO];
}

- (void)menuViewDidChooseRemove:(DTMenuView *)menuView {
    [self chooseRemove:NO];
}

- (void)menuViewDidChooseCamera:(DTMenuView *)menuView {
    [self choosePhoto:NO];
}

- (void)menuViewDidChooseWeight:(DTMenuView *)menuView {
    [self chooseWeight:NO];
}

#pragma mark - Weight Input View Delegate

- (void)weightInputViewDidDone:(DTWeightInputView *)weightInputView {
    DTWeightRecord *weightRecord = [self currentWeightRecord];
    [[DTDataManager sharedInstance] updateWeightRecordWithDate:weightRecord.createTime weight:weightInputView.weight];
}

#pragma mark - Camera Menu View Delegate

- (void)cameraMenuViewDidChoose:(DTCameraMenuView *)cameraMenuView camera:(BOOL)camera {
    UIImagePickerControllerSourceType sourceType = camera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.mediaTypes = @[CFBridgingRelease(kUTTypeImage)];
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    DTWeightRecord *weightRecord = [self currentWeightRecord];
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    image = [UIImage resizeImage:image newSize:CGSizeMake(500, 500)];
    [[DTDataManager sharedInstance] updateWeightRecordWithDate:weightRecord.createTime image:UIImagePNGRepresentation(image)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Trash Menu View Delegate

- (void)trashMenuViewDidConfirm:(DTTrashMenuView *)trashMenuView {
    DTWeightRecord *weightRecord = [self currentWeightRecord];
    [[DTDataManager sharedInstance] removeWeightRecordWithDate:weightRecord.createTime];
}

#pragma mark - Calendar View Data Source and Delegate

- (NSArray *)calendarView:(DTCalendarView *)calendarView objectsInMonth:(NSDate *)date {
    return [[DTDataManager sharedInstance] weightRecordsByMonth:date];
}

- (void)calendarViewDidChoose:(DTCalendarView *)calendarView object:(NSManagedObject *)object date:(NSDate *)date {
    if (object) {
        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    } else {
        [[DTDataManager sharedInstance] addWeightRecordWithDate:date];
    }
}

#pragma mark - Handle Notification

- (void)userDefaultsChanged {
    [self.collectionView reloadData];
}

- (void)significantTimeChanged {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentTime = [NSDate new];
    NSDate *significantTime = [[DTUserDefaults sharedInstance] getSignificantTime];
    if (significantTime) {
        NSDateComponents *currentTimeComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                              fromDate:currentTime];
        NSDateComponents *significantTimeComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit)
                                                                  fromDate:significantTime];
        if (significantTimeComponents.day != currentTimeComponents.day
            || significantTimeComponents.month != currentTimeComponents.month
            || significantTimeComponents.year != currentTimeComponents.year) {
            [self.collectionView reloadData];
            [[DTUserDefaults sharedInstance] setSignificantTime:currentTime];
        }
    } else {
        [self.collectionView reloadData];
        [[DTUserDefaults sharedInstance] setSignificantTime:currentTime];
    }
}

- (void)themeStyleChanged {
    [[DTThemeManager sharedInstance] setThemeStyle:[[DTUserDefaults sharedInstance] getThemeStyle]];
    [self customizeAppearanceBaseOnTheme];
    [self.collectionView reloadData];
}

#pragma mark - Private Helper Method

- (void)initFetchedResultsController {
    self.sectionChanges = [NSMutableArray new];
    self.objectChanges = [NSMutableArray new];
    self.fetchedResultsController = [[DTDataManager sharedInstance] fetchedResultsControllerForWeight];
    self.fetchedResultsController.delegate = self;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Error fetched weight record %@\n%@", [error localizedDescription], [error userInfo]);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

- (void)customizeAppearanceBaseOnTheme {
    self.collectionView.backgroundColor = [[DTThemeManager sharedInstance] currentTheme].cardBackgroundColor;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.actionButton setImage:[UIImage imageNamed:[[DTThemeManager sharedInstance] currentTheme].actionButtonImage] forState:UIControlStateNormal];
}

- (NSIndexPath *)indexPathForVisibleItem {
    return self.collectionView.indexPathsForVisibleItems[0];
}

- (DTWeightRecord *)currentWeightRecord {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:[self indexPathForVisibleItem]];
    return [[DTWeightRecord alloc] initWithManagedObject:object];
}

- (DTWeightRecord *)nextWeightRecord:(NSIndexPath *)indexPath {
    if (indexPath.row + 1 < [self.fetchedResultsController.sections.firstObject numberOfObjects]) {
       return [[DTWeightRecord alloc] initWithManagedObject:[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]]];
    } else {
        return nil;
    }
}

- (void)snapshot {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, self.view.window.screen.scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:NO];
    UIImage *blurImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.blurImage = [blurImage applyBlurWithRadius:2 tintColor:[[DTThemeManager sharedInstance] currentTheme].blurColor saturationDeltaFactor:0.8 maskImage:nil];
}

@end