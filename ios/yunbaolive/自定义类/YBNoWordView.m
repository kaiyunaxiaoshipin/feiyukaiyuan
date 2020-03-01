//
//  YBNoWordView.m
//  yunbaolive
//
//  Created by Boom on 2018/10/31.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "YBNoWordView.h"

@implementation YBNoWordView{
    UIButton *refrashBtn;
}

- (instancetype)initWithBlock:(refrashBtnBlock)bbbbb{
    self = [super init];
    self.frame = CGRectMake(_window_width/2-80, _window_height*0.4-80, 160, 160);
    self.block = bbbbb;
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160, 70)];
    imageView.image = [UIImage imageNamed:@"noNetWorking"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+16, 160, 16)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    label1.font = [UIFont systemFontOfSize:15];
    label1.text = @"网络请求失败";
    [self addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.bottom+6, 160, 16)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"请检查网络链接后重试～";
    [self addSubview:label2];

    refrashBtn = [UIButton buttonWithType:0];
    refrashBtn.frame = CGRectMake(45, label2.bottom+12, 70, 25);
    refrashBtn.layer.cornerRadius = 12.5;
    refrashBtn.layer.masksToBounds = YES;
    [refrashBtn setBackgroundColor:normalColors];
    [refrashBtn setTitle:@"重试" forState:0];
    refrashBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [refrashBtn addTarget:self action:@selector(refrashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:refrashBtn];
    
}
- (void)refrashBtnClick:(UIButton *)sender{
    self.block(nil);
}
@end
