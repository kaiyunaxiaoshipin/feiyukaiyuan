//
//  linkAlertView.m
//  yunbaolive
//
//  Created by Boom on 2018/10/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "linkAlertView.h"

@implementation linkAlertView{
    NSDictionary *userMsg;
    UIView *whiteView;
    
}

- (instancetype)initWithFrame:(CGRect)frame andUserMsg:(NSDictionary *)dic{
    self = [self initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    userMsg = dic;
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*(95/750.00000), _window_height/2-100, _window_width*(560/750.00000), 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5.0;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    UIImageView *headerImgview =[[ UIImageView alloc]initWithFrame:CGRectMake(whiteView.width/2-22.5, 15, 45, 45)];
    [headerImgview sd_setImageWithURL:[NSURL URLWithString:minstr([userMsg valueForKey:@"uhead"])]];
    headerImgview.layer.cornerRadius = 22.5;
    headerImgview.layer.masksToBounds = YES;
    [whiteView addSubview:headerImgview];
    
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImgview.bottom, whiteView.width, 29)];
    nameL.textColor = RGB_COLOR(@"#646566", 1);
    nameL.font = [UIFont boldSystemFontOfSize:15];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.text = minstr([userMsg valueForKey:@"uname"]);
    [whiteView addSubview:nameL];
    
    
    UIImageView *sexImgView =[[ UIImageView alloc]initWithFrame:CGRectMake(whiteView.width/2-25, nameL.bottom, 15, 15)];
    if ([minstr([userMsg valueForKey:@"sex"]) isEqual:@"1"]) {
        sexImgView.image = [UIImage imageNamed:@"sex_man"];
    }else{
        sexImgView.image = [UIImage imageNamed:@"sex_woman"];
    }
    [whiteView addSubview:sexImgView];
    
    
    UIImageView *levelImgView =[[ UIImageView alloc]initWithFrame:CGRectMake(sexImgView.right+5, sexImgView.top, 30, 15)];
    if ([userMsg valueForKey:@"level_anchor"]) {
        NSDictionary *levelDic = [common getAnchorLevelMessage:minstr([userMsg valueForKey:@"level_anchor"])];
        [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
    }else{
        NSDictionary *levelDic = [common getUserLevelMessage:minstr([userMsg valueForKey:@"level"])];
        [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
    }
    [whiteView addSubview:levelImgView];
    
    _timeL = [[UILabel alloc]initWithFrame:CGRectMake(0, levelImgView.bottom, whiteView.width, 41)];
    _timeL.textAlignment = NSTextAlignmentCenter;
    
    _timeL.textColor = RGB_COLOR(@"#636465", 1);
    [whiteView addSubview:_timeL];
    
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, _timeL.bottom, whiteView.width, 1) andColor:RGB_COLOR(@"#e3e4e5", 1) andView:whiteView];
    
    NSArray *btnTitleArr = @[YZMsg(@"拒绝"),YZMsg(@"接受")];
    for (int i = 0; i< btnTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake((whiteView.width/2+0.5)*i, _timeL.bottom+1, whiteView.width/2-0.5, 200-1-(_timeL.bottom));
        btn.tag = i+1000;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:btnTitleArr[i] forState:0];
        if (i == 0) {
            [btn setTitleColor:RGB_COLOR(@"#636465", 1) forState:0];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(btn.right, btn.top, 1, btn.height) andColor:RGB_COLOR(@"#e3e4e5", 1) andView:whiteView];
        }else{
            [btn setTitleColor:normalColors forState:0];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        [whiteView addSubview:btn];
    }
}
- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        self.block(NO);
    }else{
        self.block(YES);
    }
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
    }];

}
@end
