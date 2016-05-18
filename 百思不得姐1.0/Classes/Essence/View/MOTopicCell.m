//
//  MOTopicCell.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/1.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTopicCell.h"
#import "MOEssenceModel.h"
#import "MOTopicPicture.h"
#import "MOPublicMethod.h"
#import "MOTopicVoice.h"
#import "MOTopicVideo.h"
#import "MOCommentModel.h"
#import "MOUserModel.h"

@interface MOTopicCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *publicDate;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *dingButton;
/**
 *  帖子的文字内容
 */
@property (weak, nonatomic) IBOutlet UILabel *text_label;

/*图片帖子的内容,控件用weak*/
@property (nonatomic,weak)  MOTopicPicture *pictureView;
/*声音帖子的内容,控件用weak*/
@property (nonatomic,weak)  MOTopicVoice *voiceView;
/*视频帖子的内容,控件用weak*/
@property (nonatomic,weak)  MOTopicVideo *videoView;

/*最热评论父控件*/
@property (weak, nonatomic) IBOutlet UIView *topCommentView;

/*最热评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *topCommentContent;

@end


@implementation MOTopicCell


//什么时候下划线，什么时候不。。。晕了

+ (instancetype)cell{
    
    return [[[NSBundle mainBundle] loadNibNamed: NSStringFromClass(self) owner:nil options:nil]firstObject];
}

//懒加载

- (MOTopicPicture *)pictureView{
    
    if(! _pictureView){
        MOTopicPicture *pictureView = [MOTopicPicture pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
        
    }
    return _pictureView;
}
- (MOTopicVoice *)voiceView{
    
    if(! _voiceView){
        MOTopicVoice *voiceView = [MOTopicVoice voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
        
    }
    return _voiceView;
}

- (MOTopicVideo *)videoView{
    
    if(! _videoView){
        MOTopicVideo *videoView = [MOTopicVideo videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
        
    }
    return _videoView;
}

//给cell设置背景图片
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    UIImageView *bgView = [[UIImageView alloc] init];
//    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
//    self.backgroundView = bgView;
    self.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(MOEssenceModel *)topic
{
    _topic = topic;
    
    [self.profileImage sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.nickName.text = topic.name;
    
    self.publicDate.text = topic.create_time;
    
    [self.dingButton setTitle:[MOPublicMethod dealWithNumber:topic.ding placeHolder:@"顶"] forState:UIControlStateNormal];
    [self.caiButton setTitle:[MOPublicMethod dealWithNumber:topic.cai placeHolder:@"踩"] forState:UIControlStateNormal];
    [self.shareButton setTitle:[MOPublicMethod dealWithNumber:topic.repost placeHolder:@"分享"] forState:UIControlStateNormal];
    [self.commentButton setTitle:[MOPublicMethod dealWithNumber:topic.comment placeHolder:@"评论"] forState:UIControlStateNormal];
    
    
    //设置帖子文字
    self.text_label.text = topic.text;
    //根据模型类型（帖子类型），添加对应的内容到cell的中间，跳到前面用懒加载，只创建一次
    if (topic.type == MOTopicTypePicture) {
        self.pictureView.hidden = NO;
        self.pictureView.topic = topic;
        self.pictureView.frame = topic.pictureViewFrame;
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
    }else if (topic.type == MOTopicTypeVoice){
        
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceViewFrame;
        self.videoView.hidden = YES;
        self.pictureView.hidden = YES;
        
    }else if (topic.type == MOTopicTypeVideo){
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoViewFrame;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }else{
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    //处理最热评论
    //从数组模型中取出第一个值
    MOCommentModel *topCmt = [topic.top_cmt firstObject];
    if (topCmt) {
        self.topCommentView.hidden = NO;
        self.topCommentContent.text = [NSString stringWithFormat:@"%@ : %@", topCmt.user.username, topCmt.content];
    } else {
        self.topCommentView.hidden = YES;
    }
    
}


//复写cell的大小frame
- (void)setFrame:(CGRect)frame
{
    
    frame.origin.x = MOTopicCellMargin;
    frame.size.width -= 2 * MOTopicCellMargin;
    frame.origin.y += MOTopicCellMargin;
    frame.size.height = self.topic.cellHeight-  MOTopicCellMargin;
    
    [super setFrame:frame];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)more {
  
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏",@"举报", nil];
    
    [sheet showInView:self.window];
  }

@end
