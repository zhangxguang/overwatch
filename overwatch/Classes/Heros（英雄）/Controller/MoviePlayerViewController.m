//
//  MoviePlayerViewController.m
//  overwatch
//
//  Created by 张祥光 on 15/10/6.
//  Copyright © 2015年 张祥光. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerViewController ()
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end

@implementation MoviePlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.moviePlayer play];
    [self addNotification];
}

- (MPMoviePlayerController *)moviePlayer
{
    if (!_moviePlayer) {
        // 负责控制媒体播放的控制器
        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:self.movieURL];
        _moviePlayer.view.frame = self.view.bounds;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_moviePlayer.view];
    }
    return _moviePlayer;
}

- (void)viewDidAppear:(BOOL)animated
{
    //播放器是否全屏
    self.moviePlayer.fullscreen = YES;
}

#pragma mark - 添加通知
- (void)addNotification
{
    // 1. 添加播放状态的监听
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(stateChanged) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    // 2. 播放完成
    [nc addObserver:self selector:@selector(finished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    // 3. 取消全屏
    [nc addObserver:self selector:@selector(finished) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
}

- (void)finished
{
    // 1. 删除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 2. 返回上级窗体
    // 谁申请,谁释放
    [self.delegate moviePlayerDidFinished];
}

- (void)stateChanged
{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:
            break;
            
        case MPMoviePlaybackStatePaused:
            break;
            
        case MPMoviePlaybackStateStopped:
            break;
            
        default:
            break;
    }
}

@end
