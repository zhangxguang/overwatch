//
//  HeroMessage.m
//  overwatch
//
//  Created by 张祥光 on 15/9/17.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroMessage.h"
#import "HeroAbilities.h"
#import "HeroStories.h"

@implementation HeroMessage

+ (instancetype)messageWithDict:(NSDictionary *)dict
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
