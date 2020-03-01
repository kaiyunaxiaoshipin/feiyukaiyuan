//
//  TencentLocationVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/20.
//  Copyright © 2018年 cat. All rights reserved.
//
#define SCR_H (self.view.bounds.size.height)

#define SearchBarH 44
#define MapViewH 300

#define StatusBar_HEIGHT 20
#define NavigationBar_HEIGHT 44

#import "TencentLocationVC.h"

#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import "MJRefresh.h"
#import "SearchResultView.h"

#import "LocationCell.h"

@interface TencentLocationVC ()<UITableViewDelegate,UITableViewDataSource,QMapViewDelegate,UISearchBarDelegate,QMSSearchDelegate> {
    NSString *_selAddress;
    NSString *_selInfo;
}
@property (nonatomic,strong)QMapView *mapView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray <QMSPoiData*>* dataList;
@property(nonatomic,strong)NSMutableArray *flagArray;   //cell选中标记
@property (nonatomic,strong)QMSSearcher *searcher;
@property (nonatomic,strong)UIImageView *imageViewAnntation;
@property (nonatomic,strong)NSObject *object;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,strong)NSNumber *secondPageIndex;
@property (nonatomic,assign)BOOL isNeedLocation;
@property (nonatomic,assign)NSInteger isSearchPage; //1:YES  2:NO
@property (nonatomic,strong)QMSReGeoCodeAdInfo *currentAddressInfo;

@property(nonatomic,strong)QMSReverseGeoCodeSearchOption *regeocoder;

//搜索组合 取消、搜索框
@property(nonatomic,strong)UIView *topMix;
@property(nonatomic,strong)UIButton *cancleBtn;
@property(nonatomic,strong)UISearchBar *searchBar;  //搜索框

@property(nonatomic,strong)SearchResultView *resultView;

@end

@implementation TencentLocationVC

- (NSMutableArray<QMSPoiData *> *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.isNeedLocation = YES;
    self.object = [[NSObject alloc] init];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isNeedLocation = NO;
    self.object = nil;
    [self.dataList removeAllObjects];
    [self.flagArray removeAllObjects];
    [self.mapView.delegate mapViewDidStopLocatingUser:self.mapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    _selAddress = @"";
    _selInfo = @"";
    self.flagArray = [NSMutableArray array];
    self.pageIndex = 1;
    [self creatNavi];
    [self.view addSubview:self.topMix];
    [self setMapView];
    [self setMainTableView];
    
    __weak typeof (self) weakSelf = self;
    self.resultView.searchResultsPage = ^(NSInteger page) {
        weakSelf.secondPageIndex = @(page);
        weakSelf.isSearchPage = 1;
        QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
        poiSearchOption.keyword = weakSelf.searchBar.text;
        NSString *boundary = [NSString stringWithFormat:@"%@%@%@",@"region(",weakSelf.currentAddressInfo.province,@",1)"];
        poiSearchOption.boundary = boundary;   //@"region(北京,1)"
        poiSearchOption.page_size = 20;
        poiSearchOption.page_index = weakSelf.secondPageIndex == nil ? 1 : [weakSelf.secondPageIndex integerValue];
        [weakSelf.searcher searchWithPoiSearchOption:poiSearchOption];
    };
    
    [self.view addSubview:self.resultView];
}

#pragma mark - 发送位置
- (void)sendCurrentLocation {
    [self dismissViewControllerAnimated:YES completion:nil];
    //发送位置时截图
    [self.mapView takeSnapshotInRect:self.mapView.bounds withCompletionBlock:^(UIImage *resultImage, CGRect rect) {
        //resultImage是截取好的图片
        //同时发送当前位置数据
        //self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude
        NSLog(@"发送=====%@----纬度:%f-----经度:%f",resultImage,self.mapView.centerCoordinate.latitude,self.mapView.centerCoordinate.longitude);
        
        NSDictionary *mix = @{@"name":_selAddress?_selAddress:@"火星",
                              @"info":_selInfo?_selInfo:@"",
                              };
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mix options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *dic = @{@"latitude":@(self.mapView.centerCoordinate.latitude),
                              @"longitude":@(self.mapView.centerCoordinate.longitude),
                              @"address":jsonStr,
                              };
        self.locationEvent(dic);
    }];
}

#pragma mark - 复位
- (void)clickResetButton {
    CLLocationCoordinate2D center = self.mapView.userLocation.coordinate;
    [self.mapView setCenterCoordinate:center animated:YES];
}

- (void)loadPastData {
    [self.tableView.mj_footer endRefreshing];
    QCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = self.mapView.region.center;
    region.center= centerCoordinate;
    self.isSearchPage = 2;
    QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
    poiSearchOption.page_size = 20;
    self.pageIndex ++;
    poiSearchOption.page_index = self.pageIndex;
    [poiSearchOption setBoundaryByNearbyWithCenterCoordinate:centerCoordinate radius:1000];
    [self.searcher searchWithPoiSearchOption:poiSearchOption];
}

#pragma mark - 选中搜索位置回调
- (void)refreshData:(QMSPoiData *)result {
    
    CLLocationCoordinate2D center = result.location;
    [self.mapView setCenterCoordinate:center animated:YES];
    _searchBar.text = nil;
    self.isSearchPage = 2;
    QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
    poiSearchOption.page_size = 20;
    [poiSearchOption setBoundaryByNearbyWithCenterCoordinate:result.location radius:1000];
    [self.searcher searchWithPoiSearchOption:poiSearchOption];
}

#pragma mark - 触摸事件

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_resultView.hidden==NO) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint _touchPoint = [touch locationInView:self.view];
        if (YES == CGRectContainsPoint(_resultView.frame, _touchPoint)){
            [self clickSearchCancle];
        }
    }
}

#pragma mark - 搜索取消
-(void)clickSearchCancle {
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        _resultView.hidden = YES;
        _topMix.frame = CGRectMake(0, 64+statusbarHeight, _window_width, 44+10);
        _searchBar.frame = CGRectMake(0,0, _window_width,44);
        _cancleBtn.frame = CGRectMake(_searchBar.right, _searchBar.top, 80, 44);
        self.mapView.frame = CGRectMake(0,CGRectGetMaxY(_topMix.frame), self.view.bounds.size.width, MapViewH);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.bounds.size.width, self.view.bounds.size.height - MapViewH - 64-10-ShowDiff-statusbarHeight);
        self.imageViewAnntation.center = self.mapView.center;
    }];
    
}
#pragma mark - 搜索框
-(void)clickClearBtn {
    _resultView.alpha = 0.3;
    _resultView.tableView.hidden = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //一个一个字清空搜索框的时候
    if (searchText.length==0) {
        _resultView.alpha = 0.3;
        _resultView.tableView.hidden = YES;
    }else{
        _resultView.alpha = 1;
        _resultView.tableView.hidden = NO;
        self.isSearchPage = 1;
        QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
        poiSearchOption.keyword = _searchBar.text;
        NSString *boundary = [NSString stringWithFormat:@"%@%@%@",@"region(",self.currentAddressInfo.city,@",1)"];
        poiSearchOption.boundary = boundary;   //@"region(北京,1)"
        poiSearchOption.page_size = 20;
        poiSearchOption.page_index = 1;
        self.resultView.pageIndex = 1;
        [self.searcher searchWithPoiSearchOption:poiSearchOption];
    }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0 ) {
        [_resultView.dataSource removeAllObjects];
        [_resultView.tableView reloadData];
        _resultView.alpha = 0.3;
        _resultView.tableView.hidden = YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _resultView.hidden = NO;
        _topMix.frame = CGRectMake(0, 0, _window_width, 64+statusbarHeight);
        _searchBar.frame = CGRectMake(0,20+statusbarHeight, _window_width-80,44);
        _cancleBtn.frame = CGRectMake(_searchBar.right, _searchBar.top, 80, 44);
        self.mapView.frame = CGRectMake(0,CGRectGetMaxY(self.topMix.frame), self.view.bounds.size.width, MapViewH);
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.bounds.size.width, self.view.bounds.size.height - MapViewH - 64-10);
        self.imageViewAnntation.center = self.mapView.center;
    }];
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _resultView.alpha = 1;
    _resultView.tableView.hidden = NO;
    self.isSearchPage = 1;
    QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
    poiSearchOption.keyword = _searchBar.text;
    NSString *boundary = [NSString stringWithFormat:@"%@%@%@",@"region(",self.currentAddressInfo.city,@",1)"];
    poiSearchOption.boundary = boundary;   //@"region(北京,1)"
    poiSearchOption.page_size = 20;
    poiSearchOption.page_index = 1;
    self.resultView.pageIndex = 1;
    [self.searcher searchWithPoiSearchOption:poiSearchOption];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITabelViewDataSource / UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LocationCell *cell = [LocationCell cellWithTab:tableView andIndexPath:indexPath];
    cell.addressL.text = self.dataList[indexPath.row].title;
    cell.infoL.text = self.dataList[indexPath.row].address;
    cell.backgroundColor = CellRow_Cor;
    NSString *flag = [NSString stringWithFormat:@"%@",_flagArray[indexPath.row]];
    if ([flag isEqual:@"1"]) {
        cell.falgIV.hidden = NO;
    }else {
         cell.falgIV.hidden = YES;
    }
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_flagArray removeAllObjects];
    for (int i=0; i<_dataList.count; i++) {
        [_flagArray addObject:@"0"];
    }
    [_flagArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    [_tableView reloadData];
    
    _selAddress = [NSString stringWithFormat:@"%@",self.dataList[indexPath.row].title];
    _selInfo = [NSString stringWithFormat:@"%@",self.dataList[indexPath.row].address];
    CLLocationCoordinate2D center = [self.dataList objectAtIndex:indexPath.row].location;
    [self.mapView setCenterCoordinate:center animated:YES];
    self.object = [[NSObject alloc] init];
}

#pragma mark - QMapViewDelegate
#pragma mark - 开始定位
- (void)mapViewWillStartLocatingUser:(QMapView *)mapView {
    NSLog(@"开始定位%f--%f--%f--%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude,mapView.region.center.latitude,mapView.region.center.longitude);
    
}

#pragma mark - 结束定位
- (void)mapViewDidStopLocatingUser:(QMapView *)mapView{
    NSLog(@"结束定位");
}

#pragma mark - 刷新定位,只要位置发生变化就会调用
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    if (self.isNeedLocation) {
        if (updatingLocation) {
            
            self.regeocoder.location = [NSString stringWithFormat:@"%f,%f",mapView.region.center.latitude,mapView.region.center.longitude];
            [self.regeocoder setCoord_type:QMSReverseGeoCodeCoordinateTencentGoogleGaodeType];
            [self.searcher searchWithReverseGeoCodeSearchOption:self.regeocoder];
            
            self.isSearchPage = 2;
            QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
            poiSearchOption.page_size = 20;
            [poiSearchOption setBoundaryByNearbyWithCenterCoordinate:userLocation.location.coordinate radius:1000];
            [self.searcher searchWithPoiSearchOption:poiSearchOption];
        }
        self.isNeedLocation = NO;
    }
}

#pragma mark - 定位失败
- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"didFailToLocateUserWithError--error--%@",error);
    
}
-(void)mapViewDidFailLoadingMap:(QMapView *)mapView withError:(NSError *)error {
    NSLog(@"mapViewLoadingFail:%@",error);
}
-(void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"regionWillChange");
}
 #pragma mark -查询出现错误
- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError*)error {
    NSLog(@"searchWithSearchOption--error--%@",error);
}

#pragma mark - mapView移动后执行
- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //手动滑动地图定位
    if (self.object == nil) {
        self.pageIndex = 1;
        QCoordinateRegion region;
        CLLocationCoordinate2D centerCoordinate = mapView.region.center;
        region.center= centerCoordinate;
        self.isSearchPage = 2;
        QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
        poiSearchOption.page_size = 20;
        [poiSearchOption setBoundaryByNearbyWithCenterCoordinate:centerCoordinate radius:1000];
        [self.searcher searchWithPoiSearchOption:poiSearchOption];
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        self.object = nil;
    }
}

#pragma mark - poi查询结果回调函数
- (void)searchWithPoiSearchOption:(QMSPoiSearchOption *)poiSearchOption didReceiveResult:(QMSPoiSearchResult *)poiSearchResult {
    for (QMSPoiData *data in poiSearchResult.dataArray) {
        NSLog(@"%@-- %@-- %@",data.title,data.address,data.tel);
    }
    
    //根据本页地图返回的结果
    if (self.isSearchPage == 2) {
        //手滑动重新赋值数据源
        if (self.pageIndex == 1) {
            [self.dataList removeAllObjects];
            self.dataList = [NSMutableArray arrayWithArray:poiSearchResult.dataArray];
            [_flagArray removeAllObjects];
            for (int i=0; i<self.dataList.count; i++) {
                [_flagArray addObject:@"0"];
            }
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self tableView:_tableView didSelectRowAtIndexPath:index];
        } else {
            [self.dataList addObjectsFromArray:poiSearchResult.dataArray];
            for (int i=0; i<poiSearchResult.dataArray.count; i++) {
                [_flagArray addObject:@"0"];
            }
        }
        
        [self.tableView reloadData];
    }
    //搜索控制器根据关键词返回的结果
    if (self.isSearchPage == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SearchResultGetPoiSearchResult object:nil userInfo:@{@"data":poiSearchResult.dataArray}];
    }
}

#pragma mark - 根据定位当前的经纬度编码出当前位置信息
- (void)searchWithReverseGeoCodeSearchOption:(QMSReverseGeoCodeSearchOption *)reverseGeoCodeSearchOption didReceiveResult:(QMSReverseGeoCodeSearchResult *)reverseGeoCodeSearchResult {
    self.currentAddressInfo = reverseGeoCodeSearchResult.ad_info;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - set/get
-(SearchResultView *)resultView {
    if (!_resultView) {
        
        _resultView = [[SearchResultView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height-64-statusbarHeight)];
        _resultView.backgroundColor = [UIColor blackColor];
        _resultView.alpha = 0.3;
        _resultView.tableView.hidden = YES;
        _resultView.hidden = YES;
        YBWeakSelf;
        _resultView.dismissEvent = ^(QMSPoiData *reult) {
            [weakSelf refreshData:reult];
            [weakSelf clickSearchCancle];
        };
    }
    return _resultView;
}

-(UIView *)topMix {
    if (!_topMix) {
        _topMix = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 44+10)];
        _topMix.backgroundColor = CellRow_Cor;
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0, _window_width,44)];
        _searchBar.backgroundImage = [PublicObj getImgWithColor:CellRow_Cor];
        _searchBar.placeholder = YZMsg(@"搜索地点");
        _searchBar.delegate = self;
        UITextField *textField = [_searchBar valueForKey:@"_searchField"];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setValue:GrayText forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        UIButton *clearBtn = [textField valueForKey:@"_clearButton"];
        [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        textField.textColor = GrayText;
        textField.layer.cornerRadius = 18;
        textField.layer.masksToBounds = YES;
        [_topMix addSubview:_searchBar];
        
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(_searchBar.right, _searchBar.top, 80, 44);
        _cancleBtn.titleLabel.font = SYS_Font(15);;
        [_cancleBtn setTitle:YZMsg(@"取消") forState:0];
        [_cancleBtn setTitleColor:Pink_Cor forState:0];
        [_cancleBtn addTarget:self action:@selector(clickSearchCancle) forControlEvents:UIControlEventTouchUpInside];
        [_topMix addSubview:_cancleBtn];
        
    }
    return _topMix;
}

- (void)setMapView {
    self.regeocoder = [[QMSReverseGeoCodeSearchOption alloc] init];
    //mapView
    self.mapView = [[QMapView alloc] initWithFrame:CGRectMake(0, self.topMix.bottom, self.view.bounds.size.width, MapViewH)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    [self.mapView setShowsUserLocation:YES];
    self.mapView.showsScale = YES;
    [self.mapView setUserTrackingMode:QUserTrackingModeFollow animated:YES];
    _mapView.distanceFilter = kCLLocationAccuracyBest;//kCLLocationAccuracyNearestTenMeters;

    //传入当前定位中心点避免QMapView定位不到位置
    CLLocationCoordinate2D center;
    center.latitude = [[cityDefault getMylat] doubleValue];
    center.longitude = [[cityDefault getMylng] doubleValue];
    [self.mapView setCenterCoordinate:center zoomLevel:16.01 animated:YES];
    self.mapView.userLocation.coordinate = center;
    self.regeocoder.location = [NSString stringWithFormat:@"%f,%f",_mapView.region.center.latitude,_mapView.region.center.longitude];
    [self.regeocoder setCoord_type:QMSReverseGeoCodeCoordinateTencentGoogleGaodeType];
    //QMSSearcher
    self.searcher = [[QMSSearcher alloc] init];
    [self.searcher setDelegate:self];
    [self.searcher searchWithReverseGeoCodeSearchOption:self.regeocoder];
    self.isSearchPage = 2;
    QMSPoiSearchOption *poiSearchOption = [[QMSPoiSearchOption alloc] init];
    poiSearchOption.page_size = 20;
    [poiSearchOption setBoundaryByNearbyWithCenterCoordinate:center radius:1000];
    [self.searcher searchWithPoiSearchOption:poiSearchOption];
    
    UIButton *buttonReset = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, self.mapView.frame.size.height - 65, 50, 50)];
    //[buttonReset setTitle:@"复位" forState:UIControlStateNormal];
    [buttonReset setImage:[UIImage imageNamed:@"location_back"] forState:0];
    buttonReset.titleLabel.font = [UIFont systemFontOfSize:14];
    [buttonReset addTarget:self action:@selector(clickResetButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:buttonReset];
}

- (void)setMainTableView {
    //self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.bounds.size.width, self.view.bounds.size.height - MapViewH - SearchBarH - NavigationBar_HEIGHT - StatusBar_HEIGHT) style:UITableViewStylePlain];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), self.view.bounds.size.width, self.view.bounds.size.height - MapViewH - _topMix.height-statusbarHeight-64-ShowDiff) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = Black_Cor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新数据" forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = [UIColor blackColor];
    [self.tableView.mj_header beginRefreshing];
    
    self.imageViewAnntation = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.imageViewAnntation.center = self.mapView.center;
//    NSString *b_path = [[NSBundle mainBundle]pathForResource:@"QMapKit.bundle" ofType:nil];
//    NSString *img_path = [b_path stringByAppendingPathComponent:@"images/greenPin_lift.png"];
//    self.imageViewAnntation.image = [UIImage imageWithContentsOfFile:img_path];
    self.imageViewAnntation.image = [UIImage imageNamed:@"location_current"];
    self.imageViewAnntation.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageViewAnntation];
}

#pragma mark - 导航
-(void)creatNavi {
    YBNavi *_ybNavi = [[YBNavi alloc]init];
    _ybNavi.haveTitleR = YES;
    _ybNavi.haveTitleL = NO;
    
    [_ybNavi ybNaviLeft:^(id btnBack) {
        [self.navigationController popViewControllerAnimated:YES];
    } andRightName:YZMsg(@"发送") andRight:^(id btnBack) {
        [self sendCurrentLocation];
        [self.navigationController popViewControllerAnimated:NO];
        NSLog(YZMsg(@"发送"));
    } andMidTitle:@"位置"];
    
    [_ybNavi.leftBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:0];
//    [_ybNavi.leftBtn setTitle:YZMsg(@"取消") forState:0];
    [self.view addSubview:_ybNavi];
}

@end
