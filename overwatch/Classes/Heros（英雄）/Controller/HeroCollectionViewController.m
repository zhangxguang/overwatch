//
//  HeroCollectionViewController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/15.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "HeroCollectionViewController.h"
#import "HeroCollectionLayout.h"
#import "HeroMessage.h"
#import "HeroCollectionViewCell.h"
#import "HeroNameView.h"
#import "WMPageController.h"
#import "HeroMessageViewController.h"
#import "HeroAbilitesTableController.h"
#import "HeroStoriesTableController.h"
#import "Masonry.h"

#define Width [UIScreen mainScreen].bounds.size.width
static NSString * const reuseIdentifier = @"Cell";

@interface HeroCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) HeroCollectionLayout *lineLayout;
@property (nonatomic, strong) NSArray *Heromessages;
@property (nonatomic, strong) HeroNameView *nameView;
@end

@implementation HeroCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加collectionView
    [self.view addSubview:self.collectionView];
    //添加NameView
    [self setupNameView];
}

//添加collectionView
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //设置layout
        _lineLayout = [[HeroCollectionLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                             collectionViewLayout:_lineLayout];
        //背景颜色
        _collectionView.backgroundColor = [UIColor whiteColor];
        //隐藏滚动条
        _collectionView.showsHorizontalScrollIndicator = NO;
        //设置数据源
        _collectionView.dataSource = self;
        //设置代理
        _collectionView.delegate = self;
        //背景图片，模糊效果的图片
        _collectionView.backgroundView = self.imageView;
        
        //设置cell
        [_collectionView registerClass:[HeroCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    }
    return _collectionView;
}

//添加NameView
- (void)setupNameView
{
    HeroNameView *nameView = [[HeroNameView alloc] init];
    //初始时显示第一个英雄的信息
    HeroMessage *message = self.Heromessages[0];
    nameView.NameLabel.text = message.name;
    nameView.TypeLabel.text = message.role;
    [self.view addSubview:nameView];
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@200);
        make.height.mas_equalTo(@70);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).with.offset(-50);
    }];
    self.nameView = nameView;
}

- (NSArray *)Heromessages
{
    if (_Heromessages == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HeroMessages.plist" ofType:nil];
        
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *messagesArray = [NSMutableArray array];
        
        for (NSDictionary *dict in dictArray) {
            HeroMessage *messages = [HeroMessage messageWithDict:dict];
            
            [messagesArray addObject:messages];
        }
        _Heromessages = messagesArray;
    }
    return _Heromessages;
}

#pragma mark - 背景图片，模糊效果的图片
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //图片来源 初始是第一个英雄的图片
        HeroMessage *message = self.Heromessages[0];
        _imageView.image = [UIImage imageNamed:message.picture];
        //iOS8开始可以使用UIVisualEffectView实现毛玻璃效果
        UIView *visView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        visView.frame = self.view.bounds;
        visView.alpha = 1.0;
        [_imageView addSubview:visView];
    }
    return _imageView;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.Heromessages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    HeroCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //取出模型
    HeroMessage *message = self.Heromessages[indexPath.row];
    //设置图片
    cell.imageView.image = [UIImage imageNamed:message.picture];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
//view停止滚动时调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滚动距离
    CGFloat offsetX = scrollView.contentOffset.x;
    //单个item的宽度加上最小间距
    CGFloat width = self.lineLayout.itemSize.width + self.lineLayout.minimumLineSpacing;
    //上面两者相除得出已经滚动过去的item的个数
    NSInteger item = offsetX/width;
    
    HeroMessage *message = self.Heromessages[item];
    
    //改变HeroNameView.NameLabel和NameView.TypeLabel 的文字
    self.nameView.NameLabel.text = message.name;
    self.nameView.TypeLabel.text = message.role;
    //改变背景图
    NSString *imageName1 = message.picture;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.5f animations:^{
        weakSelf.imageView.image = [UIImage imageNamed:imageName1];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WMPageController *pageController = [self pageControllerStyleFlood];
    
    pageController.indexPath = indexPath;
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
    pageVC.progressColor = [UIColor orangeColor];
    // 设置不同的宽度
    pageVC.itemsWidths = @[@(70),@(70),@(70)];
    
    return pageVC;
}

@end
