//
//  MOShowPictureViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/4.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOShowPictureViewController.h"
#import "MOEssenceModel.h"
#import "MOProgressView.h"

@interface MOShowPictureViewController ()




/*图片*/
@property (nonatomic, weak) UIImageView * imageView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MOProgressView *progressView;

@end

@implementation MOShowPictureViewController


 - (void)viewDidLoad {
 [super viewDidLoad];
 
     
     //图片尺寸
     CGFloat pictureW = MAINSCREENWIDTH;
     CGFloat pictureH = pictureW * self.topic.height/self.topic.width;
     
     //添加图片
     UIImageView *imageView = [[UIImageView alloc]init];
     imageView.userInteractionEnabled = YES;
     //点击图片同样可以返回
     [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(backbutton)]];

    
     [self.scrollView addSubview: imageView];
     self.imageView = imageView;
     if (pictureH > MAINSCREENHEIGHT) {
         //需要滚动查看
         imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
         self.scrollView.contentSize = CGSizeMake(0, pictureH);
         
     }else{
         imageView.size = CGSizeMake(pictureW, pictureH);
         imageView.centerY = MAINSCREENHEIGHT * 0.5;
         
         
         
     }
     //马上显示当前图片的下载进度
     [self.progressView setProgress:self.topic.pictureProgress animated:YES];

     // 下载图片
     [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
         self.progressView.hidden = NO;
/**************  进度计算  ********/
         CGFloat progress = 1.0 * receivedSize / expectedSize;
/********   动画设置为NO，避免网速不好风险   */
         [self.progressView setProgress:progress animated:NO];
     } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         self.progressView.hidden = YES;
     }];
     
     
     }
- (IBAction)backbutton {
    [self dismissViewControllerAnimated:YES completion:^{
                nil;
            }];
}

 
- (IBAction)save {
    if (self.imageView.image == nil) {
        [SVProgressHUD showErrorWithStatus:@"图片并没下载完毕!"];
        return;
    }
    
    // 将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(error){
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        MOLog(@"%@",error);
    }else{
    [SVProgressHUD showSuccessWithStatus :@"保存成功"];
    }

}



@end
