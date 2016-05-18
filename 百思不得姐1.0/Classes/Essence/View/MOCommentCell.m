//
//  MOCommentCell.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/16.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOCommentCell.h"
#import "MOCommentModel.h"
#import "MOUserModel.h"

@interface MOCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;

@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@end

@implementation MOCommentCell

- (void)setComment:(MOCommentModel *)comment{
    
    _comment = comment;
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:comment.user.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.commentContent.text = comment.content;
    self.userNameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    self.sexView.image = [comment.user.sex isEqualToString:@"m" ]? [UIImage imageNamed:@"Profile_manIcon"] : [UIImage imageNamed:@"Profile_womanIcon"];
}



@end
