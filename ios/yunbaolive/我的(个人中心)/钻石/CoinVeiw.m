#import "CoinVeiw.h"
#import "coinCell1.h"
#import "coinCell3.h"
#import "applePay.h"
#import <WXApi.h>
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "DataVerifier.h"
#define TEST_SANDBOX 1
@interface CoinVeiw ()<applePayDelegate,WXApiDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int setvis;
    applePay *applePays;//苹果支付
    NSString *urlStrtimestring;//时间戳
    UIActivityIndicatorView *testActivityIndicator;//菊花
}
//以下是支付用到的
@property(nonatomic,strong)NSArray *coinArrays;
@property(nonatomic,strong)NSDictionary *seleDic;//选中的钻石字典
//支付宝
@property(nonatomic,copy)NSString *aliapp_key_ios;
@property(nonatomic,copy)NSString *aliapp_partner;
@property(nonatomic,copy)NSString *aliapp_seller_id;
@property(nonatomic,copy)NSString *aliapp_switch;
//微信
@property(nonatomic,copy)NSString *wx_appid;
@property(nonatomic,copy)NSString *wx_appsecret;
@property(nonatomic,copy)NSString *wx_key;
@property(nonatomic,copy)NSString *wx_mchid;
@property(nonatomic,copy)NSString *wx_switch;
@property  BOOL Firstcharge;
@end
@implementation CoinVeiw
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = RGB(246, 246, 246);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableV.separatorStyle = NO;
    //创建苹果支付
    applePays = [[applePay alloc]init];
    applePays.delegate = self;
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake((_window_width - 10)/2, (_window_height - 10)/2);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    self.tableV.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height - statusbarHeight - 64);
}
- (void)onAppWillEnterForeground:(UIApplication*)app {
    [self getMyCoin];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvis = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvis = 1;
    [MBProgressHUD hideHUD];
    self.navigationController.navigationBarHidden = YES;
    [self getMyCoin];
    [self navtion];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
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
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
     //判断返回cell
    if (indexPath.section == 0) {
        coinCell1 *cell = [coinCell1 cellWithTableView:self.tableV];
        cell.labCoin.text = self.coin;
        return cell;
    }
    else
    {
        NSDictionary *subdic = [_coinArrays objectAtIndex:indexPath.row];
        coinCell3 *cell = [coinCell3 cellWithTableView:self.tableV];
        NSString *money = [subdic valueForKey:@"money_ios"];
        NSString *give = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"give"]];
        if ([give isEqual:@"0"]) {
            cell.labRemake.hidden = YES;
        }
        else{
            cell.labRemake.hidden = NO;
            cell.labRemake.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"赠送"),give,[common name_coin]];
        }
        cell.btnPrice.layer.masksToBounds = YES;
        cell.btnPrice.layer.borderWidth = 1.0;
        cell.btnPrice.layer.cornerRadius = 15;
        cell.btnPrice.layer.borderColor = RGB_COLOR(@"#ffc900", 1).CGColor;
        cell.labCoin.text = [subdic valueForKey:@"coin"];
        [cell.btnPrice setTitle:money forState:UIControlStateNormal];
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    if (section == 0 ) {
        return 1;
    }
    else
    {
        return _coinArrays.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分区数
    return 2;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableV deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }
    _seleDic = _coinArrays[indexPath.row];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
    NSString *buildsss = [NSString stringWithFormat:@"%@",app_build];
    if ([[common ios_shelves] isEqual:buildsss]) {
        [applePays applePay:_seleDic];
    }
    else{
        UIAlertController *alertc = [UIAlertController alertControllerWithTitle:@"" message:YZMsg(@"选择支付方式") preferredStyle:UIAlertControllerStyleActionSheet];
        if ([_aliapp_switch isEqual:@"1"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:YZMsg(@"支付宝") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self doAlipayPay];
            }];
            [alertc addAction:action];
        }
        if ([_wx_switch isEqual:@"1"]){
            UIAlertAction *action = [UIAlertAction actionWithTitle:YZMsg(@"微信支付") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self WeiXinPay];
            }];
            [alertc addAction:action];
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:YZMsg(@"苹果支付") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [applePays applePay:_seleDic];
        }];
        [alertc addAction:action];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertc addAction:cancelAction];
        
        [self presentViewController:alertc animated:YES completion:nil];
    }
}
-(void)getMyCoin
{
    
    if ([[Config getOwnID]intValue]<=0) {
        return;
    }
    
    [YBToolClass postNetworkWithUrl:@"User.getBalance" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            NSDictionary *infoDic = [info firstObject];
            _coinArrays = [infoDic valueForKey:@"rules"];
            //支付宝的信息
            _aliapp_key_ios = [infoDic valueForKey:@"aliapp_key_ios"];
            _aliapp_partner = [infoDic valueForKey:@"aliapp_partner"];
            _aliapp_seller_id = [infoDic valueForKey:@"aliapp_seller_id"];
            _aliapp_switch = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"aliapp_switch"]];
            //微信的信息
            _wx_appid = [infoDic valueForKey:@"wx_appid"];
            _wx_appsecret = [infoDic valueForKey:@"wx_appsecret"];
            _wx_key = [infoDic valueForKey:@"wx_key"];
            _wx_mchid = [infoDic valueForKey:@"wx_mchid"];
            _wx_switch = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"wx_switch"]];
            [WXApi registerApp:_wx_appid];
            self.coin = [infoDic valueForKey:@"coin"];
            [self.tableV reloadData];
        }
        else{
            [MBProgressHUD showError:msg];
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    else
        return 70;
}
/******************   内购  ********************/
-(void)applePayHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)applePayShowHUD{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//内购成功
-(void)applePaySuccess{
    NSLog(@"苹果支付成功");
    [self getMyCoin];
}
//微信支付*****************************************************************************************************************
-(void)WeiXinPay{
    NSLog(@"微信支付");
    [MBProgressHUD showMessage:@""];
    NSDictionary *subdic = @{
                             @"changeid":[_seleDic valueForKey:@"id"],
                             @"coin":[_seleDic valueForKey:@"coin"],
                             @"money":[_seleDic valueForKey:@"money_ios"]
                             };
    [YBToolClass postNetworkWithUrl:@"Charge.getWxOrder" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [MBProgressHUD hideHUD];
            NSDictionary *dict = [info firstObject];
            //调起微信支付
            NSString *times = [dict objectForKey:@"timestamp"];
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            NSString *pid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"prepayid"]];
            if ([pid isEqual:[NSNull null]] || pid == NULL || [pid isEqual:@"null"]) {
                pid = @"123";
            }
            req.prepayId            = pid;
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            req.timeStamp           = times.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        }else{
            [MBProgressHUD showError:msg];
        }
        [MBProgressHUD hideHUD];

    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
-(void)onResp:(BaseResp *)resp{
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
}
//微信支付*****************************************************************************************************************
//支付宝支付*****************************************************************************************************************
- (void)doAlipayPay
{
    NSString *partner = _aliapp_partner;
    NSString *seller =  _aliapp_seller_id;
    NSString *privateKey = _aliapp_key_ios;

    
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0){
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:@"缺少partner或者seller或者私钥" message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        [alerts show];
        NSLog(@"缺少partner或者seller或者私钥。");
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    //获取订单id
    //将商品信息拼接成字符串

    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"changeid":[_seleDic valueForKey:@"id"],
                             @"coin":[_seleDic valueForKey:@"coin"],
                             @"money":[_seleDic valueForKey:@"money_ios"]
                             };
    
    [YBToolClass postNetworkWithUrl:@"Charge.getAliOrder" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSString *infos = [[info firstObject] valueForKey:@"orderid"];
            order.tradeNO = infos;
            order.notifyURL = [h5url stringByAppendingString:@"/Appapi/Pay/notify_ali"];
            order.amount = [_seleDic valueForKey:@"money_ios"];
            order.productName = [NSString stringWithFormat:@"%@钻石",[_seleDic valueForKey:@"coin"]];
            order.productDescription = @"productDescription";
            //以下配置信息是默认信息,不需要更改.
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types,用于快捷支付成功后重新唤起商户应用
            NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
            NSString *appScheme = identifier;
            
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                    NSLog(@"#######%ld",(long)resultStatus);
                    // NSString *publicKey = alipaypublicKey;
                    NSLog(@"支付状态信息---%ld---%@",resultStatus,[resultDic valueForKey:@"memo"]);
                    // 是否支付成功
                    if (9000 == resultStatus) {
                        /*
                         *用公钥验证签名
                         */
                        [self getMyCoin];
                        
                    }
                }];
            }
        }else{
            [MBProgressHUD showError:msg];
        }

    } fail:^{
        
    }];
    
    

}
@end
