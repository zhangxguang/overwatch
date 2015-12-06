//
//  CorrelationTableViewController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/15.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "CorrelationTableViewController.h"
#import "Public.h"
#import "CorrelationFirstCell.h"
#import "CorrelationNormalCell.h"
#import "UIImageView+WebCache.h"

@interface CorrelationTableViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataArray;
@end

@implementation CorrelationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@[@[@"Image_head.png",@"清除缓存"]],
                       @[@[@"Image_head.png",@"去App Store评个5分吧"],
                         @[@"Image_head.png",@"转给朋友"],
                         @[@"Image_head.png",@"欢迎页"]],
                       @[@[@"Image_head.png",@"投稿说明"],
                         @[@"Image_head.png",@"意见反馈"],
                         @[@"Image_head.png",@"关注我们的微博"],
                         @[@"Image_head.png",@"关于我们"]]];
    
    [self initTableView];
}

-(void)initTableView;
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height) style:UITableViewStyleGrouped];
    
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

////隐藏状态栏
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
            
        case 1:
        {
            return 1;
        }
            break;
            
        case 2:
        {
            return 3;
        }
            break;
            
        case 3:
        {
            return 4;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CorrelationFirstCell *cell = [CorrelationFirstCell cellWithTableView:tableView];
        return cell;
    }else{
        
        CorrelationNormalCell *cell = [CorrelationNormalCell cellWithTableView:tableView];
        cell.array = self.dataArray[indexPath.section - 1][indexPath.row];
        
        if (indexPath.section == 1) {
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        }
        
        return cell;
    }
}

#pragma mark - 点击cell时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {//清除缓存
        
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        CGFloat cachflt = [self folderSizeAtPath:cachPath];
        NSString *str = [NSString stringWithFormat:@"是否清除 %0.2fM 缓存？", cachflt];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self clearCache];
            
        }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 设置cell的高度，heightForHeaderInSection，heightForFooterInSection
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 85*KWidth_Scale;
    }
    
    return 50*KWidth_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35*KWidth_Scale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 清除缓存相关方法

//计算单个文件大小
- (CGFloat)fileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算文件夹大小
- (CGFloat)folderSizeAtPath:(NSString *)path
{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    CGFloat folderSize = 0.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

//清理缓存
-(void) clearCache
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
            });
}

@end
