//
//  HJTTableViewController.m
//  mvvmrac
//
//  Created by hejintao on 16/10/11.
//  Copyright © 2016年 hejintao. All rights reserved.
//

#import "HJTTableViewController.h"
#import "SXNewsCell.h"
#import "NewsViewModel.h"

#import "HJTTestViewController.h"

@interface HJTTableViewController ()
@property(nonatomic,strong) NSMutableArray *arrayList;
@property(nonatomic,assign)BOOL update;
@property(nonatomic,strong)NewsViewModel *viewModel;
@end

@implementation HJTTableViewController
- (NewsViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[NewsViewModel alloc]init];
    }
    return _viewModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 200.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = [UIColor whiteColor];
    __weak HJTTableViewController *weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.update = YES;
   
}



- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.update == YES) {
        [self.tableView.mj_header beginRefreshing];
        self.update = NO;
    }
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    NSString *allUrlstring = @"/nc/article/headline/T1348647853363/0-20.html";
    [self loadDataForType:1 withURL:allUrlstring];
}

// ------上拉加载
- (void)loadMoreData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/headline/T1348647853363/%ld-20.html",(self.arrayList.count - self.arrayList.count%10)];
    [self loadDataForType:2 withURL:allUrlstring];
}

// ------公共方法
- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    @weakify(self)
    [[self.viewModel.fetchNewsEntityCommand execute:allUrlstring]subscribeNext:^(NSArray *arrayM) {
        @strongify(self)
        if (type == 1) {
            self.arrayList = [arrayM mutableCopy];
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

#pragma mark -
#pragma mark tableView datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsEntity *newsModel = self.arrayList[indexPath.row];
    NSString *ID = [SXNewsCell idForRow:newsModel];
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    SXNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.NewsModel = newsModel;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NewsEntity *newsModel = self.arrayList[indexPath.row];
//    CGFloat rowHeight = [SXNewsCell heightForRow:newsModel];
//    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
//        rowHeight = 80;
//    }
//    return rowHeight;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
    
    HJTTestViewController *HJTTestViewVc = [[HJTTestViewController alloc]init];
    [self.navigationController pushViewController:HJTTestViewVc animated:YES];
    
    
}


@end
