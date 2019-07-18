//  垂直滑动手势
//  HYVerticalSwipeInteractionController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYVerticalSwipeInteractionController.h"
#import <objc/runtime.h>

/** 垂直滑动手势方法对应的Key */
static  NSString *const kHYVerticalSwipeGestureKey = @"kHYVerticalSwipeGestureKey";
@interface HYVerticalSwipeInteractionController ()

///** 交互完成 */
//@property (nonatomic, assign) BOOL shouldComplete;
/** 跳转到的控制器 */
@property (nonatomic, strong) UIViewController *presentedVC;

@end

@implementation HYVerticalSwipeInteractionController

- (void)hy_wireToViewController:(UIViewController *)viewController {
    self.presentedVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

/** 添加滑动手势 */
- (void)prepareGestureRecognizerInView:(UIView*)view {
    //判断是否添加过手势，添加过手势的需要移除并添加新的手势
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(view, &kHYVerticalSwipeGestureKey);
    if (gesture) {
        [view removeGestureRecognizer:gesture];
    }
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleVerticalSwipeGesture:)];
    [view addGestureRecognizer:gesture];
    
    //保存本次添加的手势，用来判断手势是否
    objc_setAssociatedObject(view, &kHYVerticalSwipeGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/** 手势处理 */
- (void)handleVerticalSwipeGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    //获取手指在屏幕上滑动的百分比
    CGPoint translation = [gestureRecognizer translationInView:self.presentedVC.view];
    CGFloat percent = translation.y /  [[UIScreen mainScreen]bounds].size.height;
    if (percent < 0) {
        [self cancelInteractiveTransition];
        return;
    }
    
    percent = fabs(percent);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            //1.标记交互标志。 在委托中提供时使用。
            self.interactionInProgress = YES;
            //根据presentingViewController判断是Push还是Present
            if (self.presentedVC.presentingViewController) {
                [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
            }else {
                [self.presentedVC.navigationController popViewControllerAnimated:YES];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:  {
            self.interactionInProgress = YES;
            [self updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (self.interactionInProgress) {
                //3.手势交互结束。检查转换是否应该发生
                self.interactionInProgress = NO;
                //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
                if (percent > 0.5 && gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

@end
