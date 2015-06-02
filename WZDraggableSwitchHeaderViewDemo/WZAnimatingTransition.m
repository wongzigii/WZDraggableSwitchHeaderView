//
//  WZAnimatingTransition.m
//  WZDraggableSwitchHeaderViewDemo
//
//  Created by Wongzigii on 6/2/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import "WZAnimatingTransition.h"
#import "WZAnimatingTransitionCell.h"

@implementation WZAnimatingTransition

+ (CATransition *)backwardTransition {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.fillMode = kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromBottom;
    return transition;
}

+ (CATransition *)forwardTransition
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.timingFunction = UIViewAnimationCurveEaseInOut;
    transition.fillMode = kCAFillModeForwards;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    return transition;
}

@end
