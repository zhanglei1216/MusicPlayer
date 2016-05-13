//
//  LyricHandle.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/13.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "LyricHandle.h"

static LyricHandle *lyricHandle = nil;

@interface LyricHandle ()

@property (nonatomic, strong) NSMutableArray *lyrics;   //歌词数组

@end
@implementation LyricHandle

/**
 * 单例
 */
+ (LyricHandle *)shareHandle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (lyricHandle == nil) {
            lyricHandle = [[LyricHandle alloc] init];
        }
    });
    return lyricHandle;
}

-(NSMutableArray *)lyrics{
    if (_lyrics == nil) {
        _lyrics = [[NSMutableArray alloc] init];
    }
    return _lyrics;
}

/**
 * 解析歌词
 * @param totalLyric
 * @return NSArray 歌词数组
 */
- (NSArray *)lyricsWithTotalLyric:(NSString *)totalLyric{
    
    [self.lyrics removeAllObjects];
    
    NSArray *totalLyricArray = [totalLyric componentsSeparatedByString:@"\n"];
    for (NSString *singlelyric in totalLyricArray) {
        if (singlelyric.length != 0) {
            NSArray *singlelyricArray = [singlelyric componentsSeparatedByString:@"]"];
            NSArray *timeArray = [[singlelyricArray[0] substringFromIndex:1] componentsSeparatedByString:@":"];
            CGFloat time = [timeArray[0] integerValue] * 60 + [timeArray[1] floatValue];
            Lyric *lyric = [Lyric lyricWithLyric:singlelyricArray[1] time:time];
            [self.lyrics addObject:lyric];
        }
    }
    return _lyrics;
}

/**
 * 返回session number
 * @return NSInteger
 */
- (NSInteger)numberOfSections{
    return 1;
}

/**
 * 返回session 的 row
 * @return NSInteger
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return _lyrics.count;
}

/**
 * 返回每个row对应的Lyric
 * @return Lyric
 */
- (Lyric *)lyricForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _lyrics[indexPath.row];
}

/**
 * 获取需要展示歌词的index
 * @param time
 * @return NSInteger
 */
- (NSInteger)indexForRowAtTime:(CGFloat)time{
    for (int i = 0; i < _lyrics.count; i++) {
        if ([_lyrics[i] time] > time) {
            return i - 1 > 0 ? i - 1 : 0;
        }
    }
    
    return _lyrics.count - 1;
}

@end
