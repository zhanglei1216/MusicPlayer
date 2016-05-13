//
//  ViewController.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "ViewController.h"
#import "MusicInfoHandle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[MusicInfoHandle shareHandle] getMusicInfosWithUrl:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist" completion:^(NSArray *musicInfos, NSError *error)  {
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
