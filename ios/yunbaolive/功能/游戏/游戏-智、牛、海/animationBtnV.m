//
//  animationBtnV.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/10.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "animationBtnV.h"
@implementation animationBtnV
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self addSubview:_bottomImage];
        _frontButton = [UIButton buttonWithType:0];
        _frontButton.titleLabel.font = [UIFont systemFontOfSize:11];
        _frontButton.frame = CGRectMake(0, 0, 30, 30);
        [self addSubview:_frontButton];
    }
    return self;
}
-(void)setAnimation{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (!_timer) {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.8;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [_bottomImage.layer addAnimation:animation forKey:nil];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(game) userInfo:nil repeats:YES];
        
    }
}
-(void)game{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [_bottomImage.layer addAnimation:animation forKey:nil];
}
-(void)stopAnimation{
    [_timer invalidate];
    _timer = nil;
    _bottomImage.frame = CGRectMake(0, 0, 30, 30);
}
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}
@end
