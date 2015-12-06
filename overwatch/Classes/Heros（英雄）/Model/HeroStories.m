//
//  HeroStories.m
//  overwatch
//
//  Created by 张祥光 on 15/9/22.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroStories.h"

@implementation HeroStories

+ (instancetype)storyWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
