//
//  DTKnowledgesViewController.m
//  WeightPhoto
//
//  Created by 但 江 on 14-5-9.
//  Copyright (c) 2014年 Dan Thought Studio. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DTKnowledgesViewController.h"
#import "DTKnowledgeViewController.h"
#import "DTLoadingView.h"
#import "DTMessageView.h"
#import "DTURLManager.h"
#import "DTThemeManager.h"
#import "DTTheme.h"
#import "DTKnowledge.h"

static NSString * const DTKnowledgeCellIdentifier = @"KnowledgeCell";

@interface DTKnowledgesViewController ()

@property (nonatomic, strong) DTLoadingView *loadingView;
@property (nonatomic, strong) DTMessageView *messageView;
@property (nonatomic, copy) NSArray *knowledges;

@end

@implementation DTKnowledgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(showKnowledges) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [[DTThemeManager sharedInstance] greenColor];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.knowledges && !self.loadingView.isAnimating) {
        self.loadingView = [[DTLoadingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.tableView.rowHeight)];
        [self.view addSubview:self.loadingView];
        [self.loadingView startAnimating];
        [self showKnowledges];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"KnowledgesToKnowledge"]) {
        UITableViewCell *cell = sender;
        DTKnowledge *knowledge = self.knowledges[[[self.tableView indexPathForCell:cell] row]];
        DTKnowledgeViewController *knowledgeViewController = segue.destinationViewController;
        knowledgeViewController.knowledge = knowledge;
    }
}

#pragma mark - Table View Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.knowledges.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DTKnowledgeCellIdentifier];
    
    DTKnowledge *knowledge = self.knowledges[indexPath.row];
    
    cell.textLabel.text = knowledge.title;
    
    return cell;
}

#pragma mark - Private Helper Method

- (void)showKnowledges {
    [self.messageView removeFromSuperview];
    DTURLManager *urlManager = [DTURLManager sharedInstance];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[urlManager listKnowledgesURL]
      parameters:@{@"token": DTToken, @"bundle": [[NSBundle mainBundle] bundleIdentifier]}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSMutableArray *knowledges = [NSMutableArray new];
             for (NSDictionary *dictionary in responseObject) {
                 DTKnowledge *knowledge = [[DTKnowledge alloc] initWithDictionary:dictionary];
                 [knowledges addObject:knowledge];
             }
             self.knowledges = knowledges;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.refreshControl endRefreshing];
                 [self.loadingView stopAnimating];
                 [self.loadingView removeFromSuperview];
                 [self.tableView reloadData];
             });
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             self.knowledges = nil;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.refreshControl endRefreshing];
                 [self.loadingView stopAnimating];
                 [self.loadingView removeFromSuperview];
                 self.messageView = [[DTMessageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.tableView.rowHeight) messsage:NSLocalizedString(@"NetworkError", @"Network Error")];
                 [self.view addSubview:self.messageView];
                 [self.tableView reloadData];
             });
         }
     ];
}

@end
