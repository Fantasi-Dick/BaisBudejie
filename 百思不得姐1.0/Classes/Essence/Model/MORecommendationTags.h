//
//  MORecommendationTags.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/21.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MORecommendationTags : NSObject

/*	image_list : http://img.spriteapp.cn/ugc/2015/03/18/161539_92786.jpg,
	theme_id : 853,
	theme_name : 新闻,
	is_sub : 0,
	is_default : 0,
	sub_number : 44684*/
/*图片*/
@property (nonatomic,strong) NSString * image_list;

/*主题*/
@property (nonatomic,strong) NSString *theme_name;

/*订阅数*/
@property (nonatomic,assign) NSInteger sub_number;


@end
