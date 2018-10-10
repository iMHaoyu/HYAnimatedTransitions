//
//  HYInteractiveTransition.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2018/10/10.
//  Copyright © 2018 徐浩宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYInteractiveTransition : UIPercentDrivenInteractiveTransition
//是否是正在交互中
@property (nonatomic, assign) BOOL interacting;

- (void)wireToViewController:(UIViewController*)viewController;
@end
