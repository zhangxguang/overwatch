//
//  CorrelationNormalCell.h
//  overwatch
//
//  Created by 张祥光 on 15/12/5.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CorrelationNormalCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) NSArray *array;

@end
