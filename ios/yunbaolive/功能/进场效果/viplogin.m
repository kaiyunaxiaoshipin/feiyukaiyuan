//
//  viplogin.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/6.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "viplogin.h"
#import <YYWebImage/YYWebImage.h>
@implementation viplogin
-(instancetype)initWithFrame:(CGRect)frame andBlock:(xinBlock)blocks{
    self = [super initWithFrame:frame];
    if (self) {
        self.blocks = blocks;
        _isUserMove = 0;
        _userLogin = [NSMutableArray array];
    }
    return self;
}
-(void)addUserMove:(NSDictionary *)msg{
    if (msg == nil) {
    }
    else
    {
        [_userLogin addObject:msg];
    }
    if(_isUserMove == 0){
        [self userLoginOne];
    }
}
-(void)userLoginOne{
    if (_userLogin.count == 0 || _userLogin == nil) {
        return;
    }
    NSDictionary *Dic = [_userLogin firstObject];
    [_userLogin removeObjectAtIndex:0];
    [self userPlar:Dic];
}
-(void)userPlar:(NSDictionary *)dic{
    
    NSString *car_words = [[dic valueForKey:@"ct"] valueForKey:@"car_words"];
    NSString *names = [NSString stringWithFormat:@"%@%@",[[dic valueForKey:@"ct"] valueForKey:@"user_nicename"],car_words];
    NSArray *textArray = @[names];
    if (_label) {
        [_label stopTimer];
        [_label removeFromSuperview];
        _label = nil;
    }
    int time = [[[dic valueForKey:@"ct"] valueForKey:@"car_swftime"] intValue];
    //car_words
    _isUserMove = 1;
    _userMoveImageV = [YYAnimatedImageView new];
    _userMoveImageV.frame = CGRectMake(0,0,_window_width,self.height-20);
    _userMoveImageV.yy_imageURL = [NSURL URLWithString:minstr([[dic valueForKey:@"ct"] valueForKey:@"car_swf"])];
    [self addSubview:_userMoveImageV];
   _userMoveImageV.contentMode = UIViewContentModeScaleAspectFit;
    _label = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,self.height-20,_window_width,20)  textArray:textArray font:[UIFont systemFontOfSize:12] textColor:normalColors];
    _label.backgroundColor = [UIColor clearColor];
    _label.speed = 2;
    [_label setOrientation:RollingOrientationLeft];
    [_label setInternalWidth:_label.frame.size.width / 3];
    [self addSubview:_label];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_userMoveImageV removeFromSuperview];
        _userMoveImageV = nil;
        _isUserMove = 0;
        [_label stopTimer];
        [_label removeFromSuperview];
        _label = nil;
        if (_userLogin.count >0) {
            [self addUserMove:nil];
        }
        if (_userLogin.count <=0) {
            self.blocks();
        }
    });


}
@end
