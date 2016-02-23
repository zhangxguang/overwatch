//
//  HeroMessage.h
//  overwatch
//
//  Created by 张祥光 on 15/9/17.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeroMessage : NSObject

//英雄名字
@property (nonatomic, copy) NSString *name;
//英雄头像
@property (nonatomic, copy) NSString *heroIcon;
//英雄图片
@property (nonatomic, copy) NSString *picture;
//英雄定位
@property (nonatomic, copy) NSString *role;
//英雄名字全称
@property (nonatomic, copy) NSString *realName;
//英雄职业
@property (nonatomic, copy) NSString *occupation;
//行动基地
@property (nonatomic, copy) NSString *baseOfOperations;
//隶属
@property (nonatomic, copy) NSString *affiliation;
//技能
@property (nonatomic, strong) NSArray *abilities;
//故事
@property (nonatomic, strong) NSArray *stories;

+ (instancetype)messageWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
