//
//  PictuerData.m
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "PictuerData.h"
#import "MJExtension.h"
#import "PictureInfoData.h"

@implementation PictuerData

+(NSDictionary *)mj_objectClassInArray
{
    return @{@"info" : [PictureInfoData class]};
}

@end
