//  侧滑动画
//  HYAnimatedTransitioning.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/10.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYPanAnimatedController.h"


@interface HYPanAnimatedController ()

@end

@implementation HYPanAnimatedController

#pragma mark - ⬅️⬅️⬅️⬅️ 重写父类方法 ➡️➡️➡️➡️
#pragma mark -
- (void)hy_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //获取到容器视图,并添加到容器
    UIView *contentView = [transitionContext containerView];
    if (fromVC.modalPresentationStyle == UIModalPresentationFullScreen) {
        //* 必须的步骤: 添加进容器视图用来表现动画
        [contentView addSubview:toView];
    }
    
    //获取控制器最终需要显示的Frame
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    //这里把初始位置设置在屏幕最右或最左侧边缘 （CGRectOffset -> 平移操作：把最终位置平移到屏幕的边缘，待会做动画用）
    CGFloat offsetWith = self.reverse ? -self.screenWidth_hy : self.screenWidth_hy;
    toView.frame = CGRectOffset(finalFrame, offsetWith, 0);
    self.reverse ? [contentView sendSubviewToBack:toView] : [contentView bringSubviewToFront:toView];
    
    //在返回的时候添加阴影
    if (self.reverse) {
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:fromView.bounds];
        fromView.layer.shadowColor = [UIColor blackColor].CGColor;
        fromView.layer.shadowOffset = CGSizeMake(-5.f, .0f);
        fromView.layer.shadowOpacity = 0.1f;
        fromView.layer.shadowRadius = 4.f;
        fromView.layer.shadowPath = shadowPath.CGPath;
    }

    //制作动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.frame = finalFrame;
        fromView.frame = CGRectOffset(fromView.frame, -offsetWith, 0);
    } completion:^(BOOL finished) {
        //* 必须的步骤: 完成动画。（这里判段手势操作是否结束）
        if (![transitionContext transitionWasCancelled]) {
            fromView.layer.shadowOpacity = 0.f;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
