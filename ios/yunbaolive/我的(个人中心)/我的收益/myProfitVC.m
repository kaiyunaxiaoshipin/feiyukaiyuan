//
//  myProfitVC.m
//  yunbaolive
//
//  Created by Boom on 2018/9/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "myProfitVC.h"
#import "profitTypeVC.h"
#import "webH5.h"
@interface myProfitVC (){
    UILabel *allVotesL;
    UILabel *nowVotesL;
    UITextField *votesT;
    UILabel *moneyLabel;
    UILabel *typeLabel;
    int cash_rate;
    UIButton *inputBtn;
    UILabel *tipsLabel;
    NSDictionary *typeDic;
    UIImageView *seletTypeImgView;
}

@end

@implementation myProfitVC
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
    
    
    UIButton *historyBtn = [UIButton buttonWithType:0];
    historyBtn.frame = CGRectMake(_window_width-75, 24+statusbarHeight, 65, 40);
    [historyBtn setTitle:YZMsg(@"提现记录") forState:0];
    [historyBtn setTitleColor:[UIColor grayColor] forState:0];
    historyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [historyBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:historyBtn];

    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];
    [self.view addSubview:navtion];
}
- (void)addBtnClick:(UIButton *)sender{
    webH5 *web = [[webH5 alloc]init];
    web.urls = [NSString stringWithFormat:@"%@/index.php?g=Appapi&m=cash&a=index&uid=%@&token=%@",h5url,[Config getOwnID],[Config getOwnToken]];
    [self.navigationController pushViewController:web animated:YES];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(244, 245, 246);
    [self navtion];
    [self creatUI];
    [self requestData];
}
- (void)requestData{
    [YBToolClass postNetworkWithUrl:@"User.getProfit" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            //获取收益
            nowVotesL.text = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"votes"]];
//            self.withdraw.text = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"todaycash"]];
            allVotesL.text = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"votestotal"]];//收益 魅力值
            cash_rate = [minstr([[info firstObject] valueForKey:@"cash_rate"]) intValue];
            NSString *tips = minstr([[info firstObject] valueForKey:@"tips"]);
            CGFloat height = [[YBToolClass sharedInstance] heightOfString:tips andFont:[UIFont systemFontOfSize:11] andWidth:_window_width*0.7-30];
            tipsLabel.text = tips;
            tipsLabel.height = height;
            NSLog(@"收益数据........%@",info);
        }
    } fail:^{
        
    }];
}
- (void)tapClick{
    [votesT resignFirstResponder];
}
- (void)creatUI{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.view addGestureRecognizer:tap];
    
    //黄色背景图
    UIImageView *backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.04, 64+statusbarHeight+10, _window_width*0.92, _window_width*0.92*24/69)];
    backImgView.image = [UIImage imageNamed:@"profitBg"];
    [self.view addSubview:backImgView];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(backImgView.width/2*(i%2), backImgView.height/4*(i/2+1), backImgView.width/2, backImgView.height/4)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        if (i<2) {
            label.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                label.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"总"),[common name_votes],YZMsg(@"数")];
            }else{
                label.text = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"可提取"),[common name_votes],YZMsg(@"数")];
                [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(backImgView.width/2-0.5, backImgView.height/4, 1, backImgView.height/2) andColor:[UIColor whiteColor] andView:backImgView];
            }
        }else{
            label.font = [UIFont boldSystemFontOfSize:22];
            label.text = @"0";
            if (i == 2) {
                allVotesL = label;
            }else{
                nowVotesL = label;
            }
        }
        [backImgView addSubview:label];
    }
    //输入提现金额的视图
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(backImgView.left, backImgView.bottom+10, backImgView.width, backImgView.height)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.cornerRadius = 5.0;
    textView.layer.masksToBounds = YES;
    [self.view addSubview:textView];
    NSArray *arr = @[[NSString stringWithFormat:@"%@%@%@",YZMsg(@"输入要提取的"),[common name_votes],YZMsg(@"数")],YZMsg(@"可到账金额")];
    for (int i = 0; i<2; i++) {
        CGFloat labelW = [[YBToolClass sharedInstance] widthOfString:arr[i] andFont:[UIFont systemFontOfSize:15] andHeight:textView.height/2];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(textView.width*0.05, textView.height/2*i, labelW+20, textView.height/2)];
        label.textColor = RGB_COLOR(@"#333333", 1);
        label.font = [UIFont systemFontOfSize:15];
        label.text = arr[i];
        [textView addSubview:label];
        if (i == 0) {
            [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(textView.width*0.05, textView.height/2-0.5, textView.width*0.9, 1) andColor:RGB(244, 245, 246) andView:textView];
            votesT = [[UITextField alloc]initWithFrame:CGRectMake(label.right, 0, textView.width*0.95-label.right, textView.height/2)];
            votesT.textColor = normalColors;
            votesT.font = [UIFont boldSystemFontOfSize:17];
            votesT.placeholder = @"0";
            votesT.keyboardType = UIKeyboardTypeNumberPad;
            [textView addSubview:votesT];
        }else{
            moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(label.right, label.top, textView.width*0.95-label.right, textView.height/2)];
            moneyLabel.textColor = [UIColor redColor];
            moneyLabel.font = [UIFont boldSystemFontOfSize:17];
            moneyLabel.text = @"¥0";
            [textView addSubview:moneyLabel];
        }
    }
    
    //选择提现账户
    
    UIView *typeView = [[UIView alloc]initWithFrame:CGRectMake(backImgView.left, textView.bottom+10, backImgView.width, 50)];
    typeView.backgroundColor = [UIColor whiteColor];
    typeView.layer.cornerRadius = 5.0;
    typeView.layer.masksToBounds = YES;
    [self.view addSubview:typeView];
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(textView.width*0.05, 0, typeView.width*0.95-40, 50)];
    typeLabel.textColor = RGB_COLOR(@"#333333", 1);
    typeLabel.font = [UIFont systemFontOfSize:15];
    typeLabel.text = YZMsg(@"请选择提现账户");
    [typeView addSubview:typeLabel];
    seletTypeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(typeLabel.left, 15, 20, 20)];
    seletTypeImgView.hidden = YES;
    [typeView addSubview:seletTypeImgView];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(typeView.width-30, 18, 14, 14)];
    rightImgView.image = [UIImage imageNamed:@"person_right"];
    rightImgView.userInteractionEnabled = YES;
    [typeView addSubview:rightImgView];

    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, typeView.width, typeView.height);
    [btn addTarget:self action:@selector(selectPayType) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:btn];
    
    inputBtn = [UIButton buttonWithType:0];
    inputBtn.frame = CGRectMake(_window_width*0.15, typeView.bottom + 30, _window_width*0.7, 30);
    [inputBtn setBackgroundColor:RGB_COLOR(@"#dcdcdc", 1)];
    [inputBtn setTitle:YZMsg(@"立即提现") forState:0];
    [inputBtn addTarget:self action:@selector(inputBtnClick) forControlEvents:UIControlEventTouchUpInside];
    inputBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    inputBtn.layer.cornerRadius = 15;
    inputBtn.layer.masksToBounds = YES;
    inputBtn.userInteractionEnabled = NO;
    [self.view addSubview:inputBtn];
    
    tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(inputBtn.left+15, inputBtn.bottom + 15, inputBtn.width-30, 100)];
    tipsLabel.font = [UIFont systemFontOfSize:11];
    tipsLabel.textColor = RGB_COLOR(@"#666666", 1);
    tipsLabel.numberOfLines = 0;
    [self.view addSubview:tipsLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeMoenyLabelValue) name:UITextFieldTextDidChangeNotification object:nil];

}
//选择z提现方式
- (void)selectPayType{
    profitTypeVC *vc = [[profitTypeVC alloc]init];
    if (typeDic) {
        vc.selectID = minstr([typeDic valueForKey:@"id"]);
    }else{
        vc.selectID = YZMsg(@"未选择提现方式");
    }
    vc.block = ^(NSDictionary * _Nonnull dic) {
        typeDic = dic;
        seletTypeImgView.hidden = NO;
        typeLabel.x = seletTypeImgView.right + 5;
        int type = [minstr([dic valueForKey:@"type"]) intValue];
        switch (type) {
            case 1:
                seletTypeImgView.image = [UIImage imageNamed:@"profit_alipay"];
                typeLabel.text = [NSString stringWithFormat:@"%@(%@)",minstr([dic valueForKey:@"account"]),minstr([dic valueForKey:@"name"])];
                break;
            case 2:
                seletTypeImgView.image = [UIImage imageNamed:@"profit_wx"];
                typeLabel.text = [NSString stringWithFormat:@"%@",minstr([dic valueForKey:@"account"])];

                break;
            case 3:
                seletTypeImgView.image = [UIImage imageNamed:@"profit_card"];
                typeLabel.text = [NSString stringWithFormat:@"%@(%@)",minstr([dic valueForKey:@"account"]),minstr([dic valueForKey:@"name"])];
                break;
                
            default:
                break;
        }

    };
    [self.navigationController pushViewController:vc animated:YES];
}
//提交申请
- (void)inputBtnClick{
    if(!typeDic){
        [MBProgressHUD showError:YZMsg(@"请选择提现账号")];
        return;
    }
    NSDictionary *dic = @{@"accountid":minstr([typeDic valueForKey:@"id"]),@"cashvote":votesT.text};
    [YBToolClass postNetworkWithUrl:@"User.SetCash" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            votesT.text = @"";
            [MBProgressHUD showError:msg];
            [self requestData];
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
- (void)ChangeMoenyLabelValue{
    moneyLabel.text = [NSString stringWithFormat:@"¥%lld",[votesT.text longLongValue]/cash_rate];
    if ([[NSString stringWithFormat:@"%lld",[votesT.text longLongValue]/cash_rate] integerValue] > 0) {
        inputBtn.userInteractionEnabled = YES;
        [inputBtn setBackgroundColor:normalColors];
    }else{
        inputBtn.userInteractionEnabled = NO;
        [inputBtn setBackgroundColor:RGB_COLOR(@"#dcdcdc", 1)];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
