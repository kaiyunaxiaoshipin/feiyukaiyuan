//
//  zhuangresultimagev.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/12.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "zhuangresultimagev.h"
@implementation zhuangresultimagev
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView  *zhuangresultimagev = [[UIImageView alloc]initWithFrame:frame];
        [zhuangresultimagev setImage:[UIImage imageNamed:@"bg_bull_fight_win"]];
        [self addSubview:zhuangresultimagev];
        _banker_profit = [[UILabel alloc]initWithFrame:CGRectMake(0,80,frame.size.width, 30)];
        _banker_profit.font = [UIFont fontWithName:@"ArialMT" size:18];
        _banker_profit.textAlignment = NSTextAlignmentCenter;
        [_banker_profit setTextColor:[UIColor whiteColor]];
        _gamecoin = [[UILabel alloc]initWithFrame:CGRectMake(0,50,frame.size.width, 30)];
        _gamecoin.textAlignment = NSTextAlignmentCenter;
        _gamecoin.font = [UIFont fontWithName:@"ArialMT" size:25];
        [_gamecoin setTextColor:normalColors];
        [zhuangresultimagev addSubview:_gamecoin];
        [zhuangresultimagev addSubview:_banker_profit];
    }
    return self;
}
@end
