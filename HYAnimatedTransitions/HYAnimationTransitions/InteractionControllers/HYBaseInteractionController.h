//  转场手势交互
//  HYBaseInteractionController.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYBaseInteractionController : UIPercentDrivenInteractiveTransition

/** 是否正在交互 */
@property (nonatomic, assign) BOOL interactionInProgress;
/** 手势交互设置 */
- (void)hy_wireToViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
