//  水平滑动手势
//  HYHorizontalSwipeInteractiveTransition.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2018/10/10.
//  Copyright © 2018 徐浩宇. All rights reserved.
//

#import "HYHorizontalSwipeInteractiveTransition.h"
#import <objc/runtime.h>

/** 水平滑动手势方法对应的Key */
static  NSString *const kHYHorizontalSwipeGestureKey = @"kHYHorizontalSwipeGestureKey";

@interface HYHorizontalSwipeInteractiveTransition()

/** 跳转到的控制器 */
@property (nonatomic, strong) UIViewController *presentedVC;

@end

@implementation HYHorizontalSwipeInteractiveTransition

- (void)hy_wireToViewController:(UIViewController*)viewController {
    self.presentedVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

/** 添加滑动手势 */
- (void)prepareGestureRecognizerInView:(UIView*)view {
    //判断是否添加过手势，添加过手势的需要移除并添加新的手势
    UIScreenEdgePanGestureRecognizer *gesture = objc_getAssociatedObject(view, &kHYHorizontalSwipeGestureKey);
    if (gesture) {
        [view removeGestureRecognizer:gesture];
    }
    gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:gesture];
    
    //保存本次添加的手势，用来判断手势是否
    objc_setAssociatedObject(view, &kHYHorizontalSwipeGestureKey, gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

/** 手势处理 */
- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.presentedVC.view];
    CGFloat percent = translatedPoint.x /  [[UIScreen mainScreen]bounds].size.width;
    if (percent < 0) {return;}
    percent = fabs(percent);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            self.interactionInProgress = YES;
            //根据presentingViewController判断是Push还是Present
            if (self.presentedVC.presentingViewController) {
                [self.presentedVC dismissViewControllerAnimated:YES completion:nil];
            }else {
                [self.presentedVC.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            self.interactionInProgress = YES;
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
                if (percent > 0.5 && gestureRecognizer.state == UIGestureRecognizerStateEnded) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
