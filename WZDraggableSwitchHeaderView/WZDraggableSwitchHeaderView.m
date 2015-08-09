//
//  WZDraggableSwitchHeaderView.m
//  WZAnimatingTransition
//
//  Created by Wongzigii on 5/21/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import "WZDraggableSwitchHeaderView.h"

#define WZ_HEADER_VIEW_BACKGROUND_COLOR [UIColor colorWithRed:35.0 / 255.0 green:35.0 / 255.0 blue:35.0 / 255.0 alpha:1.0]
#define WZ_ARROW_BACKGROUND_COLOR       [UIColor colorWithRed:3.0 / 255.0 green:3.0 / 255.0 blue:3.0 / 255.0 alpha:1.0]

const CGFloat WZ_ARROW_ANIMATION_DURATION = 0.18f;
const CGFloat WZ_ARROW_IMAGE_HEIGHT       = 15.0f;
const CGFloat WZ_FLIP_ANIMATION_DURATION  = 0.5;
const CGFloat WZ_STATUS_LABEL_HEIGHT      = 50.f;
static NSString * WZ_HEADER_VIEW_FONT     = @"Fundamental  Brigade Schwer";

@implementation WZDraggableSwitchHeaderView

- (instancetype)initWithDelegate:(id<WZDraggableSwitchHeaderViewDelegate>)delegate frame:(CGRect)frame normalStateHeight:(CGFloat)normalStateHeight heightCanTriggerSwitch:(CGFloat)heightCanTriggerSwitch
{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = WZ_HEADER_VIEW_BACKGROUND_COLOR;

        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(frame.size.height / 2 - WZ_ARROW_IMAGE_HEIGHT / 2,
                                 15.0f,
                                 WZ_ARROW_IMAGE_HEIGHT,
                                 WZ_ARROW_IMAGE_HEIGHT);
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.contents = (id)[UIImage imageNamed:@"up_arrow"].CGImage;
        layer.backgroundColor = WZ_ARROW_BACKGROUND_COLOR.CGColor;
        [self.layer addSublayer:layer];
        self.arrowImage = layer;
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(layer.frame.size.width + 2 * WZ_ARROW_IMAGE_HEIGHT,
                                                                     0,
                                                                     frame.size.width,
                                                                     WZ_STATUS_LABEL_HEIGHT)];
        self.statusLabel.text = self.normalStateText;
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = [UIFont fontWithName:WZ_HEADER_VIEW_FONT size:16.0];

        [self addSubview:self.statusLabel];
        
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        self.delegate =  delegate;
        
        self.normalStateHeight = normalStateHeight;
        self.heightCanTriggerSwitch = heightCanTriggerSwitch;
        [self setState:WZDraggableSwitchStateNormal];
    }
    return self;
}

- (instancetype)initWithDelegate:(id<WZDraggableSwitchHeaderViewDelegate>)delegate frame:(CGRect)frame
{
    self = [self initWithDelegate:delegate frame:frame normalStateHeight:self.normalStateHeight heightCanTriggerSwitch:self.heightCanTriggerSwitch];
    return self;
}

#pragma mark - Getter

- (CGFloat)normalStateHeight
{
    if (!_normalStateHeight) {
        _normalStateHeight = 20.0f;
    }
    return _normalStateHeight;
}

- (CGFloat)heightCanTriggerSwitch
{
    if (!_heightCanTriggerSwitch) {
        _heightCanTriggerSwitch = 70.0f;
    }
    return _heightCanTriggerSwitch;
}

- (NSString *)normalStateText
{
    if (!_normalStateText) {
        _normalStateText = NSLocalizedString(@"ABOUT", @"Default text for normal state.");
    }
    return _normalStateText;
}

- (NSString *)shallowStateText
{
    if (!_shallowStateText) {
        _shallowStateText = NSLocalizedString(@"PULL TO RETURN TO MENU.", @"Default text for shallow dragging state.");
    }
    return _shallowStateText;
}

- (NSString *)deepStateText
{
    if (!_deepStateText) {
        _deepStateText = NSLocalizedString(@"RELEASE TO RETURN TO MENU", @"Default text for deep dragging state.");
    }
    return _deepStateText;
}

- (void)setState:(WZDraggableSwitchState)astate
{
    switch (astate) {
        case WZDraggableSwitchStateNormal:
            if (self.state == WZDraggableSwitchStateDeepDragging || self.state == WZDraggableSwitchStateShallowDragging) {
                [self flipHeaderViewWithCommonTransitionSubtypes:kCATransitionFromTop];
                self.statusLabel.text = NSLocalizedString(self.normalStateText, "Text for the normal state.");
                [CATransaction begin];
                [CATransaction setAnimationDuration:WZ_ARROW_ANIMATION_DURATION];
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            break;
        case WZDraggableSwitchStateShallowDragging:
            if (self.state == WZDraggableSwitchStateNormal || self.state == WZDraggableSwitchStateDeepDragging) {
                if (self.state == WZDraggableSwitchStateNormal) {
                    [self flipHeaderViewWithCommonTransitionSubtypes:kCATransitionFromBottom];
                }
                self.statusLabel.text = NSLocalizedString(self.shallowStateText, @"Text for the shallow dragging state.");
                [CATransaction begin];
                [CATransaction setAnimationDuration:WZ_ARROW_ANIMATION_DURATION];
                self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
            }
            break;
        case WZDraggableSwitchStateDeepDragging:
            if (self.state == WZDraggableSwitchStateShallowDragging) {
                self.statusLabel.text = NSLocalizedString(self.deepStateText, @"Text for the deep dragging state.");
                self.arrowImage.transform = CATransform3DMakeRotation(( 2 * M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            }
            break;
    }
    _state = astate;
}

- (void)flipHeaderViewWithCommonTransitionSubtypes:(NSString *)subtype{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = WZ_FLIP_ANIMATION_DURATION;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"oglFlip";
    animation.subtype = subtype;
    [[self layer] addAnimation:animation forKey:@"FLIP_ANIMATION"];
}

# pragma mark - Delegate

- (void)WZDraggableSwitchHeaderViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging) {
        switch (self.state) {
            case WZDraggableSwitchStateNormal:
                if (scrollView.contentOffset.y < - self.normalStateHeight && scrollView.contentOffset.y > - self.heightCanTriggerSwitch) {
                    [self setState:WZDraggableSwitchStateShallowDragging];
                }
                break;
            case WZDraggableSwitchStateShallowDragging:
                if (scrollView.contentOffset.y > - self.normalStateHeight && scrollView.contentOffset.y < 0.0f) {
                    [self setState:WZDraggableSwitchStateNormal];
                }else if (scrollView.contentOffset.y < - self.heightCanTriggerSwitch) {
                    [self setState:WZDraggableSwitchStateDeepDragging];
                }
                break;
            case WZDraggableSwitchStateDeepDragging:
                if (scrollView.contentOffset.y > - self.heightCanTriggerSwitch && scrollView.contentOffset.y < - self.normalStateHeight) {
                    [self setState:WZDraggableSwitchStateShallowDragging];
                }
                break;
        }
    }
    
    if (scrollView.contentInset.top != 0) {
        scrollView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)WZDraggableSwitchHeaderViewDidEndDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > - self.heightCanTriggerSwitch && scrollView.contentOffset.y < 0.0f) {
        if ([_delegate respondsToSelector:@selector(WZDraggableSwitchHeaderViewDidTriggerShallowDragging)]) {
            [_delegate WZDraggableSwitchHeaderViewDidTriggerShallowDragging];
        }
    }else if (scrollView.contentOffset.y < - self.heightCanTriggerSwitch) {
        if ([_delegate respondsToSelector:@selector(WZDraggableSwitchHeaderViewDidTriggerDeepDragging)]) {
            [_delegate WZDraggableSwitchHeaderViewDidTriggerDeepDragging];
        }
    }
    [self setState:WZDraggableSwitchStateNormal];
}

#pragma mark - Dealloc

- (void)dealloc
{
    _delegate = nil;
    self.statusLabel = nil;
    self.backButton = nil;
    self.arrowImage = nil;
    self.normalStateText = nil;
    self.shallowStateText = nil;
    self.deepStateText = nil;
}

@end
