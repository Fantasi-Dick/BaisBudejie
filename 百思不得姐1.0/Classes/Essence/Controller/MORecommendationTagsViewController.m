//
//  MORecommendationTagsViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/21.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MORecommendationTagsViewController.h"
#import "MORecommendationTags.h"
#import "MORecommendationTagsCell.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

@interface MORecommendationTagsViewController ()

/*标签数据模型*/
@property (nonatomic, strong) NSMutableArray * tagsData;

@end

@implementation MORecommendationTagsViewController

static NSString *const MOTagsID = @"tags";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableView];
    
    [self refreshData];
    
    
}

- (void)refreshData
{
    
    //请求数据
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    
    [[AFHTTPSessionManager manager]GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        self.tagsData = [MORecommendationTags objectArrayWithKeyValuesArray:responseObject];
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
    
}

- (void)setTableView
{
    
    //加载TableView
    self.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MORecommendationTagsCell class]) bundle:nil] forCellReuseIdentifier:MOTagsID];
    self.tableView.backgroundColor = MOGlobalBg;

    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _tagsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MORecommendationTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:MOTagsID  forIndexPath:indexPath];
    
    cell.tags = _tagsData[indexPath.row];
    
    return cell;
}



@end
