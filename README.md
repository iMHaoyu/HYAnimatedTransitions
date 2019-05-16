# HYAnimatedTransitions

一行代码实现视图控制器的转换，目前只有少量动画后期可能会加入更多的动画类型。如有问题欢迎指责出来...

## 使用方法(Usage)
 1、首先导入头文件
~~~
 #import "UIViewController+HYTransitionsCategory.h"
~~~

 2、一行代码就可以调用
 
Push:
~~~
/**
 导航栏跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转，且支持手势返回

 @param viewController          需要跳转到的视图控制器
 @param animationType           跳转动画
 */
- (void)hy_pushViewController:(UIViewController *)viewController
                animationType:(HYTransitionsAnimationType)animationType;


/**
 导航栏跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转

 @attention 设置任何一个跳转的'userInteractionEnabled'都会会影响到整个导航栏是否会支持手势操作
 
 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回 - 任何一个控制器设置后，会影响到整个导航栏是否会支持手势操作
 @param animationType           跳转动画
 */
- (void)hy_pushViewController:(UIViewController *)viewController
       userInteractionEnabled:(BOOL)userInteractionEnabled
                animationType:(HYTransitionsAnimationType)animationType;


/**
 导航栏跳转
 
 @attention 设置任何一个跳转的'userInteractionEnabled'都会会影响到整个导航栏是否会支持手势操作

 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回 - 任何一个控制器设置后，都会影响到整个导航栏是否会支持手势操作
 @param animationType           跳转动画
 @param presentTransitionsView  在HYTransitionsAnimationAmplificationType类型跳转的情况下才需要传入，其他情况不需要。
 */
- (void)hy_pushViewController:(UIViewController *)viewController
       userInteractionEnabled:(BOOL)userInteractionEnabled
                animationType:(HYTransitionsAnimationType)animationType
       presentTransitionsView:(HYPresentTransitionsView (^ _Nullable )(void))presentTransitionsView;
 ~~~
Present:

~~~
/**
 模态跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转，且支持手势返回

 @param viewController          需要跳转到的视图控制器
 @param animationType           跳转动画
 */
- (void)hy_presentViewController:(UIViewController *)viewController
                   animationType:(HYTransitionsAnimationType)animationType;

/**
 模态跳转 - 默认是非 'HYTransitionsAnimationAmplificationType' 类型下的跳转

 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回
 @param animationType           跳转动画
 */
- (void)hy_presentViewController:(UIViewController *)viewController
          userInteractionEnabled:(BOOL)userInteractionEnabled
                   animationType:(HYTransitionsAnimationType)animationType;

/**
 模态跳转

 @param viewController          需要跳转到的视图控制器
 @param userInteractionEnabled  是否允许手势交互返回
 @param animationType           跳转动画
 @param presentTransitionsView  在HYTransitionsAnimationAmplificationType类型跳转的情况下才需要传入，其他情况不需要。
 */
- (void)hy_presentViewController:(UIViewController *)viewController
          userInteractionEnabled:(BOOL)userInteractionEnabled
                   animationType:(HYTransitionsAnimationType)animationType
          presentTransitionsView:(HYPresentTransitionsView (^ _Nullable )(void))presentTransitionsView;

~~~
说明： HYTransitionsAnimationType，通过这个枚举选择你想要的转场动画。

【END】


------------------- 分割线 -------------------

V1.0:

自定义实现一个简单的转场动画，此Demo仅以模态为为例，**UITabBarController** -标签控制器的控制器切换，**UINavigationController**-导航控制器push和pop 原理相同，转换的动画可以扩展。

详情请点击[这里](https://xuhaoyucn.com/2018/10/10/%E8%87%AA%E5%AE%9A%E4%B9%89%E8%BD%AC%E5%9C%BA%E5%8A%A8%E7%94%BB/)。


</br>
![1](https://raw.githubusercontent.com/iMHaoyu/HYAnimatedTransitions/master/Oct-11-2018%2006-19-52.gif)
