//
//  anchorPKAlert.m
//  yunbaolive
//
//  Created by Boom on 2018/11/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "anchorPKAlert.h"
#import "XLCircleProgress.h"

@implementation anchorPKAlert{
    BOOL isStart;
    XLCircleProgress *circle;
    UIView *whiteView;
    int count;
    NSTimer *timer;
}

- (instancetype)initWithFrame:(CGRect)frame andIsStart:(BOOL)start{
    self = [super initWithFrame:frame];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    isStart = start;
    count = 10;
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    if (isStart) {
        self.backgroundColor = [UIColor clearColor];
        circle = [[XLCircleProgress alloc]initWithFrame:CGRectMake(self.width/2-35, 0, 70, 70)];
        circle.percentLabel.text = @"10";
        circle.percentLabel.textColor = [UIColor whiteColor];
        circle.progress = 1;
        [self addSubview:circle];
    }else{
        self.backgroundColor = [UIColor whiteColor];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height/34*9)];
        label.text = YZMsg(@"对方发起PK");
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
        
        circle = [[XLCircleProgress alloc]initWithFrame:CGRectMake(self.width/2-self.height/34*7, label.bottom, self.height/34*14, self.height/34*14)];
        circle.percentLabel.text = @"10";
        circle.progress = 1;
        [self addSubview:circle];
        NSArray *arr = @[YZMsg(@"拒绝"),YZMsg(@"接受")];
        for (int i = 0; i < arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(i*self.width/2, self.height/34*26, self.width/2, self.height/34*8);
            btn.tag = 1000+i;
            [btn setTitle:arr[i] forState:0];
            if (i == 0) {
                [btn setBackgroundColor:RGB_COLOR(@"#2889f7", 1)];
            }else{
                [btn setBackgroundColor:RGB_COLOR(@"#f93232", 1)];
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }

    }
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];

    }
}
- (void)daojishi{
    count -- ;
    circle.progress = count/10.00;

    if (count > 0) {
        circle.percentLabel.text = [NSString stringWithFormat:@"%d",count];
    }else{
        [timer invalidate];
        timer = nil;
        [self.delegate removeShouhuView];
    }
}
- (void)btnClick:(UIButton *)sender{
    
    [timer invalidate];
    timer = nil;
    if (sender.tag == 1000) {
        [self.delegate notAgreeClick];
    }else{
        [self.delegate agreePKClick];
    }
//    [self.delegate removeShouhuView];
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}
- (void)removeTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
