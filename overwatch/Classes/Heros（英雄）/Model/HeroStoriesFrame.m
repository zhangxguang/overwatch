//
//  HeroStoriesFrame.m
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroStoriesFrame.h"
#import "HeroStories.h"

#define ZXGStoryFont [UIFont systemFontOfSize:18.0]

@implementation HeroStoriesFrame

- (void)setStories:(HeroStories *)stories
{
    _stories = stories;
    
    //子控件之间的间距
    CGFloat padding = 10.0;

    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat storyX = padding * 2;
    CGFloat storyY = padding;
    CGSize maxSize = CGSizeMake(screenW - padding * 2, MAXFLOAT);
    NSDictionary *attrs = @{NSFontAttributeName:ZXGStoryFont};
    
    CGSize storySize = [stories.story boundingRectWithSize:maxSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs
                                                           context:nil].size;

    _storyF = CGRectMake(storyX, storyY, storySize.width, storySize.height);

    _cellHeight = CGRectGetMaxY(_storyF) + padding;
}

@end
