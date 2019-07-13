//
//  ViewController.m
//  HYAnimatedTransitions
//
//  Created by 徐浩宇 on 2018/9/30.
//  Copyright © 2018 徐浩宇. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+HYTransitionsCategory.h"

#import "HYPanViewController.h"
#import "HYBackNarrowViewController.h"
#import "HYAmplificationViewController.h"
#import "HYDrawerViewController.h"

#import "HYBackViewController.h"



@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSArray<NSArray *> *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"转场动画";
    
    self.dataSource = @[@[@"水平滑动跳转",
                          @"垂直滑动跳转",
                          @"图片缩放跳转",],
                        @[@"导航栏跳转测试",]];
    [self tableView];
    
    [self setupNavigationButton];
}

/** 导航栏按钮 */
- (void)setupNavigationButton {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(leftMenuButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(rightMenuButtonClicked:)];
}

#pragma mark - ⬅️⬅️⬅️⬅️ TableView Delegate & DataSource ➡️➡️➡️➡️
#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    NSString *titStr = self.dataSource[indexPath.section][indexPath.row];
    cell.textLabel.text = titStr;
    UIImageView *cellImageView = cell.imageView;
    cellImageView.layer.cornerRadius = 4;
    cellImageView.layer.masksToBounds = YES;
    
    UIImage * icon = [UIImage imageNamed:@"hy_t_image1"];
    CGSize itemSize = CGSizeMake(150, 100);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    cellImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0)?@"Present/Dismiss":@"Push/Pop";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //********* Present/Dismiss ------->>>
        
        switch (indexPath.row) {
            case 0:
            {
                HYPanViewController *tempVC = [[HYPanViewController alloc]init];
                [self hy_presentViewController:tempVC userInteractionEnabled:YES animationType:HYTransitionsAnimationPanType];
            }
                break;
            case 1:
            {
                HYBackNarrowViewController *tempVC = [[HYBackNarrowViewController alloc]init];
                [self hy_presentViewController:tempVC userInteractionEnabled:YES animationType:HYTransitionsAnimationBackNarrowType];
            }
                break;
            case 2:
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UIImageView *imageView = cell.imageView;
                
                HYAmplificationViewController *tempVC = [[HYAmplificationViewController alloc]init];
                __weak typeof(tempVC) weakTempVC = tempVC;
                [self hy_presentViewController:tempVC userInteractionEnabled:YES animationType:HYTransitionsAnimationAmplificationType presentTransitionsView:^HYPresentTransitionsView{
                    return HYPresentTransitionsViewMake(imageView, weakTempVC.imageView);
                }];
            }
                break;
                
            default:
                break;
        }
        
        
    }else {
        //********* Push/Pop ------->>>
        
        switch (indexPath.row) {
            case 0:
            {
                HYBackViewController *tempVC = [[HYBackViewController alloc]init];
                [self hy_pushViewController:tempVC animationType:HYTransitionsAnimationPanType];
                
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - ⬅️⬅️⬅️⬅️ Button Actions ➡️➡️➡️➡️
#pragma mark -
/** 导航栏菜单按钮点击事件 */
- (void)leftMenuButtonClicked:(UIBarButtonItem *)sender {
    HYDrawerViewController *tempVC = [[HYDrawerViewController alloc]init];
    tempVC.hy_menuSize = CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height);
    [self hy_presentMenuViewController:tempVC fromLeft:YES menuSize:CGSizeMake(self.view.frame.size.width-50, self.view.frame.size.height)];
//    [self hy_presentViewController:tempVC userInteractionEnabled:YES animationType:HYTransitionsAnimationLeftDrawerType];
}

- (void)rightMenuButtonClicked:(UIBarButtonItem *)sender {
    HYDrawerViewController *tempVC = [[HYDrawerViewController alloc]init];
//    [self hy_presentViewController:tempVC userInteractionEnabled:YES animationType:HYTransitionsAnimationRightDrawerType];
    [self hy_presentMenuViewController:tempVC fromLeft:NO menuSize:CGSizeZero];
}


#pragma mark - ⬅️⬅️⬅️⬅️ Getter & Setter ➡️➡️➡️➡️
#pragma mark -
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 120;
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@end
