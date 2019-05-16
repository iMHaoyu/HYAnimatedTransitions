//
//  HYAmplificationAnimationController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/13.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYAmplificationAnimationController.h"
#import "UIViewController+HYTransitionsCategory.h"


@interface HYAmplificationAnimationController ()

@end
@implementation HYAmplificationAnimationController

#pragma mark - ⬅️⬅️⬅️⬅️ 重写父类方法 ➡️➡️➡️➡️
#pragma mark -
- (void)hy_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromVC = navVC.viewControllers.firstObject;
    }
    if ([toVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC = navVC.viewControllers.firstObject;
    }
    
    if (self.reverse) {
        //dismiss
        [self dismissAnimationWithTransitionContext:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }else {
        //present
        [self presentAnimationWithTransitionContext:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
}

#pragma mark - ⬅️⬅️⬅️⬅️ Private Methods - 私有方法 ➡️➡️➡️➡️
#pragma mark -
/** 弹出 */
- (void)presentAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //获取转换的两个imageView或view
    UIView *fromVCNeedZoomView = fromVC.hy_needScaledImageOrView;
    UIView *toVCNeedZoomView = toVC.hy_needScaledImageOrView;
    
    //判断是否实现了代理方法
    NSAssert((fromVCNeedZoomView && toVCNeedZoomView), @"该跳转模式下你必须符合传入'UIViewController+HYTransitionsCategory.h'的'hy_needScaledImageOrView'");
    
    // 获取容器
    UIView *contentView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对fromVC中的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *snapshotView = [fromVCNeedZoomView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [fromVCNeedZoomView convertRect:fromVCNeedZoomView.bounds toView:contentView];
    
    //设置动画前的各个控件的状态
    fromVCNeedZoomView.hidden = YES;
    toVCNeedZoomView.hidden = YES;
    toView.alpha = 0;
    
    //snapshotView 添加到contentView中，要保证在最上层，所以后添加
    [contentView addSubview:toView];
    [contentView addSubview:snapshotView];
    
    //动画吧
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.frame = [toVCNeedZoomView convertRect:toVCNeedZoomView.bounds toView:contentView];
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromVCNeedZoomView.hidden = NO;
            [snapshotView removeFromSuperview];
            [transitionContext completeTransition:NO];
        }else {
            [snapshotView removeFromSuperview];
            toVCNeedZoomView.hidden = NO;
            //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中断动画完成的部署，会出现无法交互之类的bug
            [transitionContext completeTransition:YES];
        }
    }];
}

/** 退出 */
- (void)dismissAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //获取转换的两个imageView或view
    UIView *fromVCNeedZoomView = fromVC.hy_needScaledImageOrView;
    UIView *toVCNeedZoomView = toVC.hy_needScaledImageOrView;
    
    // 获取容器
    UIView *contentView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对fromVC中的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *snapshotView = [fromVCNeedZoomView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [fromVCNeedZoomView convertRect:fromVCNeedZoomView.bounds toView:contentView];
    
    //设置初始状态
    fromVCNeedZoomView.hidden = YES;
    toView.alpha = 1;
    
    //tempView 添加到containerView中
    [contentView addSubview:snapshotView];
    
    //动画吧
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        snapshotView.frame = [toVCNeedZoomView convertRect:toVCNeedZoomView.bounds toView:contentView];
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        if ([transitionContext transitionWasCancelled]) {
            //手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            [snapshotView removeFromSuperview];
            fromVCNeedZoomView.hidden = NO;
            [transitionContext completeTransition:NO];
        }else{
            //手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            toVCNeedZoomView.hidden = NO;
            [snapshotView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
