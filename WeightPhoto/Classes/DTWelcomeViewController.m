//
//  DTWelcomeViewController.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-10.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTWelcomeViewController.h"
#import "DTUserDefaults.h"
#import "DTUnitConverter.h"
#import "DTDataManager.h"

static NSString * const DTHeightCellIdentifier = @"HeightCell";
static NSString * const DTPickerCellIdentifier = @"PickerCell";
static NSString * const DTICloudCellIdentifier = @"iCloudCell";
static NSString * const DTGuideCellIdentifier = @"GuideCell";

@interface DTWelcomeViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) float height;
@property (nonatomic, getter = isICloudEnabled) BOOL iCloudEnabled;
@property (nonatomic, getter = isHeightPickerVisible) BOOL heightPickerVisible;
@property (nonatomic, strong) NSIndexPath *heightIndexPath;
@property (nonatomic, strong) NSIndexPath *heightPickerIndexPath;

@end

@implementation DTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.height = 1.60;
    self.iCloudEnabled = YES;
    self.heightPickerVisible = NO;
    self.heightIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    self.heightPickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
}

- (IBAction)done:(id)sender {
    [[DTUserDefaults sharedInstance] saveHeight:self.height];
    if (self.iCloudEnabled) {
        [[DTUserDefaults sharedInstance] enableICloud];
    } else {
        [[DTUserDefaults sharedInstance] disableICloud];
    }
    [[DTDataManager sharedInstance] initializeCoreDataWithiCloudOrNot];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)iCloudValueChanged:(UISwitch *)iCloudSwitch {
    self.iCloudEnabled = iCloudSwitch.on;
}

#pragma mark - Navigation Bar Delegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - Picker View Data Source And Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [[DTUserDefaults sharedInstance] isUnitStandard] ? 3 : 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
        switch (component) {
            case 0:
                return 3;
            case 1:
                return 100;
            case 2:
                return 1;
            default:
                return 0;
        }
    } else {
        switch (component) {
            case 0:
                return 10;
            case 1:
                return 12;
            default:
                return 0;
        }
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
        switch (component) {
            case 0:
                title = [NSString stringWithFormat:@"%d", (int)row];
                break;
            case 1:
                title = [NSString stringWithFormat:@".%.2d", (int)row];
                break;
            case 2:
                title = @"m";
                break;
        }
    } else {
        switch (component) {
            case 0:
                title = [NSString stringWithFormat:@"%d'", (int)row];
                break;
            case 1:
                title = [NSString stringWithFormat:@"%d\"", (int)row];
                break;
        }
    }
    return [[NSAttributedString alloc] initWithString:title attributes:@{ NSForegroundColorAttributeName: [[DTThemeManager sharedInstance] darkGrayColor], NSFontAttributeName: [[DTThemeManager sharedInstance] pickerLabelFont] }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    float height = 0.0;
    if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
        height = [pickerView selectedRowInComponent:0] + [pickerView selectedRowInComponent:1] * 0.01;
    } else {
        height = [pickerView selectedRowInComponent:0] * 12 + [pickerView selectedRowInComponent:1];
        height = [[DTUnitConverter sharedInstance] meterWithInch:height];
    };
    if (height > 0) {
        self.height = height;
        [self.tableView reloadRowsAtIndexPaths:@[self.heightIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Table View Data Source and Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:self.heightPickerIndexPath] == NSOrderedSame) {
        return self.heightPickerVisible ? 217.0f : 0.0f;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 6;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"BMI", @"Calculate BMI");
    } else {
        return NSLocalizedString(@"Guide", @"Guide Text");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:DTHeightCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"Height", @"Height Text");
            float height = self.height;
            if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
                int meter = round(height * 100);
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m", meter / 100.0];
            } else {
                int inch = round([[DTUnitConverter sharedInstance] inchWithMeter:height]);
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d'%d\"", inch / 12, inch % 12];
            };
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:DTPickerCellIdentifier];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:DTICloudCellIdentifier];
            UISwitch *icloudSwitch = cell.contentView.subviews[1];
            icloudSwitch.on = self.isICloudEnabled;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:DTGuideCellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"weights-line"];
                cell.textLabel.text = NSLocalizedString(@"GuideWeight", @"Guide Text of Change Weight");
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"camera-line"];
                cell.textLabel.text = NSLocalizedString(@"GuidePhoto", @"Guide Text of Change Photo");
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"calendar-line"];
                cell.textLabel.text = NSLocalizedString(@"GuideDate", @"Guide Text of Show Calendar");
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"bird-house-line"];
                cell.textLabel.text = NSLocalizedString(@"GuideToday", @"Guide Text of Go Today");
                break;
            case 4:
                cell.imageView.image = [UIImage imageNamed:@"share-line"];
                cell.textLabel.text = NSLocalizedString(@"GuideShare", @"Guide Text of Social Share");
                break;
            default:
                cell.imageView.image = [UIImage imageNamed:@"trash-line"];
                cell.textLabel.text = NSLocalizedString(@"GuideRemove", @"Guide Text of Remove Record");
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath compare:self.heightIndexPath] == NSOrderedSame) {
        if (self.heightPickerVisible) {
            [self hideHeightPicker];
        } else {
            [self showHeightPicker];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Private Helper Method

- (void)showHeightPicker {
    if (!self.heightPickerVisible) {
        UITableViewCell *heightPickerCell = [self.tableView cellForRowAtIndexPath:self.heightPickerIndexPath];
        UIPickerView *heightPicker = heightPickerCell.contentView.subviews[0];
        
        float height = self.height;
        if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
            int meter = round(height * 100);
            [heightPicker selectRow:(meter / 100) inComponent:0 animated:NO];
            [heightPicker selectRow:(meter % 100) inComponent:1 animated:NO];
        } else {
            int inch = round([[DTUnitConverter sharedInstance] inchWithMeter:height]);
            [heightPicker selectRow:(inch / 12) inComponent:0 animated:NO];
            [heightPicker selectRow:(inch % 12) inComponent:1 animated:NO];
        };
        
        self.heightPickerVisible = YES;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        heightPicker.hidden = NO;
        heightPicker.alpha = 0.0f;
        [UIView animateWithDuration:0.25 animations:^{
            heightPicker.alpha = 1.0f;
        }];
    }
}

- (void)hideHeightPicker {
    if (self.heightPickerVisible) {
        UITableViewCell *heightPickerCell = [self.tableView cellForRowAtIndexPath:self.heightPickerIndexPath];
        UIPickerView *heightPicker = heightPickerCell.contentView.subviews[0];
        
        self.heightPickerVisible = NO;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        
        [UIView animateWithDuration:0.25 animations:^{
            heightPicker.alpha = 0.0f;
        } completion:^(BOOL finished) {
            heightPicker.hidden = YES;
        }];
    }
}

@end