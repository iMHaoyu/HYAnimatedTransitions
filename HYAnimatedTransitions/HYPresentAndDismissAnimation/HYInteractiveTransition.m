//
//  HYInteractiveTransition.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2018/10/10.
//  Copyright © 2018 徐浩宇. All rights reserved.
//

#import "HYInteractiveTransition.h"

@interface HYInteractiveTransition()
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, strong) UIViewController *presentingVC;
@end

@implementation HYInteractiveTransition

- (void)wireToViewController:(UIViewController*)viewController {
    self.presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            //1.标记交互标志。 在委托中提供时使用。
            self.interacting = YES;
            [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            break;
        case UIGestureRecognizerStateChanged:
        {
            // 2. 计算手势的百分比
            CGFloat fraction = translation.y / gestureRecognizer.view.frame.size.height;;
            //限制在0和1之间
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldComplete = (fraction > 0.3);
            
            [self updateInteractiveTransition:fraction];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            //3.手势交互结束。检查转换是否应该发生
            self.interacting = NO;
            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            } else {
                [self finishInteractiveTransition];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
