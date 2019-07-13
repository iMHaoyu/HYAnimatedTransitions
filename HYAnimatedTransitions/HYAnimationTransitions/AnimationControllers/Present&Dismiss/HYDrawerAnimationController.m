//
//  HYDrawerAnimationController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/7/13.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYDrawerAnimationController.h"

@interface HYDrawerAnimationController ()

/** 原始位置，这里只区分是在左边还是右边。NO:左边，YES:右边，默认左边 */
@property (nonatomic, assign) BOOL originalLocation;
/** 设置toView显示的尺寸 */
@property (nonatomic, assign) CGSize toViewSize;

@end
@implementation HYDrawerAnimationController
#pragma mark - ⬅️⬅️⬅️⬅️ 构造函数 ➡️➡️➡️➡️
#pragma mark -
- (instancetype)initWithReverse:(BOOL)reverse {
    return [self initWithReverse:reverse originalLocation:NO toViewSize:CGSizeMake(100, 50)];
}
- (instancetype)initWithReverse:(BOOL)reverse originalLocation:(BOOL)originalLocation toViewSize:(CGSize)size {
    self = [super initWithReverse:reverse];
    if (self) {
        self.originalLocation = originalLocation;
        self.toViewSize = size;
    }
    return self;
}

#pragma mark - ⬅️⬅️⬅️⬅️ 重写父类方法 ➡️➡️➡️➡️
#pragma mark -
- (void)hy_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    if (self.reverse) {
        //dismiss
        [self dismissAnimationWithTransitionContext:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }else {
        //present
        [self presentAnimationWithTransitionContext:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
}


#pragma mark - ⬅️⬅️⬅️⬅️ Private Methods ➡️➡️➡️➡️
#pragma mark -
/** 弹出 */
- (void)presentAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //截图 获取跳转过来的页面截图用来做动画
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:NO];
    [snapshotView addTapGestureWithClickedCompleteBlock:^{
        [fromVC dismissViewControllerAnimated:YES completion:nil];
    }];
    
    //蒙版
    UIView *maskView = [[UIView alloc]initWithFrame:snapshotView.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    maskView.userInteractionEnabled = NO;
    [snapshotView addSubview:maskView];
    
    //隐藏fromVC，对截图进行操作就可以了
    fromView.hidden = YES;
    
    //获取容器视图
    UIView *contentView = [transitionContext containerView];
    //加入需要进行转换的两个视图
    [contentView addSubview:snapshotView];
    [contentView addSubview:toView];
    
    //设置toView最终显示的位置，因为这里ToVC present出来不是全屏，设置初始的时候可能在左边或者右边，如果不设置frame的话默认就是整个屏幕咯，这里containerView的frame就是整个屏幕
    CGRect finalRect = [transitionContext finalFrameForViewController:toVC];
    //顶部偏移量和左边偏移量
    CGFloat width = self.toViewSize.width;
    CGFloat height = self.toViewSize.height;
    CGFloat ySpace = (finalRect.size.height-self.toViewSize.height)*0.5;
    CGFloat xSpace = self.originalLocation ? (finalRect.size.width-self.toViewSize.width) : 0;
    finalRect = CGRectMake(xSpace, ySpace, width, height);
    
    //设置toView的初始位置
    toView.frame = CGRectOffset(finalRect, self.originalLocation ? (self.screenWidth_hy+width) : (-width), 0);
    toView.layer.cornerRadius = 4;
    toView.layer.masksToBounds = YES;
    
    //开始动画
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.85 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        
        toView.frame = finalRect;
        //然后让截图视图缩小一点即可
        //        snapshotView.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
        //        snapshotView.layer.cornerRadius = 8;
        //改变状态栏颜色
    } completion:^(BOOL finished) {
        
        //转场失败后的处理
        if ([transitionContext transitionWasCancelled]) {
            //失败后，我们要把FromeVC显示出来
            fromView.hidden = NO;
            //然后移除截图视图，因为下次触发present会重新截图
            [snapshotView removeFromSuperview];
        }
        
        //使用如下代码标记整个转场过程是否正常完成[transitionContext transitionWasCancelled]代表手势是否取消了，如果取消了就传NO表示转场失败，反之亦然，如果不用手势present的话直接传YES也是可以的，但是无论如何我们都必须标记转场的状态，系统才知道处理转场后的操作，否者认为你一直还在转场中，会出现无法交互的情况，切记！
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

/** 退出 */
- (void)dismissAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //注意在dismiss的时候之前的fromVC 和 toVC 会变为相反
    //参照present动画的逻辑，present成功后，containerView的最后一个子视图就是截图视图，我们将其取出准备动画
    UIView *contentView = [transitionContext containerView];
    UIView *snapshotView = contentView.subviews.firstObject;
    UIView *maskView = snapshotView.subviews.firstObject;
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
//    CGFloat ySpace = self.toViewOffset.y;
    CGFloat width = fromView.frame.size.width;
    CGRect fromeViewEndRect =  CGRectOffset(fromView.frame, self.originalLocation?self.screenWidth_hy+width:-width, 0);
    
    //动画吧
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
        toView.frame = finalFrame;
//        snapshotView.transform = CGAffineTransformIdentity;
//        snapshotView.layer.cornerRadius = 0;
//        fromView.frame = CGRectOffset(fromView.frame, 0, self.screenHeight_hy);
        fromView.frame = fromeViewEndRect;
        maskView.alpha = 0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了标记失败
            [transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [snapshotView removeFromSuperview];
            toView.hidden = NO;
            [transitionContext completeTransition:YES];
        }
    }];
}

@end
