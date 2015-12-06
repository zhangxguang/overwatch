//
//  CollectionTableViewCell.h
//  overwatch
//
//  Created by 张祥光 on 15/10/7.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionHeroFrame;

@interface CollectionTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) CollectionHeroFrame *CollectionHeroFrameFrame;

@end
