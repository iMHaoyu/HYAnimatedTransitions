//
//  HYBaseViewController.h
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/14.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 判断是否为刘海屏系列 - 这样写消除了在一些Xcode上的警告 (注意这是代码块的写法)
#define HY_DEVICE_IS_IPHONE_X \
({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);\
})

@interface HYBaseViewController : UIViewController

/** dismiss */
@property (nonatomic, weak) UIButton *dismissButton;

@property (nonatomic, weak) UIImageView *imageView;

- (void)dismissButtonClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
