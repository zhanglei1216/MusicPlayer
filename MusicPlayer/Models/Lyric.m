//
//  Lyric.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/13.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "Lyric.h"

@implementation Lyric

/**
 * 初始化方法
 * @param lyric
 * @param time
 */
- (instancetype)initWithLyric:(NSString *)lyric time:(CGFloat)time{
    self = [super init];
    if (self) {
        _lyric = lyric;
        _time = time;
    }
    return self;
}

/**
 * 遍历构造方法
 */
+ (id)lyricWithLyric:(NSString *)lyric time:(CGFloat)time{
    return [[Lyric alloc] initWithLyric:lyric time:time];
}
@end
