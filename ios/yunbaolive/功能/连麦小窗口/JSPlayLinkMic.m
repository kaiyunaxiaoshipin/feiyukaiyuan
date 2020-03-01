//
//  JSPlayLinkMic.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/6/1.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "JSPlayLinkMic.h"
@implementation JSPlayLinkMic
-(instancetype)initWithRTMPURL:(NSDictionary *)dic andFrame:(CGRect)frames andisHOST:(BOOL)ishost{
    self = [super initWithFrame:frames];
    
    _subdic = [NSDictionary dictionaryWithDictionary:dic];
    
    _playurl = [NSString stringWithFormat:@"%@",[dic valueForKey:@"playurl"]];
    _pushurl = [NSString stringWithFormat:@"%@",[dic valueForKey:@"pushurl"]];

    if (self) {
        _ishost = ishost;
        _notification = [CWStatusBarNotification new];
        _notification.notificationLabelBackgroundColor = [UIColor redColor];
        _notification.notificationLabelTextColor = [UIColor whiteColor];
        
        
        if ([_pushurl isEqual:@"0"]) {
            [self RTMPPlay:frames];
        }
        else{
            [self RTMPPUSH:frames];
        }
        loadingImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frames.size.width, frames.size.height)];
        loadingImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:loadingImage];
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"loading_image0.png"],
                                 [UIImage imageNamed:@"loading_image1.png"],
                                 [UIImage imageNamed:@"loading_image2.png"],
                                 [UIImage imageNamed:@"loading_image3.png"],
                                 [UIImage imageNamed:@"loading_image4.png"],
                                 [UIImage imageNamed:@"loading_image5.png"],
                                 [UIImage imageNamed:@"loading_image6.png"],
                                 [UIImage imageNamed:@"loading_image7.png"],
                                 [UIImage imageNamed:@"loading_image8.png"],
                                 [UIImage imageNamed:@"loading_image9.png"],
                                 [UIImage imageNamed:@"loading_image10.png"],
                                 [UIImage imageNamed:@"loading_image11.png"],
                                 [UIImage imageNamed:@"loading_image12.png"],
                                 [UIImage imageNamed:@"loading_image13.png"],
                                 [UIImage imageNamed:@"loading_image14.png"],
                                 nil];
        //要展示的动画
        loadingImage.animationImages=array;
        //一次动画的时间
        loadingImage.animationDuration= [array count]*0.1;
        //只执行一次动画
        loadingImage.animationRepeatCount = MAXFLOAT;
        //开始动画
        [loadingImage startAnimating];
        
        
        //直播间观众—关闭
        UIButton  *_returnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnCancle.tintColor = [UIColor whiteColor];
        [_returnCancle setImage:[UIImage imageNamed:@"直播间观众—关闭"] forState:UIControlStateNormal];
        _returnCancle.backgroundColor = [UIColor clearColor];
        [_returnCancle setTitle:[dic valueForKey:@"userid"] forState:UIControlStateNormal];
        [_returnCancle setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_returnCancle addTarget:self action:@selector(returnCancles:) forControlEvents:UIControlEventTouchUpInside];
        _returnCancle.frame = CGRectMake(frames.size.width-30, 0, 30, 30);
        _returnCancle.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _returnCancle.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self addSubview:_returnCancle];
        
        
        if (_ishost) {
            _returnCancle.hidden = NO;
        }else{
            _returnCancle.hidden = YES;
        }
        
        
    }
    return self;
}
-(void)returnCancles:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(sender){
            sender.userInteractionEnabled = YES;
        }
    });
    if ([self.delegate respondsToSelector:@selector(js_closeuserconnect:)]) {
        [self.delegate js_closeuserconnect:sender.titleLabel.text];
    }
    [self removeFromSuperview];
}
-(void)RTMPPUSH:(CGRect)frames{
    if (_gpuStreamer) {
        [_gpuStreamer stopPreview];
        _gpuStreamer = nil;
    }
    _gpuStreamer = [[KSYGPUStreamerKit alloc]initWithDefaultCfg];
    [_gpuStreamer.preview setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
    _gpuStreamer.aCapDev.micVolume = 1.0;
    [_gpuStreamer startPreview:self];
    
    KSYGPUBeautifyExtFilter *_filter = [[KSYGPUBeautifyExtFilter alloc] init];
    [_gpuStreamer setupFilter: _filter];
    [(KSYGPUBeautifyExtFilter *)_filter setBeautylevel:5];//level 1.0 ~ 5.0
    _gpuStreamer.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [_gpuStreamer.streamerBase startStream:[NSURL URLWithString:_pushurl]];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addObservers];
//    });

//    if (!_txLivePushonfig) {
//        _txLivePushonfig = [[TXLivePushConfig alloc] init];
//        _txLivePushonfig.frontCamera = YES;
//        _txLivePushonfig.enableAutoBitrate = NO;
//        _txLivePushonfig.pauseFps = 10;
//        _txLivePushonfig.pauseTime = 300;
//        _txLivePushonfig.pauseImg = [UIImage imageNamed:@"pause_publish.jpg"];
//    }
//    if (!_txLivePush) {
//        _txLivePush = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
//
//        _txLivePush.delegate = self;
//    }
//    [_txLivePush startPreview:self];
//    [_txLivePush setBeautyStyle:0 beautyLevel:5 whitenessLevel:0 ruddinessLevel:0];
//    [_txLivePush startPush:_pushurl];
}
- (void) addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onStreamStateChange:)
                                                 name:KSYStreamStateDidChangeNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onNetStateEvent:)
                                                 name:KSYNetStateEventNotification
                                               object:nil];
}
- (void) removeObsever {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KSYStreamStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KSYNetStateEventNotification object:nil];
}

- (void) onNetStateEvent:(NSNotification *)notification {
    KSYNetStateCode netEvent = _gpuStreamer.streamerBase.netStateCode;
    //NSLog(@"net event : %ld", (unsigned long)netEvent );
    if ( netEvent == KSYNetStateCode_SEND_PACKET_SLOW ) {
        
        NSLog(@"发送包时间过长，( 单次发送超过 500毫秒 ）");
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_RAISE ) {
        
        NSLog(@"估计带宽调整，上调" );
    }
    else if ( netEvent == KSYNetStateCode_EST_BW_DROP ) {
        
        
        NSLog(@"估计带宽调整，下调" );
    }
    else if ( netEvent == KSYNetStateCode_KSYAUTHFAILED ) {
        
        NSLog(@"SDK 鉴权失败 (暂时正常推流5~8分钟后终止推流)" );
    }
}
- (void) onStreamStateChange:(NSNotification *)notification {
    if ( _gpuStreamer.streamerBase.streamState == KSYStreamStateIdle) {
        NSLog(@"推流状态:初始化时状态为空闲");
    }
    else if ( _gpuStreamer.streamerBase.streamState == KSYStreamStateConnected){
        NSLog(@"推流状态:已连接");
        if ([self.delegate respondsToSelector:@selector(js_startConnectRtmpForLink_mic)]) {
            [self.delegate js_startConnectRtmpForLink_mic];//开始连麦推流
        }
        [loadingImage removeFromSuperview];
        loadingImage = nil;

        //        [self changePlayState:1];//推流成功后改变直播状态
        if (_gpuStreamer.streamerBase.streamErrorCode == KSYStreamErrorCode_KSYAUTHFAILED ) {
            //(obsolete)
            NSLog(@"推流错误:(obsolete)");
            [_notification displayNotificationWithMessage:@"推流错误，结束连麦" forDuration:5];
            if ([self.delegate respondsToSelector:@selector(js_stoppushlink)]) {
                [self.delegate js_stoppushlink];
            }

        }
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateConnecting ) {
        NSLog(@"推流状态:连接中");
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateDisconnecting ) {
        NSLog(@"推流状态:断开连接中");
        //        [self onStreamError];
        [_notification displayNotificationWithMessage:@"推流失败，结束连麦" forDuration:5];
        if ([self.delegate respondsToSelector:@selector(js_stoppushlink)]) {
            [self.delegate js_stoppushlink];
        }

    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateError ) {
        NSLog(@"推流状态:推流出错");
        //        [self onStreamError];
        [_notification displayNotificationWithMessage:@"推流失败，结束连麦" forDuration:5];
        if ([self.delegate respondsToSelector:@selector(js_stoppushlink)]) {
            [self.delegate js_stoppushlink];
        }

        return;
    }
}

-(void)RTMPPlay:(CGRect)frames{
    _player =  [[KSYMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:_playurl]];
    _player.view.backgroundColor = [UIColor clearColor];
    [_player.view setFrame: self.bounds];  // player's frame must match parent's
    [self addSubview: _player.view];
    _player.shouldAutoplay = TRUE;
    _player.bInterruptOtherAudio = NO;
    _player.shouldEnableKSYStatModule = TRUE;
    _player.scalingMode = MPMovieScalingModeAspectFill;
    [_player prepareToPlay];
    [_player setVolume:2.0 rigthVolume:2.0];
    _player.videoDecoderMode = MPMovieVideoDecoderMode_AUTO;
    [self setupObservers];

}
- (void)setupObservers
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerLoadStateDidChangeNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMovieNaturalSizeAvailableNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerSuggestReloadNotification)
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackStatusNotification)
                                              object:nil];
    
}
-(void)handlePlayerNotify:(NSNotification*)notify
{
    if (!_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        NSLog(@"KSYPlayerVC: %@ -- ip:%@", _playurl, [_player serverAddress]);
        //移除开场加载动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loadingImage removeFromSuperview];
            loadingImage = nil;
        });
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
        
        [_player reload:[NSURL URLWithString:_playurl] flush:NO];
    }
}

- (void)stopConnect{
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
}
-(void)stopPush{
    NSLog(@"结束推流");
    [self removeObsever];
    [_gpuStreamer.streamerBase stopStream];
    [_gpuStreamer stopPreview];
    _gpuStreamer = nil;
//    [_txLivePush stopPreview];
//    [_txLivePush stopPush];
    
}
-(void)onNetStatus:(NSDictionary *)param{
    
    
    
}
-(void)dealloc{
    [self removeObsever];
    if (_gpuStreamer) {
        [_gpuStreamer.streamerBase stopStream];
        [_gpuStreamer stopPreview];
        _gpuStreamer = nil;
    }
    if (_player) {
        [_player stop];
        [_player.view removeFromSuperview];
        _player = nil;
    }
}
@end
