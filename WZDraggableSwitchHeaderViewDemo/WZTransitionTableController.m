//
//  WZTransitionTableController.m
//  WZAnimatingTransition
//
//  Created by Wongzigii on 5/26/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import "WZTransitionTableController.h"
#import "WZAnimatingTransitionCell.h"
#import "WZTransitionDetailController.h"
#import "UIColor+WZAnimatingTransition.h"
#import "WZAnimatingTransition.h"

@interface WZTransitionTableController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) CGFloat         currentSelection;
@property (nonatomic, strong) NSArray         *imageNameArray;
@property (nonatomic, strong) UILabel         *textLabel;
@property (nonatomic, strong) NSArray         *colorsArray;
@property (nonatomic, strong) NSArray         *namesArray;
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, assign, readwrite) BOOL isBackward;
@property (nonatomic, strong) NSIndexPath     *currentSelectIndexPath;
@end

@implementation WZTransitionTableController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isBackward = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.currentSelection = -1;
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.imageNameArray = @[@"social-dribbble-outline", @"social-github", @"social-dropbox", @"social-instagram", @"ios7-cloudy"];
    self.colorsArray = @[[UIColor DribbbleColor], [UIColor GithubColor], [UIColor DropboxColor], [UIColor InstagramColor], [UIColor CloudyColor]];
    self.namesArray = @[@"Dribbble", @"GitHub", @"Dropbox", @"Instagram", @"Cloudy"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *selection = [self.tableView indexPathForSelectedRow];
    if (selection) {
        [self.tableView deselectRowAtIndexPath:selection animated:YES];
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(animationBackToOrigin) withObject:nil afterDelay:0.7f];
}

- (void)animationBackToOrigin
{
    if (self.isBackward && self.currentSelectIndexPath) {
        if (!self.tableView.editing) {
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = self.currentSelectIndexPath;
            WZAnimatingTransitionCell *cell = (WZAnimatingTransitionCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 cell.iconImage.transform = CGAffineTransformMakeScale(1.0f,1.0f);
                                 CGRect iconImageRect = cell.iconImage.frame;
                                 UILabel *label = cell.titleLabel;
                                 CGRect labelRect = CGRectMake(label.frame.origin.x, iconImageRect.origin.y + iconImageRect.size.height + 10 + self.view.frame.size.height, label.frame.size.width, label.frame.size.height);
                                 [cell.titleLabel setFrame:labelRect];
                             }completion:^(BOOL finished) {
                                  self.isBackward = NO;
                                  self.currentSelection = -1;
                                  self.textLabel = nil;
                                  self.tableView.scrollEnabled = YES;
                                  self.tableView.allowsSelection = YES;
                             }];
            [self.tableView endUpdates];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)animatingTransitionForTableView:(UITableView *)tableView rowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!tableView.editing) {
        [tableView beginUpdates];
        self.currentSelectIndexPath = indexPath;
        self.currentSelection = indexPath.row;
        WZAnimatingTransitionCell *cell = (WZAnimatingTransitionCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             cell.iconImage.transform = CGAffineTransformMakeScale(2.0,2.0);
                         }completion:^(BOOL finished) {
                             CGRect iconImageRect = cell.iconImage.frame;
                             cell.titleLabel.text = self.namesArray[indexPath.row];
                             [UIView animateWithDuration:0.4f
                                              animations:^{
                                                  UILabel *label = cell.titleLabel;
                                                  CGRect labelRect = CGRectMake(label.frame.origin.x, iconImageRect.origin.y + iconImageRect.size.height + 10, label.frame.size.width, label.frame.size.height);
                                                  [cell.titleLabel setFrame:labelRect];
                                              }completion:^(BOOL finished) {
                                                  CGFloat delayInSeconds = 0.9f;
                                                  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                                                  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                      [self transitionBetweenViewControllers];
                                                  });
                                                  self.isBackward = YES;
                                                  tableView.scrollEnabled = NO;
                                                  tableView.allowsSelection = NO;
                                              }];
                         }];
        [tableView endUpdates];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

- (void)transitionBetweenViewControllers
{
    [self.navigationController.view.layer addAnimation:[WZAnimatingTransition forwardTransition] forKey:@"transition"];
    WZTransitionDetailController *vc = [[WZTransitionDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"WZExampleCell" owner:self options:nil];
    WZAnimatingTransitionCell *cell = [topLevelObjects objectAtIndex:0];
    cell.backgroundColor = self.colorsArray[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:[self.imageNameArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isBackward) {
        if (indexPath.row == self.currentSelection) {
            return self.view.bounds.size.height;
        }else
            return 160.0f;
    }else{
        return 160.0f;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView performSelectorOnMainThread:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath waitUntilDone:NO];
    [self animatingTransitionForTableView:tableView rowAtIndexPath:indexPath];
}

@end
