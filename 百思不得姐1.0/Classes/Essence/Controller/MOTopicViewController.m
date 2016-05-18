//
//  MOTopicViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/27.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOTopicViewController.h"
#import "SVProgressHUD.h"
#import "MOEssenceModel.h"
#import "MOTopicCell.h"
#import "MOCommentViewController.h"
@interface MOTopicViewController ()
/*段子*/
@property (nonatomic,strong) NSMutableArray * topics;
/*当前page*/
@property (nonatomic, assign) NSInteger page;
/*加载下一页数据时需要这个参数*/
@property (nonatomic, copy) NSString * maxTime;
/** 上一次的请求参数 */
@property (nonatomic, strong) NSDictionary *params;

@end

@implementation MOTopicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化表格
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefresh];
}

#pragma ---需重敲
- (NSMutableArray *)topics
{
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}
static NSString *const MOWordCellID = @"word";

- (void)setupTableView
{
    // 设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = MOTitilesViewY + MOTitilesViewH;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    // 设置滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册
    //    [self.tableView registerNib:[UINib nibWithNibName:@"MOWordTableViewCell" bundle:nil] forCellReuseIdentifier:@"word"];
    //
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MOTopicCell class]) bundle:nil] forCellReuseIdentifier:MOWordCellID];
}

- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    // 自动改变透明度
    self.tableView.header.autoChangeAlpha = YES;
    [self.tableView.header beginRefreshing];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadNewTopics{
    
    
    //结束上拉
    [self.tableView.footer endRefreshing];
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        [self.tableView.header endRefreshing];
        
        if (self.params != params)return;
        
        //存储maxtime
        self.maxTime = responseObject[@"info"][@"maxtime"];
        
        //字典转模型
        self.topics = [MOEssenceModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //刷新表格
        
        [self.tableView reloadData];
        
        // 清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 结束刷新
        [self.tableView.header endRefreshing];
    }];
    
}
- (void)loadMoreTopics{
    
    //结束下拉加载
    [self.tableView.header endRefreshing];
    
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    NSInteger page = self.page + 1;
    params[@"page"] = @(page);
    params[@"maxtime"] = self.maxTime;
    self.params = params;
    
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        //结束刷新
        [self.tableView.footer endRefreshing];
        
        if(self.params != params) return;
        
        
        //存储maxtime
        self.maxTime = responseObject[@"info"][@"maxtime"];
        
        //字典转模型
        NSArray *newTopics = [MOEssenceModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        
        //刷新表格
        [self.tableView reloadData];
        
        
        self.page = page;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return ;
        
        //结束刷新
        [self.tableView.footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //第二，创建一个cell，传入循环ID
   MOTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:MOWordCellID];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    MOEssenceModel *topic = self.topics[indexPath.row];
    //    cell.textLabel.text = topic.name;
    //    cell.detailTextLabel.text = topic.text;
    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    cell.topic = self.topics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出帖子模型
    MOEssenceModel *topic = self.topics[indexPath.row];
    

    return topic.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOLogFunc;
    MOCommentViewController *commentVC = [[MOCommentViewController alloc]init];
    
    commentVC.topic =  self.topics[indexPath.row];
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
//
//#import "MOTopicViewController.h"
//#import "MOEssenceModel.h"
//
//@interface  MOTopicViewController()
//
//// 2、添加tableview的数据源
///*帖子*/
//@property (nonatomic,strong) NSMutableArray *topics;
//
//// 15、添加页码属性（用于标记当前页码，因为多个方法会共用一个页码）
///*页码*/
//@property (nonatomic, assign) NSInteger page;
//
//
//@end
//
//@implementation MOTopicViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // 6、调用加载数据的方法
//    [self loadNewTopics];
//}
//
//// 16、添加tableview上下拉刷新
//- (void)setupRefresh
//{
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
//}
//
//// 3、加载新数据
//// 加载帖子
//- (void)loadNewTopics
//{
//    // 5、请求参数(看接口文档)
//    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
//    parmas[@"a"] = @"list";
//    parmas[@"c"] = @"data";
//    parmas[@"type"] = @"29";
//
//    // 4、网络请求 用AF
//    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:parmas success:^(NSURLSessionDataTask *task, id responseObject) {
//        // 7、打印下是否有数据（检验接口是否通畅）
//
//        // 8、创建数据模型
//
//        // 9、将字典数组 转换成 模型数组
//        self.topics = [MOEssenceModel objectArrayWithKeyValuesArray:responseObject[@"list"]];
//
//        // 14、tableview刷新
//        [self.tableView reloadData];
//        MOLog(@"%@", responseObject);
//
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
//
//}
//
//// 加载更多帖子
//- (void)loadMoreTopics
//{
//
//}
//
//
//#pragma mark - UITableviewDelegate
//// 1、简单写出tableview必须实现的代理
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return self.topics.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
//    }
//
//    // 10、数据源有值以后呢，检验下代理是否调用，现在给cell的textLabel赋值
//
//    // 11、取出一个模型
//    MOEssenceModel *model = self.topics[indexPath.row];
//
//    // 12、给cell.textLabel.text赋值
//    cell.textLabel.text = model.text;
//
//    // 13、发现没数据，那么就很有可能，tableview没刷新
//
//    return cell;
//}
//
//
//
//@end

