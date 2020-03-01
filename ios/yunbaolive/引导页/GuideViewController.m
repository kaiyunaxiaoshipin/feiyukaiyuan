//
//  GuideViewController.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "GuideViewController.h"
#import "PhoneLoginVC.h"
#import "ZYTabBarController.h"
#import "AppDelegate.h"
#import "YBWebViewController.h"
@interface GuideViewController (){
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    int curIndex;
}
@property (nonatomic,strong) NSArray *listArray;
@property (nonatomic,strong) NSTimer *progressTimer;
@property (nonatomic,assign) int showTime;
@property (nonatomic,assign) int allTime;
@property (nonatomic,assign) CGFloat countTime;
@property (nonatomic,strong) UIButton *circleBtn;
@property (nonatomic,strong) UIButton *jumpBtn;
@property (nonatomic,strong) NSMutableArray *imgaeArray;
@property (nonatomic,strong) UIImageView *launchImgaeV;
@property (nonatomic,strong) NSURL *videoUrl;
@property (nonatomic,strong) AVPlayer *videoPlayer;
@property (nonatomic,strong) AVPlayerLayer *videoLayer;
//监听播放起状态的监听者
@property (nonatomic ,strong) id playerTimeObserver;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    _launchImgaeV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _launchImgaeV.image = [[YBToolClass sharedInstance] getLaunchImage];
    [self.view addSubview:_launchImgaeV];

    [self requestData];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goWeb)];
    [self.view addGestureRecognizer:tap];
}
- (void)requestData{
    
    [YBToolClass postNetworkWithUrl:@"Guide.GetGuide" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            curIndex = 0;
            NSDictionary *infoDIc = [info firstObject];
            if ([minstr([infoDIc valueForKey:@"switch"]) isEqual:@"1"]) {
                _listArray = [infoDIc valueForKey:@"list"];

                if ([minstr([infoDIc valueForKey:@"type"]) isEqual:@"0"]) {
                    _showTime = [minstr([infoDIc valueForKey:@"time"]) intValue];
                    _allTime = _showTime * (int)_listArray.count;
                    [self showPic];
                }else{
                    if (_listArray.count > 0) {
                        _videoUrl = [NSURL URLWithString:minstr([_listArray[0] valueForKey:@"thumb"])];
                        [self showVideo];
                    }else{
                        [self jumpBtnClick];
                    }
                }
            }else{
                [self jumpBtnClick];
            }
        }else{
            [self jumpBtnClick];
        }
    } fail:^{
        [self jumpBtnClick];
    }];


}
- (void)showPic{

        _imgaeArray = [NSMutableArray array];
        _countTime = 0.1;
        for (int i = 0; i < _listArray.count; i ++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            imageV.clipsToBounds = YES;
            imageV.userInteractionEnabled = YES;
            [self.view addSubview:imageV];
            if (i == 0) {
                imageV.hidden = NO;
    //            firstImgV = imageV;
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:minstr([_listArray[i] valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    imageV.image = image;
                    _launchImgaeV.hidden = YES;
                }];
            }else{
                imageV.hidden = YES;
                [imageV sd_setImageWithURL:[NSURL URLWithString:minstr([_listArray[i] valueForKey:@"thumb"])]];
    
            }
            [_imgaeArray addObject:imageV];
        }
        _circleBtn = [UIButton buttonWithType:0];
        _circleBtn.frame = CGRectMake(_window_width-50, 40+statusbarHeight, 40, 40);
        [_circleBtn setTitle:@"跳过" forState:0];
        _circleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _circleBtn.layer.cornerRadius = 20;
        _circleBtn.layer.masksToBounds = YES;
        [_circleBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_circleBtn setBackgroundColor:RGB_COLOR(@"#000000", 0.5)];
        [self.view addSubview:_circleBtn];
        float centerX = _circleBtn.width/2.0;
        float centerY = _circleBtn.height/2.0;
        //半径
        float radius = (_circleBtn.width-3)/2.0;
    
        //创建贝塞尔路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:1.5f*M_PI clockwise:YES];
    
        //添加背景圆环
    
        CAShapeLayer *backLayer = [CAShapeLayer layer];
        backLayer.frame = _circleBtn.bounds;
        backLayer.fillColor =  [[UIColor clearColor] CGColor];
        backLayer.strokeColor  = [UIColor whiteColor].CGColor;
        backLayer.lineWidth = 3;
        backLayer.path = [path CGPath];
        backLayer.strokeEnd = 1;
        [_circleBtn.layer addSublayer:backLayer];
    
        //创建进度layer
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = _circleBtn.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = 3;
        _progressLayer.path = [path CGPath];
        _progressLayer.strokeEnd = 0;
    
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = _circleBtn.bounds;
        [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB_COLOR(@"#ff7200", 1) CGColor],(id)[RGB_COLOR(@"#ff7200", 1) CGColor], nil]];//normalColors
        gradientLayer.startPoint = CGPointMake(1, 1);
        gradientLayer.endPoint = CGPointMake(0, 0);
        [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
        [_circleBtn.layer addSublayer:gradientLayer];
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:_countTime target:self selector:@selector(progresTimeDaoJiShi) userInfo:nil repeats:YES];
    _launchImgaeV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _launchImgaeV.image = [[YBToolClass sharedInstance] getLaunchImage];
    [self.view addSubview:_launchImgaeV];

}
- (void)showVideo{
    AVPlayer *player = [AVPlayer playerWithURL:_videoUrl];
    player.volume = 1.0;
    self.videoPlayer = player;
    _videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
    _videoLayer.videoGravity = AVLayerVideoGravityResize;
    _videoLayer.position = CGPointMake(_window_width/2, _window_height/2);
    _videoLayer.bounds = self.view.bounds;
    
    //Layer只能添加到Layer上面
    [self.view.layer addSublayer:_videoLayer];
    
    AVPlayerItem *playerItem = self.videoPlayer.currentItem;
    
    // 给AVPlayer添加观察者 必须实现 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context；
    
    //监控状态属性(AVPlayer也有一个status属性，通过监控它的status也可以获得播放状态)
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    __weak typeof(self)WeakSelf = self;

    //播放进度观察者  //设置每0.1秒执行一次
    _playerTimeObserver =  [self.videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, NSEC_PER_SEC) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //进度 当前时间/总时间
        CGFloat progress = CMTimeGetSeconds(WeakSelf.videoPlayer.currentItem.currentTime) / CMTimeGetSeconds(WeakSelf.videoPlayer.currentItem.duration);
        if (progress > 0.0f) {
            [WeakSelf creatJumpBtn];
        }
    }];
    [self.videoPlayer play];
    
    _launchImgaeV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _launchImgaeV.image = [[YBToolClass sharedInstance] getLaunchImage];
    [self.view addSubview:_launchImgaeV];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.videoPlayer.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)progresTimeDaoJiShi{
    _countTime += 0.1;
    _progressLayer.strokeEnd = _countTime/_allTime;
    [_progressLayer removeAllAnimations];
    int aaaa = _countTime *10;
    if (aaaa % (_showTime * 10) == 0) {
        int index = aaaa / (_showTime * 10);
        if (index < _imgaeArray.count) {
            curIndex = index;
            UIImageView *imgaeV = _imgaeArray[index-1];
            UIImageView *nextImgaeV = _imgaeArray[index];
            imgaeV.hidden = YES;
            nextImgaeV.hidden = NO;
        }
    }
    if (_countTime >= _allTime) {
        [self jumpBtnClick];
    }
}
- (void)jumpBtnClick{
    [self stop];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    UINavigationController *nav;
    if ([Config getOwnID]) {
        nav = [[UINavigationController alloc]initWithRootViewController:[[ZYTabBarController alloc]init]];
    }else{
        nav = [[UINavigationController alloc]initWithRootViewController:[[PhoneLoginVC alloc]init]];
    }
    app2.window.rootViewController = nav;

}
- (void)stop{
    if (_progressTimer) {
        [_progressTimer invalidate];
        _progressTimer = nil;
    }else{
        [_videoPlayer pause];
        _videoLayer = nil;
        [self.videoPlayer.currentItem removeObserver:self forKeyPath:@"status"];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.videoPlayer.currentItem];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }

}
- (void)playFinished:(NSNotification *)not{
    [self jumpBtnClick];
}
#pragma mark
#pragma mark 进入后台
- (void)appDidEnterBackground:(NSNotification*)note
{
        NSArray *tracks = [self.videoPlayer.currentItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        self.videoLayer.player = nil;
        self.videoPlayer.volume = 0;
        [self.videoPlayer play];
}
#pragma mark
#pragma mark 进入前台
- (void)appWillEnterForeground:(NSNotification*)note
{
        NSArray *tracks = [self.videoPlayer.currentItem tracks];
        for (AVPlayerItemTrack *playerItemTrack in tracks) {
            if ([playerItemTrack.assetTrack hasMediaCharacteristic:AVMediaCharacteristicVisual]) {
                playerItemTrack.enabled = YES;
            }
        }
        self.videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.videoPlayer];
        self.videoLayer.frame = self.view.bounds;
        self.videoLayer.videoGravity = AVLayerVideoGravityResize;
        [self.view.layer insertSublayer:_videoLayer atIndex:0];
        self.videoPlayer.volume = 1;
        [self.videoPlayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerStatusUnknown:
            {
                
            }
                break;
                
            case AVPlayerStatusReadyToPlay:
            {
//                [self creatJumpBtn];
            }
                break;
                
            case AVPlayerStatusFailed:
            {
                [self jumpBtnClick];
            }
                break;
        }
        
    }

}
- (void)creatJumpBtn{
    if (!_jumpBtn) {
        _launchImgaeV.hidden = YES;
        _jumpBtn = [UIButton buttonWithType:0];
        _jumpBtn.frame = CGRectMake(_window_width-50, 40+statusbarHeight, 40, 25);
        [_jumpBtn setTitle:@"跳过" forState:0];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _jumpBtn.layer.cornerRadius = 12.5;
        _jumpBtn.layer.masksToBounds = YES;
        _jumpBtn.layer.borderWidth = 1;
        _jumpBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [ _jumpBtn addTarget:self action:@selector(jumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [ _jumpBtn setBackgroundColor:RGB_COLOR(@"#000000", 0.5)];
        [self.view addSubview: _jumpBtn];
    }
    

}
- (void)goWeb{
    [self stop];
    YBWebViewController *web = [[YBWebViewController alloc]init];
    web.urls = minstr([_listArray[curIndex] valueForKey:@"href"]);
    web.isGuide = YES;
    [self.navigationController pushViewController:web animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
