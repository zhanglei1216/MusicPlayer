//
//  AVPlayerManager.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AVPlayerManagerDelegate <NSObject>

//播放时间改变
- (void)changeTime:(CGFloat)time;

//歌曲播放完成
- (void)playDidFinish;

@end

//播放状态
typedef NS_ENUM(NSUInteger, AVPlayerManagerStatus) {
    AVPlayerPlaying, //正在播放中
    AVPlayerPause,   //暂停
    AVPlayerStop,    //停止播放
};

@interface AVPlayerManager : NSObject

@property (nonatomic, readonly) AVPlayerManagerStatus status;   //播放状态
@property (nonatomic) CGFloat currentTime; //当前的Item播放时间 单位second
@property (nonatomic) CGFloat volume;   //音量大小
@property (nonatomic, strong) UIViewController *playVC; //播放页面

@property (nonatomic, weak) id<AVPlayerManagerDelegate> delegate; //代理

/**
 * 单利
 * @return AVPlayerManager
 */
+ (AVPlayerManager *)shareManager;

/**
 * 加载播放歌曲
 * @param url
 */
- (void)playWithUrl:(NSString *)url;

/**
 * 播放
 */
- (void)play;

/**
 * 暂停
 */
- (void)pause;

/**
 * 根据时间播放歌曲
 * @param time
 */
- (void)seekToTime:(CGFloat)time;




@end
