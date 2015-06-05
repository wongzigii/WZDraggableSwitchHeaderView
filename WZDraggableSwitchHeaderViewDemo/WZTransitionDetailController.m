//
//  WZTransitionDetailController.m
//  WZAnimatingTransition
//
//  Created by Wongzigii on 5/21/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import "WZTransitionDetailController.h"
#import "WZTransitionTableController.h"
#import "WZDraggableSwitchHeaderView.h"
#import "WZAnimatingTransition.h"

@interface WZTransitionDetailController ()<UIScrollViewDelegate, WZDraggableSwitchHeaderViewDelegate>

@property (nonatomic, strong) WZDraggableSwitchHeaderView *headerView;
@property (nonatomic, strong) UIScrollView                 *scrollView;

@end

@implementation WZTransitionDetailController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView = [[WZDraggableSwitchHeaderView alloc] initWithDelegate:self frame:CGRectMake(0, 0, self.view.bounds.size.width, 50) normalStateHeight:20.0f heightCanTriggerSwitch:70.0f];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headerView.frame.size.height, self.headerView.frame.size.width, self.view.bounds.size.height - self.headerView.frame.size.height)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(0, 1.01 * self.scrollView.frame.size.height);
    self.scrollView.delegate = self;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hc-drib3"]];
    [imageView setFrame:CGRectMake(self.view.center.x - 200 / 2, self.view.center.y - 150 / 0.8, 200, 150)];
    [self.scrollView addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 300 / 2, self.view.center.y - 150 / 3 + 20, 300, 150)];
    textLabel.text = NSLocalizedString(@"All for one, one for all.", nil);
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName:@"Futura" size:16.0];
    [self.scrollView addSubview:textLabel];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.headerView];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - WZDraggableSwitchHeaderViewDelegate

- (void)WZDraggableSwitchHeaderViewDidTriggerDeepDragging;
{
    [self.navigationController.view.layer addAnimation:[WZAnimatingTransition backwardTransition] forKey:@"transition"];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.headerView WZDraggableSwitchHeaderViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.headerView WZDraggableSwitchHeaderViewDidEndDragging:scrollView];
}

@end
