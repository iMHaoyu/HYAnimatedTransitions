//
//  HYViewControllerTransitioningDelegate.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/10.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTransitionsHeader.h"

NS_ASSUME_NONNULL_BEGIN

@class HYHorizontalSwipeInteractiveTransition,HYVerticalSwipeInteractionController;
@interface HYViewControllerTransitioningDelegate : NSObject <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

/** 实例 animationType：过渡的动画类型 */
+ (id<UINavigationControllerDelegate>)hy_navigationControllerTransitioningManagerWithAnimationType:(HYTransitionsAnimationType)animationType;
+ (id<UIViewControllerTransitioningDelegate>)hy_viewControllerTransitioningManagerWithAnimationType:(HYTransitionsAnimationType)animationType;

@end

NS_ASSUME_NONNULL_END
