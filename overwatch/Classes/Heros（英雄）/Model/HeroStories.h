//
//  HeroStories.h
//  overwatch
//
//  Created by 张祥光 on 15/9/22.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroStories : NSObject

@property (nonatomic, copy) NSString *story;

+ (instancetype)storyWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
