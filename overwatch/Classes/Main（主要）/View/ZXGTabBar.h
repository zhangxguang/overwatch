//
//  ZXGTabBar.h
//  overwatch
//
//  Created by 张祥光 on 15/10/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXGTabBar;

@protocol ZXGTabBarDelegate <NSObject>
@optional
- (void)tabBar:(ZXGTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
@end

@interface ZXGTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<ZXGTabBarDelegate> delegate;
@end
