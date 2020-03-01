#import "homepageController.h"
#import "Hotpage.h"
#import "Hotpage.h"
#import "attentionViewC.h"
#import "searchVC.h"
#import "Loginbonus.h"  //每天第一次登录
#import "ZYTabBar.h"
#import "myVideoV.h"
#import "MessageListVC.h"

@import CoreLocation;
@interface homepageController ()<CLLocationManagerDelegate,FirstLogDelegate,JMessageDelegate>
{
    CLLocationManager   *_lbsManager;
    /********* firstLV -> ************/
    Loginbonus *firstLV;
    NSString *bonus_switch;
    NSString *bonus_day;
    NSArray  *bonus_list;
    NSString *dayCount;
    NSMutableArray  *coins;
    NSMutableArray  *days;
    //测试用变量
    NSString *testDay;//仅仅测试用（已注释）
    /********* <- firstLV ************/
}
@property(nonatomic,strong)NSArray *infoArrays;

@end
@implementation homepageController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUnreadCount];
}
-(void)getUnreadCount{
    [self labeiHid];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    //显示消息数量
    [self labeiHid];
}
-(void)onUnreadChanged:(NSUInteger)newCount{
    [self labeiHid];
}
-(void)labeiHid{
    dispatch_queue_t queue = dispatch_queue_create("GetIMMessage", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        unRead = [minstr([JMSGConversation getAllUnreadCount]) intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [NSString stringWithFormat:@"%d",unRead];
            if ([label.text isEqual:@"0"]) {
                label.hidden =YES;
            }else{
                label.hidden = NO;
            }
        });
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // 支持定位才开启lbs
    if (!_lbsManager)
    {
        _lbsManager = [[CLLocationManager alloc] init];
        [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _lbsManager.delegate = self;
        // 兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [_lbsManager respondsToSelector:requestSelector]) {
            [_lbsManager requestWhenInUseAuthorization];//调用了这句,就会弹出允许框了.
        } else {
            [_lbsManager startUpdatingLocation];
        }
    }
    self.adjustStatusBarHeight = YES;
    self.cellSpacing = 8;
    self.infoArrays = [NSArray arrayWithObjects:YZMsg(@"关注"),YZMsg(@"直播"),YZMsg(@"视频"), nil];
    [self setBarStyle:TYPagerBarStyleProgressView];
    [self setContentFrame];
    //创建搜索按钮
    [self setView];
    self.view.backgroundColor = [UIColor whiteColor];
    //获取所有未读消息
    [JMessage addDelegate:self withConversation:nil];
    [self getUnreadCount];
}

-(void)setView{
    //私信
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    messageBtn.frame = CGRectMake(_window_width-40,24 +statusbarHeight,40,40);
    messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [messageBtn setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.pagerBarView addSubview:messageBtn];
    label = [[UILabel alloc]initWithFrame:CGRectMake(20,5 , 16, 16)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.hidden = YES;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"%d",unRead];
    label.textAlignment = NSTextAlignmentCenter;
    [messageBtn addSubview:label];

    //搜索按钮
    UIButton *searchBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBTN setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    searchBTN.frame = CGRectMake(messageBtn.left-40,24 +statusbarHeight,40,40);
    searchBTN.contentMode = UIViewContentModeScaleAspectFit;
    [searchBTN addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    searchBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.pagerBarView addSubview:searchBTN];
    
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 63+statusbarHeight, _window_width, 1) andColor:RGB(244, 245, 246) andView:self.pagerBarView];
    
    //每天第一次登录
    [self pullInternet];
    //登录奖励后台回到前台
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}
/**********************每天第一次登录-->>**********************/
-(void)pullInternet {
    [YBToolClass postNetworkWithUrl:@"User.Bonus" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSArray *infos = info;
            bonus_switch = [NSString stringWithFormat:@"%@",[[infos lastObject] valueForKey:@"bonus_switch"]];
            bonus_day = [[infos lastObject] valueForKey:@"bonus_day"];
            bonus_list = [[infos lastObject] valueForKey:@"bonus_list"];
            
            //测试
            //bonus_day = testDay;
            
            int day = [bonus_day intValue];
            dayCount = minstr([[infos lastObject] valueForKey:@"count_day"]);
            if ([bonus_switch isEqual:@"1"] && day > 0 ) {
            
                [self firstLog];
                
            }
        }

    } fail:^{
        
    }];
}
-(void)onAppWillEnterForeground:(UIApplication*)app {
    //firstLV不存在 (避免一整天不杀进程第二天登录无奖励)
    //这里加uid判断或者把网络请求改为get请求
    NSString *uid = [Config getOwnID];
    if (!firstLV && uid) {
        [self pullInternet];
    }
}
-(void)firstLog{
    firstLV = [[Loginbonus alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)AndNSArray:bonus_list AndDay:bonus_day andDayCount:dayCount];
    firstLV.delegate = self;
//    firstLV.layer.cornerRadius = 5;
//    firstLV.layer.masksToBounds = YES;
//    [self.view addSubview:firstLV];
    [[UIApplication sharedApplication].delegate.window addSubview:firstLV];
}
#pragma mark - 代理  动画结束释放空视图
-(void)removeView:(NSDictionary*)dic{
    [firstLV removeFromSuperview];
    firstLV = nil;
    /*
    CGFloat x = [[dic valueForKey:@"x"]floatValue];
    CGFloat y = [[dic valueForKey:@"y"]floatValue];
    CGFloat w = [[dic valueForKey:@"w"]floatValue];
    CGFloat h = [[dic valueForKey:@"h"]floatValue];
    
    //奖励数量
    UIImageView *bonusIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"banner"]];
    bonusIV.center = CGPointMake(self.view.center.x, self.view.center.y+w);
    UILabel *bonusL = [[UILabel alloc]init];
    //bonusL.backgroundColor = [UIColor orangeColor];
    bonusL.frame = bonusIV.frame;
    bonusL.center = CGPointMake(self.view.center.x, self.view.center.y+w-5);
    bonusL.textAlignment = NSTextAlignmentCenter;
    int day = [bonus_day intValue];
    NSDictionary *selDic = bonus_list[day-1];
    bonusL.text = [selDic valueForKey:@"coin"];
    bonusL.textColor = [UIColor whiteColor];
    [self.view addSubview:bonusIV];
    [self.view addSubview:bonusL];
    
    UIImage *image = [dic valueForKey:@"image"];
    //添加动画
    UIImageView *animationIV=[[UIImageView alloc]initWithFrame:CGRectMake(x+_window_width*0.1, y+_window_height*0.2, w, h)];
    animationIV.image = image;
    [self.view addSubview:animationIV];
    [UIView animateWithDuration:1.0 animations:^{
        //移到屏幕中心位置
        animationIV.frame=CGRectMake(_window_width/2-animationIV.size.width, _window_height/2-animationIV.size.height, animationIV.size.width*1.5,animationIV.size.height*1.5);
        animationIV.transform = CGAffineTransformRotate(animationIV.transform, M_1_PI);
    } completion:^(BOOL finished) {
        animationIV.image = [UIImage imageNamed:@"star2"];
        [UIView animateWithDuration:0.8 animations:^{
            animationIV.frame = CGRectMake(_window_width*0.8, _window_height*0.95, animationIV.size.width/5, animationIV.size.height/5);
        }];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.8 animations:^{
            firstLV.frame = CGRectMake(_window_width*0.1, _window_height*1.2, _window_width*0.8, _window_height*0.6);
        }];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [bonusL removeFromSuperview];
        [bonusIV removeFromSuperview];
        [animationIV removeFromSuperview];
        [firstLV removeFromSuperview];
        firstLV = nil;
    });
    
    //测试
    //testDay = @"0";
    
    */
}
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                  name:UIApplicationWillEnterForegroundNotification
                object:nil];
}
/**********************<<--每天第一次登录**********************/
-(void)messageBtnClick{
    
    
    MessageListVC *msgVC = [[MessageListVC alloc]init];

    
//    messageC *msgVC = [[messageC alloc]init];
    [[MXBADelegate sharedAppDelegate]pushViewController:msgVC animated:YES];
}
-(void)search{
    searchVC *search = [[searchVC alloc]init];
    UINavigationController *naviSearch = [[UINavigationController alloc]initWithRootViewController:search];
//    [self presentViewController:naviSearch animated:YES completion:nil];
    [[MXBADelegate sharedAppDelegate]pushViewController:search animated:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController
{
    return self.infoArrays.count;
}
- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
    return self.infoArrays[index];
}
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    if (index == 0) {
        attentionViewC *hotView= [[attentionViewC alloc]init];
        hotView.pageView = self.pagerBarView;
        return hotView;
    }
    else if(index == 1){
        Hotpage *hotView= [[Hotpage alloc]init];
        hotView.pageView = self.pagerBarView;
        return hotView;
    }
    else  {
        myVideoV *videoVC= [[myVideoV alloc]init];
        videoVC.ismyvideo = 0;
        NSString *url = [purl stringByAppendingFormat:@"?service=Video.getVideoList&uid=%@&type=0",[Config getOwnID]];
        videoVC.url = url;
        videoVC.pageView = self.pagerBarView;
        return videoVC;

//        NewestVC *newView= [[NewestVC alloc]init];
//        NSString *url = @"Home.getNew";
//
//        newView.url = url;
//        newView.type = 1;
//        return newView;
    }
}

// transition from index to index with animated
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated{
    [self showTabBar];
    NSLog(@"animatedanimatedanimatedanimatedanimatedanimatedanimatedanimated");
}

// transition from index to index with progress
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    [self showTabBar];
    NSLog(@"progressprogressprogressprogressprogressprogressprogressprogress");
}



- (void)stopLbs {
    [_lbsManager stopUpdatingHeading];
    _lbsManager.delegate = nil;
    _lbsManager = nil;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        if (status == kCLAuthorizationStatusDenied) {
            liveCity *cityU = [cityDefault myProfile];
            cityU.lat = @"";
            cityU.lng = @"";
            cityU.city = YZMsg(@"好像在火星");
            cityU.addr = @"";
            [cityDefault saveProfile:cityU];
        }
        [self stopLbs];
        
    } else {
        [_lbsManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLbs];

}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocatioin = locations[0];
    liveCity *cityU = [cityDefault myProfile];
    cityU.lat = [NSString stringWithFormat:@"%f",newLocatioin.coordinate.latitude];
    cityU.lng = [NSString stringWithFormat:@"%f",newLocatioin.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocatioin completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error)
        {
            CLPlacemark *placeMark = placemarks[0];
            NSString *city      = placeMark.locality;
            NSString *addr = [NSString stringWithFormat:@"%@%@%@%@%@",placeMark.country,placeMark.administrativeArea,placeMark.locality,placeMark.subLocality,placeMark.thoroughfare];
            LiveUser *user = [Config myProfile];
            user.city = city;
            cityU.addr = addr;
            [Config updateProfile:user];
            cityU.city = city;
            [cityDefault saveProfile:cityU];
        }
    }];
    [self stopLbs];
}
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    self.pagerBarView.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = NO;
    
}

@end
