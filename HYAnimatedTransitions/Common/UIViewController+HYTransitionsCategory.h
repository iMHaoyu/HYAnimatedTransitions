//
//  UIViewController+HYTransitionsCategory.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTransitionsHeader.h"

NS_ASSUME_NONNULL_BEGIN

/** 页面跳转需要缩放的两个view，转换的fromeView和toView */
struct HYPresentTransitionsView {
    UIView * _Nonnull fromeView;
    UIView * _Nonnull toView;
};
typedef struct HYPresentTransitionsView HYPresentTransitionsView;
CG_INLINE HYPresentTransitionsView HYPresentTransitionsViewMake( UIView *fromeView, UIView *toView) {
    HYPresentTransitionsView presentTransitionsView;
    presentTransitionsView.fromeView = fromeView;
    presentTransitionsView.toView = toView;
    return presentTransitionsView;
}

@interface UIViewController (HYTransitionsCategory)

/** 在控制器跳转的时候是否需要手势交互 */
@property (nonatomic, assign, setter=hy_setNeedGestureInteraction:) BOOL hy_needGestureInteraction;
/** 跳转的时候需要缩放的图片 */
@property (nonatomic, strong, readonly) UIView *hy_needScaledImageOrView;

#pragma mark - 导航栏的跳转
/**
 导航栏跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转，且支持手势返回

 @param viewController          需要跳转到的视图控制器
 @param animationType           跳转动画
 */
- (void)hy_pushViewController:(UIViewController *)viewController
                animationType:(HYTransitionsAnimationType)animationType;


/**
 导航栏跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转

 @attention 设置任何一个跳转的'userInteractionEnabled'都会会影响到整个导航栏是否会支持手势操作
 
 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回 - 任何一个控制器设置后，会影响到整个导航栏是否会支持手势操作
 @param animationType           跳转动画
 */
- (void)hy_pushViewController:(UIViewController *)viewController
       userInteractionEnabled:(BOOL)userInteractionEnabled
                animationType:(HYTransitionsAnimationType)animationType;


/**
 导航栏跳转
 
 @attention 设置任何一个跳转的'userInteractionEnabled'都会会影响到整个导航栏是否会支持手势操作

 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回 - 任何一个控制器设置后，都会影响到整个导航栏是否会支持手势操作
 @param animationType           跳转动画
 @param presentTransitionsView  在HYTransitionsAnimationAmplificationType类型跳转的情况下才需要传入，其他情况不需要。
 */
- (void)hy_pushViewController:(UIViewController *)viewController
       userInteractionEnabled:(BOOL)userInteractionEnabled
                animationType:(HYTransitionsAnimationType)animationType
       presentTransitionsView:(HYPresentTransitionsView (^ _Nullable )(void))presentTransitionsView;





#pragma mark - 模态跳转
/**
 模态跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转，且支持手势返回

 @param viewController          需要跳转到的视图控制器
 @param animationType           跳转动画
 */
- (void)hy_presentViewController:(UIViewController *)viewController
                   animationType:(HYTransitionsAnimationType)animationType;

/**
 模态跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转

 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回
 @param animationType           跳转动画
 */
- (void)hy_presentViewController:(UIViewController *)viewController
          userInteractionEnabled:(BOOL)userInteractionEnabled
                   animationType:(HYTransitionsAnimationType)animationType;

/**
 模态跳转

 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回
 @param animationType           跳转动画
 @param presentTransitionsView  在HYTransitionsAnimationAmplificationType类型跳转的情况下才需要传入，其他情况不需要。
 */
- (void)hy_presentViewController:(UIViewController *)viewController
          userInteractionEnabled:(BOOL)userInteractionEnabled
                   animationType:(HYTransitionsAnimationType)animationType
          presentTransitionsView:(HYPresentTransitionsView (^ _Nullable )(void))presentTransitionsView;

@end

@interface UINavigationController (ssss)
/** 在控制器跳转的时候是否需要手势交互 */
@property (nonatomic, assign, setter=hy_setNeedGestureInteraction:) BOOL hy_needGestureInteraction;
@end

NS_ASSUME_NONNULL_END
