//
//  LyricCell.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/13.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "LyricCell.h"

@implementation LyricCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        self.lyricLabel = [[UILabel alloc] init];
        self.lyricLabel.numberOfLines = 0;
        self.lyricLabel.textAlignment = NSTextAlignmentCenter;
        self.lyricLabel.font = [UIFont systemFontOfSize:16.0];
        self.lyricLabel.textColor = [UIColor whiteColor];
        [self addSubview:_lyricLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.lyricLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

/**
 * 计算cell的高
 */
+ (CGFloat)heightForCellWithLyric:(NSString *)lyric{
    CGRect rect = [lyric boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0]} context:nil];
    
    return rect.size.height + 10;
}

@end
