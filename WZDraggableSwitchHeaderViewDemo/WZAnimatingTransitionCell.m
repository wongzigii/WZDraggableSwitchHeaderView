//
//  WZAnimatingTransitionCell.m
//  WZAnimatingTransition
//
//  Created by Wongzigii on 5/27/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import "WZAnimatingTransitionCell.h"

@implementation WZAnimatingTransitionCell

const CGFloat kTextLabelWidth  = 200.0f;
const CGFloat kTextLabelHeight = 30.0f;

- (void)awakeFromNib {
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:NO];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - kTextLabelWidth / 2, self.frame.origin.y + self.frame.size.height, kTextLabelWidth, kTextLabelHeight)];
    [self addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:22.0f];
}

@end
