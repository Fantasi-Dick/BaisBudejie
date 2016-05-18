//
//  MORecommendationTagsCell.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/21.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MORecommendationTagsCell.h"
#import "MORecommendationTags.h"
@interface MORecommendationTagsCell()


@property (weak, nonatomic) IBOutlet UIImageView *ImageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNameLabel;


@end

@implementation MORecommendationTagsCell

- (void)awakeFromNib {
    // Initialization code
  
    
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.x = 10;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 1;
    
    [super setFrame:frame];
}


- (void)setTags:(MORecommendationTags *)tags{
    
    _tags = tags;
    
    [self.ImageListView sd_setImageWithURL:[NSURL URLWithString:tags.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.themeNameLabel.text = tags.theme_name;

    
    self.subNameLabel.text = [NSString stringWithFormat:@"%.2f万人关注",tags.sub_number/10000.0];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
