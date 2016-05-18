//
//  MOPublicMethod.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/2.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOPublicMethod.h"

@implementation MOPublicMethod

+ (NSString *)dealWithNumber:(CGFloat)number placeHolder:(NSString *)placeHolder
{
    NSString *resultString = nil;
    if (number == 0) {
        resultString = placeHolder;
    }else
    {
        resultString = [NSString stringWithFormat:@"%zd", (NSInteger)number];
    }
    
    if (number > 10000) {
        resultString = [NSString stringWithFormat:@"%.1f万", number/10000.0];
    }
    return resultString;
}

@end
