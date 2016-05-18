//
//  MOCommentModel.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/12.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOUserModel;

@interface MOCommentModel : NSObject


/*音频时长*/
@property (nonatomic, assign) NSInteger voicetime;

/*评论的文字内容*/
@property (nonatomic, copy) NSString * content;

/*被点赞的数量*/
@property (nonatomic, assign) NSInteger like_count;

///*评论ID*/
//@property (nonatomic,copy) NSString *ID;
/*用户*/
@property (nonatomic,strong) MOUserModel *user;

@end
