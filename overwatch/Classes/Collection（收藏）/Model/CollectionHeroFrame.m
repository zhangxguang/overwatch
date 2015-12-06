//
//  CollectionHeroFrame.m
//  overwatch
//
//  Created by 张祥光 on 15/10/7.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "CollectionHeroFrame.h"
#import "HeroMessage.h"

@implementation CollectionHeroFrame

- (void)setMessage:(HeroMessage *)message
{
    _message = message;
    
    //子控件之间的间距
    CGFloat padding = 10.0;
    //屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat heroIconX = padding;
    CGFloat heroIconY = padding;
    CGFloat heroIconW = 62;
    CGFloat heroIconH = 50;
    _heroIconF = CGRectMake(heroIconX, heroIconY, heroIconW, heroIconH);
    
    CGFloat nameX = CGRectGetMaxX(_heroIconF) + padding;
    CGFloat nameY = heroIconY;
    CGFloat nameW = 100;
    CGFloat nameH = heroIconH;
    _nameF = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat roleX = screenW - padding - 50;
    CGFloat roleY = heroIconY;
    CGFloat roleW = 50;
    CGFloat roleH = heroIconH;
    _roleF = CGRectMake(roleX, roleY, roleW, roleH);
    
    _cellHeight = CGRectGetMaxY(_heroIconF) + padding;
}

@end
