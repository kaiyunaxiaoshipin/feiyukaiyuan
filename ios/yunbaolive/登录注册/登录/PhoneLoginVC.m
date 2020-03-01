#import "PhoneLoginVC.h"
#import "hahazhucedeview.h"
#import "AppDelegate.h"
#import "getpasswordview.h"
#import "ZYTabBarController.h"
#import "webH5.h"
#import <ShareSDK/ShareSDK.h>
@interface PhoneLoginVC () {
    UIActivityIndicatorView *testActivityIndicator;//菊花
    NSArray *platformsarray;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)NSString *isreg;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;

- (IBAction)EULA:(id)sender;
#pragma mark ================ 语言包的时候需要修改的label ===============

@property (weak, nonatomic) IBOutlet UILabel *logTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightRegBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@property (weak, nonatomic) IBOutlet UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIView *platformview;

@end
@implementation PhoneLoginVC
//获取三方登录方式
-(void)getLoginThird{
    [YBToolClass postNetworkWithUrl:@"Home.getLogin" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            platformsarray = [infos valueForKey:@"login_type"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setthirdview];
            });
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        
    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        
    }];
}
//添加登陆方式
-(void)setthirdview{
    //判断一下是不是数组
    if (![platformsarray isKindOfClass:[NSArray class]]) {
        return;
    }
    if (platformsarray.count <= 0) {
        _leftView.hidden = _rightView.hidden = _otherLabel.hidden = YES;
    }else {
        _leftView.hidden = _rightView.hidden = _otherLabel.hidden = NO;
    }
    //进入此方法钱，清除所有按钮，防止重复添加
    for (UIButton *btn in _platformview.subviews) {
        [btn removeFromSuperview];
    }
    //如果返回为空，登陆方式字样隐藏
//    if (platformsarray.count == 0) {
//        _otherviews.hidden = YES;
//    }
//    else{
//        _otherviews.hidden = NO;
//    }
    //注意：此处涉及到精密计算，轻忽随意改动
    CGFloat w = 40;
    CGFloat space = _window_width*0.8-([platformsarray count] - 1)*20-[platformsarray count]*40;
   
    
    for (int i=0; i<platformsarray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"login_%@",platformsarray[i]]] forState:UIControlStateNormal];
        [btn setTitle:platformsarray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(thirdlogin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(space/2+i*60,0,w,w);
        [_platformview addSubview:btn];
    }
}
//若要添加登陆方式，在此处添加
-(void)thirdlogin:(UIButton *)sender{
    /*
     1 qq
     2 wx
     3 facebook
     4 twitter
     */
    [self.view endEditing:YES];
    int type;
    if ([sender.titleLabel.text isEqual:@"qq"]) {
        type = 1;
    }else if ([sender.titleLabel.text isEqual:@"wx"]) {
        type = 2;
    }else if ([sender.titleLabel.text isEqual:@"facebook"]) {
        type = 3;
    }else if ([sender.titleLabel.text isEqual:@"twitter"]) {
        type = 4;
    }
    
    switch (type) {
        case 1:
            [self login:@"qq" platforms:SSDKPlatformTypeQQ];
            break;
        case 2:
            [self login:@"wx" platforms:SSDKPlatformTypeWechat];
            break;
        case 3:
            [self login:@"facebook" platforms:SSDKPlatformTypeFacebook];
            break;
        case 4:
            [self login:@"twitter" platforms:SSDKPlatformTypeTwitter];
            break;
        default:
            break;
    }
}
-(void)login:(NSString *)types platforms:(SSDKPlatformType)platform{
    //取消授权
    [ShareSDK cancelAuthorize:platform];
    
    [testActivityIndicator startAnimating]; // 开始旋转
    [ShareSDK getUserInfo:platform
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
             [self RequestLogin:user LoginType:types];
             
         } else if (state == 2 || state == 3) {
             [testActivityIndicator stopAnimating]; // 结束旋转
             [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
         }
         
     }];
}
-(void)RequestLogin:(SSDKUser *)user LoginType:(NSString *)LoginType
{
    
    [testActivityIndicator startAnimating]; // 结束旋转
    
    NSString *icon = nil;
    if ([LoginType isEqualToString:@"qq"]) {
        icon = [user.rawData valueForKey:@"figureurl_qq_2"];
    }
    else
    {
        icon = user.icon;
    }
    NSString *unionID;//unionid
    if ([LoginType isEqualToString:@"wx"]){
        
        unionID = [user.rawData valueForKey:@"unionid"];
        
    }
    else{
        unionID = user.uid;
    }
    if (!icon || !unionID) {
        [testActivityIndicator stopAnimating]; // 结束旋转
        [MBProgressHUD showError:YZMsg(@"未获取到授权，请重试")];
        return;
    }
    NSString *pushid;
    if ([JPUSHService registrationID]) {
        pushid = [JPUSHService registrationID];
    }else{
        pushid = @"";
    }
    NSDictionary *pDic = @{
                           @"openid":[NSString stringWithFormat:@"%@",unionID],
                           @"type":[NSString stringWithFormat:@"%@",[self encodeString:LoginType]],
                           @"nicename":[NSString stringWithFormat:@"%@",[self encodeString:user.nickname]],
                           @"avatar":[NSString stringWithFormat:@"%@",[self encodeString:icon]],
                           @"source":@"ios",
                           @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"openid=%@&76576076c1f5f657b634e966c8836a06",unionID]],
                           @"pushid":pushid
                           };
    [YBToolClass postNetworkWithUrl:@"Login.userLoginByThird" andParameter:pDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
            [Config saveProfile:userInfo];
            [self LoginJM];
            //判断第一次登陆
            NSString *isreg = minstr([infos valueForKey:@"isreg"]);
            _isreg = isreg;
            [[NSUserDefaults standardUserDefaults] setObject:minstr([infos valueForKey:@"isagent"]) forKey:@"isagent"];
            [self login];
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        
    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
    }];
}
-(NSString *)getQQunionID:(NSString *)IDID{
    
    //************为了和PC互通，获取QQ的unionID,需要注意的是只有腾讯开放平台的数据打通之后这个接口才有权限访问，不然会报错********
    NSString *url1 = [NSString stringWithFormat:@"https://graph.qq.com/oauth2.0/me?access_token=%@&unionid=1",IDID];
    url1 = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:NSUTF8StringEncoding error:nil];
    NSRange rang1 = [str rangeOfString:@"{"];
    NSString *str2 = [str substringFromIndex:rang1.location];
    NSRange rang2 = [str2 rangeOfString:@")"];
    NSString *str3 = [str2 substringToIndex:rang2.location];
    NSString *str4 = [str3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSData *data = [str4 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [data JSONValue];
    NSString *unionID = [dic valueForKey:@"unionid"];
    //************为了和PC互通，获取QQ的unionID********
    
    return unionID;
}
-(NSString*)encodeString:(NSString*)unencodedString{
    NSString*encodedString=(NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

-(void)forwardGround{
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _doLoginBtn.userInteractionEnabled = NO;

    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _logTitleLabel.text = YZMsg(@"注册登录后体验更多精彩");
    _otherLabel.text = YZMsg(@"其他登录方式");
    _phoneT.placeholder = YZMsg(@"请填写手机号");
    _passWordT.placeholder = YZMsg(@"请输入密码");
    [_regBtn setTitle:YZMsg(@"立即注册") forState:0];
    [_doLoginBtn setTitle:YZMsg(@"立即登录") forState:0];
    [_forgotBtn setTitle:YZMsg(@"忘记密码") forState:0];

    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(_window_width/2 - 10, _window_height/2 - 10);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    
    //隐私
    _privateBtn.titleLabel.textColor = RGB(111, 111, 111);
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:YZMsg(@"登录即代表你同意服务和隐私条款")];
    [attStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 7)];
    [_privateBtn setAttributedTitle:attStr forState:0];
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听 防止第一次安装不显示
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self getLoginThird];
            return;
        }else if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable){
            NSLog(@"nonetwork-------");
            [self getLoginThird];
        }else if ((status == AFNetworkReachabilityStatusReachableViaWWAN)||(status == AFNetworkReachabilityStatusReachableViaWiFi)){
            [self getLoginThird];
            NSLog(@"wifi-------");
        }
    }];

}
-(void)ChangeBtnBackground {
    if (_phoneT.text.length >0 && _passWordT.text.length >0)
    {
        [_doLoginBtn setBackgroundColor:normalColors];
        _doLoginBtn.userInteractionEnabled = YES;
    }
    else
    {
        [_doLoginBtn setBackgroundColor:[normalColors colorWithAlphaComponent:0.5]];
        _doLoginBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)mobileLogin:(id)sender {
    [self.view endEditing:YES];
    [testActivityIndicator startAnimating]; // 开始旋转
    NSString *pushid;
    if ([JPUSHService registrationID]) {
        pushid = [JPUSHService registrationID];
    }else{
        pushid = @"";
    }

    NSDictionary *Login = @{
                            @"user_login":_phoneT.text,
                            @"user_pass":_passWordT.text,
                            @"source":@"ios",
                            @"pushid":pushid
                            };
    
    [YBToolClass postNetworkWithUrl:@"Login.userLogin" andParameter:Login success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info objectAtIndex:0];
            LiveUser *userInfo = [[LiveUser alloc] initWithDic:infos];
            [Config saveProfile:userInfo];
            [self LoginJM];
            self.navigationController.navigationBarHidden = YES;
            //判断第一次登陆
            NSString *isreg = minstr([infos valueForKey:@"isreg"]);
            _isreg = isreg;
            [[NSUserDefaults standardUserDefaults] setObject:minstr([infos valueForKey:@"isagent"]) forKey:@"isagent"];
            [self login];

        }else{
            [MBProgressHUD showError:msg];
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    }];
}
-(void)LoginJM{
    NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
//    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [JMSGUser registerWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"login-极光IM注册成功");
        } else {
            NSLog(@"login-极光IM注册失败，可能是已经注册过了");
        }
        NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
        [JMSGUser loginWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,[Config getOwnID]] password:aliasStr completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSLog(@"login-极光IM登录成功");
            } else {
                NSLog(@"login-极光IM登录失败");
            }
        }];
    }];
}
-(void)login{
    ZYTabBarController *root = [[ZYTabBarController alloc]init];
    [cityDefault saveisreg:_isreg];
    [self.navigationController pushViewController:root animated:YES];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    app2.window.rootViewController = nav;
    
}
- (IBAction)regist:(id)sender {
    hahazhucedeview *regist = [[hahazhucedeview alloc]init];
    [self.navigationController pushViewController:regist animated:YES];
}
- (IBAction)forgetPass:(id)sender {
    getpasswordview *getpass = [[getpasswordview alloc]init];
    [self.navigationController pushViewController:getpass animated:YES];
}

- (IBAction)clickBackBtn:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//键盘的隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)EULA:(id)sender {
    webH5 *VC = [[webH5 alloc]init];
    NSString *paths = [h5url stringByAppendingString:@"/index.php?g=portal&m=page&a=index&id=4"];
    VC.urls = paths;
    VC.titles = YZMsg(@"服务和隐私条款");
    [self.navigationController pushViewController:VC animated:YES];
}
@end
