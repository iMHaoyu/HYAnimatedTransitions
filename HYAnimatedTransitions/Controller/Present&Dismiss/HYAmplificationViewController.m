//
//  HYAmplificationViewController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/14.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYAmplificationViewController.h"

@interface HYAmplificationViewController ()

@end

@implementation HYAmplificationViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat tempW = self.view.frame.size.width-20;
    CGFloat tempH = tempW / 1.5;
    self.imageView.frame = CGRectMake(0, 0, tempW, tempH);
    self.imageView.center = self.view.center;
    self.imageView.image = [UIImage imageNamed:@"hy_t_image2"];
    
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.5f animations:^{
        CGFloat tempY = CGRectGetMaxY(self.dismissButton.frame)+10;
        CGRect frame = CGRectMake(10,tempY , self.view.frame.size.width-20, self.view.frame.size.height-tempY-10);
        self.imageView.frame = frame;
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
