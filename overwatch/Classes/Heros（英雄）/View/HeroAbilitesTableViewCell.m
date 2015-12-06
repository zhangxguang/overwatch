//
//  HeroAbilitesTableViewCell.m
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroAbilitesTableViewCell.h"
#import "HeroAbilities.h"
#import "HeroAbilitesFrame.h"
#import "HeroIconButton.h"

#define ZXGDescribeFont [UIFont systemFontOfSize:15.0]

@interface HeroAbilitesTableViewCell()
@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UIButton *iconButton;
@property (nonatomic, weak) UILabel *nameView;
@property (nonatomic, weak) UILabel *describeView;
@end

@implementation HeroAbilitesTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"abilities";
    HeroAbilitesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HeroAbilitesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

//把创建子控件以及布局控件全部写在
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //技能图标
        HeroIconButton *iconButton = [[HeroIconButton alloc] init];
        //设置图片的内容缩放模式为UIViewContentModeScaleAspectFit，尺寸自适应
        self.iconButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:iconButton];
        self.iconButton = iconButton;
        
        //技能图片（按钮）
        UIButton *pictureButton = [[UIButton alloc] init];
        [self.contentView addSubview:pictureButton];
        self.pictureButton = pictureButton;
        
        //技能描述
        UILabel *describeView = [[UILabel alloc] init];
        describeView.textColor = [UIColor whiteColor];
        //numberOfLines 和 font 这两个属性必须得设置
        describeView.numberOfLines = 0;
        describeView.font = ZXGDescribeFont;
        [self.contentView addSubview:describeView];
        self.describeView = describeView;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAbilitiesFrame:(HeroAbilitesFrame *)abilitiesFrame
{
    _abilitiesFrame = abilitiesFrame;
    
    HeroAbilities *abilities = abilitiesFrame.abilities;

    //技能图标
    [self.iconButton setImage:[UIImage imageNamed:abilities.icon] forState:UIControlStateNormal];
    [self.iconButton setTitle:abilities.name forState:UIControlStateNormal];
    self.iconButton.frame = abilitiesFrame.iconButtonF;
    
    //技能图片
    [self.pictureButton setImage:[UIImage imageNamed:abilities.picture] forState:UIControlStateNormal];
    self.pictureButton.frame = abilitiesFrame.pictureF;
    
    //技能描述
    self.describeView.text = abilities.describe;
    self.describeView.frame = abilitiesFrame.describeF;
}

@end
