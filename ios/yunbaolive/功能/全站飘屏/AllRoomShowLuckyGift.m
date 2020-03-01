//
//  AllRoomShowLuckyGift.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "AllRoomShowLuckyGift.h"

@implementation AllRoomShowLuckyGift{
    UIImageView *planImgV;
    UIView *backView;
    UIView *yellowView;
    UILabel *contenL;
    int isMove;
    NSMutableArray *luckyArray;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        isMove = 0;
        luckyArray = [NSMutableArray array];
    }
    return self;
}
-(void)addLuckyGiftMove:(NSDictionary *)dic{
    if (dic == nil) {
        
        
        
    }
    else
    {
        [luckyArray addObject:dic];
    }
    if(isMove == 0){
        [self userLoginOne];
    }

}
-(void)userLoginOne{
    
    if (luckyArray.count == 0 || luckyArray == nil) {
        return;
    }
    NSDictionary *Dic = [luckyArray firstObject];
    [luckyArray removeObjectAtIndex:0];
    [self userPlar:Dic];
}
-(void)userPlar:(NSDictionary *)dic{
    isMove = 1;
    backView = [[UIView alloc]initWithFrame:CGRectMake(self.width, 2.5, self.width+5, 20)];
    backView.clipsToBounds = YES;
    [self addSubview:backView];
    yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width-10, 20)];
    yellowView.backgroundColor = RGB_COLOR(@"#ff8400", 1);
    yellowView.layer.cornerRadius = 10;
    yellowView.layer.masksToBounds = YES;
    yellowView.clipsToBounds = YES;
    [backView addSubview:yellowView];
    NSString *content = [NSString stringWithFormat:@"恭喜 %@ 获得%@x%@倍",minstr([dic valueForKey:@"uname"]),minstr([dic valueForKey:@"giftname"]),minstr([dic valueForKey:@"lucktimes"])];
    CGFloat widthhh = [[YBToolClass sharedInstance] widthOfString:content andFont:[UIFont systemFontOfSize:12] andHeight:20];
    contenL = [[UILabel alloc]initWithFrame:CGRectMake(yellowView.width, 0, widthhh, 20)];
    contenL.font = [UIFont systemFontOfSize:12];
    contenL.text = content;
    contenL.textColor = [UIColor whiteColor];
    [yellowView addSubview:contenL];
    planImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.width-10, 0, 25, 25)];
    planImgV.image = [UIImage imageNamed:@"gift_飞机"];
    [self addSubview:planImgV];
    //创建动画对象
    CABasicAnimation *basicAni = [CABasicAnimation animation];
    
    //设置动画属性
    basicAni.keyPath = @"position";
    
    //设置动画的起始位置。也就是动画从哪里到哪里
    basicAni.fromValue = [NSValue valueWithCGPoint:CGPointMake(widthhh, 10)];
    
    //动画结束后，layer所在的位置
    basicAni.toValue = [NSValue valueWithCGPoint:CGPointMake(-widthhh, 10)];
    
    
    //动画持续时间
    basicAni.duration = 3;
    
    basicAni.repeatCount = 2;
    //动画填充模式
    basicAni.fillMode = kCAFillModeForwards;
    
    //动画完成不删除
    basicAni.removedOnCompletion = NO;
    
    //xcode8.0之后需要遵守代理协议
//    basicAni.delegate = self;
    
    //把动画添加到要作用的Layer上面
//    [self.redLayer addAnimation:basicAni forKey:nil];

    [UIView animateWithDuration:1 animations:^{
        planImgV.x = -10;
        backView.x = 0;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            planImgV.x = -20;
            planImgV.alpha = 0;
        }];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [contenL.layer addAnimation:basicAni forKey:nil];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            yellowView.x = -self.width;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
            backView = nil;
            [planImgV removeFromSuperview];
            planImgV = nil;
            isMove = 0;
            if (luckyArray.count >0) {
                [self addLuckyGiftMove:nil];
            }

        }];
    });
}

@end
