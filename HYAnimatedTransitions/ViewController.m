//
//  ViewController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2018/9/30.
//  Copyright © 2018 徐浩宇. All rights reserved.
//

#import "ViewController.h"
#import "HYSecondVC.h"

/** 模态弹出 (导航栏的弹出与之类似，只是实现的是UINavigationControllerDelegate
 - (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                             animationControllerForOperation:(UINavigationControllerOperation)operation
                                                          fromViewController:(UIViewController *)fromVC
                                                            toViewController:(UIViewController *)toVC
 )*/
#import "HYPresentAnimation.h"
#import "HYDismissAnimation.h"
#import "HYInteractiveTransition.h"


@interface ViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIButton *tempBtn;

@property (nonatomic, strong) HYPresentAnimation *presentAnimation;
@property (nonatomic, strong) HYDismissAnimation *dismissAnimation;
@property (nonatomic, strong) HYInteractiveTransition *transitionController;

@end

@implementation ViewController
- (HYPresentAnimation *)presentAnimation {
    if (!_presentAnimation) {
        _presentAnimation = [[HYPresentAnimation alloc]init];
    }
    return _presentAnimation;
}

- (HYDismissAnimation *)dismissAnimation {
    if (!_dismissAnimation) {
        _dismissAnimation = [[HYDismissAnimation alloc]init];
    }
    return _dismissAnimation;
}

- (HYInteractiveTransition *)transitionController {
    if (!_transitionController) {
        _transitionController = [[HYInteractiveTransition alloc]init];
    }
    return _transitionController;
}

- (void)btnClicked:(UIButton *)sender {
    //present
    [self presentNextVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.delegate = self;
    [self tempBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - ⬅️⬅️⬅️⬅️ Present / Dismiss ➡️➡️➡️➡️
#pragma mark -
- (void)presentNextVC {
    HYSecondVC *tempVC = [[HYSecondVC alloc]init];
    tempVC.transitioningDelegate = self;
    [self.transitionController wireToViewController:tempVC];
    [self presentViewController:tempVC animated:YES completion:nil];
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentAnimation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissAnimation;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    NSLog(@"1111111");
    return nil;
}
//
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    NSLog(@"2222222");
    return self.transitionController.interacting ? self.transitionController : nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
- (UIButton *)tempBtn {
    if (!_tempBtn) {
        UIButton *temp = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 50, 50)];
        temp.backgroundColor = [UIColor whiteColor];
        temp.layer.cornerRadius = 25;
        [temp addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:temp];
        _tempBtn = temp;
    }
    return _tempBtn;
}

@end
