//
//  live&VideoSelectView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/3.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "live&VideoSelectView.h"

@implementation live_VideoSelectView{
    UIView *whiteView;
}

- (instancetype)init{
    self = [super init];
    self.frame = CGRectMake(0, 0, _window_width, _window_height);
    if (self) {
        [self creatUI];
        [self showWhiteView];
    }
    return self;
}
- (void)creatUI{
    UIButton *hidBtn = [UIButton buttonWithType:0];
    hidBtn.frame = CGRectMake(0, 0, _window_width, _window_height-(150+ShowDiff));
    [hidBtn addTarget:self action:@selector(hidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hidBtn];
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, 150+ShowDiff)];
    whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.98];
    [self addSubview:whiteView];
    
    NSArray *arr = @[YZMsg(@"立即直播"),YZMsg(@"拍摄视频")];
    for (int i = 0; i < arr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(_window_width/2-100+i*130, 10, 70, 90);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_jinshan",arr[i]]];
        [btn addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 70, 20)];
        label.text = arr[i];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:label];
    }
    UIButton *closeBtn = [UIButton buttonWithType:0];
    closeBtn.frame = CGRectMake(_window_width/2-20, 110, 40, 40);
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [closeBtn addTarget:self action:@selector(hidBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"jinshan_关闭"] forState:0];
    [whiteView addSubview:closeBtn];
    
}
- (void)itemBtnClick:(UIButton *)sender{
    self.userInteractionEnabled = NO;
    if (sender.tag == 1000) {
        [self.delegate clickLive:YES];
    }else{
        [self.delegate clickLive:NO];
    }
}
- (void)showWhiteView{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(0, _window_height - (150+ShowDiff), _window_width, 150+ShowDiff);
    }];
}
- (void)hidBtnClick{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(0, _window_height, _window_width, 150+ShowDiff);
    } completion:^(BOOL finished) {
        [self.delegate hideSelctView];
    }];
}
@end
