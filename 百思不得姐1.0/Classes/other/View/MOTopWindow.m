//
//  MOTopWindow.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/16.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTopWindow.h"

@implementation MOTopWindow

/**
 *  类方法不能用成员变量，所以想保住window或某些控件不被销毁，
 不用@interface  类名 ()
 @proporty  (nonatomic, strong)  。。。。
 而是用
 static 类名 + 对象名  （static不被访问）
 */
UIWindow *window_;

//1-初始化窗口
+(void)initialize
{
    //创建窗口
    window_ = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, MAINSCREENWIDTH, 20)];
    //设置frame大小，以及背景色等属性
//    window_.frame = CGRectMake(0, 0, MAINSCREENWIDTH, 20);
    //设置窗口的级别，最高级别。覆盖在所有控件之上
    window_.windowLevel = UIWindowLevelAlert;
    //加手势。（因点击窗口要做一些事情）
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(windowClick)]];//此处特别注意，因target是self，而self是个类方法，故windowClick也要是个类方法，否则会报错。

//    window_.backgroundColor = [UIColor greenColor];
}

/**
 *  监听窗口点击事件
 */
+(void)windowClick{
    //创建主窗口
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    /**
     *  在searchScrollViewInView方法中传入 “window” 为父视图。在这个父视图中寻找符合方法要求的scrollerView后进行操作---改变其坐标系。----高级操作
     ********************************************************************************/
    [self searchScrollViewInView: window];
}

+ (void)searchScrollViewInView:(UIView *)superview{
    
    //判断，如果父视图的子视图是个scrollView
    for (UIScrollView *subview in superview.subviews){
        //如果是scrollView,滚到最顶部，接下来“怎么滚？”
        if ([subview isKindOfClass:[UIScrollView class]])
        {
            //设置偏移量 等于 子视图的内容偏移量
            CGPoint offset = subview.contentOffset;
            //修改offset的y值为 子视图的内边距 “负” 顶部值，因向下偏移是负。
            offset.y = -subview.contentInset.top;
#pragma --- 结构体不允许直接修改
            /**
             *  不能写成 subview.contentOffset.y = -subview.contentInset.top
               结构体内布值不允许直接修改，故需要offset先接收，再通过修改offset中的y值，来修改子视图的frame.y值。
             */
            //最后将子视图设置偏移量为 offset，即子视图的内容偏移的y值。成功修改子视图的frame值。
            [subview setContentOffset:offset animated:YES];
            
        }
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}

+ (void)show{
    window_ .hidden = NO;
}

+ (void)hide{
    
    window_ .hidden = YES;
}
@end
