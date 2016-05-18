//
//  MOLoginViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/23.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOLoginViewController.h"
#import "MOTextField.h"
//#import "MOTopWindow.h"

@interface MOLoginViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation MOLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    UIImageView *loginBackImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_register_background"]];
//    loginBackImage.frame = CGRectMake(0, 0, MAINSCREENWIDTH, MAINSCREENHEIGHT);
//    
//    
//    
//    [self.view  addSubview: loginBackImage];
//
    
    
    //加手势监听，收起键盘
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:gesture];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [MOTopWindow hide];
}

- (void)hideKeyBoard
{
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}
- (IBAction)showLoginOrRegister:(UIButton *)button {
    
    [self hideKeyBoard];
    if (self.loginViewLeftMargin.constant == 0)
    {
        self.loginViewLeftMargin.constant = -self.view.width;
        [button setTitle:@"已有账号?" forState:UIControlStateNormal];
       
        
    }else{
        self.loginViewLeftMargin.constant = 0;
        [button setTitle:@"注册账号" forState:UIControlStateNormal];

    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)closeButton {
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        nil;
//    }];
//}


- (IBAction)backClick {
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    [MOTopWindow show];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  设置状态栏
 *
 *  @return 状态栏高亮，默认等等
 */

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
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
