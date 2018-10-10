//
//  HYSecondVC.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2018/9/30.
//  Copyright © 2018 徐浩宇. All rights reserved.
//

#import "HYSecondVC.h"

@interface HYSecondVC ()

@end

@implementation HYSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    tempView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tempView];
    
    UIView *tempView1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, 100, 50)];
    tempView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tempView1];
    // Do any additional setup after loading the view.
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
