//
//  HYBaseAnimationController.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 判断是否为刘海屏系列 - 这样写消除了在一些Xcode上的警告 (注意这是代码块的写法)
#define HY_DEVICE_IS_IPHONE_X \
({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);\
})

@interface HYBaseAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/** 屏幕宽度 */
@property (nonatomic, assign, readonly) CGFloat screenWidth_hy;
/** 屏幕高度 */
@property (nonatomic, assign, readonly) CGFloat screenHeight_hy;

/** 是否反向，区分弹出(NO)和退出(YES) */
@property (nonatomic, assign) BOOL reverse;
/** 动画的持续时间。 默认：0.5s */
@property (nonatomic, assign) NSTimeInterval duration;


/** 初始化方法 */
- (instancetype)initWithReverse:(BOOL)reverse;

/** 具体的动画实现
 *  @param transitionContext  转场动画的上下文，定义了转场时需要的元素，比如在转场过程中所参与的视图控制器和视图的相关属性
 *  @param fromVC 需要要跳转到下一个的控制器 : A->B  => A (A跳转到B,该对象表示A)
 *  @param toVC 最终需要跳转到的控制器 : A->B  => B (A跳转到B,该对象表示B)
 */
- (void)hy_animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;

@end

NS_ASSUME_NONNULL_END
