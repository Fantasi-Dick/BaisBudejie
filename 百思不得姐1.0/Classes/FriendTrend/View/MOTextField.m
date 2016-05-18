//
//  MOTextField.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/24.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTextField.h"

@implementation MOTextField

- (void)awakeFromNib
{
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
//    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}


@end
