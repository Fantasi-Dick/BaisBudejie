//
//  UIBarButtonItem+MOExtension.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "UIBarButtonItem+MOExtension.h"

@implementation UIBarButtonItem (MOExtension)

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown ];
    
    return [[self alloc] initWithCustomView:button];
}
@end
