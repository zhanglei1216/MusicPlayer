//
//  MusicViewCell.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

@interface MusicViewCell : UITableViewCell

/**
 * 为cell赋值
 * @param musicInfo
 */
- (void)setValueWithMusicInfo:(MusicInfo *)musicInfo;
@end
