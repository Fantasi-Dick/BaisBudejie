//
//  MOMeViewController.m
//  百思不得姐
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOMeViewController.h"

@interface MOMeViewController ()

@end

@implementation MOMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    
    //设置导航栏右边的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self  action:@selector(settingClick)];
   
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click"  target: self action:@selector(moonClick)];
    //特别点的，一次两
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
    
    // 设置背景色
    self.view.backgroundColor = MOGlobalBg;
    
    // Do any additional setup after loading the view.
}

- (void)settingClick
{
    MOLogFunc;
}

- (void)moonClick
{
    MOLogFunc;
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
