//
//  MOEssenceModel.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/30.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

// 8、创建帖子模型
//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MOCommentModel;

@interface MOEssenceModel : NSObject

/** 名称 */
@property (nonatomic, copy) NSString *name;
/** 头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 发帖时间 */
@property (nonatomic, copy) NSString *create_time;
/** 文字内容 */
@property (nonatomic, copy) NSString *text;
/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;
/**图片的宽度*/
@property (nonatomic, assign) CGFloat  width;
/**图片的高度*/
@property (nonatomic, assign) CGFloat  height;
/*图片的URL*/
@property (nonatomic, copy) NSString * large_image;
@property (nonatomic, copy) NSString * middle_image;
@property (nonatomic, copy) NSString * small_image;
/*帖子的类型*/
@property (nonatomic, assign) MOTopicType type;

/*音频时长*/
@property (nonatomic, assign) NSInteger voicetime;

/*播放次数*/
@property (nonatomic, assign) NSInteger playcount;


/*视频播放时长*/
@property (nonatomic, assign) NSInteger  videotime;

/*最热评论*/
@property (nonatomic,strong) NSArray *top_cmt;


/*********额外的辅助属性****************/

/**cell的高度*/
@property (nonatomic, assign,readonly) CGFloat cellHeight;
/** 图片是否太大,改写getter方法 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;
/*图片控件的frame*/
@property (nonatomic, assign,readonly) CGRect pictureViewFrame;

/*图片的下载进度*/
@property (nonatomic, assign) CGFloat  pictureProgress;
/*声音控件的frame*/
@property (nonatomic, assign,readonly) CGRect voiceViewFrame;

/*视频空间的frame*/
@property (nonatomic, assign, readonly) CGRect  videoViewFrame;

/*帖子ID*/
@property (nonatomic,copy) NSString * ID;


@end
