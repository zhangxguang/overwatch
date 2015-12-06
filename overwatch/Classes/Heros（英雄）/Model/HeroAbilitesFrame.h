//
//  HeroAbilitesFrame.h
//  overwatch
//
//  Created by 张祥光 on 15/9/23.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HeroAbilities;

@interface HeroAbilitesFrame : NSObject

@property (nonatomic, assign, readonly) CGRect iconButtonF;
@property (nonatomic, assign, readonly) CGRect pictureF;
@property (nonatomic, assign, readonly) CGRect describeF;
//cell的高度
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, strong) HeroAbilities *abilities;

@end
