//
//  HomeNormalCellData.h
//  overwatch
//
//  Created by 张祥光 on 15/12/2.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNormalCellData : NSObject

@property (nonatomic, copy) NSString *aid;
//标题
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *longtitle;

@property (nonatomic, copy) NSString *writer;
//浏览人数
@property (nonatomic, copy) NSString *click;

@property (nonatomic, copy) NSString *comment;
//描述
@property (nonatomic, copy) NSString *Description;
//图片
@property (nonatomic, copy) NSString *litpic;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *murl;
//url
@property (nonatomic, copy) NSString *html5;

@property (nonatomic, copy) NSString *timestamp;

@property (nonatomic, copy) NSString *toutiao;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *timer;

@property (nonatomic, copy) NSString *pubdate;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *typechild;
//类型  “推广”是广告
@property (nonatomic, copy) NSString *Typename;

@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSString *banner;
//cell类型 0是普通   1是图片
@property (nonatomic, copy) NSString *showtype;

@end
