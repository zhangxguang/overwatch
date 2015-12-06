//
//  CollectionTableViewCell.m
//  overwatch
//
//  Created by 张祥光 on 15/10/7.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import "HeroMessage.h"
#import "CollectionHeroFrame.h"

@interface CollectionTableViewCell()
@property (nonatomic, weak) UIImageView *heroIconView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *roleLabel;
@end

@implementation CollectionTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Collection";
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //英雄图标
        UIImageView *heroIconView = [[UIImageView alloc] init];
        [self.contentView addSubview:heroIconView];
        self.heroIconView = heroIconView;
        //英雄名字
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        //英雄定位
        UILabel *roleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:roleLabel];
        self.roleLabel = roleLabel;
    }
    return self;
}

- (void)setCollectionHeroFrameFrame:(CollectionHeroFrame *)CollectionHeroFrameFrame
{
    _CollectionHeroFrameFrame = CollectionHeroFrameFrame;
    
    HeroMessage *message = CollectionHeroFrameFrame.message;
    
    //英雄图标
    self.heroIconView.image = [UIImage imageNamed:message.heroIcon];
    self.heroIconView.frame = CollectionHeroFrameFrame.heroIconF;
    //英雄名字
    self.nameLabel.text = message.name;
    self.nameLabel.frame = CollectionHeroFrameFrame.nameF;
    //英雄定位
    self.roleLabel.text = [message.role substringFromIndex:3];
    self.roleLabel.frame = CollectionHeroFrameFrame.roleF;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
