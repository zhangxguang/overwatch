//
//  CollectionHeroFrame.h
//  overwatch
//
//  Created by 张祥光 on 15/10/7.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HeroMessage;

@interface CollectionHeroFrame : NSObject

@property (nonatomic, assign, readonly) CGRect heroIconF;
@property (nonatomic, assign, readonly) CGRect nameF;
@property (nonatomic, assign, readonly) CGRect roleF;
//cell的高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) HeroMessage *message;

@end
