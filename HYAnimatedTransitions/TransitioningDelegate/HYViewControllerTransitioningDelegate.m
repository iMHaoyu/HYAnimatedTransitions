//
//  HYViewControllerTransitioningDelegate.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/10.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYViewControllerTransitioningDelegate.h"
#import "UIViewController+HYTransitionsCategory.h"
/** 过渡动画 */
#import "HYPanAnimatedController.h"
#import "HYBackNarrowAnimationController.h"
#import "HYAmplificationAnimationController.h"

#import "HYBackAnimationController.h"

/** 手势交互方式 */
#import "HYHorizontalSwipeInteractiveTransition.h"
#import "HYVerticalSwipeInteractionController.h"


typedef NS_ENUM(NSInteger,HYTransitionsInteractiveType) {
    HYTransitionsInteractiveHorizontalSwipeType,//水平滑动手势交互
    HYTransitionsInteractiveVerticalSwipeType,//垂直滑动手势交互
};


@interface HYViewControllerTransitioningDelegate ()

/** 是否需要手势交互 */
@property (nonatomic, assign) BOOL needGestureInteraction;
/** 水平滑动手势 */
@property (nonatomic, strong) HYHorizontalSwipeInteractiveTransition *horizontalSwipeInteractive;
/** 垂直滑动手势 */
@property (nonatomic, strong) HYVerticalSwipeInteractionController *verticalSwipeInteraction;

/** 视图控制器跳转的动画类型 */
@property (nonatomic, assign) HYTransitionsAnimationType transitionsAnimationType;
/** 视图控制器跳转的手势交互类型 */
@property (nonatomic, assign) HYTransitionsInteractiveType transitionsInteractiveType;

@end

@implementation HYViewControllerTransitioningDelegate



#pragma mark - ⬅️⬅️⬅️⬅️ LifeCycle ➡️➡️➡️➡️
#pragma mark -
+ (instancetype)hy_transitioningManagerWithAnimationType:(HYTransitionsAnimationType)animationType {
    static dispatch_once_t onceToken;
    static HYViewControllerTransitioningDelegate *instance;
    dispatch_once(&onceToken, ^{
        instance = [[HYViewControllerTransitioningDelegate alloc] initWithAnimationType:animationType];
    });
    instance.transitionsAnimationType = animationType;
    return instance;
}
- (instancetype)initWithAnimationType:(HYTransitionsAnimationType)animationType {
    self = [super init];
    if (self) {
        self.transitionsAnimationType = animationType;
    }
    return self;
}

/** 实例 animationType：过渡的动画类型 */
+ (id<UINavigationControllerDelegate>)hy_navigationControllerTransitioningManagerWithAnimationType:(HYTransitionsAnimationType)animationType {
    return [self hy_transitioningManagerWithAnimationType:animationType];
}
+ (id<UIViewControllerTransitioningDelegate>)hy_viewControllerTransitioningManagerWithAnimationType:(HYTransitionsAnimationType)animationType {
    return [self hy_transitioningManagerWithAnimationType:animationType];
}



#pragma mark - ⬅️⬅️⬅️⬅️ UINavigationControllerDelegate - 导航栏转场过渡代理 ➡️➡️➡️➡️
#pragma mark -
/** 设置当执行 侧滑返回时 的转场动画效果 */
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {

    //是否需要手势交互,因为push和pop都会触发该方法m，所以只在push的时候做判断(这里注意，push和pop的时候fromVC和ToVC会置换)
    if (operation == UINavigationControllerOperationPush) {
        BOOL needGestureInteraction = toVC.hy_needGestureInteraction;
        self.needGestureInteraction = needGestureInteraction;
        if (needGestureInteraction) {
            if (self.transitionsInteractiveType == HYTransitionsInteractiveHorizontalSwipeType) {
                //水平滑动手势交互
                [self.horizontalSwipeInteractive hy_wireToViewController:toVC];
            }else {
                //垂直滑动手势交互
                [self.verticalSwipeInteraction hy_wireToViewController:toVC];
            }
        }
    }
    
    BOOL reverse = (operation == UINavigationControllerOperationPush) ? NO : YES;
    return [self animationControllerWithReverse:reverse isPush:YES];
}
/** 设置当执行 push／pop 方法时转场的动画效果的 */
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    
    //判断是否需要手势交互
    if (self.needGestureInteraction) {
        if (self.transitionsInteractiveType == HYTransitionsInteractiveHorizontalSwipeType) {
            //水平滑动手势交互
            return (self.horizontalSwipeInteractive.interactionInProgress) ? self.horizontalSwipeInteractive : nil;
        }else {
            //垂直滑动手势交互
            return (self.verticalSwipeInteraction.interactionInProgress) ? self.verticalSwipeInteraction : nil;
        }
    }else {
        return nil;
    }
}



#pragma mark - ⬅️⬅️⬅️⬅️ UIViewControllerTransitioningDelegate - 模态转场过渡代理 ➡️➡️➡️➡️
#pragma mark -
/** 设置当执行Present方法时 进行的转场动画  */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    
    //是否需要手势交互
    BOOL needGestureInteraction = presented.hy_needGestureInteraction;
    self.needGestureInteraction = needGestureInteraction;
    if (needGestureInteraction) {
        if (self.transitionsInteractiveType == HYTransitionsInteractiveHorizontalSwipeType) {
            //水平滑动手势交互
            [self.horizontalSwipeInteractive hy_wireToViewController:presented];
        }else {
            //垂直滑动手势交互
            [self.verticalSwipeInteraction hy_wireToViewController:presented];
        }
    }
    
    return [self animationControllerWithReverse:NO isPush:NO];
}
/** 设置当执行Dismiss方法时 进行的转场动画 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return [self animationControllerWithReverse:YES isPush:NO];
}

/** 设置当执行Present方法时 进行可交互的转场动画 */
//- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;

/** 设置当执行Dismiss方法时 进行可交互的转场动画 */
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    //判断是否需要手势交互
    if (self.needGestureInteraction) {
        if (self.transitionsInteractiveType == HYTransitionsInteractiveHorizontalSwipeType) {
            //水平滑动手势交互
            return (self.horizontalSwipeInteractive.interactionInProgress) ? self.horizontalSwipeInteractive : nil;
        }else {
            //垂直滑动手势交互
            return (self.verticalSwipeInteraction.interactionInProgress) ? self.verticalSwipeInteraction : nil;
        }
    }else {
        return nil;
    }
}

//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0);



#pragma mark - ⬅️⬅️⬅️⬅️  Private️ Methods - 私有方法 ➡️➡️➡️
#pragma mark -
/** 返回对用类型的动画类 */
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerWithReverse:(BOOL)reverse isPush:(BOOL)isPush {
    //判断动画类型
    HYBaseAnimationController *animation = nil;
    switch (self.transitionsAnimationType) {
        case HYTransitionsAnimationPanType://水平滑动类型
            if (isPush)
                animation = [[HYBackAnimationController alloc] initWithReverse:reverse];
            else
                animation = [[HYPanAnimatedController alloc] initWithReverse:reverse];
            
            
            break;
            
        case HYTransitionsAnimationBackNarrowType://背景抽屉类型
            animation = [[HYBackNarrowAnimationController alloc] initWithReverse:reverse];
            break;
            
        case HYTransitionsAnimationAmplificationType://图片缩放类型
            animation = [[HYAmplificationAnimationController alloc] initWithReverse:reverse];
            break;
            
        default:
            break;
    }
    return animation;
}



#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
/** 水平滑动手势 */
- (HYHorizontalSwipeInteractiveTransition *)horizontalSwipeInteractive {
    if (!_horizontalSwipeInteractive) {
        _horizontalSwipeInteractive = [[HYHorizontalSwipeInteractiveTransition alloc]init];
    }
    return _horizontalSwipeInteractive;
}
/** 垂直滑动手势 */
- (HYVerticalSwipeInteractionController *)verticalSwipeInteraction {
    if (!_verticalSwipeInteraction) {
        _verticalSwipeInteraction = [[HYVerticalSwipeInteractionController alloc]init];
    }
    return _verticalSwipeInteraction;
}
/** 视图控制器跳转的动画类型 */
- (void)setTransitionsAnimationType:(HYTransitionsAnimationType)transitionsAnimationType {
    _transitionsAnimationType = transitionsAnimationType;
    
    switch (transitionsAnimationType) {
        case HYTransitionsAnimationBackNarrowType://背景抽屉类型
            self.transitionsInteractiveType = HYTransitionsInteractiveVerticalSwipeType;
            break;
            
        case HYTransitionsAnimationAmplificationType://图片缩放类型
            self.transitionsInteractiveType = HYTransitionsInteractiveVerticalSwipeType;
            break;
            
        default:
            self.transitionsInteractiveType = HYTransitionsInteractiveHorizontalSwipeType;
            break;
    }
}

@end
