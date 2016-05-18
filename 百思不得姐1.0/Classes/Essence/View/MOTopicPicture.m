//
//  XMGTopicPictureView.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/7/29.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MOTopicPicture.h"
#import "MOEssenceModel.h"
#import "MOProgressView.h"
#import "MOShowPictureViewController.h"

@interface MOTopicPicture()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/** gif标识 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/** 查看大图按钮 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/** 进度条控件 */
@property (weak, nonatomic) IBOutlet MOProgressView *progressView;


@end

@implementation MOTopicPicture

//
+ (instancetype)pictureView
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

- (IBAction)showPicture
{
    MOShowPictureViewController *showPicture = [[MOShowPictureViewController alloc] init];
    showPicture.topic = self.topic;//将模型数据传给showpicture控制器使用
   
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
//将模型数据全部传入
- (void)setTopic:(MOEssenceModel *)topic
{
    _topic = topic;
    
    //立马显示最新的进度值（防止因网速慢，导致显示的是其他图片的下载进度）
    [self.progressView setProgress: topic.pictureProgress];
    
    // 设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
   
    /****  计算进度值 */
        topic.pictureProgress = 1.0 * receivedSize / expectedSize;
    /**** 显示进度值 */
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        //如果不是大图片
        if (topic.isBigPicture == NO) return;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureViewFrame.size, YES, 0.0);
        
        //将下载完的Image对象绘制到图形上下文
        CGFloat width =  topic.pictureViewFrame.size.width;
        CGFloat height = width * image.size.height/image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上文
        UIGraphicsEndImageContext();
        
    }];
    
    //判断是否为gif
    
    NSString *extension = topic.large_image.pathExtension;


    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];
    
    //判断是否显示“点击查看全图”
    if (topic.isBigPicture) {
        self.seeBigButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }else{
    self.seeBigButton.hidden = YES;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
}
@end
