//
//  MusicViewCell.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "MusicViewCell.h"
#import <UIImageView+WebCache.h>

@interface MusicViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    //歌曲名标签
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;   //音乐图片
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;  //歌手标签
@property (weak, nonatomic) IBOutlet UILabel *albumLabel; //专辑


@end
@implementation MusicViewCell

/**
 * 为cell赋值
 * @param musicInfo
 */
- (void)setValueWithMusicInfo:(MusicInfo *)musicInfo{
    self.nameLabel.text = musicInfo.name;
    self.singerLabel.text = musicInfo.singer;
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:musicInfo.picUrl] placeholderImage:[UIImage imageNamed:@"guoya.png"]];
    self.albumLabel.text = musicInfo.album;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
