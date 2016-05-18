//
//  MORecommendationCategory.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MORecommendationCategory : NSObject

@property (nonatomic, assign) NSInteger  count;
@property (nonatomic, assign) NSInteger  pID;
@property (nonatomic, copy) NSString * name;



//这个类别对应的用户数据
@property (nonatomic, strong) NSMutableArray * users;


/*用户组总页数*/
@property (nonatomic, assign) NSInteger  total;

/*用户组当前数据页*/
@property (nonatomic, assign) NSInteger  currentPage;


@end
