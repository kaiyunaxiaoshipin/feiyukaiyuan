//
//  MusicClassVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MusicClassVC.h"

#import "MusicModel.h"
#import "MusicCell.h"
#import "NSString+StringSize.h"
#import "TCVideoRecordViewController.h"
#import "JCHATAlertViewWait.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicClassVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    int _paging;
    AVAudioPlayer *_musicPlayer;    //音乐播放器
    UIView *nothingView;
    
    CGFloat _originVolume;          //记录系统音量
    MPVolumeView *_volumeView;
    UISlider *_volumeViewSlider;
}
/** 记录 cell 是否打开 */
@property (nonatomic, assign) BOOL isOpen;
/** 记录当前点击的 cell 行数 */
@property (nonatomic, assign) int curRow;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSMutableArray *allArray;

@end

@implementation MusicClassVC
-(void)creatVoluem {
    if (_volumeViewSlider == nil) {
        _volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-100, -100, 40, 40)];
        [self.view addSubview:_volumeView];
        for (UIView* newView in _volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                _volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    [_volumeView setHidden:NO];
    [_volumeView setShowsRouteButton:YES];
    [_volumeView setShowsVolumeSlider:YES];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _originVolume = [AVAudioSession sharedInstance].outputVolume;
    _volumeViewSlider.value = 1;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _volumeViewSlider.value = _originVolume ;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self creatVoluem];
    [self creatNavi];
    
    _paging = 1;
    self.curRow = -1;
    self.allArray = [NSMutableArray array];
    self.models = [NSArray array];
    
    [self.view addSubview:self.tableView];
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"暂无此音乐类型";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"去看看其他音乐类型吧～";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:label2];

}


-(NSArray *)models{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in _allArray) {
        MusicModel *model = [MusicModel modelWithDic:dic];
        [array addObject:model];
    }
    _models = array;
    return _models;
}

-(void)pullData {
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Music.music_list&classify=%@&uid=%@&p=%d",_class_id,[Config getOwnID],_paging];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging == 1) {
                [_allArray removeAllObjects];
            }
            if (infoA.count <=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_allArray addObjectsFromArray:infoA];
            }
            if (_allArray.count <= 0) {
                nothingView.hidden = NO;
//                [PublicView showTextNoData:weakSelf.tableView text1:YZMsg(@"对不起~") text2:YZMsg(@"没有搜索到相关内容")];
            }else{
                nothingView.hidden = YES;

                [PublicView hiddenTextNoData:weakSelf.tableView];
            }
            [_tableView reloadData];
        }else{
//            [PublicView showTextNoData:weakSelf.tableView text1:YZMsg(@"对不起~") text2:YZMsg(@"没有搜索到相关内容")];
            nothingView.hidden = NO;

            [MBProgressHUD showError:msg];
        }
    } Fail:^(id fail) {
        nothingView.hidden = NO;

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 音乐播放、暂停
-(void)playMusic:(NSString *)path currentCell:(MusicCell *)cell currentIndex:(NSIndexPath*)indexPath{
    NSLog(@"播放");
    
    if (self.curRow !=indexPath.row) {
        //点击过cell并且非同一行时候，清除掉上一个播放器
        [self stopMusic];
    }
    
    if (!_musicPlayer) {
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
      
        //创建音乐播放器
        NSError *error = nil;
        _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        //准备播放
        _musicPlayer.volume = 0.6;
        [_musicPlayer prepareToPlay];
        //播放歌曲
        [_musicPlayer play];
        _musicPlayer.numberOfLoops = -1;
        [cell.StateBtn setImage:[UIImage imageNamed:@"music_pause"] forState:0];
    }else {
        if (_musicPlayer.isPlaying) {
            [_musicPlayer pause];
            [cell.StateBtn setImage:[UIImage imageNamed:@"music_play"] forState:0];
        }else {
            [_musicPlayer play];
            [cell.StateBtn setImage:[UIImage imageNamed:@"music_pause"] forState:0];
        }
    }
}
-(void)stopMusic {
    if (_musicPlayer) {
        [_musicPlayer stop];
        _musicPlayer = nil;
    }
}


#pragma mark - tableview  UITableViewDataSource   UITableViewDelegate
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicModel *model = _models[indexPath.row];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",model.musicNameStr,model.singerStr,model.timeStr,model.songID];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:loadPath];
    if (blHave) {
        [fileManager removeItemAtPath:loadPath error:nil];
        [self.tableView reloadData];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicCell *cell = [MusicCell cellWithTab:tableView andIndexPath:indexPath];
    MusicModel *model = _models[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YBWeakSelf;
    //回调事件处理
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",model.musicNameStr,model.singerStr,model.timeStr,model.songID];
    cell.recordEvent = ^(NSString *type) {
        //停止播放音乐
        [weakSelf stopMusic];
        //开拍之前()---开拍之后(编辑页面)
        if ([_fromWhere isEqual:@"edit"]) {
            //回调音频路径
            //先back 在dismis
            if (weakSelf.backEvent) {
                weakSelf.backEvent(@"分类音乐", loadPath, model.songID);
            }
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }else{
            TCVideoRecordViewController *videoRecord = [TCVideoRecordViewController new];
            videoRecord.musicPath = loadPath;
            videoRecord.musicID = model.songID;
            videoRecord.haveBGM = YES;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoRecord];
            nav.navigationBarHidden = YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
    };
    __weak MusicCell *weakCell = cell;
    cell.rsEvent = ^(NSString *rs, NSString *erro) {
        [[JCHATAlertViewWait ins] hidenAll];
        if ([rs isEqual:@"sucess"]) {
            [weakSelf playMusic:loadPath currentCell:weakCell currentIndex:indexPath];
        }else{
            [MBProgressHUD showError:erro];
        }
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicCell *cell = (MusicCell *)[tableView cellForRowAtIndexPath:indexPath];
    MusicModel *model = _models[indexPath.row];
    
    //处理显示、隐藏开拍按钮
    if (self.curRow == (int)indexPath.row) {
        self.curRow = -99999;
        self.isOpen = NO;
        [self stopMusic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    }else{
        self.isOpen = YES;
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",model.musicNameStr,model.singerStr,model.timeStr,model.songID];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:loadPath]) {
        //已下载
        [self playMusic:loadPath currentCell:cell currentIndex:indexPath];
    }else{
        [[JCHATAlertViewWait ins] showInView];
        //下载歌曲
        [cell musicDownLoad];
    }
    MusicCell *lastCell = (MusicCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.curRow inSection:0]];
    [lastCell.StateBtn setImage:[UIImage imageNamed:@"music_play"] forState:0];
    self.curRow = (int)indexPath.row;
    /** 刷新tableView，系统默认会有一个自带的动画 */
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //普通cell 80 播放音乐+50
    return (self.curRow == (int)indexPath.row && self.isOpen) ? 130 : 80;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - set/get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40+statusbarHeight+40, _window_width, _window_height-40-statusbarHeight-40) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _paging = 1;
            [self pullData];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _paging +=1;
            [self pullData];
        }];
    }
    return _tableView;
}

#pragma mark - 导航
-(void)creatNavi {
//    YBNavi *navi = [[YBNavi alloc]init];
//    navi.leftHidden = NO;
//    navi.rightHidden = YES;
//    [navi ybNaviLeft:^(id btnBack) {
//        [self stopMusic];
//        [self.navigationController popViewControllerAnimated:YES];
//    } andRightName:@"" andRight:^(id btnBack) {
//
//    } andMidTitle:_navi_title];
//    navi.frame = CGRectMake(0, 24+statusbarHeight, _window_width, 64);
//    [self.view addSubview:navi];
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 40+statusbarHeight, _window_width, 40)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = _navi_title;
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, 0,_window_width,40);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(8,0,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"video_返回_gray"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    [self.view addSubview:navtion];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:navtion.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = navtion.bounds;
    maskLayer.path = maskPath.CGPath;
    navtion.layer.mask = maskLayer;

}
- (void)doReturn{
    [self stopMusic];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
