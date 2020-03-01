#import "getpasswordview.h"
@interface getpasswordview ()
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

@end

@implementation getpasswordview

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _titlelabel.text = YZMsg(@"忘记密码");
    _phoneT.placeholder = YZMsg(@"请填写手机号");
    _yanzhengma.placeholder = YZMsg(@"请输入验证码");
    _secretT.placeholder = YZMsg(@"请填写密码");
    _secretTT2.placeholder = YZMsg(@"请确认密码");
    [_yanzhengmaBtn setTitle:YZMsg(@"获取验证码") forState:0];
    [_findNowBtn setTitle:YZMsg(@"立即找回") forState:0];

    [_phoneT becomeFirstResponder];
    messageIssssss = 60;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)ChangeBtnBackground
{
    if (_phoneT.text.length == 11 && _yanzhengma.text.length == 6 && _secretT.text.length > 0 && _secretTT2.text.length >0)
    {
        [_findNowBtn setBackgroundColor:normalColors];
        _findNowBtn.enabled = YES;
    }
    else
    {
        [_findNowBtn setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:207/255.0 alpha:1.0]];
        _findNowBtn.enabled = NO;
    }
}
-(void)daojishi{
    [_yanzhengmaBtn setTitle:[NSString stringWithFormat:@"%ds",messageIssssss] forState:UIControlStateNormal];
    _yanzhengmaBtn.userInteractionEnabled = NO;
    if (messageIssssss<=0) {
        [_yanzhengmaBtn setTitle:YZMsg(@"发送验证码") forState:UIControlStateNormal];
        _yanzhengmaBtn.userInteractionEnabled = YES;
        [messsageTimer invalidate];
        messsageTimer = nil;
        messageIssssss = 60;
    }
    messageIssssss-=1;
}
- (IBAction)clickYanzhengma:(id)sender {
    if (_phoneT.text.length!=11){
        [MBProgressHUD showError:YZMsg(@"手机号输入错误")];
        return;
    }
    if (_phoneT.text.length == 0){
        [MBProgressHUD showError:YZMsg(@"请输入手机号")];
        return;
    }

    _yanzhengmaBtn.userInteractionEnabled = NO;
    messageIssssss = 60;
    NSDictionary *ForgetCode = @{
                                 @"mobile":_phoneT.text,
                                 @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"mobile=%@&76576076c1f5f657b634e966c8836a06",_phoneT.text]]
                                 };

    [YBToolClass postNetworkWithUrl:@"Login.getForgetCode" andParameter:ForgetCode success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
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
            _yanzhengmaBtn.userInteractionEnabled = YES;
            [MBProgressHUD showError:msg];

        }
    } fail:^{
        _yanzhengmaBtn.userInteractionEnabled = YES;

    }];

}
//键盘的隐藏
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (IBAction)doBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clickFindBtn:(id)sender {
    NSDictionary *FindPass = @{
                               @"user_login":_phoneT.text,
                               @"user_pass":_secretT.text,
                               @"user_pass2":_secretTT2.text,
                               @"code":_yanzhengma.text
                               };
    
    [YBToolClass postNetworkWithUrl:@"Login.userFindPass" andParameter:FindPass success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [MBProgressHUD showError:YZMsg(@"密码重置成功")];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
    

    
}
@end
