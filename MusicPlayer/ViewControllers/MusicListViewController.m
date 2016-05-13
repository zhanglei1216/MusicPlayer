//
//  MusicListViewController.m
//  MusicPlayer
//
//  Created by 张磊 on 16/5/11.
//  Copyright © 2016年 张磊. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicInfoHandle.h"
#import "MusicViewCell.h"
#import "URLMacro.h"
#import "AVPlayerManager.h"
#import "MusicViewController.h"
#import "MusicInfoHandle.h"
#import <MBProgressHUD.h>

static NSString *MUSIC_LIST_CELL_IDENTIFIER = @"MusicListCellIdentifier";
@interface MusicListViewController ()

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //设置title
    self.title = @"音乐列表";
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicViewCell" bundle:nil] forCellReuseIdentifier:MUSIC_LIST_CELL_IDENTIFIER];
    
    //请求数据
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"歌曲加载中...";
    [[MusicInfoHandle shareHandle] getMusicInfosWithUrl:MUSIC_LIST_URL completion:^(NSArray *musicInfos, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            NSLog(@"%@", error);
        }else{
            [self.tableView reloadData];
            
            //显示tableView的分割线
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
    }];
    
    //去掉tableView的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [[MusicInfoHandle shareHandle] numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [[MusicInfoHandle shareHandle] numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MUSIC_LIST_CELL_IDENTIFIER forIndexPath:indexPath];
    MusicInfo *musicInfo = [[MusicInfoHandle shareHandle] MusicInfoForRowAtIndexPath:indexPath];
    [cell setValueWithMusicInfo:musicInfo];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     MusicInfo *musicInfo = [[MusicInfoHandle shareHandle] MusicInfoForRowAtIndexPath:indexPath];
    MusicViewController *musicVC = nil;
    if ([AVPlayerManager shareManager].playVC && [((MusicViewController *)[AVPlayerManager shareManager].playVC) musicInfo].Id  == musicInfo.Id) {
        musicVC = (MusicViewController *)[AVPlayerManager shareManager].playVC;
    }else {
        //模态出播放页面
        musicVC = [[MusicViewController alloc] init];
        musicVC.musicInfo = musicInfo;
        //传入索引值
        musicVC.index = indexPath.row;
        [AVPlayerManager shareManager].playVC = musicVC;
    }
    [self presentViewController:musicVC animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
