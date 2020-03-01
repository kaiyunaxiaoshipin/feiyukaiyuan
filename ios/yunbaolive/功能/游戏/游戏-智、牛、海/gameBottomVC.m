
//
//  gameBottomVC.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "gameBottomVC.h"
#import "personMove.h"
#import "MoneyVC.h"
#import "PokerVC.h"
#import "animationBtnV.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "zhuangresultimagev.h"
#import "zhuangcell.h"
#define personW ((_window_width - 120)/3)
#define smallPersonW _window_width/3
#define space 30
#define smallSpace 10
@interface gameBottomVC ()<startGame,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *startShow;
    int cutDownNums;//倒计时
    NSTimer * cutDownTimer;
    UIButton *downBTN;//倒计时
    PokerVC *pokV;//创建扑克牌
    UIButton *cancleBtn;//关闭游戏
    UIImageView *bottomImage;
    UIView *bottomV;//用户按钮背景
    AVAudioPlayer *gameVoicePlayer;//game voice
    AVAudioPlayer *touchVoice;
    // SystemSoundID soundFileObject;
    UIButton *imageVS;
    UIView *blackVC;
    UIView *lightVC1;
    UIView *lightVC2;
    UIImageView *haidaoVS;//海盗船长的VS
    NSTimer *starttime;
    NSTimer *resulttimer;
    
    NSTimer *ksishiTimer;//开始倒数计时
    UILabel *startwords;//倒数计时
    int waittimes;
    BOOL shangzhuang;//上庄玩法判断
    zhuangresultimagev *zhuangresult;//上庄结果显示
    
    UIImageView *tableviewbackimage;
    
}
@property(nonatomic,strong)UIView *MaskV;//遮罩
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIImageView *jiantou;
@property(nonatomic,strong)UIButton *jumpRecharge;
@property(nonatomic,strong)UILabel *chongzhi;
@property(nonatomic,strong)UIImageView *coinImg;
@property(nonatomic,copy)NSString *type;//押注类型
@property(nonatomic,copy)NSString *money;//押注金额
@property(nonatomic,assign)CGFloat isHostY;//判断是不是主播
@property(nonatomic,strong)NSString *gameid;//游戏id
//图片
@property(nonatomic,copy)NSString *backimagename;//游戏背景图片
@property(nonatomic,copy)NSString *personimage;//游戏人物图片
@property(nonatomic,copy)NSString *personnameimage;//游戏人物名称图片
@property(nonatomic,copy)NSString *timeimage;//倒计时背景
@property(nonatomic,strong)NSArray *personname;//人物名称
@property(nonatomic,strong)NSArray *personnameX;//人物名称
@property(nonatomic,copy)NSString *moneyvcbackimage;//押注背景图
@property(nonatomic,copy)NSString *pokerbackimag;//扑克牌背景
//接口
@property(nonatomic,copy)NSString *zhajinhuagameyazhu;//炸金花押注
@property(nonatomic,copy)NSString *zhajinhuakaishi;//炸金花开始发牌
@property(nonatomic,copy)NSString *zhajinhuaendgame;//炸金花游戏结束
@property(nonatomic,copy)NSString *zhajinhuaresult;//炸金花游戏结果
@property(nonatomic,assign)int pokerNums;//扑克牌张数
@property(nonatomic,assign)int personNums;//人物数量
@property(nonatomic,assign)BOOL isLodumani;//判断是不是海盗船长
@property(nonatomic,strong)NSString *gameaction;//游戏类别
@property(nonatomic,strong)NSString *hoststream;//
@end
@implementation gameBottomVC
-(void)cancle{
    
    cancleBtn.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        cancleBtn.userInteractionEnabled = YES;
        
    });
    
    
    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    
    
    [self stopGame];
    
    NSString *url = [NSString stringWithFormat:@"%@&stream=%@&liveuid=%@&token=%@&type=%@&gameid=%@&ifset=%@",_zhajinhuaendgame,[NSString stringWithFormat:@"%@",[self.zhuboDic valueForKey:@"stream"]],[Config getOwnID],[Config getOwnToken],@"2",[_info valueForKey:@"gameid"],@"1"];
    
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
}
-(void)start{
    
    [self startGame:^(id arrays) {
        [gameState saveProfile:@"1"];//保存游戏开始状态
    }];
    
}
-(void)stopGame{
    [self releaseAll];
    [self.delagate stopGamendMethod:_method andMsgtype:_msgtype];
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    if (touchVoice) {
        [touchVoice stop];
        touchVoice = nil;
    }
}
-(instancetype)initWIthDic:(NSDictionary *)dic andIsHost:(BOOL)ok andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    self = [super init];
    if (self) {
        _bankerid = @"0";
        _items = [NSArray array];
        shangzhuang = NO;
        _isLodumani = NO;
        waittimes = gameWait;
        //智勇三张和开心牛仔 UI布局基本一样，海盗船长需要另做判断
        _method = method;
        _msgtype = msgtype;
        _zhajinhuaresult = @"Game.settleGame";//获取结果
        //炸金花游戏
        if ([_method isEqual:@"startGame"]) {
            _gameaction = @"1";
            
            _backimagename = @"img_goldflowerbg";//炸金花
            _personimage = @"img_goldflower_role";//人物
            _personnameimage = @"img_goldflower_rolename";//人物名称
            _timeimage = @"ico_bgtime";//倒计时背景
            _personname = @[YZMsg(@"大乔"),YZMsg(@"貂蝉"),YZMsg(@"小乔")];
            _personnameX =@[YZMsg(@"大乔X2"),YZMsg(@"貂蝉X2"),YZMsg(@"小乔X2")];
            _moneyvcbackimage = @"img_goldflower_betbg";//押注背景
            _pokerbackimag = @"poker_back_goldflower";
            //炸金花
            _zhajinhuagameyazhu = @"Game.JinhuaBet";//押注
            _zhajinhuakaishi    = @"Game.Jinhua";//开始
            _zhajinhuaendgame = @"Game.endGame";//游戏结束
            _method = @"startGame";
            _msgtype = @"15";
            _pokerNums = 9;
            _personNums = 3;
        }
        //牛牛
        if([_method isEqual:@"startCattleGame"]) {
            shangzhuang = YES;
            _gameaction = @"4";
            _method = @"startCattleGame";
            _msgtype = @"17";
            _backimagename = @"img_poppullbg";//
            _personimage = @"img_popbull_role";//人物
            _personnameimage = @"img_popbull_rolename";//人物名称
            _timeimage = @"ico_bgtimepopbull";//倒计时背景
            _personname = @[YZMsg(@"星星"),YZMsg(@"球球"),YZMsg(@"仔仔")];
            _personnameX =@[YZMsg(@"星星X2"),YZMsg(@"球球X2"),YZMsg(@"仔仔X2")];
            _moneyvcbackimage = @"img_popbull_betbg";//押注背景
            _pokerbackimag = @"poker_back_popbull";//扑克牌背景
            //接口
            _zhajinhuagameyazhu = @"Game.Cowboy_Bet";//押注
            _zhajinhuakaishi    = @"Game.Cowboy";//开始
            _zhajinhuaendgame = @"Game.Cowboy_end";//游戏结束
            _pokerNums = 15;
            _personNums = 3;
        }
        //海盗船长
        if ([_method isEqual:@"startLodumaniGame"]) {
            _gameaction = @"2";
            _method = @"startLodumaniGame";
            _msgtype = @"18";
            _backimagename = @"img_pullbg";
            _personimage = @"img_bull_role";//人物
            _personnameimage = @"img_bull_rolename";//人物名称
            _timeimage = @"ico_bgbulltime";//倒计时背景
            _personname   = @[YZMsg(@"罗伯茨"),YZMsg(@"平局"),YZMsg(@"基德")];
            _personnameX = @[YZMsg(@"罗伯茨X2"),YZMsg(@"平局X2"),YZMsg(@"基德X2")];
            _moneyvcbackimage = @"img_bull_betbg";//押注背景
            _pokerbackimag = @"poker_back";//扑克牌背景
            //接口
            _zhajinhuagameyazhu = @"Game.Taurus_Bet";//押注
            _zhajinhuakaishi    = @"Game.Taurus";//开始
            _zhajinhuaendgame = @"Game.Taurus_end";//游戏结束
            _pokerNums = 10;
            _personNums = 2;
            _isLodumani = YES;
        }
        _isHostY = 30;
        if (ok) {
            //          _isHostY = 60;
            if ([_method isEqual:@"startCattleGame"]) {
                _isHostY = 30;
            }
            cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancleBtn setBackgroundColor:normalColors];
            [cancleBtn setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
            cancleBtn.frame = CGRectMake(80,2,60,30);
            
            [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancleBtn];
        }
        if (!ok) {
            NSURL *url=[[NSBundle mainBundle]URLForResource:@"beginguesssound.mp3" withExtension:Nil];
            gameVoicePlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
            [gameVoicePlayer prepareToPlay];
            [gameVoicePlayer play];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kaishiapai) name:@"startYaZhu" object:nil];
        _zhuboDic = dic;
        _isHost = ok;
        _info = [NSDictionary dictionary];
        [self setView];
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
            [startwords removeFromSuperview];
            startwords = nil;
        }
        
        ksishiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpwords) userInfo:nil repeats:YES];
        [gameState saveProfile:@"0"];
    }
    return self;
}
//展示*********************************************************
-(void)setView{
    if (!bottomImage) {
        bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,_isHostY,_window_width,200)];
        bottomImage.userInteractionEnabled = YES;
        [bottomImage setImage:[UIImage imageNamed:_backimagename]];
        [self addSubview:bottomImage];
    }
    //创建人物动画 _isLodumani判断是不是海盗船长，更改坐标
    for (int i=0; i<_personNums; i++) {
        if (_isLodumani == NO) {
            personMove *moves = [[personMove alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_personimage,i]] andRect:CGRectMake(20+personW*i+ space*i,40,personW,150)];
            moves.tag = 1000+ i;
            [bottomImage addSubview:moves];
            UIImageView *imageVname = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_personnameimage,i]]];
            imageVname.tag = 2000 + i;
            imageVname.frame = CGRectMake(20+personW*i+ space*i + personW,35,30,60);
            imageVname.contentMode = UIViewContentModeScaleAspectFit;
            [bottomImage addSubview:imageVname];
        }
        else{
            personMove *moves;
            if (i==0) {
                moves = [[personMove alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_personimage,i]] andRect:CGRectMake(40,40,personW,150)];
                moves.tag = 1000+ i;
                [bottomImage addSubview:moves];
                UIImageView *imageVname = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_personnameimage,i]]];
                imageVname.tag = 2000 + i;
                imageVname.frame = CGRectMake(15,35,30,60);
                imageVname.contentMode = UIViewContentModeScaleAspectFit;
                [bottomImage addSubview:imageVname];
            }
            else{
                haidaoVS = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dezhou_vs"]];
                haidaoVS.contentMode = UIViewContentModeScaleAspectFit;
                haidaoVS.frame = CGRectMake(_window_width/2-50,90,100, 150);
                [self addSubview:haidaoVS];
                moves = [[personMove alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_personimage,i]] andRect:CGRectMake(_window_width-40-personW,40,personW,150)];
                moves.tag = 1000+ i;
                [bottomImage addSubview:moves];
                UIImageView *imageVname = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",_personnameimage,i]]];
                imageVname.tag = 2000 + i;
                imageVname.frame = CGRectMake(_window_width-45,35,30,60);
                imageVname.contentMode = UIViewContentModeScaleAspectFit;
                [bottomImage addSubview:imageVname];
            }
        }
    }
    [imageVS removeFromSuperview];
    imageVS = nil;
    if (!imageVS) {
        imageVS = [UIButton buttonWithType:UIButtonTypeCustom];
        [imageVS setBackgroundImage:[UIImage imageNamed:@"dt"] forState:UIControlStateNormal];
        [imageVS setUserInteractionEnabled:NO];
        [imageVS setFrame:CGRectMake(20, 130, _window_width-40, 30)];
        [imageVS setTitle:YZMsg(@"即将开始，请稍后") forState:UIControlStateNormal];
        [imageVS setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [self addSubview:imageVS];
    }
    [imageVS setTitle:YZMsg(@"即将开始，请稍后") forState:UIControlStateNormal];
    imageVS.frame = CGRectMake(20, 130, _window_width-40, 30);
    //游戏自动开始
    if (_isHost) {
        if (starttime) {
            [starttime invalidate];
            starttime = nil;
        }
        starttime = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(start) userInfo:nil repeats:NO];
    }
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
        [gameState saveProfile:@"1"];
    }
}

//PokerV代理方法,开始计时
-(void)startGame{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
        [startwords removeFromSuperview];
        startwords = nil;
        
    }
    [startwords removeFromSuperview];
    startwords = nil;
    if (_isHost) {
        [self.delagate startGameSocketToken:[_info valueForKey:@"token"] andGameID:[_info valueForKey:@"gameid"] andTime:[_info valueForKey:@"time"] ndMethod:_method andMsgtype:_msgtype];
        if (!cutDownTimer) {
            cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cutdown) userInfo:nil repeats:YES];
        }
    }
}
-(void)movieplayStartCut:(NSString *)time andGameid:(NSString *)gameid{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    cutDownNums = [time intValue];
    _gameid = gameid;
    if (!cutDownTimer) {
        cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cutdown) userInfo:nil repeats:YES];
    }
}
-(void)createCutDownBTN{
    if (!downBTN) {
        downBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [downBTN setBackgroundImage:[UIImage imageNamed:_timeimage] forState:UIControlStateNormal];
        [downBTN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (_isHost) {
            downBTN.frame = CGRectMake(_window_width/2 - 25,110,50,50);
            if (_isLodumani) {
                downBTN.frame = CGRectMake(_window_width/2 - 25,80,50,50);
                [downBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }else{
            downBTN.frame = CGRectMake(_window_width/2 - 25,80,50,50);
            if (_isLodumani) {
                downBTN.frame = CGRectMake(_window_width/2 - 25,30,50,50);
                [downBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        [self addSubview:downBTN];
        downBTN.hidden = YES;
    }
}
//中途加入的
-(void)getNewCOins:(NSArray *)array{
    for (int i=0; i<3; i++) {
        MoneyVC *btns = [self viewWithTag:3000+i];
        float single = [[array objectAtIndex:i] floatValue];
        btns.allLabel.text = [NSString stringWithFormat:@"%d",(int)single];
        if (single >= 10000) {
            single = single/10000;
            btns.allCoinLabel.text = [NSString stringWithFormat:@"%.1f万",single];
        }else{
            btns.allCoinLabel.text = [NSString stringWithFormat:@"%d",(int)single];
        }
    }
}
-(void)getmyCOIns:(NSArray *)arrays{
    for (int i=0; i<3; i++) {
        MoneyVC *btns = [self viewWithTag:3000+i];
        float single = [arrays[i] floatValue];
        btns.myLabel.text = [NSString stringWithFormat:@"%d",(int)single];
        if (single >= 10000) {
            single = single/10000;
            btns.myCoinLabel.text = [NSString stringWithFormat:@"%.1f万",single];
        }
        else{
            btns.myCoinLabel.text = [NSString stringWithFormat:@"%d",(int)single];
        }
    }
}
-(void)continueUI{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (haidaoVS) {
        [haidaoVS removeFromSuperview];
        haidaoVS = nil;
    }
    
    //人物动画
    for (int j=0; j<_personNums; j++) {
        personMove *moveVC = [self viewWithTag:1000+j];
        if (_isLodumani) {
            if (j==0) {
                moveVC.frame = CGRectMake(10+_window_width/_personNums*j,90,smallPersonW/2.5,100);
                [moveVC continuesetNewFrame:CGRectMake(10+_window_width/_personNums*j,90,smallPersonW/2.5,100)];
            }else{
                moveVC.frame = CGRectMake(_window_width-10-smallPersonW/2.5,90,smallPersonW/2.5,100);
                [moveVC continuesetNewFrame:CGRectMake(_window_width-10-smallPersonW/2.5,90,smallPersonW/2.5,100)];
            }
        }else{
            moveVC.frame = CGRectMake(10+_window_width/_personNums*j,90,smallPersonW/2.5,100);
            [moveVC continuesetNewFrame:CGRectMake(10+_window_width/_personNums*j,90,smallPersonW/2.5,100)];
        }
    }
    //隐藏无用UI
    for (int i=0; i<_personNums; i++) {
        UIView *hideVC = [self viewWithTag:2000+i];
        [hideVC removeFromSuperview];
        hideVC = nil;
    }
    //创建扑克牌
    pokV = [[PokerVC alloc]initWithFrame:CGRectMake(_window_width/2 - _window_width/6,90, _window_width/3,80) continue:YES andIsHost:_isHost andBackimage:_pokerbackimag andPokernums:_pokerNums andIshaidao:_isLodumani andISSANZHANF:shangzhuang];
    pokV.pokernums = _pokerNums;
    pokV.delegate = self;
    [bottomImage addSubview:pokV];
    bottomV = [[UIView alloc]initWithFrame:CGRectMake(0,230,_window_width,30)];
    [self addSubview:bottomV];
    [self CreateActionVC];
    
    //创建计分版
    CGFloat x = 10+smallPersonW/2.5;
    __block CGFloat xx = x;
    __block CGFloat ww = smallPersonW/2;
    for (int w=0; w<3; w++) {
        MoneyVC *moeneyV;
        if (_isLodumani) {
            if (w==0) {
                moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(xx,105, smallPersonW/2,80)];
            }
            else if (w == 1){
                moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(_window_width/2 - smallPersonW/4,105, smallPersonW/2,80)];
            }else{
                moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(_window_width - 10- smallPersonW/2.5 - smallPersonW/2,105, smallPersonW/2,80)];
            }
        }else{
            moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(xx,105,ww,80)];
        }
        [moeneyV setBackgroundImage:[UIImage imageNamed:_moneyvcbackimage] forState:UIControlStateNormal];
        [moeneyV addTarget:self action:@selector(stakePokers:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(7,4,60, 20)];
        labels.font =  [UIFont fontWithName:@"Helvetica-Bold" size:12];
        labels.textColor = RGB(137, 61, 14);
        [moeneyV addSubview:labels];
        labels.text = [_personnameX objectAtIndex:w];
        moeneyV.tag = 3000 + w;
        xx += _window_width/3;
        [bottomImage addSubview:moeneyV];
    }
}
-(void)createUI{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (haidaoVS) {
        [haidaoVS removeFromSuperview];
        haidaoVS = nil;
    }
    if (imageVS) {
        imageVS.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
        [UIView setAnimationDuration:0.5f];//动画时间
        imageVS.transform=CGAffineTransformMakeScale(0.01f, 0.01f);//先让要显示的view最小直至消失
        [UIView commitAnimations]; //启动动画
    }
    //人物动画
    for (int j=0; j<_personNums; j++) {
        personMove *moveVC = (personMove *)[self viewWithTag:1000+j];
        if ([moveVC isKindOfClass:[personMove class]]) {
            if (_isLodumani) {
                if (j==0) {
                    [UIView animateWithDuration:1.0 animations:^{
                        [moveVC setNewFrame:CGRectMake(10+_window_width/_personNums*j,90,smallPersonW/2.5,100)];
                    }];
                }else{
                    [UIView animateWithDuration:1.0 animations:^{
                        [moveVC setNewFrame:CGRectMake(_window_width-10-smallPersonW/2.5,90,smallPersonW/2.5,100)];
                    }];
                }
            }
            else{
                [UIView animateWithDuration:1.0 animations:^{
                    [moveVC setNewFrame:CGRectMake(10+_window_width/_personNums*j,90,smallPersonW/2.5,100)];
                }];
            }
        }
    }
    //隐藏无用UI
    for (int i=0; i<_personNums; i++) {
        UIView *hideVC = [self viewWithTag:2000+i];
        __block UIView *bloVC = hideVC;
        [UIView animateWithDuration:1.0 animations:^{
            hideVC.alpha = 0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bloVC removeFromSuperview];
            bloVC = nil;
        });
    }
    //创建扑克牌
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pokV = [[PokerVC alloc]initWithFrame:CGRectMake(_window_width/2 - _window_width/6,90, _window_width/3,80) continue:NO andIsHost:_isHost andBackimage:_pokerbackimag andPokernums:_pokerNums andIshaidao:_isLodumani andISSANZHANF:shangzhuang];
        pokV.pokernums = _pokerNums;
        pokV.delegate = self;
        [bottomImage addSubview:pokV];
    });
    //创建计分版
    CGFloat x = 10+smallPersonW/2.5;
    __block CGFloat xx = x;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int w=0; w<3; w++) {
            MoneyVC *moeneyV;
            if (_isLodumani) {
                if (w==0) {
                    moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(xx,105, smallPersonW/2,80)];
                }
                else if (w == 1){
                    moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(_window_width/2 - smallPersonW/4,105, smallPersonW/2,80)];
                }
                else{
                    moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(_window_width - 10- smallPersonW/2.5 - smallPersonW/2,105, smallPersonW/2,80)];
                }
            }
            else{
                moeneyV = [[MoneyVC alloc]initWithFrame:CGRectMake(xx,105, smallPersonW/2,80)];
                xx += _window_width/3;
            }
            [moeneyV setBackgroundImage:[UIImage imageNamed:_moneyvcbackimage] forState:UIControlStateNormal];
            [moeneyV addTarget:self action:@selector(stakePokers:) forControlEvents:UIControlEventTouchDown];
            moeneyV.tag = 3000 + w;
            UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(7,4,60,20)];
            labels.font =  [UIFont fontWithName:@"Helvetica-Bold" size:12];
            labels.textColor = RGB(137, 61, 14);
            [moeneyV addSubview:labels];
            labels.text = [_personnameX objectAtIndex:w];
            [bottomImage addSubview:moeneyV];
            moeneyV.alpha = 0;
            [UIView animateWithDuration:1.0 animations:^{
                moeneyV.alpha = 1;
            }];
        }
    });
    [self CreateActionVC];
}
//倒计时
-(void)cutdown{
    [self createCutDownBTN];
    [downBTN setTitle:[NSString stringWithFormat:@"%d",cutDownNums] forState:UIControlStateNormal];
    if (cutDownNums == 0) {
        downBTN.hidden = YES;
        [cutDownTimer invalidate];
        cutDownTimer = nil;
        bottomV.hidden = YES;
        [self kaishigetresult];
    }
    else
    {
        downBTN.hidden = NO;
    }
    cutDownNums -=1;
}
-(void)getResult:(NSArray *)array{
    [pokV result:array];
    [downBTN removeFromSuperview];
    downBTN = nil;
    //开奖
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
    resulttimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(kaijiang) userInfo:nil repeats:NO];
}
//2.主播开始发牌
-(void)startGame:(playSuccess)ok{
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
        waittimes = gameWait;
        [startwords removeFromSuperview];
        startwords = nil;
    }
    [startwords removeFromSuperview];
    startwords = nil;
    //service=Game.Jinhua
    NSString *url = [NSString stringWithFormat:@"%@&stream=%@&liveuid=%@&token=%@",_zhajinhuakaishi,[self.zhuboDic valueForKey:@"stream"],[Config getOwnID],[Config getOwnToken]];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            NSDictionary *bankerlist = [infos valueForKey:@"bankerlist"];
            _info = infos;
            [self.delagate prepGame:[infos valueForKey:@"gameid"] ndMethod:_method andMsgtype:_msgtype andBanklist:bankerlist];
            if([_method isEqual:@"startCattleGame"]) {
                [self.delagate changebank:bankerlist];
                NSString *listfirstid = [NSString stringWithFormat:@"%@",[bankerlist valueForKey:@"id"]];
                _bankerid = listfirstid;//更换上庄ID
            }
            _gameid = [infos valueForKey:@"gameid"];
            cutDownNums = [[infos valueForKey:@"time"] intValue];
            [self createUI];
            ok(@(code));

        }
    } fail:^{
        
    }];
}
-(void)kaijiang{
    NSString *url;
    if (!_isHost) {
        url = [NSString stringWithFormat:@"%@&uid=%@&gameid=%@",_zhajinhuaresult,[Config getOwnID],_gameid];
    }
    else{
        url = [NSString stringWithFormat:@"%@&uid=%@&gameid=%@",_zhajinhuaresult,[Config getOwnID],[_info valueForKey:@"gameid"]];
    }
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            NSString *coin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]];
            NSString *banker_profit = [NSString stringWithFormat:@"%@",[infos valueForKey:@"banker_profit"]];
            NSString *gamecoin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"gamecoin"]];
            NSString *isshow = [NSString stringWithFormat:@"%@",[infos valueForKey:@"isshow"]];
            
            NSArray *keyArray = [infos allKeys];
            if ([keyArray containsObject:@"isshow"]) {
                
                if (![isshow isEqual:@"0"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"%@%@%@",YZMsg(@"您的余额不足"),[gameState getzhuanglimit],YZMsg(@"将被下庄")] delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            //刷新我自己的余额
            LiveUser *user = [Config myProfile];
            user.coin = [NSString stringWithFormat:@"%@",coin];
            [Config updateProfile:user];
            
            if ([self.delagate respondsToSelector:@selector(reloadcoinsdelegate)]) {
                [self.delagate reloadcoinsdelegate];
            }
            if (shangzhuang) {
                //弹窗显示
                if (!zhuangresult) {
                    zhuangresult = [[zhuangresultimagev alloc]initWithFrame:CGRectMake(_window_width*0.1,0, _window_width*0.6, 120)];
                    [bottomImage addSubview:zhuangresult];
                }
                zhuangresult.banker_profit.text = [NSString stringWithFormat:@"%@ %@",YZMsg(@"庄家"),banker_profit];
                zhuangresult.gamecoin.text = [NSString stringWithFormat:@"%@ %@",YZMsg(@"本家"),gamecoin];
                //显示动画s
                CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                animation.duration = 0.4;
                NSMutableArray *values = [NSMutableArray array];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
                [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                animation.values = values;
                [zhuangresult.layer addAnimation:animation forKey:nil];
            }
            else{
                NSString *gamecoin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"gamecoin"]];
                LiveUser *user = [Config myProfile];
                user.coin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]];
                [Config updateProfile:user];
                int succcess = [gamecoin intValue];
                if (succcess >0) {
                    NSString *money = [NSString stringWithFormat:@"%@%@",gamecoin,[common name_coin]];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"赢了哦") message:money delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                    [alert show];
                }
                else {
                    //没中奖
                }

        }
        }
    } fail:^{
        
    }];
}

-(void)gameOver{
    if (zhuangresult) {
        [zhuangresult removeFromSuperview];
        zhuangresult = nil;
    }
    for (int i=0; i<3; i++) {
        UIView *VC1 = [self viewWithTag:1000 +i];
        UIView *VC2 = [self viewWithTag:2000 + i];
        UIView *VC3 = [self viewWithTag:3000 + i];
        [VC1 removeFromSuperview];
        [VC2 removeFromSuperview];
        [VC3 removeFromSuperview];
        VC1 = nil;
        VC2 = nil;
        VC3 = nil;
    }
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animation = (animationBtnV *)[self viewWithTag:4000 + i];
        [animation stopAnimation];
        [animation removeFromSuperview];
        animation = nil;
    }
    for (UIButton *btns in bottomImage.subviews) {
        if ([btns isKindOfClass:[MoneyVC class]]) {
            [btns removeFromSuperview];
        }
    }
    [pokV reallocAll];
    [pokV removeFromSuperview];
    pokV = nil;
    [downBTN removeFromSuperview];
    downBTN = nil;
    [self setView];
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
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
        [startwords removeFromSuperview];
        startwords = nil;
    }
    ksishiTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpwords) userInfo:nil repeats:YES];
    [gameState saveProfile:@"0"];//保存游戏开始状态
    
}
-(void)releaseAll{
    if (zhuangresult) {
        [zhuangresult removeFromSuperview];
        zhuangresult = nil;
    }
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
    }
    if (!startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (pokV) {
        [pokV reallocAll];
    }
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
        [pokV releaseMusic];
    }
    if (starttime) {
        [starttime invalidate];
        starttime = nil;
    }
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
}
-(void)dealloc{
    if (zhuangresult) {
        [zhuangresult removeFromSuperview];
        zhuangresult = nil;
    }
    if (ksishiTimer) {
        [ksishiTimer invalidate];
        ksishiTimer = nil;
    }
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
    
    if (!startwords) {
        [startwords removeFromSuperview];
        startwords = nil;
    }
    if (pokV) {
        [pokV reallocAll];
    }
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    if (starttime) {
        [starttime invalidate];
        starttime = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startYaZhu" object:nil];
}
//预告开始文字
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
//用户投注***********************************************************
-(void)CreateActionVC{
    
    if (_isHost) {
        
        return;
    }
    bottomV = [[UIView alloc]initWithFrame:CGRectMake(0,220,_window_width,30)];
    [self addSubview:bottomV];
    //创建4个押注按钮
    NSArray *array = @[@"10",@"100",@"1000",@"10000"];
    _money = [array firstObject];//初始化押注金额
    //充值lable
    _chongzhi = [[UILabel alloc] init];
    LiveUser *user = [Config myProfile];
    _chongzhi.textColor = normalColors;
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
    CGFloat x;
    
    
    if (shangzhuang) {
        x = _window_width - 70;
    }else{
        x = _window_width - 35;
    }
    
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animationvc = [[animationBtnV alloc]initWithFrame:CGRectMake(x,0,30,30)];
        animationvc.userInteractionEnabled = YES;
        [animationvc.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stake%d%d",i+1,i+1]]];
        if (i == 0) {
            [animationvc.bottomImage setImage:[UIImage imageNamed:@"stake1"]];
            [animationvc setAnimation];
        }
        [animationvc.frontButton setTitle:array[i] forState:UIControlStateNormal];
        [animationvc.frontButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        animationvc.tag = 4000 + i;
        [animationvc.frontButton addTarget:self action:@selector(stake:) forControlEvents:UIControlEventTouchDown];
        x-= 40;
        [bottomV addSubview:animationvc];
        animationvc.backgroundColor = [UIColor clearColor];
    }
    //游戏记录
    [self addtableview];
    
}
//如果有送礼物刷新钻石
-(void)reloadcoins{
    LiveUser *user = [Config myProfile];
    [self chongzhiV:user.coin];
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
    [self.delagate pushCoinV];
}
//押注//选择类型
-(void)stake:(UIButton *)sender{
    NSString *stakeS = sender.titleLabel.text;
    _money = stakeS;
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animation = (animationBtnV *)[self viewWithTag:4000 + i];
        [animation.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stake%d%d",i+1,i+1]]];
        [animation stopAnimation];
        if ([animation.frontButton.titleLabel.text isEqual:stakeS]) {
            [animation.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"stake%d",i+1]]];
            
            [animation setAnimation];
        }
    }
}
-(void)changebankid:(NSString *)bankid{
    _bankerid = bankid;
}
//点击押注
-(void)stakePokers:(UIButton *)sender{
    
    
    if (cutDownNums  < 3) {
        
        
        return;
    }
    
    //  if (![_method isEqual:@"startCattleGame"]) {
    if (_isHost) {
        
        
        return;
    }
    //   }
    
    if ([_bankerid isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:YZMsg(@"庄家无法下注")];
        return;
    }
    if ([_money isEqual:@"0"]) {
        
        return;
    }
    NSInteger g = sender.tag - 3000 + 1;
    NSString *grade = [NSString stringWithFormat:@"%ld",g];
    
    NSDictionary *subdic = @{
                             @"stream":[self.zhuboDic valueForKey:@"stream"],
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"gameid":_gameid,
                             @"coin":_money,
                             @"grade":grade
                             };
    [YBToolClass postNetworkWithUrl:_zhajinhuagameyazhu andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [self playSoundEffect];
            NSDictionary *infos = [info firstObject];
            [self chongzhiV:[NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]]];
            LiveUser *user = [Config myProfile];
            user.coin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]];
            [Config updateProfile:user];
            [self.delagate skate:grade andMoney:_money andMethod:_method andMsgtype:_msgtype];
            int asele =  [grade intValue];
            MoneyVC *btns = [self viewWithTag:3000+asele - 1];
            NSString *myCoins = btns.myLabel.text;
            float all = [myCoins floatValue];
            float single = [_money floatValue];
            all +=single;
            btns.myLabel.text = [NSString stringWithFormat:@"%d",(int)all];
            if (all >= 10000) {
                all = all/10000;
                btns.myCoinLabel.text = [NSString stringWithFormat:@"%.1f万",all];
            }
            else{
                btns.myCoinLabel.text = [NSString stringWithFormat:@"%d",(int)all];
            }

        }
    } fail:^{
        
    }];
}
- (void)playSoundEffect{
    
    if (!touchVoice) {
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"buttonclickaaaaa.mp3" withExtension:Nil];
        touchVoice = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    }
    [touchVoice prepareToPlay];
    [touchVoice play];
}
//更新押注数
-(void)getCoinType:(NSString *)type andMoney:(NSString *)money{
    MoneyVC *btns = [self viewWithTag:3000+[type intValue] - 1];
    float all = [btns.allLabel.text floatValue];
    float single = [money floatValue];
    all +=single;
    btns.allLabel.text = [NSString stringWithFormat:@"%d",(int)all];
    if (all >= 10000) {
        all = all/10000;
        btns.allCoinLabel.text = [NSString stringWithFormat:@"%.1f万",all];
    }else{
        btns.allCoinLabel.text = [NSString stringWithFormat:@"%d",(int)all];
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
    for (int i=0; i<_personname.count; i++) {
        NSString *path = [NSString stringWithFormat:@"%@",_personname[i]];
        UILabel *labels = [[UILabel alloc]init];
        labels.text = path;
        labels.backgroundColor = RGB(97,69,116);
        labels.textColor = [UIColor whiteColor];
        labels.textAlignment = NSTextAlignmentCenter;
        labels.frame = CGRectMake(x,0,_tableview.frame.size.width/3,40);
        [vCs addSubview:labels];
        x+=_tableview.frame.size.width/3;
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
    if (_isHost) {
        _MaskV.frame = CGRectMake(0, 0, _window_width, _window_height);
    }
    [self.superview addSubview:_MaskV];
    [self.superview bringSubviewToFront:_MaskV];

    
    tableviewbackimage = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + _window_width*0.15, _window_height*0.2, _window_width*0.7, _window_width*0.9)];
    [tableviewbackimage setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_bg"]];
    [self.superview addSubview:tableviewbackimage];
    tableviewbackimage.userInteractionEnabled = YES;
    
    
    if (_isHost) {
        tableviewbackimage.frame = CGRectMake(_window_width*0.15, _window_height*0.2, _window_width*0.7, _window_width*0.9);
    }
    
    UIImageView *imagevcs = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, tableviewbackimage.frame.size.width - 10, tableviewbackimage.frame.size.height - 40)];
    [imagevcs setImage:[UIImage imageNamed:@"live_hundred_bull_history_data_bg"]];
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
    if ([_method isEqual:@"startCattleGame"]) {
        [bottomV addSubview:recordbtn];
    }
}
//获取游戏记录
-(void)getnewrecord{
    
    
    NSString *url = [NSString stringWithFormat:@"%@&stream=%@&action=%@",@"Game.getGameRecord",[self.zhuboDic valueForKey:@"stream"],_gameaction];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            _items = info;
            [self.tableview reloadData];
        }
    } fail:^{
        
    }];
}
@end
