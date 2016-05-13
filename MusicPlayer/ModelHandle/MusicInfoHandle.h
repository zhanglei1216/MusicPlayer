//
//  MusicInfoHandle.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

@interface MusicInfoHandle : NSObject

@property (nonatomic, strong) NSMutableArray *musicInfos;

/**
 * 单例
 * @return
 */
+ (MusicInfoHandle *)shareHandle;

/**
 * 获取音乐信息
 * @param url
 * @param completion
 */
- (void)getMusicInfosWithUrl:(NSString *)url completion:(void(^)(NSArray *musicInfos, NSError *error))completion;

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
 * 返回每个row对应的musicInfo
 * @return MusicInfo
 */
- (MusicInfo *)MusicInfoForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * 根据索引获取上一首歌曲
 * @param index
 * @return MusicInfo
 */
- (MusicInfo *)musicInfoLastWithIndex:(NSInteger *)index;

/**
 * 根据索引获取下一首歌曲
 * @param index
 * @return MusicInfo
 */
- (MusicInfo *)musicInfoNextWithIndex:(NSInteger *)index;

/**
 * 随机或去歌曲
 * @return MusicInfo
 */
- (MusicInfo *)musicInfoRandomWithIndex:(NSInteger *)index;


@end
