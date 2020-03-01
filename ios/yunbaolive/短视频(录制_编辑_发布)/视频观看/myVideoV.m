//
//  myVideoV.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/8/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "myVideoV.h"
#import "LookVideo.h"
#import "NearbyVideoModel.h"
//#import "VideoCollectionCell.h"
#import "HotCollectionViewCell.h"
#import "ZYTabBar.h"

#import "AFNetworking.h"
@interface myVideoV ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)NSArray *modelrray;
@property(nonatomic,strong)UICollectionView *collectionView;
@end
@implementation myVideoV
{
    CGFloat oldOffset;
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _modelrray = [NSArray array];
    _page = 1;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.allArray = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2-1, (_window_width/2-1) * 1.4);
    flow.minimumLineSpacing = 2;
    flow.minimumInteritemSpacing = 2;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotCollectionViewCELL"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.mj_footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self pullInternetforNew:_page];
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self pullInternetforNew:_page];
        
    }];
    
    [self.view addSubview:self.collectionView];
    _collectionView.contentInset = UIEdgeInsetsMake(64+statusbarHeight, 0, 0, 0);

    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
  
    [self pullInternetforNew:1];
    //因为列表不可以每次 都重新刷新，影响用户体验，也浪费流量
    //在视频页面输出视频后返回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLiveList:) name:@"delete" object:nil];
    //发布视频成功之后返回首页刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pullInternetforNewDown) name:@"reloadlist" object:nil];
    
}
//在视频页面删除视频回来后删除
-(void)getLiveList:(NSNotification *)nsnitofition{
    NSString *videoid = [NSString stringWithFormat:@"%@",[[nsnitofition userInfo] valueForKey:@"videoid"]];
    NSDictionary *deletedic = [NSDictionary dictionary];
    for (NSDictionary *subdic in self.allArray) {
        NSString *videoids = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        if ([videoid isEqual:videoids]) {
            deletedic = subdic;
            break;
        }
    }
    if (deletedic) {
        [self.allArray removeObject:deletedic];
        [self.collectionView reloadData];
    }
}
-(void)refreshNear{
}
//down
-(void)pullInternetforNewDown{
    self.allArray = [NSMutableArray array];
    _page = 1;
    [self pullInternetforNew:_page];
}
-(void)getDataByFooterup{
    _page ++;
    [self pullInternetforNew:_page];
}
-(void)pullInternetforNew:(NSInteger)pages{
   
    self.collectionView.userInteractionEnabled = NO;
   
    NSString *url = [NSString stringWithFormat:@"%@&p=%ld",_url,(long)pages];
    YBWeakSelf;
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        weakSelf.collectionView.userInteractionEnabled = YES;
        if ([code isEqual:@"0"]) {
            NSArray *info = [data valueForKey:@"info"];
            if (_page == 1) {
                [self.allArray removeAllObjects];
            }
            [self.allArray addObjectsFromArray:info];
            //加载成功 停止刷新
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
            if (self.allArray.count > 0) {
                [PublicView hiddenTextNoData:_collectionView];
            }else{
                [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无热门视频哦~"];
            }
            if (info.count <= 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }else if ([code isEqual:@"700"]){
            [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];

        }else{
            if (self.allArray) {
                [self.allArray removeAllObjects];
            }
            [self.collectionView reloadData];
            [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无热门视频哦~"];
        }
    } Fail:^(id fail) {
        weakSelf.collectionView.userInteractionEnabled = YES;
        [self checkNetwork];
        self.collectionView.userInteractionEnabled = YES;
        if (self.allArray) {
            [self.allArray removeAllObjects];
        }
        [self.collectionView reloadData];
        [PublicView showTextNoData:_collectionView text1:@"" text2:@"暂无热门视频哦~"];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
    
}
#pragma mark - Table view data source
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake((_window_width - 6)/2,(_window_width - 6)/2 * 1.4);
//}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(2,2,2,2);
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LookVideo *video = [[LookVideo alloc]init];
    
    video.fromWhere = @"myVideoV";
    video.curentIndex = indexPath.row;
    video.videoList = _allArray;
    video.pages = _page;
    video.firstPlaceImage = cell.thumbImageView.image;
    video.requestUrl = _url;
    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        _page = page;
        self.allArray = array;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    };
    video.hidesBottomBarWhenPushed = YES;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HotCollectionViewCELL" forIndexPath:indexPath];
    NSDictionary *subdic = _allArray[indexPath.row];
    cell.videoModel = [[NearbyVideoModel alloc] initWithDic:subdic];
    return cell;
}

- (void)checkNetwork{
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
            _page = 1;
            [self pullInternetforNew:_page];
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
            _page = 1;
            [self pullInternetforNew:_page];
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            _page = 1;
            [self pullInternetforNew:_page];
            NSLog(@"wifi-------");
        }
    }];
}
#pragma mark ================ socrollview代理 ===============
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    oldOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > oldOffset) {
        if (scrollView.contentOffset.y > 0) {
            _pageView.hidden = YES;
            [self hideTabBar];
        }
    }else{
        _pageView.hidden = NO;
        [self showTabBar];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%f",oldOffset);
}
#pragma mark ================ 隐藏和显示tabbar ===============
- (void)hideTabBar {
    
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    self.tabBarController.tabBar.hidden = YES;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = YES;
}
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    self.tabBarController.tabBar.hidden = NO;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = NO;
    
}

@end
