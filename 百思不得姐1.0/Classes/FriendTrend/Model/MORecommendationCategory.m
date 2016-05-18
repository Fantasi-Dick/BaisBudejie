//
//  MORecommendationCategory.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MORecommendationCategory.h"

@implementation MORecommendationCategory


//需要掌握，替换key名字
- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"pID":@"id"};
}

@end
