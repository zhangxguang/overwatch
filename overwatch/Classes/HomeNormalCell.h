//
//  HomeNormalCell.h
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeImageCellData.h"

@interface HomeNormalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *litpic;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UILabel *click;

@property (nonatomic, strong) HomeImageCellData *data;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
