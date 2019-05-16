//  背景缩小动画
//  HYBackScaleAnimationController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBackNarrowAnimationController.h"
#import <objc/runtime.h>


#pragma mark - ⬅️⬅️⬅️⬅️ Category ➡️➡️➡️➡️
#pragma mark -
/** 添加view的点击事件 */
@interface UIView (HYViewAddClickEvent)

@property (nonatomic, strong) void (^clickedCompleteBlock)(void);

- (void)addTapGestureWithClickedCompleteBlock:(void(^)(void))clickedComplete;

@end

@implementation UIView (HYViewAddClickEvent)

/** 添加f点击事件并回调点击事件 */
- (void)addTapGestureWithClickedCompleteBlock:(void(^)(void))clickedComplete {
    //回调的点击事件
    self.clickedCompleteBlock = clickedComplete;
    
    //先判断当前是否有交互事件
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesturRecognizer];
    }
}
- (void)tapAction:(id)tap {
    if (self.clickedCompleteBlock) {
        self.clickedCompleteBlock();
    }
}

#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
/** 点击事件 block */
- (void(^)(void))clickedCompleteBlock {
    return objc_getAssociatedObject(self, @selector(clickedCompleteBlock));
}
- (void)setClickedCompleteBlock:(void (^)(void))clickedCompleteBlock {
    objc_setAssociatedObject(self, @selector(clickedCompleteBlock), clickedCompleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end





@interface HYBackNarrowAnimationController ()

/** 加载的控制器距离顶部的位置 */
@property (nonatomic, assign) CGFloat height_hy;

@end

@implementation HYBackNarrowAnimationController
#pragma mark - ⬅️⬅️⬅️⬅️ 构造函数 ➡️➡️➡️➡️
#pragma mark -
- (instancetype)initWithReverse:(BOOL)reverse {
    return [self initWithReverse:reverse height:HYDefaultHeight];
}
- (instancetype)initWithReverse:(BOOL)reverse height:(CGFloat)height {
    self = [super initWithReverse:reverse];
    if (self) {
        self.height_hy = height;
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

#pragma mark - ⬅️⬅️⬅️⬅️ Private Methods - 私有方法 ➡️➡️➡️➡️
#pragma mark -
/** 弹出 */
- (void)presentAnimationWithTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    //snapshotViewAfterScreenUpdates可以对某个视图截图，我们采用对这个截图做动画代替直接对FromVC做动画，因为在手势过渡中直接使用FromeVC动画会和手势有冲突， 如果不需要实现手势的话，就可以不是用截图视图了，大家可以自行尝试一下
    UIView *snapshotView = [fromView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame   = fromView.frame;
    snapshotView.layer.masksToBounds = YES;
    [snapshotView addTapGestureWithClickedCompleteBlock:^{
        [fromVC dismissViewControllerAnimated:YES completion:nil];
    }];
    //因为对截图做动画，FromeVC就可以隐藏了
    fromView.hidden = YES;
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //将截图视图和ToVC的view都加入ContainerView中
    [containerView addSubview:snapshotView];
    [containerView addSubview:toView];
    
    //设置ToVC的frame，因为这里ToVC present出来不是全屏，且初始的时候在底部，如果不设置frame的话默认就是整个屏幕咯，这里containerView的frame就是整个屏幕
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    finalFrame = CGRectMake(finalFrame.origin.x, finalFrame.origin.y+self.height_hy, finalFrame.size.width, finalFrame.size.height-self.height_hy);
    toView.frame = CGRectOffset(finalFrame, 0, self.screenHeight_hy);
    toView.layer.cornerRadius = 8;
    toView.layer.masksToBounds = YES;
    
    CGFloat stateBarH = HY_DEVICE_IS_IPHONE_X?44:20;
    CGFloat scaleValue = 1-(stateBarH*2/self.screenHeight_hy);
    
    
    //开始动画吧，使用产生弹簧效果的动画API
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.85 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        
        toView.frame = finalFrame;
        //然后让截图视图缩小一点即可
        snapshotView.transform = CGAffineTransformMakeScale(scaleValue, scaleValue);
        snapshotView.layer.cornerRadius = 8;
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
    UIView *snapshotView = contentView.subviews[0];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    //动画吧
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        //因为present的时候都是使用的transform，这里的动画只需要将transform恢复就可以了
        toView.frame = finalFrame;
        snapshotView.transform = CGAffineTransformIdentity;
        snapshotView.layer.cornerRadius = 0;
        fromView.frame = CGRectOffset(fromView.frame, 0, self.screenHeight_hy);
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

