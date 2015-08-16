//
//  DTSettingViewController.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-7.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import "DTSettingViewController.h"
#import "DTUserDefaults.h"
#import "DTUnitConverter.h"
#import "DTDataManager.h"

static NSString * const DTICloudCellIdentifier = @"iCloudCell";
static NSString * const DTHeightCellIdentifier = @"HeightCell";
static NSString * const DTPickerCellIdentifier = @"PickerCell";
static NSString * const DTUnitCellIdentifier = @"UnitCell";
static NSString * const DTThemeCellIdentifier = @"ThemeCell";
static NSString * const DTExtraCellIdentifier = @"ExtraCell";

@interface DTSettingViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

@property (nonatomic, getter = isHeightPickerVisible) BOOL heightPickerVisible;
@property (nonatomic, strong) NSIndexPath *heightIndexPath;
@property (nonatomic, strong) NSIndexPath *heightPickerIndexPath;

@end

@implementation DTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightPickerVisible = NO;
    self.heightIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    self.heightPickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
}

- (IBAction)done:(id)sender {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)iCloudValueChanged:(UISwitch *)iCloudSwitch {
    if (iCloudSwitch.on) {
        [[DTUserDefaults sharedInstance] enableICloud];
    } else {
        [[DTUserDefaults sharedInstance] disableICloud];
    }
    [[DTDataManager sharedInstance] initializeCoreDataWithiCloudOrNot];
}

- (IBAction)unitValueChanged:(UISegmentedControl *)unitSegment {
    [self hideHeightPicker];
    if (unitSegment.selectedSegmentIndex == 0) {
        [[DTUserDefaults sharedInstance] setUnitToStandard];
    } else {
        [[DTUserDefaults sharedInstance] setUnitToMetric];
    }
    [[self heightPickerInTableViewCell] reloadAllComponents];
    [self.tableView reloadRowsAtIndexPaths:@[self.heightIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)themeValueChanged:(UISegmentedControl *)themeSegment {
    if (themeSegment.selectedSegmentIndex == 0) {
        [[DTUserDefaults sharedInstance] setThemeStyle:DTThemeLightStyle];
    } else {
        [[DTUserDefaults sharedInstance] setThemeStyle:DTThemeDarkStyle];
    }
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
        [[DTUserDefaults sharedInstance] saveHeight:height];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"UseiCloud", @"Use iCloud Text");
    } else if (section == 1) {
        return NSLocalizedString(@"General", @"General Text");
    } else {
        return NSLocalizedString(@"Extra", @"Extra Text");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:DTICloudCellIdentifier];
        UISwitch *icloudSwitch = cell.contentView.subviews[1];
        icloudSwitch.on = [[DTUserDefaults sharedInstance] isICloud];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:DTHeightCellIdentifier];
            cell.textLabel.text = NSLocalizedString(@"Height", @"Height Text");
            float height = [[DTUserDefaults sharedInstance] getHeight];
            if ([[DTUserDefaults sharedInstance] isUnitStandard]) {
                int meter = round(height * 100);
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f m", meter / 100.0];
            } else {
                int inch = round([[DTUnitConverter sharedInstance] inchWithMeter:height]);
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d'%d\"", inch / 12, inch % 12];
            };
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:DTPickerCellIdentifier];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:DTUnitCellIdentifier];
            UILabel *unitlabel = cell.contentView.subviews[0];
            UISegmentedControl *unitSegment = cell.contentView.subviews[1];
            unitlabel.text = NSLocalizedString(@"Unit", @"Unit Text");
            [unitSegment setTitle:NSLocalizedString(@"Unit Standard", @"Unit Standard Text") forSegmentAtIndex:0];
            [unitSegment setTitle:NSLocalizedString(@"Unit Metric", @"Unit Metric Text") forSegmentAtIndex:1];
            unitSegment.selectedSegmentIndex = [[DTUserDefaults sharedInstance] isUnitStandard] ? 0 : 1;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:DTThemeCellIdentifier];
            UILabel *themelabel = cell.contentView.subviews[0];
            UISegmentedControl *themeSegment = cell.contentView.subviews[1];
            themelabel.text = NSLocalizedString(@"Theme", @"Theme Text");
            [themeSegment setTitle:NSLocalizedString(@"ThemeLight", @"Theme Light Text") forSegmentAtIndex:0];
            [themeSegment setTitle:NSLocalizedString(@"ThemeDark", @"Theme Dark Text") forSegmentAtIndex:1];
            themeSegment.selectedSegmentIndex = [[DTUserDefaults sharedInstance] getThemeStyle] == DTThemeLightStyle ? 0 : 1;
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:DTExtraCellIdentifier];
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Knowledge Base", @"Knowledge Base Text");
            cell.imageView.image = nil;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"About", @"About Text");
            cell.imageView.image = nil;
        } else {
            cell.textLabel.text = NSLocalizedString(@"Calorie", @"Calorie Text");
            cell.imageView.image = [UIImage imageNamed:@"calorie"];
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
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self performSegueWithIdentifier:@"SettingToKnowledges" sender:nil];
        } else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:@"SettingToAbout" sender:nil];
        } else {
            UIAlertView *leavingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LeavingAlertTitle", @"Leaving Alert Title")
                                                                   message:NSLocalizedString(@"LeavingAlertMessage", @"Leaving Alert Message")
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Text")
                                                         otherButtonTitles:NSLocalizedString(@"Open", @"Open Text"),nil];
            [leavingAlert show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NSLocalizedString(@"CrossPromotionCalorie", @"Cross Promotion Calorie URL")]];
    }
}

#pragma mark - Private Helper Method

- (void)showHeightPicker {
    if (!self.heightPickerVisible) {
        UIPickerView *heightPicker = [self heightPickerInTableViewCell];
        
        float height = [[DTUserDefaults sharedInstance] getHeight];
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
        UIPickerView *heightPicker = [self heightPickerInTableViewCell];

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

- (UIPickerView *)heightPickerInTableViewCell {
    UITableViewCell *heightPickerCell = [self.tableView cellForRowAtIndexPath:self.heightPickerIndexPath];
    return heightPickerCell.contentView.subviews[0];
}

@end
