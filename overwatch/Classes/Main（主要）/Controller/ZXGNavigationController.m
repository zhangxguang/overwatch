//
//  ZXGNavigationController.m
//  overwatch
//
//  Created by 张祥光 on 15/9/15.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "ZXGNavigationController.h"

@interface ZXGNavigationController ()

@end

@implementation ZXGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 *  第一次使用这个类的时候就会调用（一个类只会调用一次）
 */
+ (void)initialize
{
    //取出导航栏 appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    //设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    //字体颜色
    textAttrs[UITextAttributeTextColor] = [UIColor orangeColor];
    [navBar setTitleTextAttributes:textAttrs];
    
    //设置backbarbuttonitem的颜色
    navBar.barStyle = UIStatusBarStyleDefault;
    [navBar setTintColor:[UIColor orangeColor]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次push一个新的viewController都隐藏TabBar,但是如果只有一个时就不隐藏
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
