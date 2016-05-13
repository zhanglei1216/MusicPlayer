//
//  LyricCell.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/13.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricCell : UITableViewCell

@property (nonatomic, strong) UILabel *lyricLabel;  //歌词标签

/**
 * 计算cell的高
 */
+ (CGFloat)heightForCellWithLyric:(NSString *)lyric;

@end
