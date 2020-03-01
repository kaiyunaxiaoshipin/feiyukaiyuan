//
//  EditNiceName.m
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "EditNiceName.h"
@interface EditNiceName ()<UITextFieldDelegate>
{
    UITextField *input;
    float NavHeight;
    int setvisaaaa;
    UIActivityIndicatorView *testActivityIndicator;//菊花

}
@end
@implementation EditNiceName
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvisaaaa = 1;
    self.navigationController.navigationBarHidden = YES;

    [self navtion];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisaaaa = 0;
}
-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"修改昵称");
    [label setFont:navtionTitleFont];
    
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
    
    
    UIButton *BtnSave = [[UIButton alloc] initWithFrame:CGRectMake(_window_width-60,24+statusbarHeight,60,40)];
    [BtnSave setTitle:YZMsg(@"保存") forState:UIControlStateNormal];
    [BtnSave setTitleColor:normalColors forState:0];
    BtnSave.titleLabel.font = [UIFont systemFontOfSize:14];
    [BtnSave addTarget:self action:@selector(nicknameSave) forControlEvents:UIControlEventTouchUpInside];
    
    [navtion addSubview:BtnSave];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];

}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    float NavHeight = 64 + statusbarHeight;//包涵通知栏的20px
    self.view.backgroundColor = RGB(244, 245, 246);
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, _window_width, 50)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    input = [[UITextField alloc] init];
    input.delegate = self;
    NavHeight = 54 + statusbarHeight;//包涵通知栏的20px
    input.frame = CGRectMake(20,0 , [UIScreen mainScreen].bounds.size.width  - 40, 50);
    input.layer.cornerRadius = 3;
    input.layer.masksToBounds = YES;
    input.font = fontThin(15);
    input.text = [Config getOwnNicename];
    [input setBackgroundColor:[UIColor whiteColor]];
    input.clearButtonMode = UITextFieldViewModeAlways;
    [backView addSubview:input];
    UILabel *lab = [[UILabel alloc] init];
    lab.text = YZMsg(@"昵称最多8个字");
    lab.font = fontThin(11);
    [lab setTextColor:[UIColor colorWithRed:45.0/255 green:45.0/255 blue:45.0/255 alpha:1]];
    lab.frame = CGRectMake(20, backView.bottom, 200, 20);
    [self.view addSubview:lab];
    [input becomeFirstResponder];
}
-(void)nicknameSave
{
    
    
    if (input.text.length > 8) {
        [MBProgressHUD showError:YZMsg(@"字数超出限制")];
        return ;
    }
    
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    

    
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[input.text] forKeys:@[@"user_nicename"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];
    
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            LiveUser *user = [[LiveUser alloc] init];
            
            
            user.user_nicename = input.text;
            [Config updateProfile:user];
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];

        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    }];
    
}

@end
