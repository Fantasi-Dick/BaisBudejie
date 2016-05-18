//
//  MOEssenceModel.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/30.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOEssenceModel.h"
#import "MJExtension.h"
#import "MOCommentModel.h"
#import "MOUserModel.h"


@implementation MOEssenceModel

{
    CGFloat _cellHeight;
    CGRect _pictureViewFrame;
}

+(NSDictionary *)replacedKeyFromPropertyName{
    
    return @{@"small_image" : @"image0",
             @"middle_image" : @"image2",
             @"large_image" : @"image1",
             @"ID" : @"id"
            
             };
}

//不太理解。数组中装什么样的对象（模型）
+ (NSDictionary *) objectClassInArray{
    
    return @{@"top_cmt" : @"MOCommentModel"};
    
}
- (CGFloat)cellHeight{//包括纯文字cell高度，图片的frame
    
    if (!_cellHeight) {
    
        //cell的最大size，宽度等于屏幕的宽度，高度取最大的浮点值
        //文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4*MOTopicCellMargin, MAXFLOAT);
        
       
        //这个方法很牛掰，计算文字的高度
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        
        //cell的高度
        _cellHeight = textH + MOTopicCellTextY + MOTopicCellBottomBarH + 2*MOTopicCellMargin;
        
        
        
        
        //根据段子类型
        if (self.type == MOTopicTypePicture) {//如果是图片
            CGFloat pictureW = maxSize.width;
            CGFloat pictureH = pictureW * self.height/self.width;
            
            //显示出来的高度
            if (pictureH >= MOTopicCellPictureMaxH ) {
                
                pictureH = MOTopicCellPictureBreakH;
                self.bigPicture = YES;
            }
            //计算图片控件的frame
            _pictureViewFrame = CGRectMake(MOTopicCellMargin, MOTopicCellTextY+textH+MOTopicCellMargin, pictureW, pictureH);
            _cellHeight += pictureH + MOTopicCellMargin;
            
        }else if (self.type == MOTopicTypeVoice){//如果是声音
            
            CGFloat voiceX = MOTopicCellMargin ;
            CGFloat voiceY = MOTopicCellTextY+textH+MOTopicCellMargin ;
            CGFloat voiceWidth = maxSize.width;
            CGFloat voiceHeight = voiceWidth * self.height/self.width;
            
            _voiceViewFrame = CGRectMake(voiceX, voiceY,voiceWidth, voiceHeight);
            _cellHeight += voiceHeight + MOTopicCellMargin;
        
        }else if(self.type == MOTopicTypeVideo){//如果是视频
            
            CGFloat videoX = MOTopicCellMargin ;
            CGFloat videoY = MOTopicCellTextY + textH + MOTopicCellMargin ;
            CGFloat videoWidth = maxSize.width;
            CGFloat videoHeight = videoWidth * self.height/self.width;
            
            _videoViewFrame = CGRectMake(videoX, videoY,videoWidth, videoHeight);
            _cellHeight += videoHeight + MOTopicCellMargin;
        
        }
        
        //判断--在有最热评论的情况下加上评论的高度
        MOCommentModel *topcmt = [self.top_cmt firstObject];
        if(topcmt){
            NSString *content = [NSString stringWithFormat:@"%@ : %@", topcmt.user.username, topcmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName: [UIFont systemFontOfSize :13]} context:nil].size.height;
            _cellHeight += contentH + MOTopicCellMargin + MOTopicCellTopCmtTitleH;
        }
    }
    
    
    return _cellHeight;
}

- (NSString *)create_time
{
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _create_time;
    }
}

@end
