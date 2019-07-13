//
//  HYDrawerViewController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/7/14.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYDrawerViewController.h"

@interface HYDrawerViewController ()

@end

@implementation HYDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"000000 --- %@",NSStringFromCGRect(self.view.frame));
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"111111 --- %@",NSStringFromCGRect(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"222222 -- %@",NSStringFromCGRect(self.view.frame));
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
