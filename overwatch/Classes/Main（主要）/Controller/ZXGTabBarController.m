//
//  ZXGTabBarController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/15.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "ZXGTabBarController.h"
#import "ZXGNavigationController.h"
#import "HomeViewController.h"
#import "HeroCollectionViewController.h"
#import "CorrelationTableViewController.h"
#import "CollectionTableViewController.h"
#import "ZXGTabBar.h"

@interface ZXGTabBarController () <ZXGTabBarDelegate>
@property (nonatomic, weak) ZXGTabBar *customTabBar;
@property (nonatomic, strong) HomeViewController *oneVC;
@end

@implementation ZXGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化tabbar
    [self setUpTabBar];
    // 初始化所有的子控制器
    [self setUpAllChildViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}

//初始化tabbar
- (void)setUpTabBar
{
    ZXGTabBar *customTabBar = [[ZXGTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(ZXGTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
    
    //在首页，点击”首页“按钮，下拉刷新
    if (from == to && to == 0) {
        [self.oneVC initData];
    }
}

//添加所有子控制器
- (void)setUpAllChildViewController
{
    //添加第一个子控制器
    HomeViewController *oneVC = [[HomeViewController alloc] init];
    [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_highlighted"] title:@"首页"];
    self.oneVC = oneVC;
    //添加第二个子控制器
    HeroCollectionViewController *twoVC = [[HeroCollectionViewController alloc] init];
    [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@"radar_icon_people"] selectedImage:[UIImage imageNamed:@"radar_icon_people_selected"] title:@"英雄"];
    //添加第三个子控制器
    CollectionTableViewController *threeVC = [[CollectionTableViewController alloc] init];
    [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@"toolbar_unfavorite"] selectedImage:[UIImage imageNamed:@"toolbar_unfavorite_highlighted"] title:@"收藏"];
    //添加第四个子控制器
    CorrelationTableViewController *fourVC = [[CorrelationTableViewController alloc] init];
    [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@"navigationbar_setting"] selectedImage:[UIImage imageNamed:@"navigationbar_account_edit_highlighted"] title:@"关于"];
}

/**
 *  添加一个子控制器
 *
 *  @param viewController 需要初始化的子控制器
 *  @param image          图标
 *  @param selectedImage  选中的图标
 *  @param title          标题
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    ZXGNavigationController *navC = [[ZXGNavigationController alloc]initWithRootViewController:viewController];
    navC.tabBarItem.title = title;
    navC.tabBarItem.image = image;
    navC.tabBarItem.selectedImage = selectedImage;
    viewController.navigationItem.title = title;
    [self addChildViewController:navC];
    
    [self.customTabBar addTabBarButtonWithItem:navC.tabBarItem];
}

@end
