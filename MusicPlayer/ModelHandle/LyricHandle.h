//
//  LyricHandle.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/13.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lyric.h"

@interface LyricHandle : NSObject

/**
 * 单例
 */
+ (LyricHandle *)shareHandle;

/**
 * 解析歌词
 * @param totalLyric
 * @return NSArray 歌词数组
 */
- (NSArray *)lyricsWithTotalLyric:(NSString *)totalLyric;

/**
 * 返回session number
 * @return NSInteger
 */
- (NSInteger)numberOfSections;

/**
 * 返回session 的 row
 * @return NSInteger
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

/**
 * 返回每个row对应的Lyric
 * @return Lyric
 */
- (Lyric *)lyricForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 获取需要展示歌词的index
 * @param time
 * @return NSInteger
 */
- (NSInteger)indexForRowAtTime:(CGFloat)time;

@end
