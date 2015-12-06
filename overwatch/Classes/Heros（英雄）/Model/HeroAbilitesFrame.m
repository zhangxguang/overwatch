//
//  HeroAbilitesFrame.m
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroAbilitesFrame.h"
#import "HeroAbilities.h"

#define ZXGDescribeFont [UIFont systemFontOfSize:15.0]

@implementation HeroAbilitesFrame

- (void)setAbilities:(HeroAbilities *)abilities
{
    _abilities = abilities;
    
    //子控件之间的间距
    CGFloat padding = 10.0;
    //屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat iconButtonY = padding;
    CGFloat iconButtonW = screenW * 0.4;
    CGFloat iconButtonH = 44;
    CGFloat iconButtonX = screenW*0.3;
    
    _iconButtonF = CGRectMake(iconButtonX, iconButtonY, iconButtonW, iconButtonH);
    
    CGFloat pictureX = (screenW - 280)/2;
    CGFloat pictureY = CGRectGetMaxY(_iconButtonF) + padding;
    CGFloat pictureW = 280;
    CGFloat pictureH = 160;
    _pictureF = CGRectMake(pictureX, pictureY, pictureW, pictureH);
    
    CGFloat describeX = padding;
    CGFloat describeY = CGRectGetMaxY(_pictureF) + padding;
    CGSize maxSize = CGSizeMake(screenW - padding * 2, MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName:ZXGDescribeFont};
    
    CGSize describeSize = [abilities.describe boundingRectWithSize:maxSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs
                                                           context:nil].size;

    _describeF = CGRectMake(describeX, describeY, describeSize.width, describeSize.height);
    
    _cellHeight = CGRectGetMaxY(_describeF) + padding;
}

@end
