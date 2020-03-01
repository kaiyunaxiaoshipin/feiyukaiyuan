//
//  JackpotButton.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "JackpotButton.h"

@implementation JackpotButton{
    UILabel *titleL;
    UIImageView *lightImgV;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 60, 15)];
        titleL.font = [UIFont boldSystemFontOfSize:10];
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = normalColors;
        [self addSubview:titleL];
        lightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        lightImgV.image = [UIImage imageNamed:@"Jackpot_light"];
        lightImgV.center = CGPointMake(0, 0 );
        [self addSubview:lightImgV];
    }
    return self;
}
- (void)showLightAnimationWithLevel:(NSString *)level{
    titleL.text = [NSString stringWithFormat:@"Lv.%@",level];
    //创建动画对象
    CABasicAnimation *basicAni = [CABasicAnimation animation];
    
    //设置动画属性
    basicAni.keyPath = @"position";
    
    //设置动画的起始位置。也就是动画从哪里到哪里
    basicAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    
    //动画结束后，layer所在的位置
    basicAni.toValue = [NSValue valueWithCGPoint:CGPointMake(60, 30)];
    
    
    //动画持续时间
    basicAni.duration = 0.5;
    
    basicAni.repeatCount = 2;
    //动画填充模式
    basicAni.fillMode = kCAFillModeForwards;
    
    //动画完成不删除
    basicAni.removedOnCompletion = NO;
    [lightImgV.layer addAnimation:basicAni forKey:nil];
    
    
    //放大效果，并回到原位
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.4;       //执行时间
    animation.repeatCount = 2;      //执行次数
    animation.autoreverses = NO;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:1];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.3];     //结束伸缩倍数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [titleL.layer addAnimation:animation forKey:nil];

    });
}

@end
