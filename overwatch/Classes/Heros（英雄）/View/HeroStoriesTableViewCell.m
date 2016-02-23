//
//  HeroStoriesTableViewCell.m
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroStoriesTableViewCell.h"
#import "HeroStories.h"
#import "HeroStoriesFrame.h"

#define ZXGStoryFont [UIFont systemFontOfSize:18.0]

@interface HeroStoriesTableViewCell()
@property (nonatomic, weak) UILabel *storyView;
@end

@implementation HeroStoriesTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"stories";
    HeroStoriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HeroStoriesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *storyView = [[UILabel alloc] init];
        storyView.textColor = [UIColor whiteColor];
        storyView.numberOfLines = 0;
        storyView.font = ZXGStoryFont;
        [self.contentView addSubview:storyView];
        self.storyView = storyView;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setStoriesFrame:(HeroStoriesFrame *)storiesFrame
{
    _storiesFrame = storiesFrame;
    
    HeroStories *stories = storiesFrame.stories;
    
    self.storyView.text = stories.story;
    self.storyView.frame = storiesFrame.storyF;
}

@end
