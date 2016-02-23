//
//  HomeNormalCellData.m
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HomeNormalCellData.h"
#import "MJExtension.h"

@implementation HomeNormalCellData

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Description" : @"description",
             @"Typename" : @"typename"};
}

@end
