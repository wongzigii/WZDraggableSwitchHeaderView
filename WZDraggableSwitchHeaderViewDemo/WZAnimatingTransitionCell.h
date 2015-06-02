//
//  WZAnimatingTransitionCell.h
//  WZAnimatingTransition
//
//  Created by Wongzigii on 5/27/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZAnimatingTransitionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic)  UILabel *titleLabel;

@property (nonatomic, assign) BOOL isBackward;
@end
