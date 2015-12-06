//
//  HeroCollectionLayout.m
//  overwatch
//
//  Created by 张祥光 on 15/9/16.
//  Copyright (c) 2015年 张祥光. All rights reserved.
//

#import "HeroCollectionLayout.h"
#import "HeroMessage.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//定义cell的宽度(16:9)
#define ITEM_WIDTH_16_9 kScreenWidth*0.6
//定义cell的高度(16:9)
#define ITEM_HEIGHT_16_9 kScreenHeight*0.45

//定义cell的宽度(3:2)
#define ITEM_WIDTH_3_2 kScreenWidth*0.5
//定义cell的高度(3:2)
#define ITEM_HEIGHT_3_2 kScreenHeight*0.45

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

@implementation HeroCollectionLayout

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    //设置itemSize
    if (kScreenWidth <= 320) {
        CGFloat margin = (kScreenWidth - ITEM_WIDTH_3_2)/2.0;
        self.itemSize = CGSizeMake(ITEM_WIDTH_3_2, ITEM_HEIGHT_3_2);
        self.sectionInset = UIEdgeInsetsMake(0, ABS(margin), kScreenHeight * 0.1, ABS(margin));
    }else{
        CGFloat margin = (kScreenWidth - ITEM_WIDTH_16_9)/2.0;
        self.itemSize = CGSizeMake(ITEM_WIDTH_16_9, ITEM_HEIGHT_16_9);
        self.sectionInset = UIEdgeInsetsMake(0, ABS(margin), kScreenHeight * 0.1, ABS(margin));
    }
    //滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //cell最小行间的距离
    self.minimumLineSpacing = kScreenWidth * 0.15;
}

// 当前item放大
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //获取默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    // 遍历array中所有的UICollectionViewLayoutAttributes
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

/**
 *  用来设置CollectionView停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本CollectionView停止滚动那一刻的位置
 *  @param velocity              滚动速度
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
    // proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat offsetAdjustment = MAXFLOAT;
    //理论上应cell停下来的中心点
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

// 刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
