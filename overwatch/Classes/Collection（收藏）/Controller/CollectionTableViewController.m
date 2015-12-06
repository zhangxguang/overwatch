//
//  CollectionTableViewController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/15.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "CollectionTableViewController.h"
#import "CollectionHeroFrame.h"
#import "HeroMessage.h"
#import "CollectionTableViewCell.h"
#import "WMPageController.h"
#import "HeroMessageViewController.h"
#import "HeroAbilitesTableController.h"
#import "HeroStoriesTableController.h"

@interface CollectionTableViewController ()
@property (nonatomic, strong) NSMutableArray *CollectionHeroFrames;
@property (nonatomic, strong) NSMutableArray *CollectionHeroArray;
@property (nonatomic, weak) UILabel *promptlabel;
@end

@implementation CollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加提示label
    [self setupPromptlabel];
}

//view即将显示时，刷新表格
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //刷新表格
    [self.tableView reloadData];
    //判断是否显示提示label
    if (self.CollectionHeroArray.count == 0) {
        self.promptlabel.hidden = NO;
    }else{
        self.promptlabel.hidden = YES;
    }
}

//提示label
- (void)setupPromptlabel
{
    UILabel *promptlabel = [[UILabel alloc] init];
    promptlabel.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    promptlabel.text = @"你还没有收藏任何英雄~~~";
    promptlabel.textAlignment = NSTextAlignmentCenter;
    promptlabel.font = [UIFont systemFontOfSize:16];
    promptlabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:promptlabel];
    self.promptlabel = promptlabel;
    self.promptlabel.hidden = YES;
}

//收藏英雄的数组
- (NSArray *)CollectionHeroArray
{
    //从plist文件中取出数组
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"herodata.plist"];
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *heroArray = [NSMutableArray array];
    //遍历 data 数组，然后把名字相同的英雄加入数组
    for (NSString *name in data) {
        for (int i = 0; i < self.CollectionHeroFrames.count; i++) {
            CollectionHeroFrame *messageFrame = self.CollectionHeroFrames[i];
            if ([name isEqualToString:messageFrame.message.name]) {
                [heroArray addObject:messageFrame];
            }
        }
    }
    _CollectionHeroArray = heroArray;
    return _CollectionHeroArray;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//plist转模型
- (NSArray *)CollectionHeroFrames
{
    if (_CollectionHeroFrames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroMessages.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *cfArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            HeroMessage *message = [HeroMessage messageWithDict:dict];
            
            CollectionHeroFrame *cf = [[CollectionHeroFrame alloc] init];
            cf.message = message;
            
           [cfArray addObject:cf];
        }
        _CollectionHeroFrames = cfArray;
    }
    return _CollectionHeroFrames;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CollectionHeroArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    CollectionTableViewCell *cell = [CollectionTableViewCell cellWithTableView:tableView];
    //传递cell数据
    cell.CollectionHeroFrameFrame = self.CollectionHeroArray[indexPath.row];
    return cell;
    
}

#pragma mark - tableView的代理方法
/**
 *  如果实现了这个方法,就自动实现了滑动删除的功能
 *  @param editingStyle 编辑的行为
 *  @param indexPath    操作的行号
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //从plist文件中取出数组
        NSString *home = NSHomeDirectory();
        NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
        NSString *filePath = [docPath stringByAppendingPathComponent:@"herodata.plist"];
        NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filePath];
        //获取当前英雄数据
        CollectionHeroFrame *messageFrame = self.CollectionHeroArray[indexPath.row];
        //遍历数组，找出与当前英雄名字相同的字符串
        for (NSString *name in data) {
            //如果字符串与当前英雄名字相同，则把字符串从数组中删除，然后把数组重新存入文件
            if ([name isEqualToString:messageFrame.message.name]) {
                //修改数组
                [data removeObject:name];
                //存入文件
                [data writeToFile:filePath atomically:YES];
                break;
            }
        }
        //刷新表格
        [self.tableView reloadData];
        //判断是否显示提示label
        if (self.CollectionHeroArray.count == 0) {
            self.promptlabel.hidden = NO;
        }else{
            self.promptlabel.hidden = YES;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建pageController
    WMPageController *pageController = [self pageControllerStyleFlood];
    //根据所选cell得到对应的英雄详细数据
    CollectionHeroFrame *cmessageFrame = self.CollectionHeroArray[indexPath.row];
    for (int i = 0; i < self.CollectionHeroFrames.count; i++) {
        CollectionHeroFrame *messageFrame = self.CollectionHeroFrames[i];
        if ([cmessageFrame.message.name isEqualToString:messageFrame.message.name]) {
            pageController.indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    //设置pageController
    pageController.title = @"英雄介绍";
    [self.navigationController pushViewController:pageController animated:YES];
}

#pragma mark - WMPageController的方法
- (WMPageController *)pageControllerStyleFlood
{
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
        Class vcClass;
        NSString *title;
        switch (i % 3) {
            case 0:
                vcClass = [HeroMessageViewController class];
                title = @"概述";
                break;
            case 1:
                vcClass = [HeroAbilitesTableController class];
                title = @"技能";
                break;
            default:
                vcClass = [HeroStoriesTableController class];
                title = @"故事";
                break;
        }
        [viewControllers addObject:vcClass];
        [titles addObject:title];
    }
    
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
    pageVC.titleSizeSelected = 15;
    pageVC.pageAnimatable = YES;
    pageVC.menuViewStyle = WMMenuViewStyleFoold;
    //被选中的文字颜色
    pageVC.titleColorSelected = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    //文字颜色
    pageVC.titleColorNormal = [UIColor orangeColor];
    //
    pageVC.progressColor = [UIColor orangeColor];
    //设置不同的宽度
    pageVC.itemsWidths = @[@(70),@(70),@(70)];
    
    return pageVC;
}

#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionHeroFrame *cf = self.CollectionHeroFrames[indexPath.row];
    return cf.cellHeight;
}
@end
