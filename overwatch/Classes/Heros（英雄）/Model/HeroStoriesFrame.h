//
//  HeroStoriesFrame.h
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HeroStories;

@interface HeroStoriesFrame : NSObject

@property (nonatomic, assign, readonly) CGRect storyF;
//cell的高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) HeroStories *stories;

@end
