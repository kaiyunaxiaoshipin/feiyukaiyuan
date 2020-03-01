#import "shellGame.h"
#import "personMove.h"
#import "MoneyVC.h"
#import "PokerVC.h"
#import "animationBtnV.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "zhuangcell.h"
#define personW ((_window_width - 120)/3)
#define smallPersonW _window_width/3
#define space 30
#define smallSpace 10
@interface shellGame ()<UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *startShow;
    int cutDownNums;//倒计时
    NSTimer * cutDownTimer;
    UIButton *downBTN;//倒计时
    UIButton *cancleBtn;//关闭游戏
    UIButton *startbtn;//开始游戏
    UIImageView *bottomImage;
    UIView *bottomV;//用户按钮背景
    AVAudioPlayer *gameVoicePlayer;//game voice
    AVAudioPlayer *touchVoice;
    //  SystemSoundID soundFileObject;
    UIButton *imageVS;
    UIView *blackVC;
    UIView *lightVC1;
    UIView *lightVC2;
    UIImageView *haidaoVS;//海盗船长的VS
    NSTimer *starttime;
    NSTimer *kaishitimerxin;//开始倒数计时
    UILabel *startwordsxin;//倒数计时
    int waittimes;
    NSTimer *androidTimer;//倒计时开始计时器
    int startagain;//再次开始游戏间隔时间
    
    UIImageView *tableviewbackimage;
    
    NSTimer *resulttimer;
    
    
    //依次展示结果
    NSTimer *resulttimer1;
    NSTimer *resulttimer2;
    NSTimer *resulttimer3;
    NSTimer *resulttimer4;
    NSTimer *resulttimer5;
    
}
@property(nonatomic,strong)UIView *MaskV;//遮罩
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSString *gameaction;//游戏类别
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
@property(nonatomic,copy)NSString *timeimage;//倒计时背景
@property(nonatomic,copy)NSString *moneyvcbackimage;//押注背景图
@property(nonatomic,copy)NSString *pokerbackimag;//扑克牌背景
//接口
@property(nonatomic,copy)NSString *zhajinhuagameyazhu;//炸金花押注
@property(nonatomic,copy)NSString *zhajinhuakaishi;//炸金花开始发牌
@property(nonatomic,copy)NSString *zhajinhuaendgame;//炸金花游戏结束
@property(nonatomic,copy)NSString *zhajinhuaresult;//炸金花游戏结果
@property(nonatomic,assign)int pokerNums;//扑克牌张数
@property(nonatomic,strong)NSArray *personname;//人物名称
//tag 3000 点击押注
@end
@implementation shellGame
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
    
    [self stopGame];

    NSString *url = [NSString stringWithFormat:@"%@&stream=%@&liveuid=%@&token=%@&type=%@&gameid=%@&ifset=%@",_zhajinhuaendgame,[NSString stringWithFormat:@"%@",[self.zhuboDic valueForKey:@"stream"]],[Config getOwnID],[Config getOwnToken],@"2",[_info valueForKey:@"gameid"],@"1"];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
//    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSNumber *number = [responseObject valueForKey:@"ret"] ;
//        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
//        {
//            NSArray *data = [responseObject valueForKey:@"data"];
//            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
//            if([code isEqual:@"0"])
//            {
//
//
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//    }];
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
    startbtn.hidden = NO;
}
-(instancetype)initWIthDic:(NSDictionary *)dic andIsHost:(BOOL)ok andMethod:(NSString *)method andMsgtype:(NSString *)msgtype andandBanklist:(NSDictionary *)subdic{
    self = [super init];
    if (self) {
        _items = [NSArray array];
        startagain = 8;
        waittimes = gameWait;
        _method = method;
        _msgtype = msgtype;
        _zhajinhuaresult    = @"Game.settleGame";//获取结果
        _method = @"startShellGame";
        _msgtype = @"19";
        _backimagename = @"海洋背景";
        _timeimage = @"闹钟";//倒计时背景
        _moneyvcbackimage = @"方框";//押注背景
        _pokerbackimag = @"贝壳2";//背景
        //接口
        _zhajinhuagameyazhu = @"Game.Cowry_Bet";//押注
        _zhajinhuakaishi    = @"Game.Cowry";//开始
        _zhajinhuaendgame = @"Game.Cowry_end";//游戏结束
        _pokerNums = 3;
        _isHostY = 30;
        if (ok) {
            _isHostY = 60;
            cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancleBtn setBackgroundColor:normalColors];
            [cancleBtn setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
            cancleBtn.frame = CGRectMake(80,30,60,30);

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
    }
    return self;
}
-(void)jumpwords{
    waittimes-=1;
    startwordsxin.text = [NSString stringWithFormat:@"%d",waittimes];
    CAKeyframeAnimation *cakanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    cakanimation.duration = 0.7;
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(4,4,1.0)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,1.4,1.0)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    cakanimation.values = @[value1,value2,value3,value4];
    [startwordsxin.layer addAnimation:cakanimation forKey:nil];
    cakanimation.removedOnCompletion = NO;
    cakanimation.fillMode = kCAFillModeForwards;
    if (waittimes == 0) {
        cancleBtn.hidden = NO;
        [kaishitimerxin invalidate];
        kaishitimerxin = nil;
        [startwordsxin removeFromSuperview];
        startwordsxin = nil;
        waittimes = gameWait;
        
    }
}
//展示*********************************************************
-(void)getShellResult:(NSArray *)array{

    [self kaishigetresult];
    [downBTN removeFromSuperview];
    downBTN = nil;
    NSArray *array0 = array[0];
    NSArray *array1 = array[1];
    NSArray *array2 = array[2];
    
    __block int a=0;
    __block int b=0;
    __block int c=0;
    if (resulttimer1) {
        [resulttimer1 invalidate];
        resulttimer1 = nil;
    }
    if (resulttimer2) {
        [resulttimer2 invalidate];
        resulttimer2 = nil;
    }
    if (resulttimer3) {
        [resulttimer3 invalidate];
        resulttimer3 = nil;
    }
    if (resulttimer4) {
        [resulttimer4 invalidate];
        resulttimer4 = nil;
    }
    if (resulttimer5) {
        [resulttimer5 invalidate];
        resulttimer5 = nil;
    }
    
    
    
    resulttimer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resultaction1) userInfo:nil repeats:NO];
   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<2; i++) {
            UIImageView *images = [self viewWithTag:2000+i];
            [images setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shell_%@",array0[a]]]];
            a+=1;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *VC = [self viewWithTag:3000];
            UIImageView *images = [[UIImageView alloc]initWithImage:[UIImage imageNamed: [NSString stringWithFormat:@"shell_%@",array0[3]]]];
            images.tag = 7000;
            images.frame = CGRectMake(40, 40,(_window_width-40)/2 - 80, 20);
            images.contentMode = UIViewContentModeScaleAspectFit;
            [VC addSubview:images];
            images.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.5f];
            images.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView commitAnimations];
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=2; i<4; i++) {
            UIImageView *images = [self viewWithTag:2000+i];
            [images setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shell_%@",array1[b]]]];
            
            b+=1;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *VC = [self viewWithTag:3001];
            
            UIImageView *images = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"shell_%@",array1[3]]]];
            images.tag = 7001;
            images.frame = CGRectMake(40, 40,(_window_width-40)/2 - 80, 20);
            images.contentMode = UIViewContentModeScaleAspectFit;
            [VC addSubview:images];
            images.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.5f];
            images.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView commitAnimations];
        });
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=4; i<6; i++) {
            UIImageView *images = [self viewWithTag:2000+i];
           
            [images setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shell_%@",array2[c]]]];
            c+=1;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *VC = [self viewWithTag:3002];
           
            UIImageView *images = [[UIImageView alloc]initWithImage:[UIImage imageNamed: [NSString stringWithFormat:@"shell_%@",array2[3]]]];
            images.tag = 7002;
            images.frame = CGRectMake(40, 40,(_window_width-40)/2 - 80, 20);
            images.contentMode = UIViewContentModeScaleAspectFit;
            [VC addSubview:images];
            images.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.5f];
            images.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            [UIView commitAnimations];
        });
    });
    startbtn.hidden = NO;
    __weak shellGame *selfself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *VC = [[UIView alloc]initWithFrame:bottomImage.bounds];
        VC.tag = 1001;
        VC.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        [bottomImage addSubview:VC];
        if ([array0[4] isEqual:@"1"]) {
            UIView *views = [self viewWithTag:3000];
            [views removeFromSuperview];
            [bottomImage addSubview:views];
        }else if ([array1[4] isEqual:@"1"]){
            UIView *views = [self viewWithTag:3001];
            [views removeFromSuperview];
            [bottomImage addSubview:views];
        }
        else if ([array2[4] isEqual:@"1"]){
            UIView *views = [self viewWithTag:3002];
            [views removeFromSuperview];
            [bottomImage addSubview:views];
        }
        [selfself getResult:array];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(9.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [selfself reloadVC];
    });
    
    
}
-(void)resultaction1{
    
    
}
//6个贝壳              2000
//三个方块             3000
//4个押注金额按钮       4000
//显示押注             5000  5500
//隐藏计数             6000
//三个结果             7000
//黑色遮罩             1001
-(void)setView{
    if (!bottomImage) {
        bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,_isHostY,_window_width,200)];
        bottomImage.userInteractionEnabled = YES;
        [bottomImage setImage:[UIImage imageNamed:_backimagename]];
        [self addSubview:bottomImage];
        CGFloat ww = (_window_width-40)/2;
        for (int i=0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setImage:[UIImage imageNamed:_moneyvcbackimage] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(stakePokers:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 3000+i;
            if (i==0) {
                btn.frame = CGRectMake(_window_width/2-ww/2,5,ww,85);
            }else if(i ==1){
                btn.frame = CGRectMake(10,95,ww,85);
            }else if(i ==2){
                btn.frame = CGRectMake(_window_width/2+10,95,ww,85);
            }
            [bottomImage addSubview:btn];
        }
        CGFloat www = (ww-60)/2;
        CGFloat xxx1 = 20;
        CGFloat xxx2 = 20;
        CGFloat xxx3 = 20;
        for (int i=0; i<6; i++) {
            UIImageView *images = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_pokerbackimag]];
            images.tag = 2000+i;
            if (i<2) {
                UIView *view = [self viewWithTag:3000];
                images.frame = CGRectMake(xxx1,15, www, www);
                xxx1 += www+15;
                [view addSubview:images];
            }
            else if (i>=2 && i<4){
                UIView *view = [self viewWithTag:3001];
                images.frame = CGRectMake(xxx2,15, www, www);
                xxx2 += www+15;
                [view addSubview:images];
            }
            else if (i>=4 && i<6)
            {
                UIView *view = [self viewWithTag:3002];
                images.frame = CGRectMake(xxx3,15, www, www);
                xxx3 += www+15;
                [view addSubview:images];
            }
        }
        for (int i=0; i<3; i++) {
            UILabel *showlabels;
            UILabel *hidelabels;
            UILabel *myLabels;
            UIView *view;
            if (i==0) {
                view = [self viewWithTag:3000];
            }
            else if (i==1)
            {
                view = [self viewWithTag:3001];
            }else if (i==2)
            {
                view = [self viewWithTag:3002];
            }
            showlabels = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 50,30,100,40)];
            showlabels.textAlignment = NSTextAlignmentCenter;
            showlabels.tag = 5000+i;
            showlabels.backgroundColor = [UIColor clearColor];
            [view addSubview:showlabels];
            showlabels.textColor = normalColors;
            showlabels.font = fontMT(25);
            hidelabels = [[UILabel alloc]initWithFrame:CGRectMake(0,30,80,40)];
            hidelabels.center = view.center;
            [view addSubview:hidelabels];
            hidelabels.textColor = [UIColor clearColor];
            hidelabels.tag = 6000+i;
            myLabels = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 100,0,200,30)];
            myLabels.textAlignment = NSTextAlignmentCenter;
            myLabels.tag = 5500+i;
            myLabels.backgroundColor = [UIColor clearColor];
            [view addSubview:myLabels];
            myLabels.textColor = [UIColor blackColor];
            myLabels.font = fontMT(23);
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
    
    
    [self CreateActionVC];
    if (_isHost) {
        if (starttime) {
            [starttime invalidate];
            starttime = nil;
        }
        starttime = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(start) userInfo:nil repeats:NO];
    }
    if (!startwordsxin) {
        startwordsxin = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 - 40, 80, 80, 80)];
        startwordsxin.textColor = [UIColor whiteColor];
        startwordsxin.font = fontMT(60);
        startwordsxin.textAlignment = NSTextAlignmentCenter;
        [self addSubview:startwordsxin];
    }
    if (!kaishitimerxin) {
        kaishitimerxin = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpwords) userInfo:nil repeats:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [gameState saveProfile:@"0"];//保存游戏开始状态
        });
    }
}
//2.主播开始发牌
-(void)reloadVC{
    //6个贝壳              2000
    //三个方块             3000
    //4个押注金额按钮       4000
    //显示押注             5000
    //隐藏计数             6000
    //三个结果             7000
    //黑色遮罩             1001
    
    for (int i=0; i<6; i++) {
        UIImageView *images = (UIImageView *)[self viewWithTag:2000+i];
        images.image = [UIImage imageNamed:_pokerbackimag];
    }
    for (int i=0; i<3; i++) {
        UILabel *labels = (UILabel *)[self viewWithTag:5000+i];
        labels.text = @"0";
    }
    for (int i=0; i<3; i++) {
        UILabel *labels = (UILabel *)[self viewWithTag:6000+i];
        labels.text = @"0";
    }
    for (int i=0; i<3; i++) {
        UIImageView *labels = (UIImageView *)[self viewWithTag:7000+i];
        [labels removeFromSuperview];
        labels = nil;
    }
    UIView *VCS = [self viewWithTag:1001];
    [VCS removeFromSuperview];
    VCS = nil;
  
}
-(void)startGame:(playSuccess)ok{
    //service=Game.Jinhua
    NSDictionary *subdic = @{
                             @"stream":[NSString stringWithFormat:@"%@",[self.zhuboDic valueForKey:@"stream"]],
                             @"liveuid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    [YBToolClass postNetworkWithUrl:_zhajinhuakaishi andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            _info = infos;
            [self.delagate prepGame:[infos valueForKey:@"gameid"] ndMethod:_method andMsgtype:_msgtype andBanklist:nil];
            cutDownNums = [[infos valueForKey:@"time"] intValue];
            [self startGamedaoshujishi];
            [self createUI];
            [self reloadVC];
            ok(@(code));

        }
    } fail:^{
        
    }];
}
//开始倒计时
-(void)startGamedaoshujishi{
    
    
    if (_isHost) {
        [self.delagate startGameSocketToken:[_info valueForKey:@"token"] andGameID:[_info valueForKey:@"gameid"] andTime:[_info valueForKey:@"time"] ndMethod:_method andMsgtype:_msgtype];
        if (!cutDownTimer) {
            cutDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cutdown) userInfo:nil repeats:YES];
        }
    }
}
-(void)movieplayStartCut:(NSString *)time andGameid:(NSString *)gameid{
    if (imageVS) {
        imageVS.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
        [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; //InOut 表示进入和出去时都启动动画
        [UIView setAnimationDuration:0.5f];//动画时间
        imageVS.transform=CGAffineTransformMakeScale(0.01f, 0.01f);//先让要显示的view最小直至消失
        [UIView commitAnimations]; //启动动画
    }
    if (kaishitimerxin) {
        [kaishitimerxin invalidate];
        kaishitimerxin = nil;
        waittimes = gameWait;//为了适配安卓加6秒
    }
    if(startwordsxin){
        [startwordsxin removeFromSuperview];
        startwordsxin = nil;
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
        [downBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (_isHost) {
            downBTN.frame = CGRectMake(_window_width/2 - 15,125,50,50);
        }
        else{
            downBTN.frame = CGRectMake(_window_width/2 - 15,95,50,50);
        }
        [self addSubview:downBTN];
        downBTN.hidden = YES;
    }
}
-(void)createUI{
    
    [imageVS removeFromSuperview];
    imageVS = nil;
    if (haidaoVS) {
        [haidaoVS removeFromSuperview];
        haidaoVS = nil;
    }
}
//倒计时
-(void)cutdown{
    [self createCutDownBTN];
    [downBTN setTitle:[NSString stringWithFormat:@"%d",cutDownNums] forState:UIControlStateNormal];
    if (cutDownNums == 0) {
        downBTN.hidden = YES;
        [cutDownTimer invalidate];
        cutDownTimer = nil;
        startbtn.hidden = NO;
    }
    else
    {
        downBTN.hidden = NO;
    }
    cutDownNums -=1;
}
-(void)getResult:(NSArray *)array{
    [downBTN removeFromSuperview];
    downBTN = nil;
    //开奖
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
  

    if (!_isHost) {
        if (resulttimer) {
            [resulttimer invalidate];
            resulttimer = nil;
        }
          resulttimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(resulttimeraction) userInfo:nil repeats:NO];
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
    if (!androidTimer) {
        androidTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startagain) userInfo:nil repeats:YES];
    }
    
    for (int i=0; i<3; i++) {
        
        UIView *VC5 = [self viewWithTag:5000 + i];
        UIView *VC6 = [self viewWithTag:6000 + i];
        UIView *VC7 = [self viewWithTag:5500 + i];
        [VC5 removeFromSuperview];
        [VC6 removeFromSuperview];
        [VC7 removeFromSuperview];
        VC5 = nil;
        VC6 = nil;
        VC7 = nil;
    }
    for (int i=0; i<3; i++) {
        UILabel *showlabels;
        UILabel *hidelabels;
        UILabel *myLabels;
        UIView *view;
        if (i==0) {
            view = [self viewWithTag:3000];
        }
        else if (i==1)
        {
            view = [self viewWithTag:3001];
        }else if (i==2)
        {
            view = [self viewWithTag:3002];
        }
        showlabels = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 50,30,100,40)];
        showlabels.textAlignment = NSTextAlignmentCenter;
        showlabels.tag = 5000+i;
        showlabels.backgroundColor = [UIColor clearColor];
        [view addSubview:showlabels];
        showlabels.textColor = normalColors;
        showlabels.font = fontMT(25);
        hidelabels = [[UILabel alloc]initWithFrame:CGRectMake(0,30,80,40)];
        hidelabels.center = view.center;
        [view addSubview:hidelabels];
        hidelabels.textColor = [UIColor clearColor];
        hidelabels.tag = 6000+i;
        myLabels = [[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2 - 100,0,200,30)];
        myLabels.textAlignment = NSTextAlignmentCenter;
        myLabels.tag = 5500+i;
        myLabels.backgroundColor = [UIColor clearColor];
        [view addSubview:myLabels];
        myLabels.textColor = [UIColor blackColor];
        myLabels.font = fontMT(23);
    }
}
-(void)resulttimeraction{
    
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"gameid":_gameid
                             };
    [YBToolClass postNetworkWithUrl:_zhajinhuaresult andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            NSString *gamecoin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"gamecoin"]];
            LiveUser *user = [Config myProfile];
            user.coin = [NSString stringWithFormat:@"%@",[infos valueForKey:@"coin"]];
            [Config updateProfile:user];
            
            int success = [gamecoin intValue];
            if (success >0) {
                NSString *money = [NSString stringWithFormat:@"%@%@",gamecoin,[common name_coin]];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"赢了哦") message:money delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                [alert show];
            }
            
            else  {
                //没中奖
                
                
                
            }

        }
    } fail:^{
        
    }];
}
-(void)startagain{
    startagain -=1;
    if (startagain == 0) {
        startagain = 8;
        [androidTimer invalidate];
        androidTimer = nil;
        if (_isHost) {
            if (starttime) {
                [starttime invalidate];
                starttime = nil;
            }
            starttime = [NSTimer scheduledTimerWithTimeInterval:9.0 target:self selector:@selector(start) userInfo:nil repeats:NO];
        }
        if (!startwordsxin) {
            startwordsxin = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 - 40, 80, 80, 80)];
            startwordsxin.textColor = [UIColor whiteColor];
            startwordsxin.font = fontMT(60);
            startwordsxin.text = [NSString stringWithFormat:@"%d",waittimes];
            startwordsxin.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:startwordsxin];
        }
        if (!kaishitimerxin) {
            kaishitimerxin = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(jumpwords) userInfo:nil repeats:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [gameState saveProfile:@"0"];//保存游戏开始状态
            });
        }
    }
}
-(void)gameOver{
    startbtn.hidden = NO;
    for (int i=0; i<3; i++) {
        
        UIView *VC1 = [self viewWithTag:2000 +i];
        UIView *VC3 = [self viewWithTag:3000 + i];
        UIView *VC4 = [self viewWithTag:4000 + i];
        UIView *VC5 = [self viewWithTag:5000 + i];
        UIView *VC6 = [self viewWithTag:6000 + i];
        UIView *VC7 = [self viewWithTag:7000 + i];
        
        [VC1 removeFromSuperview];
        [VC3 removeFromSuperview];
        
        VC1 = nil;
        VC3 = nil;
        
        [VC4 removeFromSuperview];
        [VC5 removeFromSuperview];
        [VC6 removeFromSuperview];
        [VC7 removeFromSuperview];
        
        VC4 = nil;
        VC5 = nil;
        VC6 = nil;
        VC7 = nil;
        
        
    }
    for (UIButton *btns in bottomImage.subviews) {
        if ([btns isKindOfClass:[MoneyVC class]]) {
            [btns removeFromSuperview];
        }
    }
    [downBTN removeFromSuperview];
    downBTN = nil;
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    if (kaishitimerxin) {
        [kaishitimerxin invalidate];
        kaishitimerxin = nil;
    }
    if (androidTimer) {
        [androidTimer invalidate];
        androidTimer = nil;
    }
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
    if (touchVoice) {
        [touchVoice stop];
        touchVoice = nil;
    }
}
-(void)releaseAll{
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
    if (androidTimer) {
        [androidTimer invalidate];
        androidTimer = nil;
    }
    if (kaishitimerxin) {
        [kaishitimerxin invalidate];
        kaishitimerxin = nil;
    }
    if(startwordsxin){
        [startwordsxin removeFromSuperview];
        startwordsxin = nil;
    }
    
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    if (starttime) {
        [starttime invalidate];
        starttime = nil;
    }
    if (touchVoice) {
        [touchVoice stop];
        touchVoice = nil;
    }
}
-(void)dealloc{
    if (resulttimer) {
        [resulttimer invalidate];
        resulttimer = nil;
    }
    if (touchVoice) {
        [touchVoice stop];
        touchVoice = nil;
    }
    if (androidTimer) {
        [androidTimer invalidate];
        androidTimer = nil;
    }
    if (kaishitimerxin) {
        [kaishitimerxin invalidate];
        kaishitimerxin = nil;
    }
    if(startwordsxin){
        [startwordsxin removeFromSuperview];
        startwordsxin = nil;
    }
    if (gameVoicePlayer) {
        [gameVoicePlayer stop];
        gameVoicePlayer = nil;
    }
    if (starttime) {
        [starttime invalidate];
        starttime = nil;
    }
    [self gameOver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"startYaZhu" object:nil];
}
//预告开始文字
-(void)kaishiapai{
    if (imageVS) {
        imageVS.hidden = NO;
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
//用户投注***********************************************************
-(void)CreateActionVC{
    if (_isHost) {
        return;
    }
    bottomV = [[UIView alloc]initWithFrame:CGRectMake(0,230,_window_width,30)];
    [self addSubview:bottomV];
    //创建4个押注按钮
    NSArray *array = @[@"10",@"100",@"1000",@"1万"];
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
    CGFloat x = _window_width - 30;
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animationvc = [[animationBtnV alloc]initWithFrame:CGRectMake(x,0,40,40)];
        animationvc.userInteractionEnabled = YES;
        [animationvc.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"按钮%d",i+1]]];
        if (i == 0) {
            [animationvc.bottomImage setImage:[UIImage imageNamed:@"按钮1"]];
            [animationvc setAnimation];
        }
        [animationvc.frontButton setTitle:array[i] forState:UIControlStateNormal];
        [animationvc.frontButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        animationvc.tag = 4000 + i;
        [animationvc.frontButton addTarget:self action:@selector(stake:) forControlEvents:UIControlEventTouchDown];
        x -= 40;
        [bottomV addSubview:animationvc];
        animationvc.backgroundColor = [UIColor clearColor];
    }
    //[self addtableview];
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
//押注 //选择类型
-(void)stake:(UIButton *)sender{
    NSString *stakeS = sender.titleLabel.text;
    _money = stakeS;
    for (int i = 3; i >= 0; i--) {
        animationBtnV *animation = [self viewWithTag:4000 + i];
        [animation.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"按钮%d",i+1]]];
        [animation stopAnimation];
        if ([animation.frontButton.titleLabel.text isEqual:stakeS]) {
            [animation.bottomImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"按钮%d",i+1]]];
            [animation setAnimation];
        }
    }
}
//点击押注
-(void)stakePokers:(UIButton *)sender{
    if (cutDownNums  < 3) {
        
        
        return;
    }
    if (_isHost) {
        
        
        return;
    }
    if ([_money isEqual:@"0"]) {
        
        
        return;
    }
    if ([_money isEqual:@"1万"]) {
        
        _money = @"10000";
        
    }
    NSInteger g = sender.tag - 3000 + 1;
    NSString *grade = [NSString stringWithFormat:@"%ld",g];

    NSDictionary *subdic = @{
                             @"stream":[NSString stringWithFormat:@"%@",[self.zhuboDic valueForKey:@"stream"]],
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
            UILabel *btns = [self viewWithTag:5500+asele - 1];
            NSString *myCoins = btns.text;
            float all = [myCoins floatValue];
            float single = [_money floatValue];
            all +=single;
            btns.text = [NSString stringWithFormat:@"%d",(int)all];

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
-(void)getShellCoin:(NSString *)type andMoney:(NSString *)money{
    UILabel *btns = [self viewWithTag:6000+[type intValue] - 1];
    UILabel *btns2 = [self viewWithTag:5000+[type intValue] - 1];
    float all = [btns.text floatValue];
    float single = [money floatValue];
    all +=single;
    btns.text = [NSString stringWithFormat:@"%d",(int)all];
    if (all >= 10000) {
        all = all/10000;
        btns2.text = [NSString stringWithFormat:@"%.1f万",all];
    }else{
        btns2.text = [NSString stringWithFormat:@"%d",(int)all];
    }
    CAKeyframeAnimation *cakanimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    cakanimation.duration = 0.1;
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(4,4,1.0)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.4,1.4,1.0)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)];
    cakanimation.values = @[value1,value2,value3,value4];
    [btns2.layer addAnimation:cakanimation forKey:nil];
    cakanimation.removedOnCompletion = NO;
    cakanimation.fillMode = kCAFillModeForwards;
}
//中途加入的
-(void)getNewCOins:(NSArray *)array{
    for (int i=0; i<3; i++) {
        UILabel *btns =  [self viewWithTag:6000+i];
        UILabel *btns2 =  [self viewWithTag:5000+i];
        float single = [[array objectAtIndex:i] floatValue];
        btns.text = [NSString stringWithFormat:@"%d",(int)single];
        if (single >= 10000) {
            single = single/10000;
            btns2.text = [NSString stringWithFormat:@"%.1f万",single];
        }else{
            btns2.text = [NSString stringWithFormat:@"%d",(int)single];
        }
    }
}
-(void)getmyCOIns:(NSArray *)arrays{
    for (int i=0; i<3; i++) {
        UILabel *btns = [self viewWithTag:5500+i];
        float all = [arrays[i] floatValue];
        btns.text = [NSString stringWithFormat:@"%d",(int)all];
    }
}
@end
