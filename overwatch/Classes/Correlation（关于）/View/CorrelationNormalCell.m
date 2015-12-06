//
//  CorrelationNormalCell.m
//  overwatch
//
//  Created by 张祥光 on 15/12/5.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "CorrelationNormalCell.h"

@implementation CorrelationNormalCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CorrelationNormalCell";
    CorrelationNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[CorrelationNormalCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setArray:(NSArray *)array
{
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.image = [UIImage imageNamed:array[0]];
    self.textLabel.text = array[1];
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
