//
//  PictuerData.h
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictuerData : NSObject
//图片链接
@property (nonatomic, copy) NSString *pic;
//图片标题
@property (nonatomic, copy) NSString *text;
//图片的info数组
@property (nonatomic, strong) NSArray *info;

@end
