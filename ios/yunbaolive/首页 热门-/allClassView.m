//
//  allClassView.m
//  yunbaolive
//
//  Created by Boom on 2018/9/22.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "allClassView.h"

@implementation allClassView{
    UIView *whiteView;
    UIButton *hidBtn;
    NSInteger count;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{

    NSArray *classArray = [common liveclass];
    if (classArray.count % 5 == 0) {
        count = classArray.count/5;
    }else{
        count = classArray.count / 5 +1;
    }
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, -count*_window_width/6, _window_width, count*_window_width/6+20)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    CGFloat speace = (_window_width/6)/6;
    for (int i = 0; i < classArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(speace + i%5*(_window_width/6+speace) , 2.5 + (i/5)*_window_width/6, _window_width/6, _window_width/6);
        button.tag = i + 3000;
//        [button sd_setImageWithURL:[NSURL URLWithString:minstr([classArray[i] valueForKey:@"thumb"])] forState:0 placeholderImage:[UIImage imageNamed:@"live_all"]];
//        [button setTitle:minstr([classArray[i] valueForKey:@"name"]) forState:0];
//        button.titleLabel.font = [UIFont systemFontOfSize:11];
//        [button setTitleColor:RGB(99, 99, 99) forState:0];
        [button addTarget:self action:@selector(liveClassBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        button.imageEdgeInsets = UIEdgeInsetsMake(7.5, 12.5, 22.5, 12.5);
//        button.titleEdgeInsets = UIEdgeInsetsMake(30, -65, 0, 0);
//        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [whiteView addSubview:button];
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(button.width*0.3, button.width*0.15, button.width*0.4, button.width*0.4)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:minstr([classArray[i] valueForKey:@"thumb"])] placeholderImage:[UIImage imageNamed:@"live_all"]];
        [button addSubview:imgView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+button.width*0.1, button.width, 12)];
        label.textColor = RGB(99, 99, 99);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [label setText:minstr([classArray[i] valueForKey:@"name"])];
        [button addSubview:label];

    }
    hidBtn = [UIButton buttonWithType:0];
    hidBtn.frame = CGRectMake(0, whiteView.height, _window_width, self.height-whiteView.height);
    [hidBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    hidBtn.userInteractionEnabled = NO;
    [self addSubview:hidBtn];
}
- (void)liveClassBtnClick:(UIButton *)sender{
    NSDictionary *dic = [common liveclass][sender.tag-3000];
    if (self.block) {
        self.block(dic);
    }
    //隐藏自己
    [self hideSelf];
}
- (void)showWhiteView{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(0, 0, _window_width, count*_window_width/6+20);

    } completion:^(BOOL finished) {
        hidBtn.userInteractionEnabled = YES;

    }];
}
- (void)hideSelf{
    hidBtn.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(0, -count*_window_width/6, _window_width, count*_window_width/6+20);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];

}
@end
