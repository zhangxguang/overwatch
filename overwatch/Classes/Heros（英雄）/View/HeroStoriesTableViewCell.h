//
//  HeroStoriesTableViewCell.h
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeroStoriesFrame;

@interface HeroStoriesTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) HeroStoriesFrame *storiesFrame;

@end
