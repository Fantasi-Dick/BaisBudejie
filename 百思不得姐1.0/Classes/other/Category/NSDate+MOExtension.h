//
//  NSDate+MOExtension.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/3.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MOExtension)

/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;
@end
