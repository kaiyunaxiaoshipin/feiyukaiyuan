#import "hahazhucedeview.h"
#import "ZYTabBarController.h"
#import "AppDelegate.h"

@interface hahazhucedeview ()<UITextFieldDelegate>
{
       NSTimer *messsageTimer;
       int messageIssssss;//短信倒计时  60s
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;
#pragma mark ================ 语言包的时候需要修改的label ===============
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yzmLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel2;

@end
@implementation hahazhucedeview
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _titlelabel.text = YZMsg(@"注册");
    _phoneT.placeholder = YZMsg(@"请填写手机号");
    _yanzhengmaT.placeholder = YZMsg(@"请输入验证码");
    _passWordT.placeholder = YZMsg(@"请填写密码");
    _password2.placeholder = YZMsg(@"请确认密码");
    [_yanzhengmaBtn setTitle:YZMsg(@"获取验证码") forState:0];
    [_registBTn setTitle:YZMsg(@"注册并登录") forState:0];
    
    [_phoneT becomeFirstResponder];
    messageIssssss = 60;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];
}
//MARK:-ChangeBtnBackground
-(void)ChangeBtnBackground
{
    if (_phoneT.text.length == 11) {
        [_yanzhengmaBtn setTitleColor:normalColors forState:0];
    }else{
        [_yanzhengmaBtn setTitleColor:RGB_COLOR(@"#c8c8c8", 1) forState:0];

    }
    if (_phoneT.text.length == 11 && _yanzhengmaT.text.length == 6 && _passWordT.text.length > 0 && _password2.text.length >0)
    {
        [_registBTn setBackgroundColor:normalColors];
        _registBTn.enabled = YES;
    }
    else
    {
        [_registBTn setBackgroundColor:[normalColors colorWithAlphaComponent:0.5]];
        _registBTn.enabled = NO;
    }
}
//获取验证码倒计时
-(void)daojishi{
    [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%@%ds",YZMsg(@"倒计时"),messageIssssss] forState:UIControlStateNormal];
    _yanzhengmaBtn.userInteractionEnabled = NO;
    [_yanzhengmaBtn setTitleColor:RGB_COLOR(@"#c8c8c8", 1) forState:0];

    if (messageIssssss<=0) {
        [_yanzhengmaBtn setTitleColor:normalColors forState:0];
        [_yanzhengmaBtn setTitle:YZMsg(@"重新获取") forState:UIControlStateNormal];
        _yanzhengmaBtn.userInteractionEnabled = YES;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageIssssss = 60;
    }
    messageIssssss-=1;
}
//键盘的隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doRegist:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:YZMsg(@"正在注册")];
    NSDictionary *Reg = @{
                          @"user_login":_phoneT.text,
                          @"user_pass":_passWordT.text,
                          @"user_pass2":_password2.text,
                          @"code":_yanzhengmaT.text,
                          @"source":@"ios"
                          };
    [YBToolClass postNetworkWithUrl:@"Login.userReg" andParameter:Reg success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];

        if (code == 0) {
//            [MBProgressHUD showError:@"注册成功"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.navigationController popViewControllerAnimated:YES];
//            });
            [self goLogin];
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        [MBProgressHUD hideHUD];
    }];

}
- (void)goLogin{
    [MBProgressHUD showError:YZMsg(@"正在登录")];
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
            [[NSUserDefaults standardUserDefaults] setObject:minstr([infos valueForKey:@"isagent"]) forKey:@"isagent"];
            [cityDefault saveisreg:isreg];
            [self login];
            
        }else{
            [MBProgressHUD showError:msg];
            [MBProgressHUD hideHUD];
        }
        
    } fail:^{
        [MBProgressHUD hideHUD];
    }];

}
-(void)LoginJM{
    NSString *aliasStr = [NSString stringWithFormat:@"%@PUSH",[Config getOwnID]];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
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
    [self.navigationController pushViewController:root animated:YES];
    
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:root];
    app2.window.rootViewController = nav;
    
}


- (IBAction)getYanZheng:(id)sender {
    if (_phoneT.text.length!=11){
        [MBProgressHUD showError:YZMsg(@"手机号输入错误")];
        return;
    }
    if (_phoneT.text.length == 0){
        [MBProgressHUD showError:YZMsg(@"请输入手机号")];
        return;
    }
    else{
        [MBProgressHUD showMessage:@""];
        messageIssssss = 60;
        _yanzhengmaBtn.userInteractionEnabled = NO;
        NSDictionary *getcode = @{
                                  @"mobile":_phoneT.text,
                                  @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"mobile=%@&76576076c1f5f657b634e966c8836a06",_phoneT.text]]

                                  };
        
        [YBToolClass postNetworkWithUrl:@"Login.getCode" andParameter:getcode success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            [MBProgressHUD hideHUD];
            if (code == 0) {
                _yanzhengmaBtn.userInteractionEnabled = YES;
                if (messsageTimer == nil) {
                    messsageTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                }
                [MBProgressHUD showError:YZMsg(@"发送成功")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                });

            }else{
                [MBProgressHUD showError:msg];
                _yanzhengmaBtn.userInteractionEnabled = YES;
            }
        } fail:^{
            [MBProgressHUD hideHUD];
            _yanzhengmaBtn.userInteractionEnabled = YES;
        }];
    }
}
@end
