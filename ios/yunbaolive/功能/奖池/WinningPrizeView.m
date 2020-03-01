//
//  WinningPrizeView.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "WinningPrizeView.h"

@implementation WinningPrizeView{
    UIImageView *redImgV;
    UIImageView *backImgV;
    UIImageView *starImgV;
    
}

- (instancetype)initWithFrame:(CGRect)frame andMsg:(NSDictionary *)dic{
    if (self = [super initWithFrame:frame]) {
        [self creatUI:dic];
    }
    return self;
}
- (void)creatUI:(NSDictionary *)dic{
    starImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _window_width*0.4, _window_width*0.4*1.22)];
    starImgV.image = [UIImage imageNamed:@"prize_流星"];
    starImgV.hidden = YES;
    [self addSubview:starImgV];
    
    backImgV = [[UIImageView alloc] initWithFrame:CGRectMake(_window_width*0.1, 0, _window_width*0.8, _window_width*0.8)];
    backImgV.image = [UIImage imageNamed:@"prize_背景"];
    backImgV.hidden = YES;
    [self addSubview:backImgV];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999;
    [backImgV.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

    
    redImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _window_width*0.57, _window_width*0.57)];
    redImgV.image = [UIImage imageNamed:@"prize_中奖"];
    redImgV.center = backImgV.center;
    [self addSubview:redImgV];
    
    UIImageView *headerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(redImgV.width*0.45, redImgV.height*0.2, redImgV.height*0.1, redImgV.height*0.1)];
    headerImgV.contentMode = UIViewContentModeScaleAspectFill;
    headerImgV.clipsToBounds = YES;
    [headerImgV sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"uhead"])]];
    headerImgV.layer.cornerRadius = redImgV.height*0.05;
    headerImgV.layer.masksToBounds = YES;
    [redImgV addSubview:headerImgV];

    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImgV.bottom, redImgV.width, headerImgV.height)];
    nameL.textColor = [UIColor whiteColor];
    nameL.font = [UIFont systemFontOfSize:12];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.text = minstr([dic valueForKey:@"uname"]);
    [redImgV addSubview:nameL];
    
    UILabel *coinL = [[UILabel alloc]initWithFrame:CGRectMake(0, redImgV.height*0.7, redImgV.width, redImgV.height*0.125)];
    coinL.textColor = normalColors;
    coinL.font = [UIFont systemFontOfSize:17];
    coinL.textAlignment = NSTextAlignmentCenter;
    coinL.text = minstr([dic valueForKey:@"wincoin"]);
    [redImgV addSubview:coinL];
    redImgV.transform = CGAffineTransformMakeScale(0.1, 0.1);

    [UIView animateWithDuration:0.5 animations:^{
        redImgV.transform = CGAffineTransformMakeScale(1, 1);
        
    } completion:^(BOOL finished) {
        backImgV.hidden = NO;
        starImgV.hidden = NO;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            starImgV.center = CGPointMake(self.width-(starImgV.width/2), backImgV.height-(starImgV.height/2));
        } completion:^(BOOL finished) {
            starImgV.hidden = YES;
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self removeFromSuperview];
    });
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
