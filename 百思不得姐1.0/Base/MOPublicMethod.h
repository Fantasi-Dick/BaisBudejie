//
//  MOPublicMethod.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/2.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOPublicMethod : NSObject

/**
 *  处理可能会上万的数字
 */
+ (NSString *)dealWithNumber:(CGFloat)number placeHolder:(NSString *)placeHolder;

@end
