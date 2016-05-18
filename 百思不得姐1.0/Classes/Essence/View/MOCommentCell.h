//
//  MOCommentCell.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/16.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOCommentModel;

@interface MOCommentCell : UITableViewCell


/*评论模型数据*/
@property (nonatomic,strong) MOCommentModel *comment;

@end
