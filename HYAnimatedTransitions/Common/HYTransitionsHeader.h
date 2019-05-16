//
//  HYTransitionsHeader.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/14.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#ifndef HYTransitionsHeader_h
#define HYTransitionsHeader_h

/** 视图控制器跳转的动画类型 */
typedef NS_ENUM(NSInteger,HYTransitionsAnimationType) {
    HYTransitionsAnimationDefaultType       = 0,      //系统默认的类型
    HYTransitionsAnimationPanType           = 1 << 0, //水平滑动类型
    HYTransitionsAnimationBackNarrowType    = 1 << 1, //背景抽屉类型,
    HYTransitionsAnimationAmplificationType = 1 << 2, //图片缩放类型，该类型下'modalPresentationStyle' 设置为 'UIModalPresentationCustom'
};

#endif /* HYTransitionsHeader_h */
