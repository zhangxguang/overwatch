//
//  HeroNameView.m
//  overwatch
//
//  Created by 张祥光 on 15/9/20.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroNameView.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"

// HeroNameView内部view的比例
#define HeroNameViewRatio 0.6

@interface HeroNameView ()

@end

@implementation HeroNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupNameLabel];
        [self setupTypeLabel];
    }
    return self;
}

- (void)setupNameLabel
{
    UILabel *NameLabel = [[UILabel alloc] init];
    NameLabel.backgroundColor = [UIColor clearColor];
    //设置Label文字
    NameLabel.text = @"";
    //设置Label的文字大小
    NameLabel.font = [UIFont systemFontOfSize:25];
    //设置Label文字居中
    NameLabel.textAlignment = NSTextAlignmentCenter;
    //设置Label字体颜色
    [NameLabel setTextColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self addSubview:NameLabel];
    [NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height).multipliedBy(HeroNameViewRatio);
    }];
    //替换
    self.NameLabel = NameLabel;
}

- (void)setupTypeLabel
{
    UILabel *TypeLabel = [[UILabel alloc] init];
    TypeLabel.backgroundColor = [UIColor clearColor];
    //设置Label文字
    TypeLabel.text = @"";
    //设置Label的文字大小
    TypeLabel.font = [UIFont systemFontOfSize:18];
    //设置Label文字居中
    TypeLabel.textAlignment = NSTextAlignmentCenter;
    //设置Label字体颜色
    [TypeLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:TypeLabel];
    [TypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NameLabel.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(self.mas_height).multipliedBy(1 - HeroNameViewRatio);
    }];
    //替换
    self.TypeLabel = TypeLabel;
}

@end
