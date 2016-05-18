//
//  MOProgressView.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/4.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOProgressView.h"

@implementation MOProgressView

- (void)awakeFromNib
{
    self.roundedCorners = 2;
    self.progressLabel.textColor = [UIColor whiteColor];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    self.progressLabel.text = [text stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
