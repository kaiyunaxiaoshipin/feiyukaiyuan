#import "AppDelegate.h"//cn.weilianliveappstore
#import "YBUserInfoViewController.h"
/******shark sdk *********/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
//#import "LivePlay.h"
/******shark sdk  end*********/
//腾讯bug监控
#import <Bugly/Bugly.h>
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>
#import "PhoneLoginVC.h"
#import "ZYTabBarController.h"
#import <Twitter/Twitter.h>
#import "EBBannerView.h"

#import <QMapKit/QMapKit.h>
#import <QMapSearchKit/QMapSearchKit.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>

#import "TXUGCBase.h"
#import "GuideViewController.h"

@import CoreLocation;
@interface AppDelegate ()<CLLocationManagerDelegate,WXApiDelegate,JMessageDelegate>
{
    CLLocationManager   *_lbsManager;
}
@property(nonatomic,strong)NSArray *scrollarrays;//轮播
@end
@implementation AppDelegate
{
    NSNotification * sendEmccBack;
}
- (void)stopLbs {
    [_lbsManager stopUpdatingHeading];
    _lbsManager.delegate = nil;
    _lbsManager = nil;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLiveing"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPlaying"];
    [QMapServices sharedServices].apiKey = TencentKey;
    [[QMSSearchServices sharedServices] setApiKey:TencentKey];
    [[SDWebImageManager sharedManager].imageDownloader setValue: nil forHTTPHeaderField:@"Accept"];
    [Bugly startWithAppId:BuglyId];
    [UMConfigure initWithAppkey:youmengKey channel:youmengChannel];
    [MobClick setScenarioType:E_UM_NORMAL];

    [[NSUserDefaults standardUserDefaults] setObject:ZH_CN forKey:CurrentLanguage];
    [[RookieTools shareInstance] resetLanguage:[[NSUserDefaults standardUserDefaults] objectForKey:CurrentLanguage] withFrom:@"appdelegate"];
    // 告诉app支持后台播放
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    self.window = [[UIWindow alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_height)];
    [self location];
    [self thirdPlant];
    
    [TXUGCBase setLicenceURL:LicenceURL key:LicenceKey];
    //共享的key
//    [TXUGCBase setLicenceURL:@"http://license.vod2.myqcloud.com/license/v1/4f5531f46fbe3ca5353e1ae243f4cadb/TXUgcSDK.licence" key:@"3739a6ae81da935f1473d5925b3160cd"];
    
    //后台运行定时器
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    
    self.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:[[GuideViewController alloc] init]];
    [self.window makeKeyAndVisible];

//    if ([Config getOwnID]) {
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ZYTabBarController alloc] init]];
//        [self.window makeKeyAndVisible];
//    }
//    else{
//        PhoneLoginVC *login = [[PhoneLoginVC alloc]initWithNibName:@"PhoneLoginVC" bundle:nil];
//        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:login];
//        [self.window makeKeyAndVisible];
//    }
//
    //集成 极光IM
    [JMessage setupJMessage:launchOptions appKey:JMessageAppKey channel:nil apsForProduction:isProduction category:nil messageRoaming:NO];

    if ([Config getOwnID]) {
        NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
        //[JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
        [JPUSHService setupWithOption:launchOptions appKey:JMessageAppKey
                              channel:@"Publish channel"
                     apsForProduction:isProduction
                advertisingIdentifier:nil];
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSLog(@"appdelegate-极光IM登录成功");

            } else {
                NSLog(@"appdelegate-极光IM登录失败");
            }
        }];
    }
    //推送
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [JMessage resetBadge];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerDidClick:) name:EBBannerViewDidClickNotification object:nil];

    //InstallUncaughtExceptionHandler();
    return YES;
}
-(void)location{
    if (!_lbsManager) {
        _lbsManager = [[CLLocationManager alloc] init];
        [_lbsManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _lbsManager.delegate = self;
        // 兼容iOS8定位
        SEL requestSelector = NSSelectorFromString(@"requestWhenInUseAuthorization");
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [_lbsManager respondsToSelector:requestSelector]) {
            [_lbsManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
        } else {
            [_lbsManager startUpdatingLocation];
        }
    }
}
-(void)thirdPlant{
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeMail),
                                        @(SSDKPlatformTypeSMS),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        @(SSDKPlatformTypeRenren),
                                        @(SSDKPlatformTypeFacebook),
                                        @(SSDKPlatformTypeTwitter),
                                        @(SSDKPlatformTypeGooglePlus),
                                        ] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                                    break;
                                                    
                                                case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class]
                                                               tencentOAuthClass:[TencentOAuth class]];
                                                    break;
                                                case SSDKPlatformTypeTwitter:
                                                    break;
                                                default:
                                                    break;
                                            }
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [appInfo SSDKSetupWeChatByAppId:WechatAppId
                                                                          appSecret:WechatAppSecret];
                                                    break;
                                                case SSDKPlatformTypeQQ:
                                                    [appInfo SSDKSetupQQByAppId:QQAppId
                                                                         appKey:QQAppKey
                                                                       authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeFacebook:
                                    [appInfo SSDKSetupFacebookByApiKey:FacebookApiKey
                                                                appSecret:FacebookAppSecret
                                                                           displayName: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
                                                                              authType:SSDKAuthTypeBoth];
                                                    break;
                                                case SSDKPlatformTypeTwitter:
                                                    [appInfo SSDKSetupTwitterByConsumerKey:TwitterKey consumerSecret:TwitterSecret redirectUri:TwitterRedirectUri];
                                                    break;
                                                default:
                                                    break;
                                            }
                                        }];
}
//杀进程
- (void)applicationWillTerminate:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shajincheng" object:nil];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     [JMessage registerDeviceToken:deviceToken];
     [JPUSHService registerDeviceToken:deviceToken];
//    NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
//    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
     if(application.applicationState == UIApplicationStateInactive)
     {
         if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"1"]) {

             if([[userInfo valueForKey:@"userinfo"] valueForKey:@"uid"] != nil)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"jinruzhibojiantongzhi" object:[userInfo valueForKey:@"userinfo"]];
             }
         }else if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"2"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notification" object:nil];
         }
         [JPUSHService handleRemoteNotification:userInfo];
     }
    
}
#endif
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
     [JPUSHService handleRemoteNotification:userInfo];
     
     if(application.applicationState == UIApplicationStateInactive)
     {
         if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"1"]) {

             if([[userInfo valueForKey:@"userinfo"] valueForKey:@"uid"] != nil)
             {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"jinruzhibojiantongzhi" object:[userInfo valueForKey:@"userinfo"]];
             }
         }else if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"2"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notification" object:nil];

         }
     
     [JPUSHService handleRemoteNotification:userInfo];
     }
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notificationUpdate" object:nil];
//极光推送 新加附加附加参数 type 消息类型  1表示开播通知，2表示系统消息
//    [EBBannerView showWithContent:minstr([[userInfo valueForKey:@"aps"] valueForKey:@"alert"])];
    if (application.applicationState == UIApplicationStateActive) {
        if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"1"]) {
            if([[userInfo valueForKey:@"userinfo"] valueForKey:@"uid"] != nil)
            {
                [[EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                    make.content = minstr([[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
                    make.object = [userInfo valueForKey:@"userinfo"];
                }] show];
            }
        }else if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"2"]) {
            [[EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
                make.content = minstr([[userInfo valueForKey:@"aps"] valueForKey:@"alert"]);
                make.object = nil;
            }] show];

        }
    }else{
    

   
     [JPUSHService handleRemoteNotification:userInfo];
     if(application.applicationState == UIApplicationStateInactive)
     {

         if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"1"]) {

             if([[userInfo valueForKey:@"userinfo"] valueForKey:@"uid"] != nil)
             {
                 if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLiveing"]) {
                     [MBProgressHUD showError:YZMsg(@"正在直播中，无法退出")];
                     return;
                 }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"]) {
                     //[NSString stringWithFormat:@"是否进入%@的直播间",minstr([[userInfo valueForKey:@"userinfo"]valueForKey:@"user_nicename"])]
                     UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"是否退出直播间")  preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     }];
                     [alertContro addAction:cancleAction];
                     UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"qiehuanfangjian" object:[userInfo valueForKey:@"userinfo"]];
                         
                     }];
                     [alertContro addAction:sureAction];
                     [self.window.rootViewController presentViewController:alertContro animated:YES completion:nil];
                     
                     return;
                 }else{
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"jinruzhibojiantongzhi" object:[userInfo valueForKey:@"userinfo"]];
                 }

             }
         } else if ([minstr([userInfo valueForKey:@"type"]) isEqual:@"2"]) {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notification" object:nil];
         }
         [JPUSHService handleRemoteNotification:userInfo];
     }
     completionHandler(UIBackgroundFetchResultNewData);
     
    }
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    [JMessage resetBadge];
     [JPUSHService setBadge:0];
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application cancelAllLocalNotifications];
     [JMessage resetBadge];
     [JPUSHService setBadge:0];
}
- (void)applicationDidBecomeActive:(UIApplication *)application{
    [JMessage resetBadge];
}
#pragma mark --- 支付宝接入
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
            
        }];
    }
    return YES;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}
#pragma mark ================ 通知点击事件 ===============
- (void)bannerDidClick:(NSNotification *)notifi{
    NSDictionary *dic = [notifi object];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLiveing"]) {
        [MBProgressHUD showError:YZMsg(@"正在直播中，无法退出")];
        return;
    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"]) {
        
        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"是否退出直播间") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([dic count] > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"jinruzhibojiantongzhi" object:dic];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notification" object:nil];
                
            }

        }];
        [alertContro addAction:sureAction];
        [self.window.rootViewController presentViewController:alertContro animated:YES completion:nil];
        
        return;
    }else{
        if ([dic isKindOfClass:[NSDictionary class]] && [dic count] > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jinruzhibojiantongzhi" object:dic];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"system_notification" object:nil];

        }
    }

}

@end
