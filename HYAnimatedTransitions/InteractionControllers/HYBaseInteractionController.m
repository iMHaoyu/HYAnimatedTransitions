//  转场手势交互
//  HYBaseInteractionController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBaseInteractionController.h"

@implementation HYBaseInteractionController

- (void)hy_wireToViewController:(UIViewController *)viewController {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"必须在子类中重写 %@", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end
