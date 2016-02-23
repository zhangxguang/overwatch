//
//  HeroAbilitesTableController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroAbilitesTableController.h"
#import "HeroAbilities.h"
#import "HeroAbilitesFrame.h"
#import "HeroAbilitesTableViewCell.h"
#import "MoviePlayerViewController.h"

@interface HeroAbilitesTableController()
@property (nonatomic, strong) NSMutableArray *AbilitiesFrame;
@property (nonatomic, strong) MoviePlayerViewController *playerController;
@property (nonatomic, copy) NSString *urlStr;
@end

@implementation HeroAbilitesTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动条为白色
    self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSMutableArray *)AbilitiesFrame
{
    if (_AbilitiesFrame == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroAbilites.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *afArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray[self.indexPath.row]) {
            HeroAbilities *abilities = [HeroAbilities abilitiesWithDict:dict];
            
            HeroAbilitesFrame *af = [[HeroAbilitesFrame alloc] init];
            af.abilities = abilities;
            
            [afArray addObject:af];
        }
        _AbilitiesFrame = afArray;
    }
    return _AbilitiesFrame;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.AbilitiesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
 {
     //创建cell
     HeroAbilitesTableViewCell *cell = [HeroAbilitesTableViewCell cellWithTableView:tableView];
     //使cell无法被点击
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     //设置pictureButton的tag
     cell.pictureButton.tag = indexPath.row;
     //点击技能按钮时调用pictureViewClick:方法
     [cell.pictureButton addTarget:self action:@selector(pictureViewClick:) forControlEvents:UIControlEventTouchUpInside];
     
     cell.abilitiesFrame = self.AbilitiesFrame[indexPath.row];
     
    return cell;
}

#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeroAbilitesFrame *af = self.AbilitiesFrame[indexPath.row];
    
    return af.cellHeight;
}

#pragma mark - 播放网络视频
//点击技能按钮时调用,播放网络视频
- (void)pictureViewClick:(UIButton *)button
{
    //根据button.tag找到相应cell内网络视频的url
    HeroAbilitesFrame *af = self.AbilitiesFrame[button.tag];
    self.urlStr = af.abilities.url;
    //以模态弹出窗口，播放网络视频
    [self presentViewController:self.playerController animated:YES completion:nil];
}

- (MoviePlayerViewController *)playerController
{
    if (!_playerController) {
        _playerController = [[MoviePlayerViewController alloc] init];
        _playerController.delegate = self;
        _playerController.movieURL = [NSURL URLWithString:self.urlStr];
    }
    return _playerController;
}

- (void)moviePlayerDidFinished
{
    // dismissViewControllerAnimated 将当前视图控制器的模态窗口关闭
    [self dismissViewControllerAnimated:YES completion:nil];
    //设置playerController为nil，不影响下次的网络视频播放
    self.playerController = nil;
}

@end
