//
//  WZDraggableSwitchHeaderView.h
//  WZAnimatingTransition
//
//  Created by Wongzigii on 5/21/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat WZ_ARROW_ANIMATION_DURATION;
extern const CGFloat WZ_ARROW_IMAGE_HEIGHT;
extern const CGFloat WZ_FLIP_ANIMATION_DURATION;
extern const CGFloat WZ_STATUS_LABEL_HEIGHT;

/// The state of header view will process.

/// WZDraggableSwitchStateNormal          - The normal state.
/// WZDraggableSwitchStateShallowDragging - The shallow dragging state.
/// WZDraggableSwitchStateDeepDragging    - The deep dragging state.

typedef NS_ENUM (NSInteger, WZDraggableSwitchState){
    WZDraggableSwitchStateNormal = 0,
    WZDraggableSwitchStateShallowDragging,
    WZDraggableSwitchStateDeepDragging,
};

/// Invoked by the delegate when focused state changed.
@protocol WZDraggableSwitchHeaderViewDelegate <NSObject>

@required
- (void)WZDraggableSwitchHeaderViewDidTriggerDeepDragging;

@optional
- (void)WZDraggableSwitchHeaderViewDidTriggerShallowDragging;

@end

@interface WZDraggableSwitchHeaderView : UIView

/// The y contentOffset range between normal state and shallow dragging state. If end dragging on this range, `- WZDraggableSwitchHeaderViewDidTriggerShallowDragging` will be invoked.
/// Default is 20.0f.
@property (nonatomic, assign) CGFloat normalStateHeight;

/// The total height of this header view will trace down with. End up dragging on the y contentOffset if less than `heightCanTriggerSwitch`, `- WZDraggableSwitchHeaderViewDidTriggerDeepDragging` will be invoked. properly.
/// Default is 70.0f.
@property (nonatomic, assign) CGFloat heightCanTriggerSwitch;

/// The status label shows the text of state.
@property (nonatomic, strong) UILabel *statusLabel;

/// The button can be tapped to return to menu.
@property (nonatomic, strong) UIButton *backButton;

/// The layer of arrow Image.
@property (nonatomic, strong) CALayer *arrowImage;

/// The state of this headerView.
@property (nonatomic, assign) WZDraggableSwitchState state;

/// Make sure you set the delegate properly.
@property (nonatomic, weak) NSObject <WZDraggableSwitchHeaderViewDelegate>* delegate;

/// The text will show in normal state. Default is `ABOUT`.
@property (nonatomic, strong) NSString *normalStateText;

/// The text will show on shallow dragging state. Default is `PULL TO RETURN TO MENU.`
@property (nonatomic, strong) NSString *shallowStateText;

/// The text will show on deep dragging state. Default is `RELEASE TO RETURN TO MENU.`
@property (nonatomic, strong) NSString *deepStateText;

/// This is the designated init method for this class. Always use this method to init the header view.
- (instancetype)initWithDelegate:(id<WZDraggableSwitchHeaderViewDelegate>)delegate frame:(CGRect)frame normalStateHeight:(CGFloat)normalStateHeight heightCanTriggerSwitch:(CGFloat)heightCanTriggerSwitch;

- (instancetype)initWithDelegate:(id<WZDraggableSwitchHeaderViewDelegate>)delegate frame:(CGRect)frame;

/// This method will trace down the state of header view while scrolling.
/// Note that : You need to invoke this method manually within UIScrollViewDelegate's `- scrollViewDidScroll:` method.
- (void)WZDraggableSwitchHeaderViewDidScroll:(UIScrollView *)scrollView;

/// This method will trace down the state of header view when end dragging.
/// Note that : You need to invoke this method manually within UIScrollViewDelegate's `- scrollViewDidEndDragging:willDecelerate:` method.
- (void)WZDraggableSwitchHeaderViewDidEndDragging:(UIScrollView *)scrollView;

@end
