//
//  AlbumVideoVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "AlbumVideoVC.h"

#import "AlbumVideoCell.h"
#import <Photos/Photos.h>

@interface AlbumVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>{
    UIView *navtion;
    CGFloat hhhhhhhh;
    UIActivityIndicatorView *_indicatorV;
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation AlbumVideoVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;

//    if (_dataArray.count==0) {
//        [self getAlbumVideo];
//    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_dataArray.count==0) {
        [self getAlbumVideo];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarHidden = YES;
    [_indicatorV stopAnimating];
    [_indicatorV setHidesWhenStopped:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    if (![PublicObj havePhotoLibraryAuthority]) {
        //注册实施监听相册变化
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    
    [self creatNavi];
    self.dataArray = [NSArray array];
//    [self getAlbumVideo];
    [self.view addSubview:self.collectionView];
    
    //指示器
    _indicatorV = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorV.frame = CGRectMake(_window_width/2-20, 100, 40, 40);
    [_indicatorV startAnimating];
    [_collectionView addSubview:_indicatorV];
  
}

#pragma mark - 相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if ([PublicObj havePhotoLibraryAuthority]) {
            [self getAlbumVideo];
        }
        [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
    });
}


#pragma mark - 获取相册视频
-(void)getAlbumVideo{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld",PHAssetMediaTypeVideo];
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    
    //获取所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *streamAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
    PHFetchResult *userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];
    
    NSArray *arrAllAlbums = @[smartAlbums, streamAlbums, userAlbums, syncedAlbums, sharedAlbums];
    
    __block NSMutableArray *m_array = [NSMutableArray array];
    
    for (PHFetchResult<PHAssetCollection *> *album in arrAllAlbums) {
        
        [album enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull collection, NSUInteger idx, BOOL *stop) {
            //过滤PHCollectionList对象
            if (![collection isKindOfClass:PHAssetCollection.class]) return;
            //过滤最近删除和已隐藏
            if (collection.assetCollectionSubtype > 215 ||
                collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) return;
            //获取相册内asset result
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
            NSString *title = collection.localizedTitle;
            NSLog(@"===6.26===%@====%@==%ld",result,title,(long)collection.assetCollectionSubtype);
            if (!result.count) return;
            
            if (collection.assetCollectionSubtype==PHAssetCollectionSubtypeSmartAlbumVideos) {
                
                [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *m_dic = [NSMutableDictionary dictionary];
                    PHAsset *phAsset = (PHAsset *)obj;
                    NSLog(@"===88=%@",phAsset);
                    NSString *position = [NSString string];
                    if ([PublicObj judgeAssetisInLocalAblum:phAsset]) {
                        position = @"location";
                    }else{
                        position = @"iCloud";
                    }
                    [m_dic setObject:position forKey:@"position"];
                    [self getVideoPathFromPHAsset:phAsset Complete:^(NSString *filePatch, NSString *dTime) {
                        if (filePatch && dTime) {
                            [m_dic setObject:filePatch forKey:@"filePath"];
                            [m_dic setObject:dTime forKey:@"time"];
                        }
                        
                    }];
                    [self getVideoImageFromPHAsset:phAsset Complete:^(UIImage *image) {
                        [m_dic setObject:image forKey:@"cover"];
                    }];
                    [m_array addObject:m_dic];
                }];
            }
        }];
    }
    
     NSLog(@"=======%lu",(unsigned long)m_array.count);
    
    _dataArray = [NSArray arrayWithArray:m_array];
    if (_dataArray.count == 0) {
        [PublicView showTextNoData:_collectionView text1:@"" text2:@"无本地视频"];
    }else{
        [PublicView hiddenTextNoData:_collectionView];
    }
    [_indicatorV stopAnimating];
    [_indicatorV setHidesWhenStopped:YES];
    [self.collectionView reloadData];
}

#pragma mark - 根据asset获取视频地址、时间
- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(void (^)(NSString *filePatch,NSString *dTime))result {
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        
        NSString * sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
        NSArray * arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
        NSString * filePath = arr[arr.count - 1];
        
        CMTime   time = [asset duration];
        int seconds = ceil(time.value/time.timescale);
        //format of minute
        NSString *str_minute = [NSString stringWithFormat:@"%d",seconds/60];
        //format of second
        NSString *str_second = [NSString stringWithFormat:@"%.2d",seconds%60];
        //format of time
        NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
        result(filePath,format_time);
    }];
}
#pragma mark - 根据asset获取视频封面
- (void)getVideoImageFromPHAsset:(PHAsset *)asset Complete:(void (^)(UIImage *image))resultBack{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(200, 200) contentMode:PHImageContentModeDefault options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        UIImage *iamge = result;
        resultBack(iamge);
    }];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumVideoCell *cell = (AlbumVideoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumVideoCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    [cell.coverIV setImage:[dic valueForKey:@"cover"]];
    NSString *time = [NSString stringWithFormat:@"%@",[dic valueForKey:@"time"]];
    if ([time isEqual:@"(null)"]) {
        //时间为空的是iCloud视频
        time = @"";
    }
    cell.timeL.text = time;
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = _dataArray[indexPath.row];
    
    NSString *postion = [NSString stringWithFormat:@"%@",[dic valueForKey:@"position"]];
    if ([postion isEqual:@"iCloud"]) {
        [MBProgressHUD showError:@"请将iCloud视频从系统相册下载到本地后重新尝试"];
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@",[dic valueForKey:@"filePath"]];
    if (self.selEvent) {
        self.selEvent(path);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake(_window_width/4-2, _window_width/4-2);
        flow.minimumLineSpacing = 1;
        flow.minimumInteritemSpacing = 0.5;
        [flow setHeaderReferenceSize:CGSizeMake(_window_width, 0)];
        [flow setFooterReferenceSize:CGSizeMake(_window_width, 0)];
       
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,navtion.bottom, _window_width, _window_height-(navtion.bottom)) collectionViewLayout:flow];
        [_collectionView registerNib:[UINib nibWithNibName:@"AlbumVideoCell" bundle:nil] forCellWithReuseIdentifier:@"AlbumVideoCell"];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate =self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = Black_Cor;
    }
    return _collectionView;
}

#pragma mark - 导航
-(void)creatNavi {
    if (iPhoneX) {
        hhhhhhhh = 20;
    }else{
        hhhhhhhh = 0;
    }
    navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + hhhhhhhh)];
    

    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"本地视频";
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, hhhhhhhh,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, hhhhhhhh, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + hhhhhhhh,40,40);
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

//    navi = [[YBNavi alloc]init];
//    navi.leftHidden = NO;
//    navi.rightHidden = YES;
////    navi.imgTitleSameR = YES;
//    [navi ybNaviLeft:^(id btnBack) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } andRightName:@"" andRight:^(id btnBack) {
//
//    } andMidTitle:@"本地视频"];
//    if (iPhoneX) {
//        navi.frame = CGRectMake(0, 20, _window_width, 64+20);
//    }else{
//        navi.frame = CGRectMake(0, 20, _window_width, 64);
//    }
//    [self.view addSubview:navi];
}
- (void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
/*
 -(NSDictionary *)getVideoMsgWithPHAsset:(PHAsset *)asset {
 
 NSDictionary *dic = [NSDictionary dictionary];
 
 PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
 options.version = PHImageRequestOptionsVersionCurrent;
 options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
 
 [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
 
 NSString * sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
 
 NSArray * arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
 
 NSString * filePath = arr[arr.count - 1];
 
 CMTime   time = [asset duration];
 int seconds = ceil(time.value/time.timescale);
 //format of minute
 NSString *str_minute = [NSString stringWithFormat:@"%d",seconds/60];
 //format of second
 NSString *str_second = [NSString stringWithFormat:@"%.2d",seconds%60];
 //format of time
 NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
 dic = @{
 @"filePath":filePath,
 @"formatTime":format_time,
 }
 }];
 return dic;
 }
 */
