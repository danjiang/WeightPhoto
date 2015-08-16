//
//  AppDelegate.m
//  WeightPhoto
//
//  Created by 但 江 on 14-4-29.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import "AppDelegate.h"
#import "iRate.h"
#import "Flurry.h"
#import "TSTapstream.h"
#import "DTUserDefaults.h"
#import "DTThemeManager.h"
#import "DTDataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[DTUserDefaults sharedInstance] setThemeStyleToDefault];
    [[DTUserDefaults sharedInstance] setUnitToDefaultBaseOnLanguage];
    [[DTThemeManager sharedInstance] setThemeStyle:[[DTUserDefaults sharedInstance] getThemeStyle]];
    [DTDataManager sharedInstance];
    if ([[DTUserDefaults sharedInstance] getHeight] != 0) {
        [[DTDataManager sharedInstance] initializeCoreDataWithiCloudOrNot];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showICloudAlert) name:DTICloudNotReadyNotification object:nil];
    
    [iRate sharedInstance].daysUntilPrompt = 7;
    [iRate sharedInstance].messageTitle = NSLocalizedString(@"iRateMessageTitle", @"iRate message title");
    [iRate sharedInstance].message = NSLocalizedString(@"iRateAppMessage", @"iRate message");
    [iRate sharedInstance].cancelButtonLabel = NSLocalizedString(@"iRateCancelButton", @"iRate decline button");
    [iRate sharedInstance].remindButtonLabel = NSLocalizedString(@"iRateRemindButton", @"iRate remind button");
    [iRate sharedInstance].rateButtonLabel = NSLocalizedString(@"iRateRateButton", @"iRate accept button");
    
    [Flurry startSession:@"key"];
    [Crashlytics startWithAPIKey:@"key"];
    [TSTapstream createWithAccountName:@"name" developerSecret:@"key" config:[TSConfig configWithDefaults]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DTICloudNotReadyNotification object:nil];
}

#pragma mark - Private helper method

- (void)showICloudAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"iCloudErrorTitle", "iCloud Error Title") message:NSLocalizedString(@"iCloudErrorMessage", "iCloud Error Message") delegate:self cancelButtonTitle:NSLocalizedString(@"UseLocalStore", "Use Local Store") otherButtonTitles:NSLocalizedString(@"Retry", "Retry"), nil];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[DTUserDefaults sharedInstance] disableICloud];
    }
    [[DTDataManager sharedInstance] initializeCoreDataWithiCloudOrNot];
}

@end
