
#import "musicViewVideo.h"

#import "MusicModel.h"
#import "MusicCell.h"
#import "NSString+StringSize.h"
#import "TCVideoRecordViewController.h"
#import "MusicHeaderView.h"
#import "MusicClassVC.h"
#import <AVFoundation/AVFoundation.h>
#import "JCHATAlertViewWait.h"
#import <MediaPlayer/MediaPlayer.h>

@interface musicViewVideo ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    
    UIButton *btn;
    CGFloat classHeight;            //分类的高度
    int _paging;
    AVAudioPlayer *_musicPlayer;    //音乐播放器
    
    BOOL _isSearch;                 //当前显示 是否是 搜索
    BOOL _isColl;                   //NO - 当前显示是top10  YES - 当前显示是收藏
    
    CGFloat _originVolume;          //记录系统音量
    MPVolumeView *_volumeView;
    UISlider *_volumeViewSlider;
}
@property(nonatomic,strong)UIView *searchBg;                //搜索框背景
@property(nonatomic,strong)UISearchBar *search;

@property(nonatomic,strong)MusicHeaderView *musicClassV;    //音乐分类

/** 记录 cell 是否打开 */
@property (nonatomic, assign) BOOL isOpen;
/** 记录当前点击的 cell 行数 */
@property (nonatomic, assign) int curRow;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSMutableArray *allArray;

@end
@implementation musicViewVideo
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
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _volumeViewSlider.value = _originVolume ;
    //指示器消失
    [PublicView indictorHide];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //指示器消失
    [PublicView indictorHide];
    _isSearch = NO;
    _search.text = @"";
    [self resetAttribute];
    [self recoveryHeight];
    if (_isColl == NO) {
        //重新加载热门
        [self pullTopTenMusic];
    }else{
        [self pullCollectMusic];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _originVolume = [AVAudioSession sharedInstance].outputVolume;
    _volumeViewSlider.value = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self creatVoluem];
    [self creatNavi];
    _paging = 1;
    _isSearch = NO;
    _isColl = NO;
    self.curRow = -1;
    self.allArray = [NSMutableArray array];
    self.models = [NSArray array];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, _window_width, 400)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    [self.view addSubview:self.searchBg];
    [self.view addSubview:self.musicClassV];
    [self.view addSubview:self.tableView];
    
}
-(void)resetAttribute {
    self.isOpen = NO;
    self.curRow = -1;
    _paging = 1;
    self.allArray = nil;
    self.allArray = [NSMutableArray array];
    [self.tableView reloadData];
}
#pragma mark - top10
-(void)pullTopTenMusic {
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Music.hotLists&uid=%@",[Config getOwnID]];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging == 1) {
                [self.allArray removeAllObjects];
            }
            if (infoA.count<=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.allArray addObjectsFromArray:infoA];
            }
            if (self.allArray.count==0) {
                [PublicView showTextNoData:weakSelf.tableView text1:YZMsg(@"对不起~") text2:YZMsg(@"没有搜索到相关内容")];
            }else{
                [PublicView hiddenTextNoData:weakSelf.tableView];
            }
            [self.tableView reloadData];
        }else{
            [PublicView showTextNoData:weakSelf.tableView text1:YZMsg(@"对不起~") text2:YZMsg(@"没有搜索到相关内容")];
            [MBProgressHUD showError:msg];
        }
    } Fail:^(id fail) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 收藏
-(void)pullCollectMusic {
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Music.getCollectMusicLists&uid=%@&p=%d",[Config getOwnID],_paging];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging == 1) {
                [self.allArray removeAllObjects];
            }
            if (infoA.count<=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.allArray addObjectsFromArray:infoA];
            }
            
            if (self.allArray.count==0) {
                [PublicView showTextNoData:weakSelf.tableView text1:@"" text2:@"你还没有收藏任何音乐"];
            }else{
                [PublicView hiddenTextNoData:weakSelf.tableView];
            }
            [self.tableView reloadData];
        }else{
            [PublicView showTextNoData:weakSelf.tableView text1:@"" text2:@"还没有收藏任何音乐"];
            [MBProgressHUD showError:msg];
        }
    } Fail:^(id fail) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 搜索
-(void)pullSearchMusic {
    NSString *url = [purl stringByAppendingFormat:@"?service=Music.searchMusic&key=%@&p=%d&uid=%@",self.search.text,_paging,[Config getOwnID]];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            //指示器消失
            [PublicView indictorHide];
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging == 1) {
                [self.allArray removeAllObjects];
            }
            if (infoA.count<=0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.allArray addObjectsFromArray:infoA];
            }
            
            if (self.allArray.count ==0) {
                [PublicView showTextNoData:weakSelf.tableView text1:YZMsg(@"对不起~") text2:YZMsg(@"没有搜索到相关内容")];
            }else{
                [PublicView hiddenTextNoData:weakSelf.tableView];
            }
            [self.tableView reloadData];
        }else{
            [PublicView showTextNoData:weakSelf.tableView text1:YZMsg(@"对不起~") text2:YZMsg(@"没有搜索到相关内容")];
            [MBProgressHUD showError:msg];
            //指示器消失
            [PublicView indictorHide];
        }
    } Fail:^(id fail) {
        //指示器消失
        [PublicView indictorHide];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];
}
-(NSArray *)models{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in self.allArray) {
        MusicModel *model = [MusicModel modelWithDic:dic];
        [array addObject:model];
    }
    _models = array;
    return _models;
}

#pragma mark - 点击事件

-(void)keyHide{
    [self.search resignFirstResponder];
}

#pragma mark - 音乐播放、暂停
-(void)playMusic:(NSString *)path currentCell:(MusicCell *)cell currentIndex:(NSIndexPath*)indexPath{
    NSLog(@"播放");
    
    if (self.curRow !=indexPath.row) {
        //点击过cell并且非同一行时候，清除掉上一个播放器
        [self stopMusic];
    }
    
    if (!_musicPlayer) {

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
        
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
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    MusicModel *model = _models[indexPath.row];
//    NSFileManager* fileManager=[NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *loadPath = [docDir stringByAppendingFormat:@"/*%@*%@*%@*%@.mp3",model.musicNameStr,model.singerStr,model.timeStr,model.songID];
//    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:loadPath];
//    if (blHave) {
//        [fileManager removeItemAtPath:loadPath error:nil];
//        [self.tableView reloadData];
//        [MBProgressHUD showError:@"音乐缓存清除成功"];
//    }else{
//        [MBProgressHUD showError:@"音乐缓存为空"];
//    }
//    [self stopMusic];
//    
//}
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
            if (weakSelf.pathEvent) {
                weakSelf.pathEvent(loadPath, model.songID);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
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
        if ([rs isEqual:@"sucess"]) {
            [weakSelf stopMusic];
             [weakSelf playMusic:loadPath currentCell:weakCell currentIndex:indexPath];
        }else{
            [MBProgressHUD showError:erro];
        }
        [[JCHATAlertViewWait ins] hidenAll];
    };
//    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicCell *cell = (MusicCell *)[tableView cellForRowAtIndexPath:indexPath];
    MusicModel *model = _models[indexPath.row];
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
    //处理显示、隐藏开拍按钮
    if (self.curRow == (int)indexPath.row) {
        return;
    }
    MusicCell *lastCell = (MusicCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.curRow inSection:0]];
    [lastCell.StateBtn setImage:[UIImage imageNamed:@"music_play"] forState:0];
    self.isOpen = YES;
    self.curRow = (int)indexPath.row;
    /** 刷新tableView，系统默认会有一个自带的动画 */
    [tableView beginUpdates];
    [tableView endUpdates];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //普通cell 80 播放音乐+50
    return (self.curRow == (int)indexPath.row && self.isOpen) ? 130 : 80;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.search resignFirstResponder];
}

#pragma mark - 搜索关键词/清除关键词 更改分类以及tableview的高度
-(void)reduceHeight {
    _musicClassV.frame = CGRectMake(0, _searchBg.bottom+5, _window_width, 0);
    _tableView.frame = CGRectMake(0,_musicClassV.bottom, _window_width, _window_height-64-statusbarHeight-ShowDiff-_searchBg.height-_musicClassV.height-5);
}
-(void)recoveryHeight {
    _musicClassV.frame = CGRectMake(0, _searchBg.bottom+5, _window_width, classHeight);
    _tableView.frame = CGRectMake(0,_musicClassV.bottom, _window_width, _window_height-64-statusbarHeight-ShowDiff-_searchBg.height-_musicClassV.height-5);
}

#pragma mark - 搜索框
-(void)clickClearBtn {
    _isSearch = NO;
    [self recoveryHeight];
    if (_isColl == NO) {
        //重新加载热门
        [self pullTopTenMusic];
    }else{
        [self pullCollectMusic];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //一个一个字清空搜索框的时候
    if (searchText.length==0) {
        _isSearch = NO;
        [self recoveryHeight];
        if (_isColl == NO) {
            //重新加载热门
            [self pullTopTenMusic];
        }else{
            [self pullCollectMusic];
        }
    }else{
        
        _isSearch = YES;
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isSearch = YES;
    [self reduceHeight];
    //指示器显示
    [PublicView indictorShow];
    
    [searchBar resignFirstResponder];
//    self.allArray = nil;
//    self.allArray = [NSArray array];
//    [self.tableView reloadData];
    //重置部分属性
    [self resetAttribute];
    
    [self pullSearchMusic];
    
}

#pragma mark - set/get
-(UIView *)searchBg {
    if (!_searchBg) {
        _searchBg = [[UIView alloc]initWithFrame:CGRectMake(0,80+statusbarHeight,_window_width,44)];
        _searchBg.backgroundColor = [UIColor whiteColor];
        
        _search = [[UISearchBar alloc]initWithFrame:CGRectMake(20,2, _window_width-40,40)];
        _search.backgroundImage = [PublicObj getImgWithColor:RGB_COLOR(@"#f9fafb", 1)];
        _search.placeholder = @"搜索歌曲名称";
        _search.delegate = self;
        _search.layer.cornerRadius = 20;
        _search.layer.masksToBounds = YES;
        UITextField *textField = [_search valueForKey:@"_searchField"];
        [textField setBackgroundColor:RGB_COLOR(@"#f9fafb", 1)];
        [textField setValue:GrayText forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        UIButton *clearBtn = [textField valueForKey:@"_clearButton"];
        [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        textField.textColor = GrayText;
        textField.layer.cornerRadius = 18;
        textField.layer.masksToBounds = YES;
        [_searchBg addSubview:_search];
    }
    return _searchBg;
}
- (MusicHeaderView *)musicClassV {
    if (!_musicClassV) {
        //5个像素空隙
        classHeight = _window_width/5+60;
        YBWeakSelf;
        _musicClassV = [[MusicHeaderView alloc]initWithFrame:CGRectMake(0, _searchBg.bottom+5, _window_width, classHeight) withBlock:^(NSString *type, NSString *title) {
            //停止播放音乐
            [weakSelf stopMusic];
            
            MusicClassVC *classVC = [[MusicClassVC alloc]init];
            classVC.navi_title = title;
            classVC.class_id = type;
            if ([_fromWhere isEqual:@"edit"]) {
                classVC.fromWhere = _fromWhere;
            }
            classVC.backEvent = ^(NSString *type, NSString *loadPath, NSString *songID) {
                //从音乐分类中返回事件
                if (weakSelf.pathEvent && [type isEqual:@"分类音乐"]) {
                    weakSelf.pathEvent(loadPath, songID);
                }
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                
            };
            [weakSelf.navigationController pushViewController:classVC animated:YES];
        }];
        _musicClassV.backgroundColor = [UIColor whiteColor];
        _musicClassV.segEvent = ^(NSString *type) {
            //重置部分属性
            [weakSelf resetAttribute];
            [weakSelf stopMusic];
            if ([type isEqual:YZMsg(@"热门")]) {
                _isColl = NO;
                [weakSelf pullTopTenMusic];
            }else{//收藏
                _isColl = YES;
                [weakSelf pullCollectMusic];
            }
        };
        
    }
    return _musicClassV;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_musicClassV.bottom, _window_width, _window_height-64-statusbarHeight-ShowDiff-_searchBg.height-_musicClassV.height-5) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = Black_Cor;
        _tableView.separatorStyle = UITableViewCellAccessoryNone;
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _paging = 1;
            if (_isSearch == YES) {
                [self pullSearchMusic];
            }else{
                if (_isColl == YES) {
                    [self pullCollectMusic];
                }else{
                    [self pullTopTenMusic];
                }
            }
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _paging +=1;
            if (_isSearch == YES) {
                [self pullSearchMusic];
            }else{
                if (_isColl == YES) {
                    [self pullCollectMusic];
                }else{
                    //top10没有分页
                    _paging = 1;
                    [self pullTopTenMusic];
                }
            }
        }];
        
        UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyHide)];
        swip.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
        [_tableView addGestureRecognizer:swip];
    }
    return _tableView;
}

#pragma mark - 导航
-(void)creatNavi {
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 40+statusbarHeight, _window_width, 40)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"选择音乐";
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, 0,_window_width,40);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(8,0,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"video_关闭_gray"] forState:UIControlStateNormal];
    [returnBtn setTintColor:[UIColor blackColor]];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    [self.view addSubview:navtion];
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:navtion.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = navtion.bounds;
    maskLayer.path = maskPath.CGPath;
    navtion.layer.mask = maskLayer;
    
//    YBNavi *navi = [[YBNavi alloc]init];
//    navi.leftHidden = NO;
////    if ([_fromWhere isEqual:@"edit"]) {
////        navi.rightHidden = YES;
////    }else{
////        navi.rightHidden = NO;
////    }
//    navi.rightHidden = YES;
//
//    navi.haveTitleR = YES;
//    [navi ybNaviLeft:^(id btnBack) {
//        //停止播放音乐
//        [self stopMusic];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    } andRightName:@"开拍" andRight:^(id btnBack) {
//        //停止播放音乐
//        [self stopMusic];
//        TCVideoRecordViewController *videoRecord = [TCVideoRecordViewController new];
//        videoRecord.haveBGM = NO;
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:videoRecord];
//        nav.navigationBarHidden = YES;
//        [self presentViewController:nav animated:YES completion:nil];
//    } andMidTitle:@"选择音乐"];
//    navi.frame = CGRectMake(0, 24+statusbarHeight, _window_width, 40);
//    [navi.leftBtn setImage:[UIImage imageNamed:@"video_返回"] forState:0];
//    [self.view addSubview:navi];
}
- (void)doReturn{
    [self stopMusic];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc{

}
@end
