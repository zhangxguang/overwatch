//
//  HeroIconButton.m
//  overwatch
//
//  Created by 张祥光 on 15/11/19.
//  Copyright © 2015年 张祥光. All rights reserved.
//

// 图标的比例
#define ZXGTabBarButtonImageRatio 0.7

#import "HeroIconButton.h"

@implementation HeroIconButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置图片的拉伸模式为UIViewContentModeScaleAspectFit，尺寸自适应
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 字体大小
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        // 文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted
{
    
}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * ZXGTabBarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * ZXGTabBarButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(0, titleY, titleW, titleH);
}

@end
