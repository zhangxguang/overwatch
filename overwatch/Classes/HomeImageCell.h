//
//  HomeImageCell.h
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeImageCellData.h"

@interface HomeImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *click;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *img0;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;

@property (nonatomic, strong) HomeImageCellData *data;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
