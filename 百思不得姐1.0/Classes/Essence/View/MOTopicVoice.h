//
//  MOTopicVoice.h
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/11.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MOEssenceModel;

@interface MOTopicVoice : UIView


/** 帖子数据 */
@property (nonatomic, strong) MOEssenceModel *topic;

+ (instancetype)voiceView;

@end
