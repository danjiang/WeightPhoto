//
//  DTAboutViewController.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-8.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

@import MessageUI;
#import "DTAboutViewController.h"

static const NSInteger DTRateAlertTag = 1;
static const NSInteger DTWebsiteAlertTag = 2;

@interface DTAboutViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *appVersion;

@end

@implementation DTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *majorVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.appVersion.text = [NSString stringWithFormat:NSLocalizedString(@"App Version", @"App Version Text"), majorVersion];
}

- (IBAction)rate:(id)sender {
    [self showLeavingAlertWithTag:DTRateAlertTag];
}

- (IBAction)feedback:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setToRecipients:@[@"dan@danthought.com"]];
        [picker setSubject:NSLocalizedString(@"FeedbackSubject", @"Feedback Mail Subject")];
        [picker setMessageBody:NSLocalizedString(@"FeedbackBody", @"Feedback Mail Body") isHTML:NO];
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        UIAlertView *mailAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MailAlertTitle", @"Setting Mail Alert Title")
                                                            message:NSLocalizedString(@"MailAlertMessage", @"Setting Mail Alert Message")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK Text")
                                                  otherButtonTitles:nil, nil];
        [mailAlert show];
    }
}

- (IBAction)website:(id)sender {
    [self showLeavingAlertWithTag:DTWebsiteAlertTag];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == DTRateAlertTag) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://georiot.co/weight"]];
        } else if (alertView.tag == DTWebsiteAlertTag) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://danthought.com/weight"]];
        }
    }
}

#pragma mark - Mail Compose View Controller Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Helper Method

- (void)showLeavingAlertWithTag:(NSInteger)tag {
    UIAlertView *leavingAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LeavingAlertTitle", @"Leaving Alert Title")
                                                           message:NSLocalizedString(@"LeavingAlertMessage", @"Leaving Alert Message")
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Text")
                                                 otherButtonTitles:NSLocalizedString(@"Open", @"Open Text"), nil];
    leavingAlert.tag = tag;
    [leavingAlert show];
}

@end
