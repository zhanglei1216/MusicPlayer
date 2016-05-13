//
//  MusicInfoHandle.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "MusicInfoHandle.h"

static MusicInfoHandle *musicInfoHandle = nil;

@implementation MusicInfoHandle

/**
 * 单例
 * @return
 */
+ (MusicInfoHandle *)shareHandle{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (musicInfoHandle == nil) {
            musicInfoHandle = [[MusicInfoHandle alloc] init];
        }
    });
    return  musicInfoHandle;
}

/**
 * 获取音乐信息
 * @param url
 * @param completion
 */
- (void)getMusicInfosWithUrl:(NSString *)url completion:(void(^)(NSArray *musicInfos, NSError *error))completion{
    
    NSURL *URL = [NSURL URLWithString:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSError *resultError = error;
            if (!resultError) { //判断数据请求是否成功
                
                //生成plist文件路径
                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"result.plist"];
                //将请求的数据写入文件
                [data writeToFile:filePath options:NSDataWritingAtomic error:&resultError];
                if (!resultError) { //判断数据写入文件是否成功
                    //用数组读取文件中的数据
                    NSArray *resultArray = [NSArray arrayWithContentsOfFile:filePath];
                    
                    //清空属性数组中的所有值，重新加载数据
                    [self.musicInfos removeAllObjects];
                    //将数组中的数据生成Model
                    for (NSDictionary *dic in resultArray) {
                        MusicInfo *musicInfo = [[MusicInfo alloc] init];
                        [musicInfo setValuesForKeysWithDictionary:dic];
                        [_musicInfos addObject:musicInfo];
                    }
                }else{
                    resultError = [NSError errorWithDomain:@"数据写入文件失败！" code:0 userInfo:@{@"requestType": @"MusicInfoGet"}];
                    NSLog(@"%@", resultError);
                }
                
            }else{
                NSLog(@"%@", resultError);
            }
            //block回调
            if (completion) {
                completion(_musicInfos, resultError);
            }
        });
    }];
    [task resume];
}

///懒加载
- (NSMutableArray *)musicInfos{
    if (_musicInfos == nil) {
        _musicInfos = [[NSMutableArray alloc] init];
    }
    return _musicInfos;
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
    return _musicInfos.count;
}

/**
 * 返回每个row对应的musicInfo
 * @return MusicInfo
 */
- (MusicInfo *)MusicInfoForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _musicInfos[indexPath.row];
}

/**
 * 根据索引获取上一首歌曲
 * @param index
 * @return MusicInfo
 */
- (MusicInfo *)musicInfoLastWithIndex:(NSInteger *)index{
    if (*index == 0) {
        *index = _musicInfos.count - 1;
        return [_musicInfos lastObject];
    }else{
        *index = *index - 1;
        return [_musicInfos objectAtIndex:*index];
    }
}

/**
 * 根据索引获取下一首歌曲
 * @param index
 * @return MusicInfo
 */
- (MusicInfo *)musicInfoNextWithIndex:(NSInteger *)index{
    if (*index == _musicInfos.count - 1) {
        *index = 0;
        return [_musicInfos firstObject];
    }else{
        *index = *index + 1;
        return [_musicInfos objectAtIndex:*index];
    }
}

/**
 * 随机或去歌曲
 * @return MusicInfo
 */
- (MusicInfo *)musicInfoRandomWithIndex:(NSInteger *)index{
    *index = arc4random() % _musicInfos.count;
    return _musicInfos[*index];
}

@end
