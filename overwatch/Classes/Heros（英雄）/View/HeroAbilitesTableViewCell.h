//
//  HeroAbilitesTableViewCell.h
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeroAbilitesFrame;

@interface HeroAbilitesTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton *pictureButton;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) HeroAbilitesFrame *abilitiesFrame;

@end
