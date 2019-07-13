//
//  HYBaseViewController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/14.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBaseViewController.h"

@interface HYBaseViewController ()



@end

@implementation HYBaseViewController

- (void)dealloc {
    NSLog(@"%@ --> 销毁了",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self dismissButton];
    [self imageView];
    // Do any additional setup after loading the view.
}



- (void)dismissButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
/** dismiss */
- (UIButton *)dismissButton {
    if (!_dismissButton) {
        CGFloat tempW = 50;
        CGFloat tempX = self.view.frame.size.width-50-20;
        CGFloat tempY = HY_DEVICE_IS_IPHONE_X?44:20;
        UIButton *temp = [[UIButton alloc]initWithFrame:CGRectMake(tempX, tempY, tempW, tempW)];
        [temp setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [temp addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:temp];
        _dismissButton = temp;
    }
    return _dismissButton;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat tempY = CGRectGetMaxY(self.dismissButton.frame)+10;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10,tempY , self.view.frame.size.width-20, self.view.frame.size.height-tempY-10)];
        image.image = [UIImage imageNamed:@"hy_t_image3"];
        image.layer.cornerRadius = 4;
        image.layer.masksToBounds = YES;
        image.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:image];
        _imageView = image;
    }
    return _imageView;
}

@end
