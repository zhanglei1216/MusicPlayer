//
//  Tools.h
//  MusicPlayer
//
//  Created by 张磊 on 16/5/12.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tools : NSObject
/**
 * 将数值时间（单位second）转化为时间格式字符串
 * @param seconds
 * @return NSString
 */
+ (NSString *)timeStrFromSeconds:(CGFloat)seconds;

@end
