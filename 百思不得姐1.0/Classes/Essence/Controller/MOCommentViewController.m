//
//  MOCommentViewController.m
//  百思不得姐1.0
//
//  Created by Andy_Lin on 16/5/12.
//  Copyright © 2016年 Andy_Lin. All rights reserved.
//

#import "MOCommentViewController.h"
#import "MOTopicCell.h"
#import "MOEssenceModel.h"
#import "MOCommentModel.h"
#import "MOCommentCell.h"


@interface MOCommentViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;


@property (weak, nonatomic) IBOutlet UITableView *tableViewComment;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotComments;
/** 最新评论 */
@property (nonatomic, strong) NSMutableArray *latestComments;

@end

static NSString * const MOCommentId = @"comment";
@implementation MOCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //控制器View的基本设置
    [self setupBasic];
    
    //tableView的顶部设置
    [self setupHeader];
    
    
    [self setupRefresh];

    
   
}

- (void)setupRefresh{
//    [self.tableViewComment.header setRefreshingAction:@selector(loadNewComments)];
   
    self.tableViewComment.header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
//
    [self.tableViewComment.header beginRefreshing];
    
}

- (void)loadNewComments{
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    MOLog(@"self.topic.ID = %@", self.topic.ID);
//    params[@"page"] = @(page);
//    XMGComment *cmt = [self.latestComments lastObject];
//    params[@"lastcid"] = cmt.ID;
    
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php"  parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        self.hotComments = [MOCommentModel objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        self.latestComments = [MOCommentModel objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        [self.tableViewComment reloadData];
        [self.tableViewComment.header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.tableViewComment.header endRefreshing];
    }];
    
}

- (void)setupHeader{
    
    //设置header
    UIView *header = [[UIView alloc]init];
    header.height = self.topic.cellHeight + MOTopicCellMargin;
    
    //添加cell
    MOTopicCell *cell = [MOTopicCell cell];
    cell.topic = self.topic;
    cell.size = CGSizeMake(MAINSCREENWIDTH, self.topic.cellHeight);
    [header addSubview:cell];
    
//    self.tableViewComment.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    
    //设置header
    self.tableViewComment.tableHeaderView = header;
    
}

- (void)setupBasic{
    
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:nil action:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.tableViewComment.backgroundColor = MOGlobalBg;
   
//    self.tableViewComment.estimatedRowHeight = 94;
//    self.tableViewComment.rowHeight = UITableViewAutomaticDimension;
    //注册xib
      [self.tableViewComment registerNib:[UINib nibWithNibName:NSStringFromClass([MOCommentCell class]) bundle:nil] forCellReuseIdentifier:MOCommentId];
}

- (void)keyboardWillChangeFrame: (NSNotification *)note{
    //键盘显示/隐藏完毕的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //修改底部约束
    self.bottomSpace.constant = MAINSCREENHEIGHT - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo [UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    //动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma ---tableView 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat rowHeight = 55;
    return rowHeight;
   
}

#pragma  --- tableView datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    
//    NSInteger hotCount = self.hotComments.count;
//    NSInteger latestCount = self.latestComments.count;
//    if (hotCount) {
//        return 2;
//    }else if(latestCount){
//        return 1;
//    }
//    return  0;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSInteger hotCount = self.hotComments.count;
//    NSInteger latestCount = self.latestComments.count;
//    if (section == 0 ) {
//      return   hotCount ? hotCount : latestCount;
//    }
//    return latestCount;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    
//    NSInteger hotCount = self.hotComments.count;
//    
//    if (section == 0) {
//        return hotCount? @"最热评论": @"最新评论";
//    }
//    return  @"最新评论";
- (NSArray *)commentsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.hotComments.count ? self.hotComments : self.latestComments;
    }
    return self.latestComments;
}

- (MOCommentModel *)commentInIndexPath:(NSIndexPath *)indexPath
{
    return [self commentsInSection:indexPath.section][indexPath.row];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    
    if (hotCount) return 2; // 有"最热评论" + "最新评论" 2组
    if (latestCount) return 1; // 有"最新评论" 1 组
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if (section == 0) {
        return hotCount ? hotCount : latestCount;
    }
    
    // 非第0组
    return latestCount;
}
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MOCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:MOCommentId];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
//    }

//    //    // 12、给cell.textLabel.text赋值
//    MOCommentModel *model = self.latestComments[indexPath.row];
//    cell.textLabel.text = model.content;
    cell.comment = [self commentInIndexPath:indexPath];
   
    return cell;
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
