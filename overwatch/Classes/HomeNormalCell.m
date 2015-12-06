//
//  HomeNormalCell.m
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HomeNormalCell.h"
#import "UIImageView+WebCache.h"

@interface HomeNormalCell ()

@end

@implementation HomeNormalCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeNormalCell";
    HomeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeNormalCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setData:(HomeImageCellData *)data
{
    self.title.text = data.title;
    self.click.text = [NSString stringWithFormat:@"%@人浏览", data.click];
    self.Description.text = data.Description;
    NSURL *url = [NSURL URLWithString:data.litpic];
    [self.litpic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"演示图片"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
