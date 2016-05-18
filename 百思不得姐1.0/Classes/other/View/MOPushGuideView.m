//
//  MOPushGuideView.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/25.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOPushGuideView.h"

@implementation MOPushGuideView

+ (instancetype)guideView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)close {
    
    [self removeFromSuperview ];
}

+ (void)showPushGuideView{
    
    //获取当前软件的版本号
    NSString *key = @"CFBundleShortVersionString";
//    MOLog(@"%@",[NSBundle mainBundle].infoDictionary);
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    NSString *sandboxVersion = [[NSUserDefaults standardUserDefaults]stringForKey:key];
    
    if (![currentVersion isEqualToString:sandboxVersion]) {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //创建pushGuideView推送引导
        MOPushGuideView *guideView = [MOPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        //存储数据
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
    
    }
}

@end
