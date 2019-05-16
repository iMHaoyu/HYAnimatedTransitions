//
//  HYBaseNaigationVC.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/10.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBaseNaigationVC.h"

@interface HYBaseNaigationVC ()<UINavigationControllerDelegate>

@end

@implementation HYBaseNaigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    // Do any additional setup after loading the view.
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
