//
//  HomeImageCell.m
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HomeImageCell.h"
#import "UIImageView+WebCache.h"
#import "PictuerData.h"

@interface HomeImageCell ()

@end

@implementation HomeImageCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HomeImageCell";
    HomeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeImageCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setData:(HomeImageCellData *)data
{
    self.click.text = [NSString stringWithFormat:@"%@人浏览", data.click];
    self.title.text = data.title;
    
    PictuerData *picData0 = data.showitem[0];
    NSURL *url0 = [NSURL URLWithString:picData0.pic];
    [self.img0 sd_setImageWithURL:url0 placeholderImage:[UIImage imageNamed:@"演示图片"]];
    PictuerData *picData1 = data.showitem[1];
    NSURL *url1 = [NSURL URLWithString:picData1.pic];
    [self.img1 sd_setImageWithURL:url1 placeholderImage:[UIImage imageNamed:@"演示图片"]];
    PictuerData *picData2 = data.showitem[2];
    NSURL *url2 = [NSURL URLWithString:picData2.pic];
    [self.img2 sd_setImageWithURL:url2 placeholderImage:[UIImage imageNamed:@"演示图片"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
