//
//  Lyric.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/13.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Lyric : NSObject

@property (nonatomic, copy) NSString *lyric; //歌词
@property (nonatomic) CGFloat time;    //播放时间 单位s

/**
 * 初始化方法
 * @param lyric
 * @param time
 */
- (instancetype)initWithLyric:(NSString *)lyric time:(CGFloat)time;

/**
 * 遍历构造方法
 */
+ (id)lyricWithLyric:(NSString *)lyric time:(CGFloat)time;

@end
