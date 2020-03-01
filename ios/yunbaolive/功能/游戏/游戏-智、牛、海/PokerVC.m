//
//  PokerVC.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "PokerVC.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Additions.h"
#import "UIImage+Additions.h"
@interface PokerVC ()
{
    AVAudioPlayer *gameVoicePlayer;
    BOOL isHosts;//判断是不是主播
    NSMutableArray *imageNameArraysss;//保存开牌
    NSMutableArray *arrays;
    NSTimer *lasttimer;
    NSTimer *resulttimer;
    NSTimer *resulttimer1;
    NSTimer *resulttimer2;
    NSTimer *resulttimer3;
}
@end
@implementation PokerVC
-(instancetype)initWithFrame:(CGRect)frame continue:(BOOL)isContinue andIsHost:(BOOL)isHost andBackimage:(NSString *)imagename andPokernums:(int)pokernums andIshaidao:(BOOL)ishaidao andISSANZHANF:(BOOL)issanzhang{
    self = [super initWithFrame:frame];
    if (self) {
        _isshangzhuang = issanzhang;//判断是不是上庄玩法
        _isHaidao = ishaidao;
        //总的扑克牌的张数
        _pokernums = pokernums;
        isHosts = isHost;
        //翻牌
        _ct = [NSArray array];
         arrays = [NSMutableArray array];
        imageNameArraysss = [NSMutableArray array];
        _isThirdTimesOK1 = 0;
        _isThirdTimesOK2 = 0;
        _resultArray = [NSMutableArray array];
        //发牌动画
        if (_pokernums == 9) {
           _isThirdTimes = 2;//判断一副牌发够3次
            _groups = 3;
            _pokerGroups = _pokernums/3;

        }
        else if (_pokernums == 15){
             _isThirdTimes = 4;
            _groups = 3;
            _pokerGroups = _pokernums/3;
        }
        else if (_pokernums == 10){
            _isThirdTimes =4;
            _groups = 2;
            _pokerGroups = _pokernums/2;
        }
        //初始化三副牌的x
        CGFloat xsss = -(_window_width - 80)/3;
        //扑克牌的背景
        for (int i=0; i<_groups; i++) {
            UIImageView *imagevs = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"出生日期背景副本.png"]];
            if (_isHaidao) {
                if (i==0) {
                    imagevs.frame = CGRectMake(-_window_width/2  + _window_width/6 +_window_width*0.05,-70,_window_width*0.35,80);
                }
                else{
                    imagevs.frame = CGRectMake(_window_width/2 + _window_width/6 - _window_width*0.35-_window_width*0.05,-70, _window_width*0.35,80);
                }
            }
            else
            {
            imagevs.frame = CGRectMake(xsss,-70, (_window_width - 80)/3,80);
            xsss += (_window_width - 80)/3 + 15;
            }
            [self addSubview:imagevs];
            imagevs.tag = 900 + i;
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.6;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1,1.1,1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9,0.9,1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)]];
            animation.values = values;
            [imagevs.layer addAnimation:animation forKey:nil];
        }
        
        //创建发牌手
        for (int i = 0; i < _pokernums; i++) {
            UIImageView *imageBottomVc = [[UIImageView alloc]init];
            [imageBottomVc setImage:[UIImage imageNamed:imagename]];
            imageBottomVc.contentMode = UIViewContentModeScaleAspectFit;
            UIView *bottomVCs;
            if (i<_pokerGroups) {
                bottomVCs = [self viewWithTag:900];
            }
            else if (i>=_pokerGroups && i<_pokerGroups*2)
            {
                bottomVCs = [self viewWithTag:901];
            }
            else{
                bottomVCs = [self viewWithTag:902];
            }
            CGFloat shipeiX;
       
            if (IS_IPHONE_6P)
            {
                shipeiX = -25;
            }
            else if (IS_IPHONE_6){
                shipeiX = -20;
            }
            else{
                shipeiX = -15;
            }
                imageBottomVc.frame = CGRectMake(shipeiX,2,bottomVCs.width-10,bottomVCs.height-20);
                imageBottomVc.tag = 1000 + i;
                [bottomVCs addSubview:imageBottomVc];
                imageBottomVc.hidden = YES;
            }
        
        static int i = -1;
        if(!isContinue){
        //开始发牌
            __weak PokerVC *weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself moveViewMove:i];
            
        });
        }
        else{
            [self moveViewMoveContinue:i];
        }
        [self wordStart];
        
    }
    return self;
}
//******************************************发牌***********************************************************//
//预告文字
-(void)wordStart{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startYaZhu" object:nil];
}
-(void)moveViewMove:(int)i{
    
    if (i  > _pokernums) {
        //开始游戏
            if ([self.delegate respondsToSelector:@selector(startGame)]) {
                [self.delegate startGame];
            }
        return;
    }
    i+=1;
    [self startMove:i];
}
-(void)changepokerframe{
    if (_pokernums == 9) {
        if (IS_IPHONE_6P) {
            _moveX = -30;
        }
        else if (IS_IPHONE_6){
            _moveX = -25;
        }
        else{
            _moveX = -20;
        }
    }
    else if (_pokernums == 15){
        if (IS_IPHONE_6P) {
            _moveX = -9;
        }
        else if (IS_IPHONE_6){
            _moveX = -5;
        }
        else{
            _moveX = -1;
        }
    }
    else if (_pokernums == 10){
        if (IS_IPHONE_6P) {
            _moveX = -3;
        }
        else if (IS_IPHONE_6){
            _moveX = -5;
        }
        else{
            _moveX = -1;
        }
    }
}
-(void)startMove:(int)i{
    
    _isThirdTimes +=1;
    if (_isThirdTimes ==_pokerGroups) {
            _isThirdTimes = 0;
        if (i>=_pokerGroups*2 && i<_pokerGroups*3) {
            [self changepokerframe];
        }
        else if (i >=_pokerGroups && i < _pokerGroups*2){
           [self changepokerframe];
        }
        else{
            [self changepokerframe];
        }
    }
    UIImageView *moveVC = [self viewWithTag:1000 + i];
    moveVC.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        moveVC.frame = CGRectMake(_moveX,2,(_window_width - 80)/_pokerGroups,60);
        if (_pokernums == 9) {
        if (IS_IPHONE_6P) {
           _moveX += 30;
        }
        else if (IS_IPHONE_6){
            _moveX += 25;
        }
        else{
            _moveX += 20;
         }
        }
        else if (_pokernums == 15){
            if (IS_IPHONE_6P) {
                _moveX += 15;
            }else if (IS_IPHONE_6){
                _moveX += 12;
            }else{
                _moveX += 8;
            }
        }
        else if (_pokernums == 10){
            if (IS_IPHONE_6P) {
                _moveX += 20;
            }else if (IS_IPHONE_6){
                _moveX += 20;
            }else{
                _moveX += 16;
            }
        }
    }];
    [self moveViewMove:i];
}
//*******************中途加入****************************//
-(void)moveViewMoveContinue:(int)i{
    if (i  > _pokernums) {
        //开始游戏
        if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(startGame)]) {
            [self.delegate startGame];
            if (gameVoicePlayer) {
                [gameVoicePlayer stop];
                 gameVoicePlayer = nil;
            }
        }
    }
        if (!isHosts) {
            if (gameVoicePlayer) {
                [gameVoicePlayer stop];
                gameVoicePlayer = nil;
            }
        }
        return;
    }
    i+=1;
    [self startMoveContinue:i];
}
-(void)startMoveContinue:(int)i{
    _isThirdTimes +=1;
    if (_isThirdTimes ==_pokerGroups) {
        _isThirdTimes = 0;
        if (i>=_pokerGroups*2 && i<_pokerGroups*3) {
             [self changepokerframe];
        }
        else if (i >=_pokerGroups && i < _pokerGroups*2){
            [self changepokerframe];
        }
        else{
          [self changepokerframe];
        }
    }
    UIImageView *moveVC = [self viewWithTag:1000 + i];
    moveVC.hidden = NO;
        moveVC.frame = CGRectMake(_moveX,2,(_window_width - 80)/_pokerGroups,60);
    if (_pokernums == 9) {
        if (IS_IPHONE_6P) {
            _moveX += 30;
        }
        else if (IS_IPHONE_6){
            _moveX += 25;
        }
        else{
            _moveX += 20;
        }
    }
    else if (_pokernums == 15){
        if (IS_IPHONE_6P) {
            _moveX += 15;
        }else if (IS_IPHONE_6){
            _moveX += 12;
        }else{
            _moveX += 8;
        }
    }
    else if (_pokernums == 10){
        if (IS_IPHONE_6P) {
            _moveX += 20;
        }else if (IS_IPHONE_6){
            _moveX += 20;
        }else{
            _moveX += 8;
        }
    }
    [self moveViewMoveContinue:i];
}
//******************************************翻牌***********************************************************//
//游戏结果动画
/* 花色	4表示黑桃 3表示红桃 2表示方片  1表示梅花 */
/* 牌面 格式 花色-数字 14代表1(PS：请叫它A (jian))*/
//ct中 0 未中奖。1 中奖
/*
 3-10,
 3-11,
 4-10,
 3,()
 对子,
 1000,
 2,
 2
 */
-(void)result:(NSArray *)array{
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    static int i = -1;
    _ct = array;
    int resultname;//结果文字显示
    int isSuccess = 0;//是否中奖
    if (_pokernums == 15 || _pokernums == 10) {
        //牛牛
        resultname = 6;
        isSuccess = 7;
    }
    else {
        //炸金花
        resultname = 4;
        isSuccess = 3;
    }
    [self moveViewAround:i];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    for (int i=0; i<_pokerGroups; i++) {
        UIImageView *moveVC = [self viewWithTag:1000 + i];
        [UIView beginAnimations:@"View Filp" context:nil];
        [UIView setAnimationDelay:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:moveVC cache:NO];
        [UIView commitAnimations];
        [moveVC setImage:[UIImage imageNamed:imageNameArraysss[i]]];
    }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *VC = [self viewWithTag:900];
            //判断如果是炸金花（上庄玩法，名字拼法不一样）
            NSString *imageName = [_ct[0] objectAtIndex:resultname];
            if (_isshangzhuang) {
                NSString *type1  = [_ct[0] objectAtIndex:isSuccess];
                imageName = [imageName stringByAppendingFormat:@"%@",type1];
                NSLog(@"1------%@",imageName);
            }
            UIImageView *imageVs = [[UIImageView alloc]initWithFrame:CGRectMake(0,15,VC.width,60)];
            imageVs.contentMode = UIViewContentModeScaleAspectFit;
            [imageVs setImage:[UIImage imageNamed:imageName]];
            imageVs.tag = 3000 + i;
            [VC addSubview:imageVs];
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (int i=_pokerGroups; i<_pokerGroups*2; i++) {
                UIImageView *moveVC = [self viewWithTag:1000 + i];
                [UIView beginAnimations:@"View Filp" context:nil];
                [UIView setAnimationDelay:0.25];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:moveVC cache:NO];
                [UIView commitAnimations];
                [moveVC setImage:[UIImage imageNamed:imageNameArraysss[i]]];
            }
            //显示结果文字
            UIView *VC = [self viewWithTag:901];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *imageName = [_ct[1] objectAtIndex:resultname];
                if (_isshangzhuang) {
                    NSString *type2  = [_ct[1] objectAtIndex:isSuccess];
                    imageName = [imageName stringByAppendingFormat:@"%@",type2];
                    NSLog(@"2------%@",imageName);
                }
                UIImageView *imageVs = [[UIImageView alloc]initWithFrame:CGRectMake(0,15,VC.width,60)];
                imageVs.contentMode = UIViewContentModeScaleAspectFit;
                [imageVs setImage:[UIImage imageNamed:imageName]];
                imageVs.tag = 3000 + i;
                [VC addSubview:imageVs];
            });
        });
    if (!_isHaidao) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=_pokerGroups*2; i<_pokerGroups*3; i++) {
            UIImageView *moveVC = [self viewWithTag:1000 + i];
            [UIView beginAnimations:@"View Filp" context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:moveVC cache:NO];
            [UIView commitAnimations];
            [moveVC setImage:[UIImage imageNamed:imageNameArraysss[i]]];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *VC = [self viewWithTag:902];
            NSString *imageName = [_ct[2] objectAtIndex:resultname];
            if (_isshangzhuang) {
                NSString *type3  = [_ct[2] objectAtIndex:isSuccess];
                imageName = [imageName stringByAppendingFormat:@"%@",type3];
                NSLog(@"3------%@",imageName);
            }
            UIImageView *imageVs = [[UIImageView alloc]initWithFrame:CGRectMake(0,15,VC.width,60)];
            imageVs.contentMode = UIViewContentModeScaleAspectFit;
            [imageVs setImage:[UIImage imageNamed:imageName]];
            imageVs.tag = 3000 + i;
            [VC addSubview:imageVs];
        });
     });
    }
    
    
    //添加结果文字显示
    CGFloat x = -_window_width/3 + 20;
    for (int i = 0; i<3; i++) {
            x+=_window_width/3;
        if (_isHaidao) {
            if (i==1 || i==0) {
                 [_resultArray addObject:[_ct[i] objectAtIndex:isSuccess]];
            }
            if (i==2) {
                
                
            }
        }
        else{
            [_resultArray addObject:[_ct[i] objectAtIndex:isSuccess]];
        }
        }
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
    resulttimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(showovervc) userInfo:nil repeats:NO];
    lasttimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(lastrequs) userInfo:nil repeats:NO];
}
-(void)showovervc{
    
    UIImageView *overVC;
    overVC = [[UIImageView alloc] init];
    overVC.contentMode = UIViewContentModeScaleAspectFit;
    
    for (int i=0; i<_resultArray.count; i++) {
        NSString *string = [NSString stringWithFormat:@"%@",[_resultArray objectAtIndex:i]];
        if ([string isEqual:@"1"]) {
            if (i==0) {
                [overVC setImage:[UIImage imageNamed:@"左11111(2)"]];
            }else if (i==1){
                [overVC setImage:[UIImage imageNamed:@"中22222222"]];
            }else{
                [overVC setImage:[UIImage imageNamed:@"右2222222"]];
            }
        }
        [self addSubview:overVC];
        

        
        if (overVC) {
            
            [overVC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.superview);
                make.right.equalTo(self.superview);
                make.height.mas_equalTo(280);
                make.top.mas_equalTo(self.top).offset(-140);
            }];
        }
        
        if (_isshangzhuang) {
            overVC.hidden = YES;
        }
        else{
            overVC.hidden = NO;
        }
    }
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    if (!isHosts) {
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"guesssuccesssound.mp3" withExtension:Nil];
        gameVoicePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        [gameVoicePlayer prepareToPlay];
        gameVoicePlayer.volume = 1.0;
        [gameVoicePlayer play];
    }

}
-(void)lastrequs{
    [self.delegate gameOver];
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
}
-(void)moveViewAround:(int)i{
    
    if (_isHaidao) {
        if (_ct.count == 2) {
            
        }else{
        NSArray *array1 = _ct[0];
        NSArray *array2 = _ct[2];
        [arrays addObject:array1];
        [arrays addObject:array2];
        _ct = arrays;
        }
    }
    if (i  > _pokernums - 2) {
        return;
    }
    NSArray *imageNameArray;
    NSString *imageName;
    if (_isThirdTimesOK1 ==_pokerGroups) {
        _isThirdTimesOK1 = 0;
        _isThirdTimesOK2 += 1;
    }
    i+=1;
    
    imageNameArray = _ct[_isThirdTimesOK2];
    imageName = imageNameArray[_isThirdTimesOK1];
    _isThirdTimesOK1 +=1;
    [imageNameArraysss addObject:imageName];
    [self startMoveAround:i and:(NSString *)imageName];
   
}
-(void)startMoveAround:(int)i and:(NSString *)imageName{
    [self moveViewAround:i];
}
-(void)reallocAll{
        [resulttimer invalidate];
        resulttimer = nil;
    
    [lasttimer invalidate];
    lasttimer = nil;
    [gameVoicePlayer stop];
    gameVoicePlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"overResult" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startYaZhu" object:nil];
}
-(void)dealloc{
    [gameVoicePlayer stop];
    gameVoicePlayer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"overResult" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startYaZhu" object:nil];
}
-(void)releaseMusic{
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
}
@end
