//
//  MoviePlayerViewController.h
//  overwatch
//
//  Created by 张祥光 on 15/10/6.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoviePlayerViewControllerDelegate <NSObject>
- (void)moviePlayerDidFinished;
@end

@interface MoviePlayerViewController : UIViewController
@property (nonatomic, weak) id<MoviePlayerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURL *movieURL;
@end
