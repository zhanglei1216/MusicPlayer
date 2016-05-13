//
//  MusicViewController.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

@interface MusicViewController : UIViewController

@property (nonatomic, strong) MusicInfo *musicInfo; //歌曲信息
@property (nonatomic) NSInteger index;  //歌曲索引

@end
