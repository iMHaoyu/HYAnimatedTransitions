//
//  HYBaseAnimationController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBaseAnimationController.h"

@implementation HYBaseAnimationController

#pragma mark - ⬅️⬅️⬅️⬅️ 构造函数 ➡️➡️➡️➡️
#pragma mark -
- (instancetype)init {
    return [self initWithReverse:NO];
}
- (instancetype)initWithReverse:(BOOL)reverse {
    self = [super init];
    if (self) {
        self.duration = 0.5f;
        self.reverse = reverse;
    }
    return self;
}

#pragma mark - ⬅️⬅️⬅️⬅️ Public Methods - 公共方法 ➡️➡️➡️➡️
#pragma mark -
/** 具体的动画实现 */
- (void)hy_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
}


#pragma mark - ⬅️⬅️⬅️⬅️ UIViewControllerAnimatedTransitioning - 模态转场动画过渡代理  ➡️➡️➡️➡️
#pragma mark -
/** 设置动画执行的时长 */
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

/** 处理具体的动画 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//        UIView *fromView = fromVC.view;
//        UIView *toView = toVC.view;
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    [self hy_animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
}


#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
/** 屏幕宽度 */
- (CGFloat)screenWidth_hy {
    return [UIScreen mainScreen].bounds.size.width;
}
/** 屏幕高度 */
- (CGFloat)screenHeight_hy {
    return [UIScreen mainScreen].bounds.size.height;
}


@end
