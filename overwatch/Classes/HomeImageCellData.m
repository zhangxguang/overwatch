//
//  HomeImageCellData.m
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HomeImageCellData.h"
#import "MJExtension.h"
#import "InfochildData.h"
#import "PictuerData.h"

@implementation HomeImageCellData

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Description":@"description",
             @"Typename":@"typename"
             };
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"infochild" : [InfochildData class],
             @"showitem"  : [PictuerData class]};
}

@end
