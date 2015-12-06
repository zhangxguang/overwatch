//
//  HeroCollectionViewCell.m
//  overwatch
//
//  Created by 张祥光 on 15/9/17.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "HeroCollectionViewCell.h"
#import "HeroCollectionLayout.h"
#import "HeroMessage.h"

@implementation HeroCollectionViewCell

#pragma mark - init methods
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end
