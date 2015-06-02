//
//  WZAnimatingTransition.h
//  WZDraggableSwitchHeaderViewDemo
//
//  Created by Wongzigii on 6/2/15.
//  Copyright (c) 2015 Wongzigii. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface WZAnimatingTransition : NSObject
+ (CATransition *)forwardTransition;

+ (CATransition *)backwardTransition;

@end
