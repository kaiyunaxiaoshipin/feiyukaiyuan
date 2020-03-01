#import "Hotpage.h"
#import "hotModel.h"
#import "LivePlay.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "tuijianwindow.h"
#import "HotCollectionViewCell.h"
#import "classVC.h"
#import "allClassView.h"
#import "YBWebViewController.h"
#import "SDCycleScrollView.h"

@interface Hotpage ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate,tuijian,UIScrollViewDelegate,SDCycleScrollViewDelegate>
{
    NSDictionary *selectedDic;
    UIImageView *NoInternetImageV;//直播无网络的时候显示
    UIAlertController *alertController;//邀请码填写
    UITextField *codetextfield;
    NSString *type_val;//
    NSString *livetype;//
    tuijianwindow *tuijianw;
    CGFloat oldOffset;
    int page;
    UIView *collectionHeaderView;
    UIAlertController *md5AlertController;
    allClassView *allClassV;
    YBNoWordView *noNetwork;
    NSString *_sdkType;//0-金山  1-腾讯


}
@property(nonatomic,strong)NSMutableArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSMutableArray *infoArray;//获取到的主播列表信息
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;//加密密码
@property(nonatomic,strong)NSArray *CarouselArray;//轮播图
@property (nonatomic,strong) SDCycleScrollView *cycleScroll;

@end
@implementation Hotpage
-(void)jump{
    tuijianw.hidden = YES;
    [tuijianw removeFromSuperview];
    tuijianw = nil;
    //邀请码
    NSString *isregs = [[NSUserDefaults standardUserDefaults] objectForKey:@"isagent"];
    if ([isregs isEqual:@"1"]) {
        [self showyaoqingma];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%f",_collectionView.contentOffset.y);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    oldOffset = 0;
    type_val = @"0";
    livetype = @"0";
    page = 1;
    self.infoArray    =  [NSMutableArray array];
    self.zhuboModel    =  [NSMutableArray array];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self createCollectionView];
    [self nothingview];
    [self yaoqingma];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeConfig) name:@"home.getconfig" object:nil];
}
- (void)homeConfig{
    [self createCollectionHeaderView];
}
- (void)createCollectionHeaderView{
    if (collectionHeaderView) {
        [collectionHeaderView removeFromSuperview];
        collectionHeaderView = nil;
    }
    collectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 65+_window_width*0.3)];
    collectionHeaderView.backgroundColor = [UIColor whiteColor];
    NSArray *liveClass = [common liveclass];
    NSInteger count;
    if (liveClass.count>6) {
        count = 5;
        UIButton *allButton = [UIButton buttonWithType:0];
        allButton.frame = CGRectMake(_window_width/6*5, 0, _window_width/6, _window_width/6);
        allButton.tag = 10086;
        [allButton addTarget:self action:@selector(liveClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [collectionHeaderView addSubview:allButton];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(allButton.width*0.3, allButton.width*0.15, allButton.width*0.4, allButton.width*0.4)];
        [imgView setImage:[UIImage imageNamed:@"live_all"]];
        [allButton addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+allButton.width/8, allButton.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:YZMsg(@"全部")];
        [allButton addSubview:label];
    }else{
        count = liveClass.count;
    }
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(i*(_window_width/6), 0, _window_width/6, _window_width/6);
        button.tag = i + 20180922;
        [button addTarget:self action:@selector(liveClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [collectionHeaderView addSubview:button];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(button.width*0.3, button.width*0.15, button.width*0.4, button.width*0.4)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:minstr([liveClass[i] valueForKey:@"thumb"])] placeholderImage:[UIImage imageNamed:@"live_all"]];
        [button addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:minstr([liveClass[i] valueForKey:@"name"])];
        [button addSubview:label];

    }
    _cycleScroll = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 65, _window_width, _window_width*0.3)];
    _cycleScroll.delegate = self;
    _cycleScroll.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [collectionHeaderView addSubview:_cycleScroll];
    _cycleScroll.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _cycleScroll.autoScrollTimeInterval = 3.0;//轮播时间间隔，默认1.0秒，可自定义
    _cycleScroll.currentPageDotColor = normalColors;
    _cycleScroll.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;

}
-(void)createCollectionView{

    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2-4.5, (_window_width/2-4.5));
    flow.minimumLineSpacing = 3;
    flow.minimumInteritemSpacing = 3;
    flow.sectionInset = UIEdgeInsetsMake(3, 3,3, 3);
    flow.headerReferenceSize = CGSizeMake(_window_width, 65+_window_width*0.3);

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) collectionViewLayout:flow];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotCollectionViewCELL"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV"];

    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self pullInternet];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self pullInternet];
    }];
    
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(64+statusbarHeight, 0, 0, 0);
    [self pullInternet];

}
-(void)nothingview{
//    NoInternetImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.2 * _window_height, 0.4 * _window_width, 0.4 * _window_width)];
//    NoInternetImageV.contentMode = UIViewContentModeScaleAspectFit;
//    NoInternetImageV.image = [UIImage imageNamed:@"shibai"];
//    [self.view addSubview:NoInternetImageV];
//    NoInternetImageV.hidden = YES;
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self pullInternet];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];

}
-(void)yaoqingma{
    //主播推荐
    NSString *isregs = minstr([cityDefault getreg]);
    if ([isregs isEqual:@"1"]) {
        if (!tuijianw) {
            tuijianw = [[tuijianwindow alloc]initWithFrame:CGRectMake(0,0,_window_width,_window_height)];
            tuijianw.delegate = self;
            [tuijianw makeKeyAndVisible];
        }
    }else{
        [self jump];
    }
}
-(void)showyaoqingma{
    [cityDefault saveisreg:@"0"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isagent"];
    alertController = [UIAlertController alertControllerWithTitle:YZMsg(@"请输入邀请码") message:@""preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = YZMsg(@"请输入邀请码");
        codetextfield = textField;
    }];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:YZMsg(@"确定")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (codetextfield.text.length == 0) {
            [self presentViewController:alertController animated:YES completion:nil];
            [MBProgressHUD showError:YZMsg(@"邀请码不能为空")];
            return;
        }
        [self uploadInvitationV];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:YZMsg(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [defaultAction setValue:normalColors forKey:@"_titleTextColor"];
        [cancelAction setValue:normalColors forKey:@"_titleTextColor"];
    }
    [alertController addAction:defaultAction]; [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//获取网络数据
-(void)pullInternet{
    
    [YBToolClass postNetworkWithUrl:@"Home.getHot" andParameter:@{@"p":@(page)} success:^(int code,id info,NSString *msg) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        noNetwork.hidden = YES;

        if (code == 0) {
                NSArray *infoA = [info objectAtIndex:0];
                NSArray *list = [infoA valueForKey:@"list"];
                if (page == 1) {
                    [_infoArray removeAllObjects];
                    [_zhuboModel removeAllObjects];
                    NSMutableArray *sliderMuArr = [NSMutableArray array];
                    if (!collectionHeaderView) {
                        [self createCollectionHeaderView];
                    }
                    self.CarouselArray = [infoA valueForKey:@"slide"];
                    for (NSDictionary *dic in _CarouselArray) {
                        [sliderMuArr addObject:minstr([dic valueForKey:@"slide_pic"])];
                    }
                    _cycleScroll.imageURLStringsGroup = sliderMuArr;
                }
                [_infoArray addObjectsFromArray:list];
                for (NSDictionary *dic in list) {
                    hotModel *model = [[hotModel alloc]initWithDic:dic];
                    [_zhuboModel addObject:model];
                }
                [_collectionView reloadData];
            
            if (list.count == 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } fail:^{
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        if (_infoArray.count == 0) {
            noNetwork.hidden = NO;
        }

    }];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _zhuboModel.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedDic = _infoArray[indexPath.row];
    [self checklive:[selectedDic valueForKey:@"stream"] andliveuid:[selectedDic valueForKey:@"uid"]];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HotCollectionViewCELL" forIndexPath:indexPath];
    cell.model = _zhuboModel[indexPath.row];
    
    return cell;
}

#pragma mark ================ collectionview头视图 ===============


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV" forIndexPath:indexPath];

        header.backgroundColor = [UIColor whiteColor];
        [header addSubview:collectionHeaderView];
        return header;
    }else{
        return nil;
    }
}

//进入房间
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedDic = _infoArray[indexPath.row];
    [self checklive:[selectedDic valueForKey:@"stream"] andliveuid:[selectedDic valueForKey:@"uid"]];
}
-(void)checklive:(NSString *)stream andliveuid:(NSString *)liveuid{
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.checkLive"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 5.0;
    request.HTTPMethod = @"post";
    NSString *param = [NSString stringWithFormat:@"uid=%@&token=%@&liveuid=%@&stream=%@",[Config getOwnID],[Config getOwnToken],liveuid,stream];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSError *error;
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [MBProgressHUD showError:@"无网络"];
    }
    else{
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingMutableContainers error:nil];
        NSNumber *number = [dic valueForKey:@"ret"];
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [dic valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *type = [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                _sdkType = minstr([info valueForKey:@"live_sdk"]);

                if ([type isEqual:@"0"]) {
                    [self pushMovieVC];
                }
                else if ([type isEqual:@"1"]){
                    NSString *_MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                    //密码
                    md5AlertController = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"该房间为密码房间") preferredStyle:UIAlertControllerStyleAlert];
                    //添加一个取消按钮
                    [md5AlertController addAction:[UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }]];
                    
                    //在AlertView中添加一个输入框
                    [md5AlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.placeholder = @"请输入密码";
                    }];
                    
                    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
                    [md5AlertController addAction:[UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITextField *alertTextField = md5AlertController.textFields.firstObject;
                        //                        [self checkMD5WithText:envirnmentNameTextField.text andMD5:_MD5];
                        //输出 检查是否正确无误
                        NSLog(@"你输入的文本%@",alertTextField.text);
                        if ([_MD5 isEqualToString:[self stringToMD5:alertTextField.text]]) {
                            [self pushMovieVC];
                        }else{
                            alertTextField.text = @"";
                            [MBProgressHUD showError:YZMsg(@"密码错误")];
                            [self presentViewController:md5AlertController animated:true completion:nil];
                            return ;
                        }
                        
                    }]];
                    
                    
                    //present出AlertView
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:md5AlertController animated:true completion:nil];
                    });
                }
                else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:minstr([info valueForKey:@"type_msg"]) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];

                    }];
                    [alertContro addAction:cancleAction];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self doCoast];
                    }];
                    [alertContro addAction:sureAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alertContro animated:YES completion:nil];
                    });

                }
                
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }
        
    }
    
}
-(void)pushMovieVC{
    
    moviePlay *player = [[moviePlay alloc]init];
    player.scrollarray = _infoArray;
    player.scrollindex = 0;
    player.playDoc = selectedDic;
    player.type_val = type_val;
    player.livetype = livetype;
    player.sdkType = _sdkType;
    [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
}
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
//执行扣费
-(void)doCoast{
    [YBToolClass postNetworkWithUrl:@"Live.roomCharge" andParameter:@{@"liveuid":minstr([selectedDic valueForKey:@"uid"]),@"stream":minstr([selectedDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            [self pushMovieVC];
            //计时扣费
            
        }
        
    } fail:^{
        [self.collectionView.mj_header endRefreshing];
    }];

}
-(void)uploadInvitationV{
    [YBToolClass postNetworkWithUrl:@"User.setDistribut" andParameter:@{@"code":minstr(codetextfield.text)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subdic = [info firstObject];
            [MBProgressHUD showError:minstr([subdic valueForKey:@"msg"])];
        }else{
            [MBProgressHUD showError:msg];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } fail:^{
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
}
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
#pragma mark ================ 分类按钮点击事件 ===============
- (void)liveClassBtnClick:(UIButton *)sender{
    if (sender.tag == 10086) {
        if (!allClassV) {
            allClassV = [[allClassView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height)];
            [self.view addSubview:allClassV];
        }else{
            allClassV.hidden = NO;
        }
        __weak Hotpage *weakSelf = self;
        allClassV.block = ^(NSDictionary * _Nonnull dic) {
            [weakSelf pushLiveClassVC:dic];
        };
        [allClassV showWhiteView];
    }else{
        NSDictionary *dic = [common liveclass][sender.tag - 20180922];
        [self pushLiveClassVC:dic];
    }
}
- (void)pushLiveClassVC:(NSDictionary *)dic{
    classVC *class = [[classVC alloc]init];
    class.titleStr = minstr([dic valueForKey:@"name"]);
    class.classID = minstr([dic valueForKey:@"id"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:class animated:YES];

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
#pragma mark ============轮播图点击=============
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    YBWebViewController *web = [[YBWebViewController alloc]init];
    web.urls = minstr([_CarouselArray[index] valueForKey:@"slide_url"]);
    [[MXBADelegate sharedAppDelegate] pushViewController:web animated:YES];
}

@end
