//
//  MOFriendTrendsViewController.m
//  百思不得姐
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOFriendTrendsViewController.h"
#import "MORecommendationViewController.h"
#import "MOLoginViewController.h"

@interface MOFriendTrendsViewController ()

@end

@implementation MOFriendTrendsViewController
- (IBAction)logInButton {
    
    
    MOLoginViewController *login = [[MOLoginViewController alloc]init];
    
    [self presentViewController:login animated:YES completion:^{
    
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏
    self.navigationItem.title = @"我的关注";
    
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click"  target: self action:@selector(friendClick)];
    
    
    // 设置背景色
    self.view.backgroundColor = MOGlobalBg;
    // Do any additional setup after loading the view.
}



- (void)friendClick
{
    MOLogFunc;
    MORecommendationViewController *recommendationVC = [[MORecommendationViewController alloc]init];
    
    [self.navigationController pushViewController:recommendationVC animated:YES];
//    MORecommendViewController *vc = [[MORecommendViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];

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
