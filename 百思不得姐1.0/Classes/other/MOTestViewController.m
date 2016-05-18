//
//  MOTestViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTestViewController.h"


@interface MOTestViewController ()

@end

@implementation MOTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"MOTestViewController";
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = MORGBColor(200, 100, 50);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
