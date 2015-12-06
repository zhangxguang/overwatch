//
//  CorrelationFirstCell.m
//  overwatch
//
//  Created by 张祥光 on 15/12/5.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "CorrelationFirstCell.h"

@implementation CorrelationFirstCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CorrelationFirstCell";
    CorrelationFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CorrelationFirstCell" owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
