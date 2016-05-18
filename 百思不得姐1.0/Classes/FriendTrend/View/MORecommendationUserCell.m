//
//  MORecommendationUserCell.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/19.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MORecommendationUserCell.h"
#import "MORecommendationUser.h"
#import "UIImageView+WebCache.h"

@interface MORecommendationUserCell()

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

//@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end

@implementation MORecommendationUserCell


- (void)setUser:(MORecommendationUser *)user
{
    _user = user;
    self.screenNameLabel.text = user.screen_name;
    //#pragma - <这里怎么想到用NSString 来转？>
    self.fansCountLabel.text =[NSString stringWithFormat:@"%zd",user.fans_count];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
}
@end
