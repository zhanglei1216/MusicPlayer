//
//  AVPlayerManager.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "AVPlayerManager.h"

static AVPlayerManager *avPlayerManager = nil;

@interface AVPlayerManager ()

@property (nonatomic, strong) AVPlayer *avPlayer; //播放器
@property (nonatomic, copy) NSString *currentUrl;  //正在播放的url
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AVPlayerManager
/**
 * 单利
 * @return AVPlayerManager
 */
+ (AVPlayerManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (avPlayerManager == nil) {
            avPlayerManager = [[AVPlayerManager alloc] init];
            
        }
    });
    return avPlayerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = AVPlayerStop;
        //初始化定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        //暂停
        _timer.fireDate = [NSDate distantFuture];
        
        //添加歌曲播放完成通知监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerDidFinishPlay:) name:AVPlayerItemDidPlayToEndTimeNotification  object:nil];
        
        
    }
    return self;
}

/**
 * 接收到歌曲播放完成通知
 */

- (void)avPlayerDidFinishPlay:(NSNotification *)notification{
    //执行播放完成代理方法
    if ([_delegate respondsToSelector:@selector(playDidFinish)]) { //判断代理有没有实现代理方法
        [_delegate playDidFinish];
    }
}



/**
 * 播放
 * @param url
 */
- (void)playWithUrl:(NSString *)url{
    //生成playerItem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    
    if (_avPlayer == nil) {
        _avPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        //添加状态监控 KVO
        [_avPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }else{
        
        //替换现在正在播放的歌曲
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    }
    _currentUrl = url;
    
    
    //播放
    [_avPlayer play];
    
    //启动timer
    _timer.fireDate = [NSDate distantPast];

}

/**
 * 播放
 */
- (void)play{
    [_avPlayer play];
    _status = AVPlayerPlaying;
    
    //启动定时器
    _timer.fireDate = [NSDate distantPast];
}

/**
 * 暂停
 */
- (void)pause{
    [_avPlayer pause];
    _status = AVPlayerPause;
    
    //暂停timer
    _timer.fireDate = [NSDate distantFuture];
}

/**
 * 根据时间播放歌曲 跳转到具体的时间点播放
 * @param time
 */
- (void)seekToTime:(CGFloat)time{
    //第一个参数 value 用second * timescale 计算出
    //第二个参数就是 timescale 比例
    [_avPlayer seekToTime:CMTimeMake(time * _avPlayer.currentItem.currentTime.timescale, _avPlayer.currentTime.timescale)];
}

#pragma mark - 私有方法

//观察到 avplayer status 变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerStatus status = [change[@"new"] integerValue];
    
    switch (status) {
        case AVPlayerStatusReadyToPlay:
            _status = AVPlayerPlaying;
            break;
        case AVPlayerStatusFailed:
            //暂停定时器
            _timer.fireDate = [NSDate distantFuture];
            
            _status = AVPlayerStop;
            break;
        case AVPlayerStatusUnknown:
            break;
        default:
            break;
    }
}

//定时器
- (void)timer:(NSTimer *)timer{
    //执行代理方法
    if ([_delegate respondsToSelector:@selector(changeTime:)]) {
        [_delegate changeTime:self.currentTime];
    }
    
}


#pragma mark - GET SET 方法
/**
 *
 */
- (CGFloat)currentTime{
    CGFloat time = _avPlayer.currentItem.currentTime.value / _avPlayer.currentTime.timescale;
    return time;
}

- (void)setVolume:(CGFloat)volume{
    _volume = volume;
    _avPlayer.volume = volume;
}


@end
