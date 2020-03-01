//
//  redBagView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "redBagView.h"

@implementation redBagView{
    UIImageView *redView;
    UIImageView *leftImgView;
    UIImageView *rightImgView;
    UITextField *coinT;
    UITextField *numT;
    UILabel *rightLabel;
    UITextView *contentT;
    UIButton *timeTypeBtn;
    NSString *type;
    NSString *type_grant;
    UIButton *sendBtn;
    UILabel *llllLabel;
}
- (void)hidSelf{
    if (coinT.isFirstResponder || numT.isFirstResponder || contentT.isFirstResponder) {
        [coinT resignFirstResponder];
        [numT resignFirstResponder];
        [contentT resignFirstResponder];
        return;
    }
    self.block(@"909");
}
- (void)hidKeyBoard{
    [coinT resignFirstResponder];
    [numT resignFirstResponder];
    [contentT resignFirstResponder];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        type = @"1";
        type_grant = @"1";
        [self creatUI];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeBtnBackground:) name:UIControlEventEditingChanged object:nil];

    }
    return self;
}
- (void)creatUI{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidSelf)];
    [self addGestureRecognizer:tap];
    redView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.14, _window_height, _window_width*0.72, _window_width*0.72*76/54)];
    redView.layer.cornerRadius = 10.0;
    redView.layer.masksToBounds =YES;
    redView.userInteractionEnabled = YES;
    redView.image = [UIImage imageNamed:@"sendRed_back"];
    redView.center = self.center;
    [self addSubview:redView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
    [redView addGestureRecognizer:tap2];

    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, redView.height*1/76, redView.width, redView.height*7/76)];
    titleL.text = YZMsg(@"直播间红包");
    titleL.textColor = normalColors;
    titleL.font = [UIFont boldSystemFontOfSize:17];
    titleL.textAlignment = NSTextAlignmentCenter;
    [redView addSubview:titleL];
    
    UILabel *titleL2 = [[UILabel alloc]initWithFrame:CGRectMake(0, titleL.bottom, redView.width, redView.height*3/76)];
    titleL2.text = YZMsg(@"给当前直播间观众发红包");
    titleL2.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titleL2.font = [UIFont systemFontOfSize:11];
    titleL2.textAlignment = NSTextAlignmentCenter;
    [redView addSubview:titleL2];
    NSArray *arr = @[YZMsg(@"拼手气红包"),YZMsg(@"平均红包")];
    for (int i = 0; i < 2; i ++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(redView.width/2-100 + 100*i, titleL2.bottom, 100, titleL.height);
        [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [redView addSubview:btn];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, btn.height/2-5, 10, 10)];
        [btn addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right+8, imgView.top-5, 77, 20)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = arr[i];
        [btn addSubview:label];
        if (i == 0) {
            leftImgView = imgView;
            leftImgView.image = [UIImage imageNamed:@"类型选中@3x"];
        }else{
            rightImgView = imgView;
            rightImgView.image = [UIImage imageNamed:@"类型未选中@3x"];
        }
    }
    int height = 10;
    for (int i = 0; i < 3; i ++) {
        if (i == 2) {
            height = 12;
        }
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(redView.width*0.075, titleL2.bottom+redView.height*8/76+i * (redView.height*11/76), redView.width*0.85, redView.height*height/76)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        [redView addSubview:view];
//        if (i == 0) {
//            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, view.height/3, 40, view.height/3)];
//            imgView.contentMode = UIViewContentModeScaleAspectFit;
//            imgView.image = [UIImage imageNamed:@"logFirst_钻石"];
//            [view addSubview:imgView];
//        }
//        if (i == 1) {
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, view.height/3, 40, view.height/3)];
//            label.font = [UIFont systemFontOfSize:14];
//            label.text = YZMsg(@"数量");
//            label.textAlignment = NSTextAlignmentCenter;
//            [view addSubview:label];
//        }
        if (i != 2) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.height/3, view.width*0.3, view.height/3)];
            label.font = [UIFont systemFontOfSize:14];
            [label setAdjustsFontSizeToFitWidth:YES];
            if (i == 0) {
                llllLabel = label;
                label.text = YZMsg(@"总金额");
            }else{
                label.text = YZMsg(@"数量");
            }
            label.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label];

            UITextField *textFiled = [[UITextField alloc]initWithFrame:CGRectMake(view.width*0.3, 0, view.width*0.4, view.height)];
            textFiled.font = [UIFont boldSystemFontOfSize:17];
            textFiled.textAlignment = NSTextAlignmentCenter;
            textFiled.keyboardType = UIKeyboardTypeNumberPad;
            textFiled.delegate = self;
            [view addSubview:textFiled];
            [textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

            UILabel *rLabel = [[UILabel alloc]initWithFrame:CGRectMake(view.width-70, 0, 60, view.height)];
            rLabel.textAlignment = NSTextAlignmentRight;
            rLabel.textColor = RGB_COLOR(@"#959697", 1);
            rLabel.font = [UIFont systemFontOfSize:14];
            [view addSubview:rLabel];
            if (i == 0) {
                coinT = textFiled;
                coinT.textColor = normalColors;
                coinT.text = @"100";

                rightLabel = rLabel;
                rLabel.text = [common name_coin];
                
            }else{
                numT = textFiled;
                numT.textColor = RGB_COLOR(@"#636465", 1);
                numT.text = @"10";
                rLabel.text = YZMsg(@"个");
            }
        }else{
            contentT = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, view.width-20, view.height)];
            contentT.delegate = self;
            contentT.text = YZMsg(@"恭喜发财，大吉大利");
            contentT.font = [UIFont systemFontOfSize:15];
            contentT.textColor = RGB_COLOR(@"#959697", 1);
            [view addSubview:contentT];
        }

    }
    timeTypeBtn = [UIButton buttonWithType:0];
    timeTypeBtn.frame = CGRectMake(redView.width/2-redView.height*9/76, redView.height*57/76, redView.height*18/76, redView.height*5/76);
    [timeTypeBtn setImage:[UIImage imageNamed:@"时间-延时"] forState:UIControlStateNormal];
    [timeTypeBtn setImage:[UIImage imageNamed:@"时间-立即"] forState:UIControlStateSelected];
    [timeTypeBtn addTarget:self action:@selector(timeTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    timeTypeBtn.selected = NO;
    [redView addSubview:timeTypeBtn];
    //
    sendBtn = [UIButton buttonWithType:0];
    sendBtn.frame = CGRectMake(redView.width*0.075, timeTypeBtn.bottom + redView.height*2/76, redView.width*0.85, redView.height*8/76);
    [sendBtn setBackgroundColor:normalColors];
    [sendBtn setTitle:[NSString stringWithFormat:@"%@ 100%@",YZMsg(@"发红包"),[common name_coin]] forState:0];
    [sendBtn setTitleColor:RGB_COLOR(@"#ee3b2f", 1) forState:0];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = redView.height*4/76;
    [redView addSubview:sendBtn];

}
- (void)typeBtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        leftImgView.image = [UIImage imageNamed:@"类型选中@3x"];
        rightImgView.image = [UIImage imageNamed:@"类型未选中@3x"];
        rightLabel.text = [common name_coin];
        type = @"1";
        coinT.text = @"100";
        numT.text = @"10";
        [sendBtn setTitle:[NSString stringWithFormat:@"%@ 100%@",YZMsg(@"发红包"),[common name_coin]] forState:0];
        llllLabel.text = YZMsg(@"总金额");

    }else{
        rightImgView.image = [UIImage imageNamed:@"类型选中@3x"];
        leftImgView.image = [UIImage imageNamed:@"类型未选中@3x"];
        rightLabel.text = [NSString stringWithFormat:@"%@",[common name_coin]];
        type = @"0";
        coinT.text = @"1";
        numT.text = @"100";
        [sendBtn setTitle:[NSString stringWithFormat:@"%@ 100%@",YZMsg(@"发红包"),[common name_coin]] forState:0];
        llllLabel.text = YZMsg(@"单个金额");
    }
}
- (void)timeTypeBtnClick:(UIButton *)sender{
    timeTypeBtn.selected = !timeTypeBtn.selected;
    if (timeTypeBtn.selected) {
        type_grant = @"0";
    }else{
        type_grant = @"1";
    }
}
- (void)sendBtnClick{
    if (coinT.text == NULL || coinT.text == nil || coinT.text.length == 0) {
        [MBProgressHUD showError:YZMsg(@"请输入红包金额")];
        return;
    }
    if (numT.text == NULL || numT.text == nil || numT.text.length == 0) {
        [MBProgressHUD showError:YZMsg(@"请输入红包数量")];
        return;
    }
    [MBProgressHUD showMessage:@""];
    NSDictionary *dic = @{
                          @"stream":minstr([_zhuboDic valueForKey:@"stream"]),
                          @"type":type,
                          @"type_grant":type_grant,
                          @"coin":coinT.text,
                          @"nums":numT.text,
                          };
    NSString *url = [NSString stringWithFormat:@"Red.SendRed&des=%@",contentT.text];
    [YBToolClass postNetworkWithUrl:url andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        if (code == 0) {
            if (self.block) {
                self.block(type);
            }
        }
        [MBProgressHUD showError:msg];
        
    } fail:^{
        [MBProgressHUD hideHUD];
    }];
}
- (void)textFieldDidChange:(UITextField *)textField{
    NSString *str = textField.text;
    if (textField == coinT) {
        if (str.length > 8) {
            textField.text = [str substringToIndex:8];
            
        }
    }else{
        if (numT.text.length > 6) {
            textField.text = [str substringToIndex:6];
        }
    }

    NSString *coinStr;
    if ([type isEqual:@"1"]) {
        if ([coinT.text intValue] >= 10000) {
            if (([coinT.text intValue] * [numT.text intValue]) % 1000 == 0) {
                if (([coinT.text intValue] * [numT.text intValue]) % 10000 == 0) {
                    coinStr = [NSString stringWithFormat:@"%@ %dw%@",YZMsg(@"发红包"),[coinT.text intValue]/10000,[common name_coin]];
                }else{
                    coinStr = [NSString stringWithFormat:@"%@ %.1fw%@",YZMsg(@"发红包"),[coinT.text intValue]/10000.0,[common name_coin]];
                }
            }else{
                coinStr = [NSString stringWithFormat:@"%@ %.2fw%@",YZMsg(@"发红包"),[coinT.text intValue] /10000.00,[common name_coin]];
            }
        }else{
            coinStr = [NSString stringWithFormat:@"%@ %d%@",YZMsg(@"发红包"),[coinT.text intValue],[common name_coin]];
        }

    }else{
        if ([coinT.text longLongValue] * [numT.text longLongValue] >= 10000) {
            if (([coinT.text longLongValue] * [numT.text longLongValue]) % 1000 == 0) {
                if (([coinT.text longLongValue] * [numT.text longLongValue]) % 10000 == 0) {
                    coinStr = [NSString stringWithFormat:@"%@ %lldw%@",YZMsg(@"发红包"),([coinT.text longLongValue] * [numT.text longLongValue])/10000,[common name_coin]];
                }else{
                    coinStr = [NSString stringWithFormat:@"%@ %.1fw%@",YZMsg(@"发红包"),([coinT.text longLongValue] * [numT.text longLongValue])/10000.0,[common name_coin]];
                }
            }else{
                coinStr = [NSString stringWithFormat:@"%@ %.2fw%@",YZMsg(@"发红包"),([coinT.text longLongValue] * [numT.text longLongValue])/10000.00,[common name_coin]];
            }
        }else{
            coinStr = [NSString stringWithFormat:@"%@ %d%@",YZMsg(@"发红包"),[coinT.text intValue] * [numT.text intValue],[common name_coin]];
        }
    }
    [sendBtn setTitle:coinStr forState:0];
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
    }
}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//}
//- (void)textFieldDidChange:(UITextField *)textField
//{
//    NSString *str = textField.text;
//    if (textField == coinT) {
//        if (str.length > 8) {
//            textField.text = [str substringToIndex:8];
//
//        }
//    }else{
//        if (numT.text.length > 6) {
//            textField.text = [str substringToIndex:6];
//        }
//    }
//}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
