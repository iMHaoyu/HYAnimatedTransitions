//
//  HYBackViewController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2019/5/16.
//  Copyright © 2019 徐浩宇. All rights reserved.
//

#import "HYBackViewController.h"

@interface HYBackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *mainTableView;

@end

@implementation HYBackViewController

- (void)dealloc {
    NSLog(@"%@ --> 销毁了",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Navigation Push Test";
    self.view.backgroundColor = [UIColor whiteColor];

    [self mainTableView];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = [NSString stringWithFormat:@"Navigation Push Test - Section %ld Row - %ld", (long)indexPath.section,(long)indexPath.row];
    return cell;
}

#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
- (UIScrollView *)mainTableView {
    if (!_mainTableView) {
        UITableView *tempView = [[UITableView alloc] initWithFrame:self.view.bounds];
        tempView.delegate = self;
        tempView.dataSource = self;
        tempView.rowHeight = 80;
        [self.view addSubview:tempView];
        _mainTableView = tempView;
        
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _mainTableView;
}

@end
