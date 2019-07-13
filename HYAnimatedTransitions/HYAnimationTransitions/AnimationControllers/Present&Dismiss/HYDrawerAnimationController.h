//
//  HYDrawerAnimationController.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/7/13.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBaseAnimationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYDrawerAnimationController : HYBaseAnimationController

- (instancetype)initWithReverse:(BOOL)reverse originalLocation:(BOOL)originalLocation toViewSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
