//
//  Tools.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/12.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/**
 * 将数值时间（单位second）转化为时间格式字符串
 * @param seconds
 * @return NSString
 */
+ (NSString *)timeStrFromSeconds:(CGFloat)seconds{
    NSInteger sec = (NSInteger)seconds;
    NSInteger minute = sec / 60;
    NSString *minuteStr = [NSString stringWithFormat:@"%02ld", minute];
    NSInteger second = sec % 60;
    NSString *secondStr = [NSString stringWithFormat:@"%02ld", second];
    return [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
    
}

@end
