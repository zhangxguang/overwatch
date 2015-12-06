//
//  HeroAbilities.h
//  overwatch
//
//  Created by 张祥光 on 15/9/22.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroAbilities : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *describe;

+ (instancetype)abilitiesWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
