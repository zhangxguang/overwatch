//
//  HomeViewController.m
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeNormalCell.h"
#import "HomeImageCell.h"
#import "NetworkSingleton.h"
#import "MJExtension.h"
#import "HomeNormalCellData.h"
#import "HomeImageCellData.h"
#import "InfochildData.h"
#import "PictuerData.h"
#import "PictureInfoData.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "WebViewController.h"
#import "Public.h"

#define NewDataUrl @"http://cache.tuwan.com/app/?appid=1&dtid=57067&appid=1&appver=2.1"
#define MoreDataUrl @"http://cache.tuwan.com/app/?appid=1&dtid=57067&appid=1&appver=2.1&start="

@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray *homeData;
@property (nonatomic, weak) UILabel *promptlabel;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self setupHomeData];
    
    //下拉刷新 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //上拉加载 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)initData
{
    self.tableView.mj_header.state = MJRefreshStateRefreshing;
}

//加载数据
- (void)setupHomeData
{
    NSString *url = NewDataUrl;
    
    [[NetworkSingleton sharedManager] getResultWithParameter:nil url:url successBlock:^(id responseBody) {
        
        self.homeData = [HomeImageCellData mj_objectArrayWithKeyValuesArray:responseBody[@"data"][@"list"]];
        // 刷新表格
        [self.tableView reloadData];
        
    } failureBlock:^(NSString *error) {
        
    }];
}

//下拉刷新
- (void)loadNewData
{
    NSString *url = NewDataUrl;
    
    [[NetworkSingleton sharedManager] getResultWithParameter:nil url:url successBlock:^(id responseBody) {
        //当前显示的数组中的第一个
        HomeImageCellData *firstData = self.homeData[0];
        //下拉刷新后得到的数组
        NSMutableArray *newDataArray = [NSMutableArray array];
        //真正需要显示的数组
        NSMutableArray *addArray = [NSMutableArray array];
        
        newDataArray = [HomeImageCellData mj_objectArrayWithKeyValuesArray:responseBody[@"data"][@"list"]];
        
        for (HomeImageCellData *data in newDataArray) {
            if ([data.aid longLongValue] > [firstData.aid longLongValue]) {
                [addArray addObject:data];
            }
        }
        
        //设置提示label
        [self setupPromptlabel];
        
        if (addArray.count == 0) {
            self.promptlabel.text = @"没有新闻~~~";
            self.promptlabel.hidden = NO;
            //0.75秒后移除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.promptlabel.hidden = YES;
            });
        }else{
            self.promptlabel.text = [NSString stringWithFormat:@"已经更新%lu条新闻", (unsigned long)addArray.count];
            self.promptlabel.hidden = NO;
            //0.75秒后移除
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.promptlabel.hidden = YES;
            });
        }
        
        [addArray addObjectsFromArray:self.homeData];
        //替换
        self.homeData = addArray;
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        
    }];
}

//上拉加载
- (void)loadMoreData
{
    NSString *url = [NSString stringWithFormat:@"%@%lu", MoreDataUrl, (unsigned long)self.homeData.count];
    
    [[NetworkSingleton sharedManager] getResultWithParameter:nil url:url successBlock:^(id responseBody) {
        
        NSMutableArray *array = [HomeImageCellData mj_objectArrayWithKeyValuesArray:responseBody[@"data"][@"list"]];
        
        [self.homeData addObjectsFromArray:array];
        
        // 刷新表格
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failureBlock:^(NSString *error) {
        
    }];
}

//懒加载homeData
- (NSMutableArray *)homeData
{
    if (_homeData == nil){
        _homeData = [NSMutableArray array];
    }
    return _homeData;
}

//设置提示label
- (void)setupPromptlabel
{
    UILabel *promptlabel = [[UILabel alloc] init];
    promptlabel.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44);
    promptlabel.backgroundColor = RGBA(247, 247, 247, 1.0);
    promptlabel.text = @"";
    promptlabel.textAlignment = NSTextAlignmentCenter;
    promptlabel.font = [UIFont systemFontOfSize:16];
    promptlabel.textColor = [UIColor orangeColor];
    [self.view.superview addSubview:promptlabel];
    self.promptlabel = promptlabel;
    self.promptlabel.hidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    //删除广告
//    for (HomeImageCellData *data in self.homeData) {
//        if ([data.Typename isEqualToString:@"推广"]) {
//            [self.homeData removeObject:data];
//        }
//    }
    
//    NSLog(@"numberOfRowsInSection %lu", (unsigned long)self.homeData.count);
    
    return self.homeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeImageCellData *data = self.homeData[indexPath.row];
    
    if ([data.showtype  isEqualToString: @"1"]) {
        
        //创建cell
        HomeImageCell *cell = [HomeImageCell cellWithTableView:tableView];
        //设置cell的数据
        cell.data = data;
        
        return cell;
    }else{
        
        //创建cell
        HomeNormalCell *cell = [HomeNormalCell cellWithTableView:tableView];
        //设置cell的数据
        cell.data = data;
        
        return cell;
    }
}

#pragma mark - 点击cell时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeImageCellData *data = self.homeData[indexPath.row];
    
    WebViewController *wbc = [[WebViewController alloc] init];

    if ([data.type isEqualToString:@"video"]) {
        wbc.url = [NSURL URLWithString:data.murl];
    }else if ([data.type isEqualToString:@"pic"]) {
        wbc.url = [NSURL URLWithString:data.murl];
    }else{
        wbc.url = [NSURL URLWithString:data.html5];
    }

    [self.navigationController pushViewController:wbc animated:YES];
}

#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     HomeImageCellData *data = self.homeData[indexPath.row];
    if ([data.showtype  isEqual: @"1"]) {
        return 120;
    }
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
