//
//  MusicInfo.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicInfo : NSObject{
    NSInteger _id;
}

@property (nonatomic, copy) NSString *mp3Url; //播放路径
@property (nonatomic) NSInteger Id; //id
@property (nonatomic, copy) NSString *name; //歌曲的名字
@property (nonatomic, copy) NSString *picUrl; //歌曲图片路径
@property (nonatomic, copy) NSString *blurPicUrl;   //模糊图
@property (nonatomic, copy) NSString *album; //专辑
@property (nonatomic, copy) NSString *singer;   //歌手
@property (nonatomic) NSInteger duration; //时长 单位 ms
@property (nonatomic, copy) NSString *artists_name; //艺名
@property (nonatomic, copy) NSString *lyric; //歌词

@property (nonatomic) CGFloat totalTime; //总时长 单位second
@end
