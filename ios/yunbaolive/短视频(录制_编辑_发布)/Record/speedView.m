//
//  speedView.m
//  yunbaolive
//
//  Created by Boom on 2018/12/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "speedView.h"

@implementation speedView{
    UIView *removeView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    NSArray *segArr = @[YZMsg(@"极慢"),YZMsg(@"慢"),YZMsg(@"正常"),YZMsg(@"快"),YZMsg(@"极快")];
    CGFloat width = _window_width*0.6/5;
    removeView = [[UIView alloc]initWithFrame:CGRectMake(self.width/2-width/2, 0, width, self.height)];
    removeView.backgroundColor = normalColors;
    removeView.layer.cornerRadius = 5.0;
    removeView.layer.masksToBounds = YES;
    [self addSubview:removeView];
    for (int i = 0; i < segArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(width*i, 0, width, self.height);
        btn.tag = 1221+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:segArr[i] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:btn];
    }
}
- (void)btnClick:(UIButton *)sender{
    int i = (int)sender.tag - 1221;
    if (self.block) {
        self.block(i);
    }
    [UIView animateWithDuration:0.2 animations:^{
        removeView.x = sender.x;
    }];
}
@end
