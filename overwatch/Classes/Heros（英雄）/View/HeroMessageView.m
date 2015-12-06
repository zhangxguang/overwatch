//
//  HeroMessageView.m
//  overwatch
//
//  Created by 张祥光 on 15/9/24.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroMessageView.h"
#import "HeroMessage.h"
#import "HeroMessageFrame.h"
#import "Masonry.h"

#define NAMEFONT [UIFont systemFontOfSize:25]
#define NAMEVIEWFONT [UIFont systemFontOfSize:15]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface HeroMessageView()
@property (nonatomic, weak) UIView *bigView;
@property (nonatomic, weak) UIImageView *pictureView;
@property (nonatomic, weak) UILabel *nameView;
@property (nonatomic, weak) UILabel *roleView;
@property (nonatomic, weak) UILabel *realNameView;
@property (nonatomic, weak) UILabel *occupationView;
@property (nonatomic, weak) UILabel *baseOfOperationsView;
@property (nonatomic, weak) UILabel *affiliationView;
@end

@implementation HeroMessageView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        self.showsHorizontalScrollIndicator = NO;
        self.contentOffset = CGPointMake(0, 0);
        self.pagingEnabled = YES;
        self.scrollEnabled = YES;
        
        UIView *bigView = [[UIView alloc] init];
        [self addSubview:bigView];
        self.bigView = bigView;
        
        //英雄图片
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bigView addSubview:pictureView];
        self.pictureView = pictureView;
        
        //英雄名称
        UILabel *nameView = [[UILabel alloc] init];
        nameView.textColor = [UIColor whiteColor];
        nameView.font = NAMEFONT;
        nameView.textAlignment = NSTextAlignmentLeft;
        [self.bigView addSubview:nameView];
        self.nameView = nameView;
        
        //英雄定位
        UILabel *roleView = [[UILabel alloc] init];
        roleView.textColor = [UIColor whiteColor];
        roleView.font = NAMEVIEWFONT;
        roleView.textAlignment = NSTextAlignmentLeft;
        [self.bigView addSubview:roleView];
        self.roleView = roleView;
        
        //英雄全称
        UILabel *realNameView = [[UILabel alloc] init];
        realNameView.textColor = [UIColor whiteColor];
        realNameView.font = NAMEVIEWFONT;
        realNameView.textAlignment = NSTextAlignmentLeft;
        [self.bigView addSubview:realNameView];
        self.realNameView = realNameView;
        
        //英雄职业
        UILabel *occupationView = [[UILabel alloc] init];
        occupationView.textColor = [UIColor whiteColor];
        occupationView.font = NAMEVIEWFONT;
        occupationView.textAlignment = NSTextAlignmentLeft;
        [self.bigView addSubview:occupationView];
        self.occupationView = occupationView;
        
        //英雄行动基地
        UILabel *baseOfOperationsView = [[UILabel alloc] init];
        baseOfOperationsView.textColor = [UIColor whiteColor];
        baseOfOperationsView.font = NAMEVIEWFONT;
        baseOfOperationsView.textAlignment = NSTextAlignmentLeft;
        [self.bigView addSubview:baseOfOperationsView];
        self.baseOfOperationsView = baseOfOperationsView;
        
        //英雄隶属
        UILabel *affiliationView = [[UILabel alloc] init];
        affiliationView.textColor = [UIColor whiteColor];
        affiliationView.font = NAMEVIEWFONT;
        affiliationView.textAlignment = NSTextAlignmentLeft;
        [self.bigView addSubview:affiliationView];
        self.affiliationView = affiliationView;
    }
    return self;
}

- (void)setMessageFrame:(HeroMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    HeroMessage *message = messageFrame.message;
    
    __weak __typeof(&*self)weakSelf = self;
    //一个可变数组，用来存放各个labelView的尺寸
    NSMutableArray *sizeArray = [NSMutableArray array];
    //各个view之间的间隔    pictureView的宽度     pictureView的高度     bigView的宽度
    CGFloat padding = 10, pictureWidth = 165, pictureHeight = 220, bigViewWidth = 0;
    
#pragma mark - 设置subView的数据
    //英雄图片
    self.pictureView.image = [UIImage imageNamed:message.picture];
    //英雄名称
    self.nameView.text =  message.name;
    CGSize nameSize = [message.name sizeWithAttributes:@{NSFontAttributeName:NAMEFONT}];
    NSLog(@"%@" ,NSStringFromCGSize(nameSize));
    [sizeArray addObject:NSStringFromCGSize(nameSize)];
    //英雄定位
    self.roleView.text = message.role;
    CGSize roleSize = [message.role sizeWithAttributes:@{NSFontAttributeName:NAMEVIEWFONT}];
    NSLog(@"%@" ,NSStringFromCGSize(roleSize));
    [sizeArray addObject:NSStringFromCGSize(roleSize)];
    //英雄职业
    self.occupationView.text = message.occupation;
    CGSize occupationSize = [message.occupation sizeWithAttributes:@{NSFontAttributeName:NAMEVIEWFONT}];
    NSLog(@"%@" ,NSStringFromCGSize(occupationSize));
    [sizeArray addObject:NSStringFromCGSize(occupationSize)];
    
    //获得前三个label的最大宽度
    CGFloat MAXWidth_picture = 0;
    for (int i = 0; i < sizeArray.count; i++) {
        CGSize size = CGSizeFromString(sizeArray[i]);
        if (MAXWidth_picture < size.width) {
            MAXWidth_picture = size.width;
        }
    }
    
    //英雄全称
    self.realNameView.text = message.realName;
    CGSize realNameSize = [message.realName sizeWithAttributes:@{NSFontAttributeName:NAMEVIEWFONT}];
    NSLog(@"%@" ,NSStringFromCGSize(realNameSize));
    [sizeArray addObject:NSStringFromCGSize(realNameSize)];
    //英雄行动基地
    self.baseOfOperationsView.text = message.baseOfOperations;
    CGSize baseOfOperationsSize = [message.baseOfOperations sizeWithAttributes:@{NSFontAttributeName:NAMEVIEWFONT}];
    NSLog(@"%@" ,NSStringFromCGSize(baseOfOperationsSize));
    [sizeArray addObject:NSStringFromCGSize(baseOfOperationsSize)];
    //英雄隶属
    self.affiliationView.text = message.affiliation;
    CGSize affiliationSize = [message.affiliation sizeWithAttributes:@{NSFontAttributeName:NAMEVIEWFONT}];
    NSLog(@"%@" ,NSStringFromCGSize(affiliationSize));
    [sizeArray addObject:NSStringFromCGSize(affiliationSize)];
    
    //找出所有label中宽度最大的一个
    CGFloat MAXWidth_all = 0;
    for (int i = 0; i < sizeArray.count; i++) {
        CGSize size = CGSizeFromString(sizeArray[i]);
        if (MAXWidth_all < size.width) {
            MAXWidth_all = size.width;
        }
    }
    //比较上半部与下半部的宽度
    if (MAXWidth_all < (MAXWidth_picture + padding + pictureWidth)) {
        bigViewWidth = MAXWidth_picture + padding + pictureWidth;
    }else{
        bigViewWidth = MAXWidth_all + 0.5;//+0.5 是为了向上取整
    }
    //如果bigViewWidth大于屏幕宽度，则把bigViewWidth设置为屏幕宽度
    if (bigViewWidth > kScreenWidth) {
        bigViewWidth = kScreenWidth;
    }
    //bigView与superView之间的间隙
    CGFloat bigViewPadding = (kScreenWidth - bigViewWidth) / 2;
    NSLog(@"MAXWidth_all %f" ,MAXWidth_all);
    NSLog(@"bigViewWidth %f" ,bigViewWidth);

//    self.bigView.backgroundColor = [UIColor grayColor];
#pragma mark - 自动布局 Masonry
    //英雄图片
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bigView).with.offset(padding);
        if (MAXWidth_all < (MAXWidth_picture + padding + pictureWidth)) {
            //如果上半部更宽则pictureView依据nameView定位
            make.left.equalTo(weakSelf.nameView.mas_right).with.offset(padding);
        }
        //如果下半部更宽则pictureView依据bigView定位
        make.right.equalTo(weakSelf.bigView);
        make.width.mas_equalTo(pictureWidth);
        make.height.mas_equalTo(pictureHeight);
    }];
    //英雄名称
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bigView).with.offset(padding);
        make.left.equalTo(weakSelf.bigView);
        make.height.mas_equalTo(@88);
        make.width.mas_equalTo(MAXWidth_picture);
    }];
    //英雄定位
    [self.roleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameView.mas_bottom);
        make.left.equalTo(weakSelf.bigView);
        make.height.mas_equalTo(@66);
        make.width.mas_equalTo(MAXWidth_picture);
    }];
    //英雄职业
    [self.occupationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.roleView.mas_bottom);
        make.left.equalTo(weakSelf.bigView);
        make.height.mas_equalTo(@66);
        make.width.mas_equalTo(MAXWidth_picture);
    }];
    //英雄全称
    [self.realNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.occupationView.mas_bottom);
        make.left.equalTo(weakSelf.bigView);
        make.right.equalTo(weakSelf.bigView);
        make.height.mas_equalTo(@66);
    }];
    //英雄行动基地
    [self.baseOfOperationsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.realNameView.mas_bottom);
        make.left.equalTo(weakSelf.bigView);
        make.right.equalTo(weakSelf.bigView);
        make.height.mas_equalTo(@66);
    }];
    //英雄隶属
    [self.affiliationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.baseOfOperationsView.mas_bottom);
        make.left.equalTo(weakSelf.bigView);
        make.right.equalTo(weakSelf.bigView);
        make.height.mas_equalTo(@66);
    }];
    //bigView
    [self.bigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf);
        make.left.equalTo(weakSelf.mas_left).with.offset(bigViewPadding);
        make.width.mas_equalTo(bigViewWidth);
        make.bottom.equalTo(weakSelf.affiliationView.mas_bottom);
    }];
}

@end
