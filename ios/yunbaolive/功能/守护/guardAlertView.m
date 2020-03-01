//
//  guardAlertView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "guardAlertView.h"

@implementation guardAlertView

{
    UIView *alertView;
}

- (instancetype)initWithFrame:(CGRect)frame andType:(int)type andMsg:(NSString *)msg{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB_COLOR(@"#000000", 0.1);
        [self creatUI:type and:msg];
    }
    return self;
}
- (void)creatUI:(int)type and:(NSString *)msg{
    alertView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.15, _window_height/2-_window_width*0.2, _window_width*0.7, _window_width*0.4)];
    alertView.center = self.center;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 5.0;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, alertView.height/8, alertView.width, alertView.height/32*3)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = RGB_COLOR(@"#333333", 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = YZMsg(@"提示");
    [alertView addSubview:titleLabel];
    
    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(alertView.width/8, titleLabel.bottom, alertView.width*0.75, alertView.height/32*15)];
    msgLabel.font = [UIFont systemFontOfSize:12];
    msgLabel.textColor = RGB_COLOR(@"#636465", 1);
    msgLabel.numberOfLines = 0;
    msgLabel.text = msg;
    [alertView addSubview:msgLabel];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, msgLabel.bottom, alertView.width, 1) andColor:RGB_COLOR(@"#e4e5e6", 1) andView:alertView];
    if (type == 1) {
//        msgLabel.text = YZMsg(@"您当前为主播的月守护，开通年守护将覆盖您的月守护剩余时长，是否开通？");
        NSArray *arr = @[YZMsg(@"取消"),YZMsg(@"确定")];
        for (int i = 0; i < arr.count; i++) {
            UIButton *button = [UIButton buttonWithType:0];
            button.frame = CGRectMake((alertView.width/2+0.5)*i, msgLabel.bottom+1, alertView.width/2-0.5, alertView.height*5/16-1);
            button.tag = 181112+i;
            [button setTitle:arr[i] forState:0];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                [button setTitleColor:RGB_COLOR(@"#636465", 1) forState:0];
                [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(button.right, button.top, 1, button.height) andColor:RGB_COLOR(@"#e4e5e6", 1) andView:alertView];
            }else{
                [button setTitleColor:normalColors forState:0];
            }
            [alertView addSubview:button];
        }

    }else{
//        msgLabel.text = YZMsg(@"您当前为主播的年守护\n无法开通7天/月守护");
        msgLabel.textAlignment = NSTextAlignmentCenter;
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(0, msgLabel.bottom+1, alertView.width, alertView.height*5/16-1);
        button.tag = 181112;
        [button setTitle:YZMsg(@"确定") forState:0];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:normalColors forState:0];
        [alertView addSubview:button];
    }

    
}
- (void)buttonClick:(UIButton *)sender{
    
    if (sender.tag == 181112) {
        self.block(NO);
    }else{
        self.block(YES);
    }
}
@end
