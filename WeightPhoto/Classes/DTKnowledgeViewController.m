//
//  DTKnowledgeViewController.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-9.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import <UIWebView+AFNetworking.h>
#import "DTKnowledgeViewController.h"
#import "DTURLManager.h"
#import "DTKnowledge.h"

@interface DTKnowledgeViewController () <UINavigationBarDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UINavigationItem *navItem;

@end

@implementation DTKnowledgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DTURLManager *urlManager = [DTURLManager sharedInstance];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlManager showKnowledgeURL:self.knowledge.identifier]]];
    
    
    [self.webView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navItem.title = NSLocalizedString(@"Loading", @"Loading Text");
        });
    } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navItem.title = NSLocalizedString(@"Knowledge", @"Knowledge Text");
        });
        return HTML;
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navItem.title = NSLocalizedString(@"NetworkError", @"Network Error");
        });
    }];
}

- (IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation Bar Delegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end