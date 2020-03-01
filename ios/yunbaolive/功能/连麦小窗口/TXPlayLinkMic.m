//
//  TXPlayLinkMic.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/6/1.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "TXPlayLinkMic.h"

@interface TXPlayLinkMic()
{
    UIButton  *_returnCancle;
}
@end

@implementation TXPlayLinkMic
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
        _returnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnCancle.tintColor = [UIColor whiteColor];
        [_returnCancle setImage:[UIImage imageNamed:@"直播间观众—关闭"] forState:UIControlStateNormal];
        _returnCancle.backgroundColor = [UIColor clearColor];
        [_returnCancle setTitle:[dic valueForKey:@"userid"] forState:UIControlStateNormal];
        [_returnCancle setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [_returnCancle addTarget:self action:@selector(returnCancles:) forControlEvents:UIControlEventTouchUpInside];
        _returnCancle.frame = CGRectMake(frames.size.width-37, 3, 34, 34);
        _returnCancle.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_returnCancle];
        
        
        if (_ishost) {
            _returnCancle.hidden = NO;
        }else{
            _returnCancle.hidden = YES;
        }
        
    }
    return self;
}

- (void)appactive{
    [_txLivePush resumePush];
}
- (void)appnoactive{
//    [_txLivePush pausePush];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)returnCancles:(UIButton *)sender{
    
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(sender){
            sender.userInteractionEnabled = YES;
        }
    });
    if ([self.delegate respondsToSelector:@selector(tx_closeuserconnect:)]) {
        [self.delegate tx_closeuserconnect:sender.titleLabel.text];
    }
    [self removeFromSuperview];
}
-(void)RTMPPUSH:(CGRect)frames{
    UIView *preView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frames.size.width, frames.size.height)];
    [self addSubview:preView];
    
    if (!_txLivePushonfig) {
        _txLivePushonfig = [[TXLivePushConfig alloc] init];
        _txLivePushonfig.frontCamera = YES;
        _txLivePushonfig.enableAutoBitrate = NO;
        _txLivePushonfig.pauseFps = 10;
        _txLivePushonfig.pauseTime = 300;
        _txLivePushonfig.pauseImg = [UIImage imageNamed:@"pause_publish.jpg"];
    }
    if (!_txLivePush) {
        _txLivePush = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
       
        _txLivePush.delegate = self;
    }
    [_txLivePush startPreview:preView];
    [_txLivePush setBeautyStyle:0 beautyLevel:5 whitenessLevel:0 ruddinessLevel:0];
    [_txLivePush startPush:_pushurl];
    //注册进入后台的处理
    NSNotificationCenter* dc = [NSNotificationCenter defaultCenter];
    [dc addObserver:self
           selector:@selector(appactive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    [dc addObserver:self
           selector:@selector(appnoactive)
               name:UIApplicationWillResignActiveNotification
             object:nil];

}
-(void)RTMPPlay:(CGRect)frames{
    if (!_config) {
        _config = [[TXLivePlayConfig alloc] init];
        //自动模式
        _config.bAutoAdjustCacheTime   = YES;
        _config.minAutoAdjustCacheTime = 1;
        _config.maxAutoAdjustCacheTime = 5;
        _txLivePlayer =[[TXLivePlayer alloc] init];
        if (ios8) {
            _txLivePlayer.enableHWAcceleration = false;
           
        }
        else{
            _txLivePlayer.enableHWAcceleration = YES;

        }
        [_txLivePlayer setupVideoWidget:frames containView:self insertIndex:0];
        [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        [_txLivePlayer setConfig:_config];
    }
    if(_txLivePlayer != nil)
    {
        _txLivePlayer.delegate = self;
        NSString *playUrl = _playurl;
        NSInteger _playType = 0;
        if ([playUrl hasPrefix:@"rtmp:"]) {
            _playType = PLAY_TYPE_LIVE_RTMP;
        } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".flv"].length > 0) {
            _playType = PLAY_TYPE_LIVE_FLV;
            
        } else{
            [_notification displayNotificationWithMessage:@"播放地址不合法，直播目前仅支持rtmp,flv播放方式!" forDuration:5];
        }
        int result = [_txLivePlayer startPlay:playUrl type:PLAY_TYPE_LIVE_RTMP_ACC];//RTMP直播加速播放
        NSLog(@"play_linkMicwangminxin%d",result);
        if (result == -1)
        {
            
        }
        if( result != 0)
        {
            [_notification displayNotificationWithMessage:@"视频流播放失败" forDuration:5];
        }
        if( result == 0){
            
            
        }
    }
}
//播放监听事件
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            NSLog(@"play_linkMic已经连接服务器");
        }
        else if (EvtID == PLAY_EVT_RTMP_STREAM_BEGIN){
            NSLog(@"play_linkMic已经连接服务器，开始拉流");
        }
        else if (EvtID == PLAY_EVT_PLAY_BEGIN){
            NSLog(@"play_linkMic视频播放开始");
            [loadingImage removeFromSuperview];
            loadingImage = nil;
        }
        else if (EvtID== PLAY_WARNING_VIDEO_PLAY_LAG){
            NSLog(@"play_linkMic当前视频播放出现卡顿（用户直观感受）");
        }
        else if (EvtID == PLAY_EVT_PLAY_END){
            NSLog(@"play_linkMic视频播放结束");
        }
        else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            NSLog(@"play_linkMic网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
//            if ([self.delegate respondsToSelector:@selector(tx_closeUserbyVideo:)]) {
//                [self.delegate tx_closeUserbyVideo:_subdic];
//            }
            [self returnCancles:_returnCancle];
        }
    });
}
//推流监听
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID >= 0) {
            if (EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL)
            {
                _txLivePush.config.enableHWAcceleration = false;
                NSLog(@"play_linkmic连麦推流硬编码启动失败，采用软编码");
            }
            else if (EvtID == PUSH_EVT_CONNECT_SUCC)
            {
                // 已经连接推流服务器
                NSLog(@"play_linkmic连麦推流已经连接推流服务器");
            }
            else if (EvtID == PUSH_EVT_PUSH_BEGIN)
            {
                // 已经与服务器握手完毕,开始推流
                NSLog(@"play_linkmic连麦推流已经与服务器握手完毕,开始推流");
                if ([self.delegate respondsToSelector:@selector(tx_startConnectRtmpForLink_mic)]) {
                    [self.delegate tx_startConnectRtmpForLink_mic];//开始连麦推流
                }
                [loadingImage removeFromSuperview];
                loadingImage = nil;
                
                //3.拉取其它正在和大主播连麦的小主播的视频流
            }
            else if (EvtID == PUSH_WARNING_RECONNECT){
                // 网络断连, 已启动自动重连 (自动重连连续失败超过三次会放弃)
                NSLog(@"movieplay连麦推流网络断连, 已启动自动重连 (自动重连连续失败超过三次会放弃)");
            }
            else if (EvtID == PUSH_WARNING_NET_BUSY) {
                [_notification displayNotificationWithMessage:@"您当前的网络环境不佳，请尽快更换网络保证正常连麦" forDuration:5];
            }
        }
        else{
            if (EvtID == PUSH_ERR_NET_DISCONNECT) {
                NSLog(@"movieplay连麦推流 推流失败，结束连麦");
                [_notification displayNotificationWithMessage:@"推流失败，结束连麦" forDuration:5];
                if ([self.delegate respondsToSelector:@selector(tx_stoppushlink)]) {
                    [self.delegate tx_stoppushlink];
                }
                
            }
        }
    });
}
- (void)stopConnect{
    if(_txLivePlayer != nil)
    {
        _txLivePlayer.delegate = nil;
        [_txLivePlayer stopPlay];
        [_txLivePlayer removeVideoWidget];
    }
}
-(void)stopPush{
    
    [_txLivePush stopPreview];
    [_txLivePush stopPush];
    
}
-(void)onNetStatus:(NSDictionary *)param{
    
    
    
}

//混流
-(void)hunliu:(NSDictionary *)hunDic andHost:(BOOL)isHost;{
    NSString *selfUrl = minstr([hunDic valueForKey:@"selfUrl"]);
    NSString *otherUrl = minstr([hunDic valueForKey:@"otherUrl"]);
    
    NSMutableArray * inputStreamList = [NSMutableArray new];
    NSString * appid = [common getTXSDKAppID];
    if ([PublicObj checkNull:appid]) {
        [MBProgressHUD showError:@"缺少腾讯Appid"];
        return;
    }
    /**
     *  大背景
     *  主播与主播连麦 背景设置为画布(input_type = 3)
     *  用户-主播连麦大主播fram 或者 主播-主播连麦的背景画布 的fram
     */
    CGFloat big_bg_x = 0;
    CGFloat big_bg_y = 0;
    CGFloat big_bg_w = _window_width;
    CGFloat big_bg_h = _window_height;
    
    /**
     *  视频流
     *  用户-主播连麦连麦用户fram 或者 主播-主播连麦的右边主播fram
     */
    CGFloat small_x = 0.75;//_window_width-100;
    CGFloat small_y = 0.6;//_window_height - 110 -statusbarHeight - 150 -ShowDiff;
    CGFloat small_w = 0.25;//100;
    CGFloat small_h = 0.21;//150;
    
    /**
     *  视频流
     *  仅用于主播与主播连麦，主播-主播左边主播fram
     */
    CGFloat host_own_x = 0;
    CGFloat host_own_y = 0.25;//0
    CGFloat host_own_w = 0.5;//_window_width/2;
    CGFloat host_own_h = 0.5;//_window_width*2/3;
    
    NSString * _mainStreamId = [self getStreamIDByStreamUrl:selfUrl];
    NSString *host_own_stram_id = _mainStreamId;
    NSString *inputType = @"0";
    if (isHost && ![PublicObj checkNull:otherUrl]) {
        host_own_stram_id = @"canvas1";
        inputType = @"3";
        
//        big_bg_x = 0;
//        big_bg_y = 130+statusbarHeight;
//        big_bg_w = host_own_w*2;
//        big_bg_h = host_own_h;
        
        small_x = 0.5;//_window_width/2;
        small_y = 0.25;//host_own_y;
        small_w = 0.5;//host_own_w;
        small_h = 0.5;//host_own_h;
    }
    
    //大主播
    NSDictionary * mainStream = @{
                                  @"input_stream_id": host_own_stram_id,
                                  @"layout_params": @{
                                          @"image_layer": [NSNumber numberWithInt:1],
                                          @"image_width": [NSNumber numberWithFloat: big_bg_w],
                                          @"image_height": [NSNumber numberWithFloat: big_bg_h],
                                          @"location_x": [NSNumber numberWithFloat:big_bg_x],
                                          @"location_y": [NSNumber numberWithFloat:big_bg_y],
                                          @"input_type":inputType,
                                          },
                                  /*
                                  @"crop_params":@{
                                          @"crop_width":[NSNumber numberWithFloat: big_bg_w],
                                          @"crop_height":[NSNumber numberWithFloat: big_bg_h],
                                          @"crop_x":@0,
                                          @"crop_y":@0,
                                          }
                                  */
                                  };
    [inputStreamList addObject:mainStream];
    
    if (![PublicObj checkNull:otherUrl]) {
        if (isHost) {
            //pk主播(左边边主播)
            NSDictionary * mainStream = @{
                                          @"input_stream_id": _mainStreamId,
                                          @"layout_params": @{
                                                  @"image_layer": [NSNumber numberWithInt:3],
                                                  @"image_width": [NSNumber numberWithFloat: host_own_w],
                                                  @"image_height": [NSNumber numberWithFloat: host_own_h],
                                                  @"location_x": [NSNumber numberWithFloat:host_own_x],
                                                  @"location_y": [NSNumber numberWithFloat:host_own_y]
                                                  },
                                          /*
                                          @"crop_params":@{
                                                  @"crop_width":[NSNumber numberWithFloat: host_own_w],
                                                  @"crop_height":[NSNumber numberWithFloat: host_own_h],
                                                  @"crop_x":@0,
                                                  @"crop_y":@0,
                                                  }
                                          */
                                          };
            [inputStreamList addObject:mainStream];
        }
        //小主播(用户:右下角) 或者 pk主播(右边主播)
        NSString *subPath = [self getStreamIDByStreamUrl:otherUrl];
        NSDictionary * subStream = @{
                                     @"input_stream_id": subPath,
                                     @"layout_params": @{
                                             @"image_layer": [NSNumber numberWithInt:2],
                                             @"image_width": [NSNumber numberWithFloat: small_w],
                                             @"image_height": [NSNumber numberWithFloat: small_h],
                                             @"location_x": [NSNumber numberWithFloat:small_x],
                                             @"location_y": [NSNumber numberWithFloat:small_y],
                                             },
                                     /*
                                     @"crop_params":@{
                                             @"crop_width":[NSNumber numberWithFloat: small_w],
                                             @"crop_height":[NSNumber numberWithFloat: small_h],
                                             @"crop_x":@0,
                                             @"crop_y":@0,
                                         }
                                      */
                                     };
        [inputStreamList addObject:subStream];
    }
    
    //para
    NSDictionary * para = @{
                            @"app_id": [NSNumber numberWithInt:[appid intValue]] ,
                            @"interface": @"mix_streamv2.start_mix_stream_advanced",
                            @"mix_stream_session_id": _mainStreamId,
                            @"output_stream_id": _mainStreamId,
                            @"input_stream_list": inputStreamList
                            };
    //interface
    NSDictionary * interface = @{
                                 @"interfaceName":@"Mix_StreamV2",
                                 @"para":para
                                 };
    //mergeParams
    NSDictionary * mergeParams = @{
                                   @"timestamp": [NSNumber numberWithLong: (long)[[NSDate date] timeIntervalSince1970]],
                                   @"eventId": [NSNumber numberWithLong: (long)[[NSDate date] timeIntervalSince1970]],
                                   @"interface": interface
                                   };
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mergeParams options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *url = [purl stringByAppendingFormat:@"?service=Linkmic.MergeVideoStream"];
    NSDictionary *mergeInfo = @{
                                  @"uid":[Config getOwnID],
                                  @"mergeparams":jsonStr
                                  };
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YBNetworking postWithUrl:url Dic:mergeInfo Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        
    } Fail:nil];
    
    
}
-(NSString*) getStreamIDByStreamUrl:(NSString*) strStreamUrl {
    if (strStreamUrl == nil || strStreamUrl.length == 0) {
        return nil;
    }
    strStreamUrl = [strStreamUrl lowercaseString];
    //推流地址格式：rtmp://8888.livepush.myqcloud.com/live/8888_test_12345_test?txSecret=aaaa&txTime=bbbb
    NSString * strLive = @"/live/";
    NSRange range = [strStreamUrl rangeOfString:strLive];
    if (range.location == NSNotFound) {
        return nil;
    }
    NSString * strSubString = [strStreamUrl substringFromIndex:range.location + range.length];
    NSArray * array = [strSubString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"?."]];
    if ([array count] > 0) {
        return [array objectAtIndex:0];
    }
    return @"";
}
@end
