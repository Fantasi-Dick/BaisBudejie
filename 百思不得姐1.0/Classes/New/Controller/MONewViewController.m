//
//  MONewViewController.m
//  百思不得姐
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//


#import "MONewViewController.h"
#import "MOTestViewController.h"

@implementation MONewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
   
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    
    // 设置背景色
    self.view.backgroundColor = MOGlobalBg;
}

- (void)tagClick
{
    MOLogFunc;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    MOTestViewController *vc = [[MOTestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
