//
//  MOTopicVoice.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/11.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTopicVoice.h"
#import "MOEssenceModel.h"
#import "MOShowPictureViewController.h"

@interface MOTopicVoice()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playcount;
@property (weak, nonatomic) IBOutlet UILabel *voicetime;

@end

@implementation MOTopicVoice



+ (instancetype)voiceView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
}
- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    // 给图片添加监听器
    self.imageView.userInteractionEnabled = YES;//这句不能少
    
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

- (void)showPicture
{
    MOShowPictureViewController *showPicture = [[MOShowPictureViewController alloc] init];
    showPicture.topic = self.topic;//将模型数据传给showpicture控制器使用
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(MOEssenceModel *)topic
{
    _topic = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    //播放次数
    self.playcount.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    //播放时长
  
    NSInteger minute = topic.voicetime/60;
    NSInteger second = topic.voicetime % 60;
    self.voicetime.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];

}


@end
