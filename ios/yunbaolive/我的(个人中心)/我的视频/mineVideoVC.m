//
//  mineVideoVC.m
//  yunbaolive
//
//  Created by Boom on 2018/12/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "mineVideoVC.h"
#import "mineVideoCell.h"
#import "NearbyVideoModel.h"
#import "LookVideo.h"
@interface mineVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    int page;
    NSMutableArray *infoArray;
    UIView *nothingView;

}
@property (nonatomic,strong)UICollectionView *collectionView;
@end

@implementation mineVideoVC
-(void)navtion{
    UIView *navtion = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = _titleStr;
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self navtion];
    infoArray = [NSMutableArray array];
    page = 1;
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake((_window_width-2)/3, (_window_width-2)/3/25*33);
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = 1;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height-(64+statusbarHeight)) collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"mineVideoCell" bundle:nil] forCellWithReuseIdentifier:@"mineVideoCELL"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.mj_footer  = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestData];
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestData];
    }];
    
    [self.view addSubview:self.collectionView];
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"你还没有视频作品";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = @"赶快去拍摄上传吧～";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:label2];

    [self requestData];
    
}
- (void)requestData{

    [YBToolClass postNetworkWithUrl:@"video.gethomevideo" andParameter:@{@"p":@(page),@"touid":[Config getOwnID]} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (code == 0) {
            if (page == 1) {
                [infoArray removeAllObjects];
            }
            [infoArray addObjectsFromArray:info];
            if (infoArray.count == 0) {
                nothingView.hidden = NO;
            }else{
                nothingView.hidden = YES;
            }
            [_collectionView reloadData];
        }else{
            nothingView.hidden = NO;
        }
    } fail:^{
        nothingView.hidden = NO;
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return infoArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    mineVideoCell *cell = (mineVideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LookVideo *video = [[LookVideo alloc]init];
    
    video.fromWhere = @"myVideoV";
    video.curentIndex = indexPath.row;
    video.videoList = infoArray;
    video.pages = page;
    video.firstPlaceImage = cell.thumbImgView.image;
    video.requestUrl = [NSString stringWithFormat:@"%@/?service=video.gethomevideo&uid=%@&touid=%@",purl,[Config getOwnID],[Config getOwnID]];
    video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
        page = page;
        infoArray = array;
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    };
    video.hidesBottomBarWhenPushed = YES;
    [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    mineVideoCell *cell = (mineVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"mineVideoCELL" forIndexPath:indexPath];
    NSDictionary *subdic = infoArray[indexPath.row];
    cell.model = [[NearbyVideoModel alloc] initWithDic:subdic];
    return cell;
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
