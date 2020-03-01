//
//  WPFRotateView.m
//  01-幸运转盘第二遍
//
//  Created by 王鹏飞 on 16/1/13.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//
#import "WPFRotateView.h"
#import "WPFButton.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "rotationBtn.h"
#import "animationBtnV.h"
#import "resultAction.h"
#import "zhuangcell.h"
// 整个转盘的按钮个数
#define kCount 20
// 每个按钮所对应角度
#define kAngle (M_PI * 2 / 20)
@interface WPFRotateView ()<CAAnimationDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton         *_selBtn;   // 当前被选择的星座按钮
    CADisplayLink    *_link;     // 定时器
    NSTimer *dengTime;
    //  SystemSoundID soundFileObject;
    AVAudioPlayer *touchVoice;
    AVAudioPlayer *gameVoicePlayer;
    
    int cutDownNums;//倒计时
    NSTimer * cutDownTimer;
    UIButton *downBTN;//倒计时
    BOOL _ishost;
    UIView *bottomV;//用户按钮背景
    UIButton *imageVS;
    resultAction *resultaction;//开奖动画
    UIButton *cancleBtn;//关闭游戏
    NSTimer *starttimers;
    NSTimer *resulttimers;
    
    
    NSTimer *ksishiTimer;//开始倒数计时
    UILabel *startwords;//倒数计时
    int waittimes;
    UIImageView *tableviewbackimage;
        
}
@property(nonatomic,strong)NSArray *personname;//人物名称
@property(nonatomic,strong)UIView *MaskV;//遮罩
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIImageView *jiantou;
@property(nonatomic,strong)UIButton *jumpRecharge;
@property(nonatomic,strong)UILabel *chongzhi;
@property(nonatomic,strong)UIImageView *coinImg;
@property(nonatomic,copy)NSString *type;//押注类型
@property(nonatomic,copy)NSString *money;//押注金额
@property(nonatomic,strong)NSString *gameid;
@property (weak, nonatomic) IBOutlet UIImageView *rotateWheel;
@end
// 图片框默认不与用户交互
// view 默认只支持单点触控，点开mutableTouch 则支持多点触控
@implementation WPFRotateView
//如果有送礼物刷新钻石
-(void)reloadcoins{
    LiveUser *user = [Config myProfile];
    [self chongzhiV:user.coin];
}
-(void)cancle{
    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    cancleBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cancleBtn.userInteractionEnabled = YES;
    });
    [self.delegate stopRotationgameBySelf];
    [self stopRotatipnGameInt];
    [gameState saveProfile:@"0"];//保存游戏开始状态
    NSString *url = [NSString stringWithFormat:@"Game.Dial_end&stream=%@&liveuid=%@&token=%@&type=%@&gameid=%@&ifset=%@",[NSString stringWithFormat:@"%@",_stream],[Config getOwnID],[Config getOwnToken],@"2",_gameid,@"1"];
    NSLog(@"%@",url);
    
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
    
}
//用户投注***********************************************************
-(void)stopRotatipnGameInt{
    [self removeall];
    if (cancleBtn) {
        if (gameVoicePlayer) {
            [gameVoicePlayer stop];
            gameVoicePlayer = nil;
        }
    }
}
-(void)CreateActionVC{
    _items = [NSArray array];
    if (_ishost) {
        return;
    }
    bottomV = [[UIView alloc]initWithFrame:CGRectMake(0,_window_width/1.5 - 45,_window_width,30)];
    bottomV.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomV];
    
    //创建4个押注按钮
    NSArray *array = @[@"10",@"100",@"1000",@"10000"];
    _money = [array firstObject];//初始化押注金额
    //充值lable
    _chongzhi = [[UILabel alloc] init];
    LiveUser *user = [Config myProfile];
    _chongzhi.textColor = [UIColor redColor];
    _chongzhi.font = [UIFont systemFontOfSize:14];
    int chongzhi_y = bottomV.frame.size.height/2-7;
    _chongzhi.text = user.coin;
    [bottomV addSubview:_chongzhi];
    //充值上透明按钮
    _jumpRecharge = [[UIButton alloc] initWithFrame:CGRectMake(5,chongzhi_y,250,40)];
    _jumpRecharge.titleLabel.text = @"";
    [_jumpRecharge setBackgroundColor:[UIColor clearColor]];
    [_jumpRecharge addTarget:self action:@selector(jumpRechargess) forControlEvents:UIControlEventTouchUpInside];
    [bottomV addSubview:_jumpRecharge];
    //充值图标
    _coinImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人中心(钻石)"]];
    [bottomV addSubview:_coinImg];
    //箭头
    _jiantou = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_yingpiao_check"]];
    [bottomV addSubview:_jiantou];
    [self chongzhiV:user.coin];
    
    CGFloat www;
    if (IS_IPHONE_5) {
        www = 30;
    }
    else{
        www = 40;
    }
    CGFloat x = _window_width - www - 5;
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animationvc = [[animationBtnV alloc]initWithFrame:CGRectMake(x,0,www,www)];
        animationvc.userInteractionEnabled = YES;
        //       [animationvc.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stakestake%@",array[i]]]];
        [animationvc.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stake%d%d",i+1,i+1]]];
        if (i == 0) {
            [animationvc.bottomImage setImage:[UIImage imageNamed:@"stake1"]];
            [animationvc setAnimation];
        }
        [animationvc.frontButton setTitle:array[i] forState:UIControlStateNormal];
        [animationvc.frontButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        //button.frame = CGRectMake(x,0,40,40);
        animationvc.tag = 4000 + i;
        [animationvc.frontButton addTarget:self action:@selector(stake:) forControlEvents:UIControlEventTouchDown];
        x-= www + 5;
        [bottomV addSubview:animationvc];
        animationvc.backgroundColor = [UIColor clearColor];
    }
}
-(void)chongzhiV:(NSString *)coins{
    if (_chongzhi) {
        _chongzhi.text = [NSString stringWithFormat:@"%@ : %@",YZMsg(@"充值"),coins];
        _chongzhi.font = [UIFont systemFontOfSize:14];
        int chongzhi_y = bottomV.frame.size.height/2-7;
        CGSize size = [_chongzhi.text boundingRectWithSize:CGSizeMake(_window_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_chongzhi.font} context:nil].size;
        _chongzhi.frame = CGRectMake(10, chongzhi_y, size.width, size.height);
        _coinImg.frame = CGRectMake(size.width + 14, chongzhi_y, 14, 14);
        int jiantou_x = _coinImg.frame.origin.x + _coinImg.frame.size.width+4;
        _jiantou.frame = CGRectMake(jiantou_x, chongzhi_y, 14, 14);
        _jumpRecharge.frame = CGRectMake(10, chongzhi_y, _chongzhi.frame.size.width + _coinImg.frame.size.width + _jiantou.frame.size.width + 10, 20);
    }
}
-(void)jumpRechargess{
    [self.delegate pushCoinV];
}
//押注 //选择类型
-(void)stake:(UIButton *)sender{
    NSString *stakeS = sender.titleLabel.text;
    _money = stakeS;
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animation = [self viewWithTag:4000 + i];
        [animation.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stake%d%d",i+1,i+1]]];
        [animation stopAnimation];
        if ([animation.frontButton.titleLabel.text isEqual:stakeS]) {
            [animation.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stake%d",i+1]]];
            [animation setAnimation];
        }
    }
}
-(void)isHost:(BOOL)isHost andHostDic:(NSString *)hoststream{
    waittimes = gameWait;
    if (isHost) {
        _actionbtn.hidden = NO;
        cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setBackgroundColor:normalColors];
        [cancleBtn setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
        cancleBtn.frame = CGRectMake(_window_width - 70,7,60,30);

        [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        
        
    }
    else{
        [self playmusic];
    }
    _ishost = isHost;
    _stream = hoststream;
    [self CreateActionVC];
    [self jijiangkaishi];
}
-(void)jumpwords{
    waittimes-=1;
    startwords.text = [NSString stringWithFormat:@"%d",waittimes];
    CAKeyframeAnimation *cakanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    cakanimation.duration = 0.7;
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(4,4,1.0)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,1.4,1.0)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    cakanimation.values = @[value1,value2,value3,value4];
    [startwords.layer addAnimation:cakanimation forKey:nil];
    cakanimation.removedOnCompletion = NO;
    cakanimation.fillMode = kCAFillModeForwards;
    if (waittimes == 0) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        [startwords removeFromSuperview];
        startwords = nil;
        waittimes = gameWait;
    }
}
//更新押注
-(void)getRotationCoinType:(NSString *)type andMoney:(NSString *)money{
    rotationBtn *btns = [self viewWithTag:2000+[type intValue] - 1];
    float all = [btns.smallLabels.text floatValue];
    float single = [money floatValue];
    all +=single;
    btns.smallLabels.text = [NSString stringWithFormat:@"%d",(int)all];
    if (all >= 10000) {
        all = all/10000;
        btns.badgeValue = [NSString stringWithFormat:@"%.1f万",all];
    }
    else{
        btns.badgeValue = [NSString stringWithFormat:@"%d",(int)all];
    }
}
//点击押注
-(void)stakePokers:(UIButton *)sender{
    
    if (cutDownNums  < 3) {
        return;
    }
    if (_ishost) {
        
        return;
    }
    if ([_money isEqual:@"0"]) {
        
        return;
    }
    NSInteger g = sender.tag - 2000 + 1;
    NSString *grade = [NSString stringWithFormat:@"%ld",g];
    NSDictionary *subdic = @{
                             @"stream":_stream,
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"gameid":_gameid,
                             @"coin":_money,
                             @"grade":grade
                             };
    [YBToolClass postNetworkWithUrl:@"Game.Dial_Bet" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [self playSoundEffect];
            NSDictionary *infos = [info firstObject];
            [self chongzhiV:[NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]]];
            LiveUser *user = [Config myProfile];
            user.coin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]];
            [Config updateProfile:user];
            [self.delegate skateRotaton:grade andMoney:_money];
            UILabel *labels  = [self viewWithTag:1500 + g - 1];
            rotationBtn *btns = [self viewWithTag:2000+[grade intValue] - 1];
            float all = [btns.mysmallLabels.text floatValue];
            float single = [_money floatValue];
            all +=single;
            btns.mysmallLabels.text = [NSString stringWithFormat:@"%d",(int)all];
            if (all >= 10000) {
                all = all/10000;
                labels.text = [NSString stringWithFormat:@"%.1f万",all];
            }
            else{
                labels.text = [NSString stringWithFormat:@"%d",(int)all];
            }
            CGSize size = [labels.text boundingRectWithSize:CGSizeMake(_window_width/8, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            if (size.width<20) {
                size.width = 20;
            }
            labels.frame = CGRectMake(_window_width/6.5,-25,size.width, 20);
            labels.hidden = NO;

        }
    } fail:^{
        
    }];
}
//揭晓结果
-(void)getRotationResult:(NSArray *)array{
    [self kaishigetresult];
    if (downBTN) {
        downBTN.hidden = YES;
        [cutDownTimer invalidate];
        cutDownTimer = nil;
    }
   int aa = [array[0] intValue] - 1;
    
    if (aa ==  1 || aa ==2 || aa ==3 || aa == 0) {
        
        
    }
    else{
        aa = 0;
    }
    WPFButton *btn = [self viewWithTag:aa+3000];
    if (btn) {
        [self btnDidClick:btn];
    }
    [self rotation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    
        for (int i=0; i<4; i++) {
            rotationBtn *btn = [self viewWithTag:2000 +i];
            [btn setBadgeValue:@"0"];
            btn.smallLabels.text = @"";
            btn.mysmallLabels.text = @"";
            [btn removeBadge];
            UILabel *label = [self viewWithTag:1500 + i];
            label.hidden = YES;
        }
        if (resultaction) {
            [resultaction stop];
            [resultaction removeFromSuperview];
            resultaction = nil;
        }
        resultaction = [[resultAction alloc]init];
        resultaction.frame = CGRectMake(0,_window_height, _window_width, _window_width);
        NSString *path = [NSString stringWithFormat:@"card_%d",aa];
        [resultaction setimage:path];
        [resultaction startAction];
        [self addSubview:resultaction];
        if (!_ishost) {
            
            if (gameVoicePlayer) {
                [gameVoicePlayer stop];
                gameVoicePlayer = nil;
            }
            NSURL *url=[[NSBundle mainBundle]URLForResource:@"guesssuccesssound.mp3" withExtension:Nil];
            gameVoicePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
            [gameVoicePlayer prepareToPlay];
            gameVoicePlayer.volume = 1.0;
            [gameVoicePlayer play];
            
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            
            resultaction.frame = CGRectMake(0,-_window_height/2.5, _window_width, _window_width);
            
        }];
        
        if (resulttimers) {
            [resulttimers invalidate];
            resulttimers = nil;
        }
//        resulttimers = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(hetresultmessage) userInfo:nil repeats:NO];
        //rk_19-3-26 统一 8s
        [self performSelector:@selector(hetresultmessage) withObject:nil afterDelay:8.0];
        
        [self getResultINternet];
        
        if (starttimers) {
            [starttimers invalidate];
            starttimers = nil;
        }
//        starttimers = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(doRotation:) userInfo:nil repeats:NO];
        [self performSelector:@selector(doRotation:) withObject:nil afterDelay:17.0];
    });
}
-(void)hetresultmessage{
    if (resultaction) {
        [UIView animateWithDuration:0.5 animations:^{
            resultaction.frame = CGRectMake(0,_window_height, _window_width, _window_width);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [resultaction stop];
            [resultaction removeFromSuperview];
        });
        [self jijiangkaishi];
    }
}
-(void)getResultINternet{
    if (!_ishost) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSDictionary *subdic = @{
                                     @"uid":[Config getOwnID],
                                     @"gameid":_gameid
                                     };
            [YBToolClass postNetworkWithUrl:@"Game.settleGame" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
                if (code == 0) {
                    NSDictionary *infos = [info firstObject];
                    NSString *gamecoin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"gamecoin"]];
                    LiveUser *user = [Config myProfile];
                    user.coin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]];
                    [Config updateProfile:user];
                    [self chongzhiV:user.coin];
                    if ([gamecoin isEqual:@"0"]) {
                        //没中奖
                        
                        
                        
                    }else{
                        NSString *money = [NSString stringWithFormat:@"%@%@",gamecoin,[common name_coin]];
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"赢了哦") message:money delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                        [alert show];
                    }

                }
            } fail:^{
                
            }];
        });
    }
}
- (void)playSoundEffect{
    
    if (!touchVoice) {
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"buttonclickaaaaa.mp3" withExtension:Nil];
        touchVoice = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    }
    [touchVoice prepareToPlay];
    [touchVoice play];
}
// 让转盘开始旋转
- (void)startRotating {
    // 如果当前定时器为空，就重新实例化一个
    if (nil == _link) {
        // 实例化计时器
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(keepRatate)];
        // 添加到当前运行循环中
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    else {
        // 如果不为空，就关闭暂停
        _link.paused = NO;
        
    }
}
// 让转盘保持旋转
- (void)keepRatate {
    [_rotateWheel.layer removeAllAnimations];
    self.rotateWheel.transform = CGAffineTransformRotate(self.rotateWheel.transform, M_PI_4 * 0.01);
    
}
// 核心动画 执行完毕后调用这个方法
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CGFloat angle = kAngle * _selBtn.tag;
    // 这里是为了直接转到正上方
    self.rotateWheel.transform = CGAffineTransformMakeRotation(-angle);
    self.userInteractionEnabled = YES;
    [self stopRotatipnGameInt];
}
-(void)hostgetstart{
    [self jijiangkaishi];
    if (starttimers) {
        [starttimers invalidate];
        starttimers = nil;
    }
//    starttimers = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(doRotation:) userInfo:nil repeats:NO];
    [self performSelector:@selector(doRotation:) withObject:nil afterDelay:8.0];
}
- (IBAction)doRotation:(id)sender {
    
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (imageVS) {
        [imageVS removeFromSuperview];
        imageVS = nil;
    }
    if (resultaction) {
        [resultaction stop];
        [resultaction removeFromSuperview];
        resultaction = nil;
    }
    if (!_ishost) {
        return;
    }
    NSDictionary *subdic = @{
                             @"stream":_stream,
                             @"liveuid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    [YBToolClass postNetworkWithUrl:@"Game.Dial" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            [self.delegate startRotationGameSocketToken:[infos valueForKey:@"token"] andGameID:[infos valueForKey:@"gameid"] andTime:[infos valueForKey:@"time"]];
            _gameid = [infos valueForKey:@"gameid"];
            cutDownNums = [[infos valueForKey:@"time"] intValue];
            if (!cutDownTimer) {
                cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cutdown) userInfo:nil repeats:YES];
            }
            [gameState saveProfile:@"1"];
            
            [self startRotating];

        }
    } fail:^{
        
    }];
}
-(void)rotation{
    self.userInteractionEnabled = NO;
    _link.paused = YES;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.delegate = self;
    CGFloat angle = kAngle * _selBtn.tag;
    anim.toValue = @(M_PI * 2 * 7 -angle);
    anim.duration = 6.0;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion  = NO;
    [_rotateWheel.layer addAnimation:anim forKey:nil];
}
//倒计时
-(void)cutdown{
    [self createCutDownBTN];
    [downBTN setTitle:[NSString stringWithFormat:@"%d",cutDownNums] forState:UIControlStateNormal];
    if (cutDownNums == 0) {
        downBTN.hidden = YES;
        [cutDownTimer invalidate];
        cutDownTimer = nil;
    }
    else
    {
        downBTN.hidden = NO;
    }
    cutDownNums -=1;
}
-(void)createCutDownBTN{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (!downBTN) {
        downBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [downBTN setBackgroundImage:[UIImage imageNamed:@"ico_bgtime"] forState:UIControlStateNormal];
        downBTN.frame = CGRectMake(20,5,50,50);
        [downBTN setTitleColor:RGB(194, 104, 23) forState:UIControlStateNormal];
        [self addSubview:downBTN];
        downBTN.hidden = YES;
    }
}
-(void)movieplayStartCut:(NSString *)time andGameid:(NSString *)gameid{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    [self playmusic];
    if (resultaction) {
        [resultaction stop];
        [resultaction removeFromSuperview];
        resultaction = nil;
    }
    cutDownNums = [time intValue];
    _gameid = gameid;
    [self kaishiapai];
    [self startRotating];
    if (!cutDownTimer) {
        cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cutdown) userInfo:nil repeats:YES];
    }
}
// 加载xib文件
+ (instancetype)rotateView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WPFRotateView" owner:nil options:nil] lastObject];
}
// 添加按钮
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _ishost = NO;
    // 默认显示星座
    self.function = @"Astrology";
    NSString *path = [[NSBundle mainBundle]pathForResource:@"card" ofType:@"plist"];
    NSArray *arrays = [NSArray arrayWithContentsOfFile:path];
    for (NSInteger i = 0; i < arrays.count; i++) {
        WPFButton *btn = [WPFButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:arrays[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+ 3000;
        [self.rotateWheel addSubview:btn];
        btn.imageEdgeInsets = UIEdgeInsetsMake(35, 0, 20, 0);
    }
    if (!dengTime) {
        dengTime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dengdeng) userInfo:nil repeats:YES];
    }
}
-(void)dengdeng{
    [_deng setImage:[UIImage imageNamed:@"deng1.png"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_deng setImage:[UIImage imageNamed:@"deng2.png"]];
    });
}
-(void)dealloc{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    [dengTime invalidate];
    dengTime = nil;
    [_link invalidate];
    _link = nil;
    [gameVoicePlayer stop];
    gameVoicePlayer = nil;
    if (starttimers) {
        [starttimers invalidate];
        starttimers = nil;
    }
    if (resulttimers) {
        [resulttimers invalidate];
        resulttimers = nil;
    }
}
-(void)removeall{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hetresultmessage) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRotation:) object:nil];
    
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    [dengTime invalidate];
    dengTime = nil;
    [_link invalidate];
    _link = nil;
    [gameVoicePlayer stop];
    gameVoicePlayer = nil;
    if (starttimers) {
        [starttimers invalidate];
        starttimers = nil;
    }
    if (resulttimers) {
        [resulttimers invalidate];
        resulttimers = nil;
    }
}
- (void)btnDidClick:(UIButton *)sender {
    _selBtn.selected = NO;
    sender.selected = YES;
    _selBtn = sender;
}
// 根据图片名称和索引裁剪图片
- (UIImage *)clipsImgWithImgName:(NSString *)name index:(NSInteger)idx {
    // 获取图片
    UIImage *image = [UIImage imageNamed:name];
    // 设置frame
    CGFloat imgWidth = image.size.width / kCount;
    CGFloat imgHeight = image.size.height;
    CGFloat imgX = imgWidth * idx;
    // 设置缩放比例(Retina屏幕plus 放大三倍， 普通放大两倍， 非retina屏幕一倍)
    CGFloat scale = [UIScreen mainScreen].scale;
    imgWidth *= scale;
    imgHeight *= scale;
    imgX *= scale;
    CGImageRef clipImg = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(imgX, 0, imgWidth, imgHeight));
    return [UIImage imageWithCGImage:clipImg];
}
// 调整按钮位置
- (void)layoutSubviews {
    [super layoutSubviews];
    //设置frame
    CGFloat btnWidth = 68;
    CGFloat btnHeight = 143;
    [self.rotateWheel.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 设置frame
        obj.bounds = CGRectMake(0, 0, btnWidth, btnHeight);
        obj.center = self.rotateWheel.center;
        // 上移
        obj.layer.anchorPoint = CGPointMake(0.5, 1);
        // 旋转 分散
        // MakeRotation 相对于原始位置转动一定的角度
        obj.transform = CGAffineTransformMakeRotation(kAngle * idx);
    }];

}
-(void)setlayoutview{
    CGFloat x = 0;
    for (int i=0; i<4; i++) {
        rotationBtn *btn = [rotationBtn buttonWithType:UIButtonTypeCustom];
        btn.tag =2000 +i;
        btn.frame = CGRectMake(x,-10, _window_width/4,60);
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"card_%d",i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self action:@selector(stakePokers:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.textColor = [UIColor whiteColor];
        btn.titleLabel.backgroundColor = [UIColor greenColor];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0,btn.imageView.right, 0, 0);
        [_bgBtn addSubview:btn];
        [btn badgeInit];
        x+=_window_width/4;
        UILabel *label = [[UILabel alloc]init];
        label.hidden = YES;
        label.backgroundColor = [UIColor redColor];
        label.frame = CGRectMake(_window_width/4,-10,20,20);
        label.textAlignment = NSTextAlignmentLeft;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 10;
        label.textColor = [UIColor whiteColor];
        label.tag = 1500 + i;
        label.font = [UIFont systemFontOfSize:12];
        [btn addSubview:label];
    }
}
-(void)kaishiapai{
    if (imageVS) {
        [imageVS setTitle:YZMsg(@"开始支持") forState:UIControlStateNormal];
        imageVS.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.6f];
        imageVS.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            imageVS.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.5f];
            imageVS.transform=CGAffineTransformMakeScale(0.01f,0.01f);
            [UIView commitAnimations];
        });
    }
}
//揭晓结果文字
-(void)kaishigetresult{
    if (imageVS) {
        imageVS.hidden = NO;
        [imageVS setTitle:YZMsg(@"揭晓结果") forState:UIControlStateNormal];
        imageVS.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDuration:0.5f];
        imageVS.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView commitAnimations];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            imageVS.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDuration:0.5f];
            imageVS.transform=CGAffineTransformMakeScale(0.01f,0.01f);
            [UIView commitAnimations];
        });
    }
}
-(void)jijiangkaishi{
    [imageVS removeFromSuperview];
    imageVS = nil;
    if (!imageVS) {
        imageVS = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageVS setBackgroundImage:[UIImage imageNamed:@"dt"] forState:UIControlStateNormal];
        [imageVS setUserInteractionEnabled:NO];
        [imageVS setFrame:CGRectMake(20, _window_width/4, _window_width-40, 30)];
        [imageVS setTitle:@"即将开始" forState:UIControlStateNormal];
        [imageVS setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [self addSubview:imageVS];
    }
    [imageVS setTitle:@"即将开始" forState:UIControlStateNormal];
    imageVS.frame = CGRectMake(20, _window_width/4, _window_width-40, 30);
    imageVS.hidden = NO;
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (!startwords) {
        startwords = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 - 40, 90, 80, 80)];
        startwords.textColor = [UIColor whiteColor];
        startwords.font = fontMT(60);
        startwords.text = [NSString stringWithFormat:@"%d",waittimes];
        startwords.textAlignment = NSTextAlignmentCenter;
        [self addSubview:startwords];
    }
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
    }
    ksishiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpwords) userInfo:nil repeats:YES];
    [gameState saveProfile:@"0"];//保存游戏开始状态
}
-(void)playmusic{
    if (!_ishost) {
        if (gameVoicePlayer) {
            [gameVoicePlayer stop];
            gameVoicePlayer = nil;
        }
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"beginguesssound.mp3" withExtension:Nil];
        gameVoicePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        [gameVoicePlayer prepareToPlay];
        [gameVoicePlayer play];
    }
}
//中途加入
-(void)continueGame:(NSString *)time andgameId:(NSString *)gameid andMoney:(NSArray *)moneys andmycoin:(NSArray *)moneyss{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = 8;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    [self playmusic];
    cutDownNums = [time intValue];
    _gameid = gameid;
    [self kaishiapai];
    [self startRotating];
    if (!cutDownTimer) {
        cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cutdown) userInfo:nil repeats:YES];
    }
    
    for (int i=0; i<4; i++) {
        rotationBtn *btn = [self viewWithTag:2000 +i];
        float all = [moneys[i] floatValue];
        if (all >0) {
            
            btn.smallLabels.text = [NSString stringWithFormat:@"%d",(int)all];
            if (all >= 10000) {
                all = all/10000;
                btn.badgeValue = [NSString stringWithFormat:@"%.1f万",all];
            }
            else{
                btn.badgeValue = [NSString stringWithFormat:@"%d",(int)all];
            }
        }
    }
    
    for (int i=0; i<4; i++) {
        
        UILabel *labels  = [self viewWithTag:1500 + i];
        float all = [moneyss[i] floatValue];
        if (all >= 10000) {
            all = all/10000;
            labels.text = [NSString stringWithFormat:@"%.1f万",all];
        }
        else{
            labels.text = [NSString stringWithFormat:@"%d",(int)all];
        }
        CGSize size = [labels.text boundingRectWithSize:CGSizeMake(_window_width/8, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        if (size.width<20) {
            size.width = 20;
        }
        labels.frame = CGRectMake(_window_width/6.5,-25,size.width, 20);
        labels.hidden = NO;
        
    }
    
    
    
}
//隐藏tableview
-(void)dohidetableview{
    
    [self tableviewanimationhide];
    _MaskV.hidden = YES;
    tableviewbackimage.hidden = YES;
    
}
//添加游戏记录
-(void)dorecord{
    [self getnewrecord];
    tableviewbackimage.hidden = NO;
    _MaskV.hidden = NO;
    [self tableviewanimation];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _items.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    zhuangcell *cell = [zhuangcell cellWithTableview:tableView];
    cell.frame = CGRectMake(0,0, _tableview.frame.size.width, 50);
    [cell setmodel:_items[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vCs = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
    CGFloat x = 0;
    _personname = @[YZMsg(@"香蕉"),YZMsg(@"萝卜"),YZMsg(@"豌豆"),YZMsg(@"柿子")];
    for (int i=0; i<_personname.count; i++) {
        NSString *path = [NSString stringWithFormat:@"%@",_personname[i]];
        UILabel *labels = [[UILabel alloc]init];
        labels.text = path;
        labels.backgroundColor = RGB(97,69,116);
        labels.textColor = [UIColor whiteColor];
        labels.textAlignment = NSTextAlignmentCenter;
        labels.frame = CGRectMake(x,0,_tableview.frame.size.width/4,40);
        [vCs addSubview:labels];
        x+=_tableview.frame.size.width/4;
    }
    return vCs;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableviewanimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [tableviewbackimage.layer addAnimation:animation forKey:nil];
}
-(void)tableviewanimationhide{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8,0.8,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6,0.6,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4,0.4,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0,0,1.0)]];
    animation.values = values;
    [tableviewbackimage.layer addAnimation:animation forKey:nil];
}
-(void)addtableview{
    
    
    _MaskV = [[UIView alloc]initWithFrame:CGRectMake(_window_width,0,_window_width,_window_height)];
    _MaskV.hidden = YES;
    [self.superview addSubview:_MaskV];
    
    
    tableviewbackimage = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + _window_width*0.15, _window_height*0.3, _window_width*0.7, _window_width*0.9)];
    [tableviewbackimage setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_bg"]];
    [self.superview addSubview:tableviewbackimage];
    tableviewbackimage.userInteractionEnabled = YES;
    
    
    UIImageView *imagevcs = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, tableviewbackimage.frame.size.width - 10, tableviewbackimage.frame.size.height - 40)];
    [imagevcs setImage:[UIImage imageNamed:@"live_hundred_bull_history_data_bg4"]];
    imagevcs.userInteractionEnabled = YES;
    
    
    _tableview = [[UITableView alloc]initWithFrame:imagevcs.bounds style:UITableViewStylePlain];
    _tableview.allowsSelection = NO;
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    _tableview.layer.masksToBounds = YES;
    _tableview.layer.cornerRadius = 10;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor clearColor];
    
    
    
    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(0,0,tableviewbackimage.frame.size.width, 30)];
    labels.font = fontMT(18);
    labels.textAlignment = NSTextAlignmentCenter;
    labels.textColor = [UIColor whiteColor];
    labels.text = YZMsg(@"历史记录");
    
    
    [tableviewbackimage addSubview:labels];
    [tableviewbackimage addSubview:imagevcs];
    [imagevcs addSubview:_tableview];
    tableviewbackimage.hidden = YES;
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dohidetableview) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [tableviewbackimage addSubview:btn];
    btn.frame =CGRectMake(tableviewbackimage.frame.size.width - 25,-20,40,40);
    
    
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dohidetableview)];
    [_MaskV addGestureRecognizer:taps];
    
    
    UIButton *recordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordbtn setImage:[UIImage imageNamed:@"hundred_bet_history"] forState:UIControlStateNormal];
    [recordbtn addTarget:self action:@selector(dorecord) forControlEvents:UIControlEventTouchUpInside];
    recordbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    recordbtn.frame =CGRectMake(_window_width - 35,-3,35,35);
    //    [bottomV addSubview:recordbtn];
    
    
}
-(void)stoplasttimer{
    
}
//获取游戏记录
-(void)getnewrecord{
    NSString *url = [NSString stringWithFormat:@"%@&stream=%@&action=%@",@"Game.getGameRecord",_stream,@"3"];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            _items = info;
            [self.tableview reloadData];
        }
    } fail:^{
        
    }];
}
@end
