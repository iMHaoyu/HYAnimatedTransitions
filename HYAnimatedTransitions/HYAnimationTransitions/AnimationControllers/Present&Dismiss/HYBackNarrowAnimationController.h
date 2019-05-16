//  背景缩小动画
//  HYBackScaleAnimationController.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/11.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBaseAnimationController.h"

NS_ASSUME_NONNULL_BEGIN
static CGFloat const HYDefaultHeight = 40.f;
@interface HYBackNarrowAnimationController : HYBaseAnimationController

/** 初始化方法。 height:加载的控制器距离顶部的位置，默认:HYDefaultHeight */
- (instancetype)initWithReverse:(BOOL)reverse height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
