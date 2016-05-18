//
//  MORecommendationViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/4/15.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MORecommendationViewController.h"
#import "SVProgressHUD.h"
#import "MORecommendationCategoryCell.h"
#import "MJExtension.h"
#import "MORecommendationCategory.h"
#import "MORecommendationUserCell.h"
#import "MORecommendationUser.h"
#import "MJRefresh.h"

//定义被选中category的用户数组数据
#define MOSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface MORecommendationViewController () <UITableViewDataSource,UITableViewDelegate>

/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

/** 右边的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;

/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;

/** AFN请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;



@end

@implementation MORecommendationViewController

static NSString *const MOCategoryId = @"category";
static NSString *const MOUserId = @"user";

#pragma -- 懒加载<管理是否请求数据，须解释>

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        
    }
    return _manager;
}


//控制器渲染

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //控件的初始化
    [self setupTableView];

    
    // 添加刷新控件
    
    [self setupRefresh];

    
    // 加载左侧的类别数据
    [self loadCategories];

    

}

//刷新左侧标签数据
- (void)loadCategories
{
    // 显示指示器
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    // 发送请求（固定格式）
    //1、创建可变字典请求参数，后转成模型
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    
    //请求数据成功以及失败处理
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
    
        
    // 隐藏指示器
        [SVProgressHUD dismiss];
        
    // 服务器返回的JSON数据，将字典转成categories模型数据
        self.categories = [MORecommendationCategory objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
    // 刷新标签数据list表格
        [self.categoryTableView reloadData];
        
    // 默认一进入选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    // 让用户表格进入下拉刷新状态。与默认进入同时使用，效果佳
        [self.userTableView.header beginRefreshing];
    
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // 显示失败信息
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
    }];
}


//创建TableView，包括左侧标签与右侧用户数据
- (void)setupTableView{
    
    //注册左侧TabelView xib
    
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MORecommendationCategoryCell class]) bundle:nil] forCellReuseIdentifier:MOCategoryId];
    
    
    //注册右侧TabelView xib
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MORecommendationUserCell class]) bundle:nil] forCellReuseIdentifier:MOUserId];
    
    
    //设置inset，解决顶部被挡的问题
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    
    
    //设置基础属性，标题，背景色
    self.title = @"推荐关注";


    self.view.backgroundColor = MOGlobalBg;
    self.categoryTableView.backgroundColor = MOGlobalBg;
    self.userTableView.backgroundColor = MOGlobalBg;

//    self.categoryTableView.tableFooterView = [UIView new];
}


/**
* 添加刷新控件
*/
- (void)setupRefresh
{
 
    //MJRefresh中的header -- footer刷新方法
    //下拉刷新新数据--头部
    self.userTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
   
    //上拉加载旧数据---底部
    self.userTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    
    //刷新完毕隐藏footer
    self.userTableView.footer.hidden = YES;
}

- (void)loadNewUsers
{
    //创建左侧被选中标签 对象
    MORecommendationCategory *rc = MOSelectedCategory;
    
    // 设置当前页码为1
    rc.currentPage = 1;
    
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.pID);
    params[@"page"] =@(rc.currentPage);
    self.params = params;
    
    // 发送请求给服务器, 加载右侧的数据
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [MORecommendationUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 清除所有旧数据，
        [rc.users removeAllObjects];
        
        // 添加到当前类别对应的用户数组中
        [rc.users addObjectsFromArray:users];
        
        // 保存总数
        rc.total = [responseObject[@"total"] integerValue];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.userTableView reloadData];
        
        // 结束刷新
        [self.userTableView.header endRefreshing];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 结束刷新
        [self.userTableView.header endRefreshing];
    }];
}

- (void)loadMoreUsers
{
    MORecommendationCategory *category = MOSelectedCategory;
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.pID);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 字典数组 -> 模型数组
        NSArray *users = [MORecommendationUser objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        
        // 不是最后一次请求
        if (self.params != params) return;
        
        // 刷新右边的表格
        [self.userTableView reloadData];
        
        // 让底部控件结束刷新
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (self.params != params) return;
        
        // 提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
        
        // 让底部控件结束刷新
        [self.userTableView.footer endRefreshing];
    }];
}

/**
 * 时刻监测footer的状态
 */
- (void)checkFooterState
{
    MORecommendationCategory *rc = MOSelectedCategory;
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.userTableView.footer.hidden = (rc.users.count == 0);
    
    // 让底部控件结束刷新
    if (rc.users.count == rc.total) { // 全部数据已经加载完毕
        [self.userTableView.footer noticeNoMoreData];
    } else { // 还没有加载完毕
        [self.userTableView.footer endRefreshing];
    }
}

#pragma - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 左边的类别表格
    if (tableView == self.categoryTableView) return self.categories.count;
    
    // 监测footer的状态
    [self checkFooterState];
    
    // 右边的用户表格
    return [MOSelectedCategory users].count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置标识
    if (tableView == self.categoryTableView) {
        MORecommendationCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:MOCategoryId];
        
        //设置下标(超级不熟)
        cell.category = self.categories[indexPath.row];

         return cell;
        
    }else{

        MORecommendationUserCell *cell = [tableView dequeueReusableCellWithIdentifier:MOUserId];
       

        
        cell.user = [MOSelectedCategory users][indexPath.row];
        

         return cell;
        

    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.categoryTableView) {
        return 45;
    }else{
        return 70;
    }
  
}

#pragma - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //结束刷新
    [self.userTableView.header endRefreshing];
    [self.userTableView.footer endRefreshing];
    
    MORecommendationCategory *c = self.categories[indexPath.row];
    

    if (c.users.count) {
        // 显示曾经的数据
        [self.userTableView reloadData];
    } else {
        // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.userTableView reloadData];
        
        // 进入下拉刷新状态
        [self.userTableView.header beginRefreshing];
    }
    
    
}
#pragma mark - 控制器的销毁
- (void)dealloc
{
    // 停止所有操作
    [self.manager.operationQueue cancelAllOperations];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
