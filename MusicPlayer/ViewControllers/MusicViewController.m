//
//  MusicViewController.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "MusicViewController.h"
#import <UIImageView+WebCache.h>
#import "AVPlayerManager.h"
#import "Tools.h"
#import "MusicInfoHandle.h"
#import "LyricHandle.h"
#import "LyricCell.h"


typedef NS_ENUM(NSUInteger, LoopType) {
    SingleType,  //单曲循环
    ShuffleType, //随机循环
    OrderType,   //顺序
};

@interface MusicViewController ()<AVPlayerManagerDelegate, UITableViewDataSource, UITableViewDelegate>{
    BOOL isSeek;    //是否开始拖拽进度条
    CGFloat canScrollTime; //可以控制
    LoopType loopType;  //播放类型
}

@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;   //音乐图片
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;  //进度条
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;    //模糊视图
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;   //页面消失button
@property (weak, nonatomic) IBOutlet UITableView *tableView;    //歌词列表
@property (weak, nonatomic) IBOutlet UILabel *currentPlayTimeLabel; //当前播放时间标签
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;  //剩余时间标签
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    //歌名标签
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;  //歌手标签
@property (weak, nonatomic) IBOutlet UIButton *rewindButton;    //上一首
@property (weak, nonatomic) IBOutlet UIButton *forwindButton; //下一首
@property (weak, nonatomic) IBOutlet UIButton *playButton;  //播放按钮
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;    //音量滑动条
@property (weak, nonatomic) IBOutlet UIButton *singleLoopButton;    //单曲循环按钮
@property (weak, nonatomic) IBOutlet UIButton *loopButton;  //顺序循环按钮
@property (weak, nonatomic) IBOutlet UIButton *randomButton;  //随机按钮

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置音乐图片的圆角
    _musicImageView.layer.cornerRadius = ([UIScreen mainScreen].bounds.size.width - 100) / 2;
    _musicImageView.layer.masksToBounds = YES;
    
    
    //设置播放器代理
    [AVPlayerManager shareManager].delegate = self;
    
    //设置进度条按钮图片
    [_progressSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    
    //设置歌词table delegate
    _tableView.dataSource = self;
    _tableView.delegate = self;
    //注册cell
    [_tableView registerClass:[LyricCell class] forCellReuseIdentifier:@"cell"];
    //隐去分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //设置view
    [self setUpView];
    
    //设置播放类型
    loopType = OrderType;
}
- (void)dealloc{
    
}

/**
 * 设置播放页面
 */
- (void)setUpView{
    
    //播放音乐
    [[AVPlayerManager shareManager] playWithUrl:_musicInfo.mp3Url];
    //改变播放按钮状态
    [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    
    //设置歌曲信息
    _nameLabel.text = _musicInfo.name;
    _singerLabel.text = _musicInfo.singer;
    [_musicImageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo.picUrl] placeholderImage:[UIImage imageNamed:@"place_holder"]];
    [_blurImageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo.blurPicUrl]];
    
    //设置progressSlider min max
    _progressSlider.minimumValue = 0.0;
    _progressSlider.maximumValue = _musicInfo.totalTime;
    _progressSlider.value = 0;
    
    //设置volume slider min max
    _volumeSlider.minimumValue = 0.0;
    _volumeSlider.maximumValue = 1.0;
    _volumeSlider.value = 0.5;
    
    //当前时间、剩余时间label赋值
    _currentPlayTimeLabel.text = @"00:00";
    _remainTimeLabel.text = [Tools timeStrFromSeconds:_musicInfo.totalTime];
    
    //解析歌词
    [[LyricHandle shareHandle] lyricsWithTotalLyric:_musicInfo.lyric];
    
    //显示歌词
    [_tableView reloadData];
    
    //tableView回到顶端
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Regesture
- (IBAction)dismiss:(id)sender {
    //返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

//时间进度条改变
- (IBAction)progressChange:(id)sender {
    //改变歌曲播放进度
    [[AVPlayerManager shareManager] seekToTime:_progressSlider.value];
    isSeek = NO;
}

//开始触摸进度条
- (IBAction)progressTouchDown:(id)sender {
    isSeek = YES;
}


//上一首
- (IBAction)last:(id)sender {
    _musicInfo = [[MusicInfoHandle shareHandle] musicInfoLastWithIndex:&_index];
    //更新播放页面
    [self setUpView];
    
    
}

//下一首
- (IBAction)next:(id)sender {
    _musicInfo = [[MusicInfoHandle shareHandle] musicInfoNextWithIndex:&_index];
    //更新播放页面
    [self setUpView];
}

//播放
- (IBAction)play:(id)sender {
    
    if ([AVPlayerManager shareManager].status == AVPlayerPause) {
        [[AVPlayerManager shareManager] play];
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else if ([AVPlayerManager shareManager].status == AVPlayerPlaying) {
        [[AVPlayerManager shareManager] pause];
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}

//音量大小改变
- (IBAction)volumeChangeValue:(id)sender {
    [AVPlayerManager shareManager].volume = _volumeSlider.value;
}
//单曲循环
- (IBAction)singleLoop:(id)sender {
    [_singleLoopButton setImage:[UIImage imageNamed:@"singleloop-s"] forState:UIControlStateNormal];
    [_loopButton setImage:[UIImage imageNamed:@"loop"] forState:UIControlStateNormal];
    [_randomButton setImage:[UIImage imageNamed:@"shuffle"] forState:UIControlStateNormal];
    loopType = SingleType;
}

//循环播放
- (IBAction)loop:(id)sender {
    [_singleLoopButton setImage:[UIImage imageNamed:@"singleloop"] forState:UIControlStateNormal];
    [_loopButton setImage:[UIImage imageNamed:@"loop-s"] forState:UIControlStateNormal];
    [_randomButton setImage:[UIImage imageNamed:@"shuffle"] forState:UIControlStateNormal];
    loopType = OrderType;
}

//随机播放
- (IBAction)shuffle:(id)sender {
    [_singleLoopButton setImage:[UIImage imageNamed:@"singleloop"] forState:UIControlStateNormal];
    [_loopButton setImage:[UIImage imageNamed:@"loop"] forState:UIControlStateNormal];
    [_randomButton setImage:[UIImage imageNamed:@"shuffle-s"] forState:UIControlStateNormal];
    loopType = ShuffleType;
}

#pragma mark - AVPlayerManager Delegate
- (void)changeTime:(CGFloat)time{
    
    //改变进度条进度
    if (!isSeek) {
        _progressSlider.value = time;
    }
    
    //改变播放时间
    _currentPlayTimeLabel.text = [Tools timeStrFromSeconds:time];
    
    //音乐图片旋转
    [UIView animateWithDuration:0.1 animations:^{
        _musicImageView.transform = CGAffineTransformRotate(_musicImageView.transform, 0.05);
    }];
    
//    //剩余时间
//    _remainTimeLabel.text = [Tools timeStrFromSeconds:_musicInfo.totalTime - time];
    
    //显示正在播放的歌词
    [self showLyricWithTime:time];

}

//一条曲目播放完成
- (void)playDidFinish{
    //播放下一首歌曲
    [self getMusicInfo];
}

//显示正在播放的歌词
- (void)showLyricWithTime:(CGFloat)time{
    NSInteger index = [[LyricHandle shareHandle] indexForRowAtTime:time];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    LyricCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    cell.lyricLabel.textColor = [UIColor greenColor];
    if (canScrollTime < time) {
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
    //清除没有播放的歌词的颜色
    for (int i = 0; i < [[LyricHandle shareHandle] numberOfRowsInSection:0]; i++) {
        if (i != index) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            LyricCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.lyricLabel.textColor = [UIColor whiteColor];
        }
    }
}

//判断播放类型获取下一首歌
- (void)getMusicInfo{
    switch (loopType) {
        case SingleType:
            [self setUpView];
            break;
        case ShuffleType:
            _musicInfo = [[MusicInfoHandle shareHandle] musicInfoRandomWithIndex:&_index];
            [self setUpView];
            break;
        case OrderType:
            _musicInfo = [[MusicInfoHandle shareHandle] musicInfoNextWithIndex:&_index];
            [self setUpView];
            break;
        default:
            break;
    }
}


#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[LyricHandle shareHandle] numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[LyricHandle shareHandle] numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LyricCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Lyric *lyric = [[LyricHandle shareHandle] lyricForRowAtIndexPath:indexPath];
    cell.lyricLabel.text  = lyric.lyric;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return [LyricCell heightForCellWithLyric:[[[LyricHandle shareHandle] lyricForRowAtIndexPath:indexPath] lyric]];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    canScrollTime = [AVPlayerManager shareManager].currentTime + 5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
