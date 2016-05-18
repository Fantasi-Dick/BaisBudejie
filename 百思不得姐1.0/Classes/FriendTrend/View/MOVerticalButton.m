//
//  MOVerticalButton.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/23.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOVerticalButton.h"

@implementation MOVerticalButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*文字居中设置*/
- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}



/*init方法重写*/
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


/*xib加载*/
- (void)awakeFromNib
{
    [self setup];
}


/*渲染界面*/
- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.width;
    
    
    NSInteger distance = 5;
    self.titleLabel.x = 0;
    self.titleLabel.y = self.width + distance;
    self.titleLabel.width = self.imageView.width;
    self.titleLabel.height = self.height - self.titleLabel.y - distance;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

@end
