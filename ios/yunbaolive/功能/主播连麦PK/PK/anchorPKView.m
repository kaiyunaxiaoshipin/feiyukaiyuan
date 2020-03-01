//
//  anchorPKView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "anchorPKView.h"
#import "pkProgressView.h"
@implementation anchorPKView{
    pkProgressView *proView;
    UIImageView *actionImage;
    NSTimer *timer;
    int timeCount;
    UILabel *timeL;
    UIImageView *resultImage;

}

- (instancetype)initWithFrame:(CGRect)frame andTime:(NSString *)time{
    self = [super initWithFrame:frame];
    timeCount = [time intValue];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    actionImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height/2-10-_window_width*8/75, _window_width, _window_width*16/75)];
    actionImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:actionImage];

    resultImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height/2-10-_window_width*8/75, 56, 33)];
    resultImage.contentMode = UIViewContentModeScaleAspectFit;
    resultImage.hidden = YES;
    resultImage.center = actionImage.center;
    [self addSubview:resultImage];

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i<20; i++) {
        NSString *imageName=[NSString stringWithFormat:@"pk%d.png",i];
        NSString *path = [[NSBundle mainBundle]pathForResource:imageName ofType:nil];
        UIImage *image=[UIImage imageWithContentsOfFile:path];
        [array addObject:image];
    }
    actionImage.animationImages=array;
    //一次动画的时间
    actionImage.animationDuration=[array count]*0.08;
    //只执行一次动画
    actionImage.animationRepeatCount = 1;
    //开始动画
    [actionImage startAnimating];
    //释放内存
    [actionImage performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:[array count]*0.08];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.52 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        actionImage.image = [UIImage imageNamed:@"pk19"];
    });
    proView = [[pkProgressView alloc]initWithFrame:CGRectMake(0, self.height-20, _window_width, 20)];
    [self addSubview:proView];
    timeL = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-40, self.height-25-18, 80, 18)];
    timeL.font = [UIFont systemFontOfSize:10];
    timeL.text = [NSString stringWithFormat:@"PK%@ %@",YZMsg(@"时间"),[self seconds:timeCount]];
    timeL.textAlignment = NSTextAlignmentCenter;
    timeL.layer.cornerRadius = 9;
    timeL.layer.masksToBounds = YES;
    timeL.layer.borderWidth = 0.5;
    timeL.layer.borderColor = RGB_COLOR(@"#323232", 0.5).CGColor;
    timeL.backgroundColor = RGB_COLOR(@"#000000", 0.3);
    timeL.textColor = normalColors;
    [self addSubview:timeL];
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimeL) userInfo:nil repeats:YES];
    }
}
- (void)changeTimeL{
    timeCount --;
    timeL.text = [NSString stringWithFormat:@"PK%@ %@",YZMsg(@"时间"),[self seconds:timeCount]];
    if (timeCount <= 0) {
        timeL.text = [NSString stringWithFormat:@"PK%@ 00:00",YZMsg(@"时间")];
        [timer invalidate];
        timer = nil;
    }

}
- (void)changeChengfaTimeL{
    timeCount --;
    timeL.text = [NSString stringWithFormat:@"%@ %@",YZMsg(@"惩罚时间"),[self seconds:timeCount]];
    if (timeCount <= 0) {
        timeL.text = [NSString stringWithFormat:@"%@ 00:00",YZMsg(@"惩罚时间")];
        [timer invalidate];
        timer = nil;
        [self.delegate removePKView];
    }

}

- (void)showPkResult:(NSDictionary *)dic andWin:(int)win{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    if (win == 0) {
        resultImage.image = [UIImage imageNamed:@"平局icon"];
        resultImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.2 animations:^{
            actionImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            actionImage.hidden = YES;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            resultImage.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                resultImage.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                actionImage.hidden = YES;
            }];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                resultImage.frame = CGRectMake(_window_width/2-28, self.height-20-33, 56, 33);
            } completion:^(BOOL finished) {
                [self.delegate removePKView];
            }];
        });

    }else{
        timeCount = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeChengfaTimeL) userInfo:nil repeats:YES];
        timeL.text = [NSString stringWithFormat:@"%@ %@",YZMsg(@"惩罚时间"),[self seconds:timeCount]];
        resultImage.image = [UIImage imageNamed:@"胜利icon"];
        resultImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
        
        [UIView animateWithDuration:0.2 animations:^{
            actionImage.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            actionImage.hidden = YES;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            resultImage.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                resultImage.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                actionImage.hidden = YES;
            }];
            
        });
        if (win == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    resultImage.frame = CGRectMake(_window_width/4-28, self.height-20-33, 56, 33);
                } completion:^(BOOL finished) {
                    
                }];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    resultImage.frame = CGRectMake(_window_width*3/4-28, self.height-20-33, 56, 33);
                } completion:^(BOOL finished) {
                }];
            });
        }
    }

}

- (void)setAnimationImages:(id)sender{
    NSLog(@"==========================");
}
- (void)updateProgress:(CGFloat)progress withBlueNum:(NSString *)blueNum withRedNum:(NSString *)redNum{
    [proView updateProgress:progress withBlueNum:blueNum withRedNum:redNum];
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}
- (NSString *)seconds:(int)s{
    NSString *str;
    str = [NSString stringWithFormat:@"%02d:%02d",s/60,s%60];
    return str;
}

@end
