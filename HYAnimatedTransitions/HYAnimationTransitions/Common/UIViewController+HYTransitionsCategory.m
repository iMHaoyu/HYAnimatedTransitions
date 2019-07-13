//
//  UIViewController+HYTransitionsCategory.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "UIViewController+HYTransitionsCategory.h"
#import "HYViewControllerTransitioningDelegate.h"
#import <objc/runtime.h>

@implementation UIViewController (HYTransitionsCategory)

#pragma mark - ⬅️⬅️⬅️⬅️ Push & Pop - 导航栏的Push和Pop ➡️➡️➡️➡️
#pragma mark -
- (void)hy_pushViewController:(UIViewController *)viewController
                animationType:(HYTransitionsAnimationType)animationType {
    [self hy_pushViewController:viewController
         userInteractionEnabled:YES
                  animationType:animationType
         presentTransitionsView:nil];
    
}
- (void)hy_pushViewController:(UIViewController *)viewController
       userInteractionEnabled:(BOOL)userInteractionEnabled
                animationType:(HYTransitionsAnimationType)animationType {
    [self hy_pushViewController:viewController
         userInteractionEnabled:userInteractionEnabled
                  animationType:animationType
         presentTransitionsView:nil];
    
}
- (void)hy_pushViewController:(UIViewController *)viewController
       userInteractionEnabled:(BOOL)userInteractionEnabled
                animationType:(HYTransitionsAnimationType)animationType
       presentTransitionsView:(HYPresentTransitionsView (^ _Nullable )(void))presentTransitionsView {
    
    //导航栏跳转代理
    id<UINavigationControllerDelegate> delegate = [HYViewControllerTransitioningDelegate hy_navigationControllerTransitioningManagerWithAnimationType:animationType];
    if (self.navigationController.delegate != delegate) {
        self.navigationController.delegate = delegate;
    }
    //手势交互，这里基本上是退出时的手势交互,设置任何一个跳转的'userInteractionEnabled'都会会影响到整个导航栏是否会支持手势操作
    self.navigationController.hy_needGestureInteraction = userInteractionEnabled;
    [self.navigationController pushViewController:viewController animated:YES];
    
    //在图片缩放跳转的情况下才需要传入，其他情况不需要。
    if ((animationType == HYTransitionsAnimationAmplificationType) && presentTransitionsView) {
        
        UIView *fromView = presentTransitionsView().fromeView;
        UIView *toView = presentTransitionsView().toView;
        NSAssert((fromView && toView), @"在该模式（图片缩放的模式）下进行跳转，fromView和toView不能为空。请查看你传入的两个值是否为空");
        
        [self setupNeedScaledImageOrView:fromView viewController:self];
        [self setupNeedScaledImageOrView:toView viewController:viewController];
    }
}

#pragma mark - ⬅️⬅️⬅️⬅️ Present & Dismiss - 模态弹出和退出操作 ➡️➡️➡️➡️
#pragma mark -
- (void)hy_presentViewController:(UIViewController *)viewController
                   animationType:(HYTransitionsAnimationType)animationType {
    [self hy_presentViewController:viewController
            userInteractionEnabled:YES
                     animationType:animationType
            presentTransitionsView:nil];
    
}
- (void)hy_presentViewController:(UIViewController *)viewController
          userInteractionEnabled:(BOOL)userInteractionEnabled
                   animationType:(HYTransitionsAnimationType)animationType {
    [self hy_presentViewController:viewController
            userInteractionEnabled:userInteractionEnabled
                     animationType:animationType
            presentTransitionsView:nil];
    
}

/** 显示菜单控制器 */
- (void)hy_presentMenuViewController:(UIViewController *)viewController fromLeft:(BOOL)formLeft menuSize:(CGSize)menuSize {
    
    if (CGSizeEqualToSize(menuSize, CGSizeZero)) {
        viewController.hy_menuSize = CGSizeMake(200, self.view.frame.size.height);
    }else {
        viewController.hy_menuSize = menuSize;
    }
    
    [self hy_presentViewController:viewController
            userInteractionEnabled:NO
                     animationType:formLeft?HYTransitionsAnimationLeftDrawerType:HYTransitionsAnimationRightDrawerType
            presentTransitionsView:nil];
}

- (void)hy_presentViewController:(UIViewController *)viewController
          userInteractionEnabled:(BOOL)userInteractionEnabled
                   animationType:(HYTransitionsAnimationType)animationType
          presentTransitionsView:(HYPresentTransitionsView (^ _Nullable )(void))presentTransitionsView {
    
    //模态跳转代理
    viewController.transitioningDelegate = [HYViewControllerTransitioningDelegate hy_viewControllerTransitioningManagerWithAnimationType:animationType];
    //手势交互，这里基本上是退出时的手势交互
    viewController.hy_needGestureInteraction = userInteractionEnabled;
    [self presentViewController:viewController animated:YES completion:nil];
    
    //在图片缩放跳转的情况下才需要传入，其他情况不需要。
    if ((animationType == HYTransitionsAnimationAmplificationType) && presentTransitionsView) {
        
        UIView *fromView = presentTransitionsView().fromeView;
        UIView *toView = presentTransitionsView().toView;
        NSAssert((fromView && toView), @"在该模式（图片缩放的模式）下进行跳转，fromView和toView不能为空。请查看你传入的两个值是否为空");
        
        [self setupNeedScaledImageOrView:fromView viewController:self];
        [self setupNeedScaledImageOrView:toView viewController:viewController];
    }
}

- (void)hy_dismissViewControllerAnimated:(BOOL)animated {
    [self dismissViewControllerAnimated:animated completion:nil];
}

#pragma mark - ⬅️⬅️⬅️⬅️ Private Methods - 私有方法 ➡️➡️➡️➡️
#pragma mark -
/** 关联对象 图片缩放跳转对应的图片，在图片缩放跳转的情况下 */
- (void)setupNeedScaledImageOrView:(UIView *)view viewController:(UIViewController *)viewController {
    objc_setAssociatedObject(viewController, @selector(hy_needScaledImageOrView), view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
/** 在控制器跳转的时候是否需要手势交互 */
- (BOOL)hy_needGestureInteraction {
    NSNumber *need = objc_getAssociatedObject(self, @selector(hy_needGestureInteraction));
    return [need boolValue];
}
- (void)hy_setNeedGestureInteraction:(BOOL)hy_needGestureInteraction {
    objc_setAssociatedObject(self, @selector(hy_needGestureInteraction), @(hy_needGestureInteraction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 跳转的时候需要缩放的图片。FromVC和ToVC都要实现 */
- (UIView *)hy_needScaledImageOrView {
    return objc_getAssociatedObject(self, @selector(hy_needScaledImageOrView));
}

/** 设置显示菜单控制器的尺寸,默认:宽度200，上下间距0 */
- (CGSize)hy_menuSize {
    NSString *sizeSetString = objc_getAssociatedObject(self, @selector(hy_menuSize));
    CGSize size = CGSizeFromString(sizeSetString);
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(200, self.view.frame.size.height);
    }
    return size;
}
- (void)hy_setMenuSize:(CGSize)hy_menuSize {
    NSString *sizeSetString = NSStringFromCGSize(hy_menuSize);
    objc_setAssociatedObject(self, @selector(hy_menuSize), sizeSetString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

