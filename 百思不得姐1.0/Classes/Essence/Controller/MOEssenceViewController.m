//
//  MOEssenceViewController.m
//  百思不得姐
//
//  Created by Andy_Lin on 16/4/14.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//
#import "MOEssenceViewController.h"
#import "MOTestViewController.h"
#import "MORecommendationTagsViewController.h"
#import "MOTopicViewController.h"
#import "MOTopWindow.h"

@interface MOEssenceViewController () <UIScrollViewDelegate>

/*按钮下红色小条*/
@property (nonatomic, weak) UIView * indicatorView;


/*被选中按钮*/
@property (nonatomic, weak) UIButton * selectedButton;

/*顶部所有的标签*/
@property (nonatomic, weak) UIView * titlesView;


/*底部的所有内容*/
@property (nonatomic, assign) UIScrollView * contentView;

@end

@implementation MOEssenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化子控制器
    [self setupChildVces];
    
    //设置导航栏
    [self setupNavContr];
    
    //设置顶部的标签栏
    [self setTitlesView];
    
    //底部的scrollView
    [self setupContentView];
    
    [MOTopWindow show];
}

- (void)setupChildVces{
    MOTopicViewController *all = [[MOTopicViewController alloc] init];
    all.title = @"全部";
    all.type = MOTopicTypeAll;
    
    [self addChildViewController:all];
    
  
    MOTopicViewController *video = [[MOTopicViewController alloc] init];
    video.title = @"视频";
    video.type = MOTopicTypeVideo;
    
    [self addChildViewController:video];
    
   
    MOTopicViewController *voice = [[MOTopicViewController alloc] init];
    voice.title = @"声音";
    voice.type = MOTopicTypeVoice;
    
    [self addChildViewController:voice];
    
    MOTopicViewController *picture = [[MOTopicViewController alloc] init];
    picture.title = @"图片";
    picture.type = MOTopicTypePicture;
    [self addChildViewController:picture];
    
    MOTopicViewController *word = [[MOTopicViewController alloc] init];
    word.title = @"字段";
    word.type = MOTopicTypeWord;
    
    [self addChildViewController:word];
}



  //设置顶部的标签栏
- (void)setTitlesView{
    UIView *titlesView = [[UIView alloc]init];
    titlesView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    [titlesView setFrame:CGRectMake(0, 64, self.view.width, 35)];
    [self.view addSubview:titlesView];
    
    self.titlesView = titlesView;
    
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor =[UIColor redColor];
    indicatorView.height = 2 ;
    indicatorView.y = titlesView.height - indicatorView.height;
    
    self.indicatorView = indicatorView;
    
    
    
    NSInteger count = self.childViewControllers.count;
    
    CGFloat width = titlesView.width / count;
    CGFloat height = titlesView.height;
    
    for (int i = 0; i <count; i++) {
        UIButton *button = [[UIButton alloc]init];
        button.height = height;
        button.width = width;
        button.x = i * width;
        
        UIViewController *vc = self.childViewControllers[i];
        
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.tag = i;
        
        //强制布局，以解决，提前被用到的问题；
        [button layoutIfNeeded];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        [button addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
    
        [titlesView addSubview:button];
        
        
        //默认选中第一个标签
        if (i == 0) {
            button.enabled = NO;
            _selectedButton = button;
            
            [button.titleLabel sizeToFit];
            
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;

        }
        
        
    }
    [titlesView addSubview:indicatorView];
}

//点击顶部标签按钮方法
-(void)buttonclick:(UIButton *)button {
    
    MOLog(@"buttonclick");
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;

    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.width = button.titleLabel.width;
        self.indicatorView.centerX = button.centerX;
    }];
    //滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag *self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

//底部的scrollView
- (void)setupContentView{
    
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    

    
    contentView.contentSize = CGSizeMake(contentView.width *self.childViewControllers.count, 0);
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    
    //添加第一个控制器的View
    [self scrollViewDidEndScrollingAnimation:contentView];
}

//设置导航栏
- (void)setupNavContr{
    
    // 设置导航栏标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置导航栏左边的按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target: self action:@selector(tagClick)];
    
    
    // 设置背景色
    self.view.backgroundColor = MOGlobalBg;

    
}

//设置左上角按钮，push到下一个视图控制器方法
- (void)tagClick
{
    MORecommendationTagsViewController *tags = [[MORecommendationTagsViewController alloc]init];
    [self.navigationController pushViewController:tags animated:YES];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
  
    //添加子控制器的View
    
    //当前索引
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;//解决设置控制器View默认值为20
    vc.view.height = scrollView.height;//设置控制器的view默认是比屏幕高度少20
    
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
    
    //通过inset来实现穿透功能
    vc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    
    //设置滚动条的内边距
    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
    
    
    [scrollView addSubview: vc.view];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //这句啥？？？
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    NSInteger index = scrollView.contentOffset.x/scrollView.width;
    
    [self buttonclick:self.titlesView.subviews[index]];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    MOTestViewController *vc = [[MOTestViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end