//
//  HYBackAnimationController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/15.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBackAnimationController.h"
#import "UIViewController+HYTransitionsCategory.h"

@implementation HYBackAnimationController

#pragma mark - ⬅️⬅️⬅️⬅️ 重写父类方法 ➡️➡️➡️➡️
#pragma mark -
- (void)hy_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    if (self.reverse) {
        //退出
        
        UIView *contentView = [transitionContext containerView];
        [contentView addSubview:toView];
        [contentView bringSubviewToFront:fromView];
    
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:fromView.bounds];
        fromView.layer.shadowColor = [UIColor blackColor].CGColor;
        fromView.layer.shadowOffset = CGSizeMake(-5.f, .0f);
        fromView.layer.shadowOpacity = 0.1f;
        fromView.layer.shadowRadius = 4.f;
        fromView.layer.shadowPath = shadowPath.CGPath;
        
        toView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        CGRect fromViewFrame = fromView.frame;
        [UIView animateWithDuration:0.3 animations:^{
            fromView.frame = CGRectOffset(fromViewFrame, self.screenWidth_hy, 0);
            toView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            if (transitionContext.transitionWasCancelled) {
                fromView.frame = fromViewFrame;
            }
            toView.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }else {
        //推出
        
        UIView *contentView = [transitionContext containerView];
        [contentView addSubview:toView];
        
        CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
        toView.frame = CGRectOffset(finalFrame, self.screenWidth_hy, 0);
        [UIView animateWithDuration:0.3 animations:^{
            toView.frame = finalFrame;
            fromView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            fromView.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    }
}
@end
