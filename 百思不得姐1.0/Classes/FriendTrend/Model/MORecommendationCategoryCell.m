//
//  MORecommendationCategoryCell.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/18.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MORecommendationCategoryCell.h"
#import "MORecommendationCategory.h"
@interface MORecommendationCategoryCell()


@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;

@end

@implementation MORecommendationCategoryCell

- (void)awakeFromNib {
    self.backgroundColor = MORGBColor(244, 244, 244);

    self.selectedIndicator.backgroundColor = MORGBColor(219, 26, 21);
}


- (void)setCategory:(MORecommendationCategory *)category
{
    
    _category = category;
    
    self.textLabel.text = category.name;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.y = 2;
    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : MORGBColor(78, 78, 78);

    
}
@end
