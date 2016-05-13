//
//  MusicInfo.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo
@synthesize Id = _id;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (CGFloat)totalTime{
    return _duration / 1000.0;
}

@end
