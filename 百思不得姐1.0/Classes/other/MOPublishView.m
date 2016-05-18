//
//  MOPublishViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/5.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOPublishView.h"
#import "MOVerticalButton.h"


static CGFloat const MOAnimationDelay = 0.1;
static CGFloat const MOSpringFactor = 10 ;
@interface MOPublishView ()


@end

@implementation MOPublishView


+ (instancetype)publishView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}


static UIWindow *window_;
+ (void)show{
    
    // 创建窗口
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    window_.hidden = NO;
    
    // 添加发布界面
    MOPublishView *publishView = [MOPublishView publishView];
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
}

- (void)awakeFromNib {
    // 不能被点击
    self.userInteractionEnabled = NO;
    // 数据
    NSArray *images = @[@"publish-video", @"publish-picture", @"publish-text", @"publish-audio", @"publish-review", @"publish-offline"];
    NSArray *titles = @[@"发视频", @"发图片", @"发段子", @"发声音", @"审帖", @"离线下载"];
    
    
    // 中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 50;
    CGFloat buttonStartY = (MAINSCREENHEIGHT - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = ( MAINSCREENWIDTH- 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    
    for (int i = 0; i < images.count; i++) {
        MOVerticalButton *button = [[MOVerticalButton alloc]init];
        [self addSubview: button];
        
        // 设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        //        button.titleEdgeInsets = UIEdgeInsetsMake(-20, 0, 0, 0);
     
        
#pragma -  按钮的frame等设置要重新看，不完全掌握
    
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - MAINSCREENHEIGHT;
        button.tag = i;

        //设置按钮方法
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //按钮动画
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = MOSpringFactor;
        anim.springSpeed = MOSpringFactor;
        anim.beginTime = CACurrentMediaTime()+MOAnimationDelay * i;
        
        //加动画
        [button pop_addAnimation:anim forKey:nil];
    }
    
    //添加标语
    UIImageView *sloganView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self addSubview: sloganView];
    
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerEndY= MAINSCREENHEIGHT * 0.2;
    CGFloat centerX = MAINSCREENWIDTH * 0.5;
    CGFloat centerBeginY = centerEndY - MAINSCREENHEIGHT;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue =  [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.springBounciness = MOSpringFactor;
    anim.springSpeed = MOSpringFactor;
    anim.beginTime = CACurrentMediaTime() + images.count * MOAnimationDelay;
    
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        // 标语动画执行完毕, 恢复点击事件
        self.userInteractionEnabled = YES;
        
    }];    [sloganView pop_addAnimation:anim forKey:nil];
    
    
}
- (IBAction)cancel {
    
    
    [self cancelWithCompletionBlock:nil];
    
  
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    
}
/**
 *  先执行退出动画，然后执行
 *
 *  @param completionBlock 取消，退出动画
 */


- (void)cancelWithCompletionBlock:(void(^)())completionBlock{
    
    self.userInteractionEnabled = NO;
    
    int beginIndex = 1;
    for (int i = beginIndex; i<self.subviews.count; i++) {
        UIView *subview = self.subviews [i];//学会写这句
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + MAINSCREENHEIGHT;
        anim.toValue =  [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i-beginIndex) * MOAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        
        //监听最后一个动画，删掉View
        
        if (i == self.subviews.count-1) {
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
               
                //销毁窗口
                window_.hidden = YES;
//                [window_ removeFromSuperview];
//                window_ = nil;
                
                //执行传进来的completionBlock参数
                !completionBlock ? : completionBlock();
            }];
            
            
        }
    }
}

- (void)buttonClick:(UIButton*)button{
 
    [self cancelWithCompletionBlock:^{
        if (button.tag ==0) {
            MOLogFunc;
        }
    }];
   

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
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
