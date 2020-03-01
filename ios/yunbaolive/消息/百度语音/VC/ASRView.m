//
//  ASRView.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/31.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "ASRView.h"

#import "BDSASRDefines.h"
#import "BDSASRParameters.h"
#import "BDSWakeupDefines.h"
#import "BDSWakeupParameters.h"
#import "BDSEventManager.h"
#import "BDRecognizerViewController.h"
#import "BDVRSettings.h"
#import "fcntl.h"
#import "AudioInputStream.h"

@interface ASRView()<UITextViewDelegate,BDSClientASRDelegate>
{
    NSString *_endRsStr;  //识别字段最终结果
}
/** 输入框、返回键、清除按钮、发送按钮 */
@property(nonatomic,strong)UIView *botMixView;
//@property(nonatomic,strong)MyTextView *textView;                 //输入框  .h
@property(nonatomic,strong)UILabel *explainL;                    //按住说话
@property(nonatomic,strong)UIButton *backBtn;                    //返回按钮
@property(nonatomic,strong)UIButton *clearBtn;                   //清除按钮
@property(nonatomic,strong)UIButton *sendBtn;                    //发送按钮
@property(nonatomic,strong)UIButton *voiceBtn;                   //录音按钮

@property (strong, nonatomic) BDSEventManager *asrEventManager;

@property(nonatomic, assign) BOOL continueToVR;
@property(nonatomic, strong) NSFileHandle *fileHandler;
@property(nonatomic, strong) BDRecognizerViewController *recognizerViewController;
@property(nonatomic, assign) TBDVoiceRecognitionOfflineEngineType curOfflineEngineType;

@property(nonatomic, strong) NSTimer *longPressTimer;
@property(nonatomic, assign) BOOL longPressFlag;
@property(nonatomic, assign) BOOL touchUpFlag;

@property(nonatomic, assign) BOOL longSpeechFlag;

@end

@implementation ASRView

- (instancetype)initWithFrame:(CGRect)frame callBack:(ASRBlock)asrBack{
    self = [super initWithFrame:frame];
    if (self) {
       
        self.asrEvent = asrBack;
        _endRsStr = [NSString string];
        [self addSubview:self.botMixView];
        
        self.asrEventManager = [BDSEventManager createEventManagerWithName:BDS_ASR_NAME];
        NSLog(@"Current SDK version: %@", [self.asrEventManager libver]);
        self.continueToVR = NO;
        [[BDVRSettings getInstance] configBDVRClient];
        [self configVoiceRecognitionClient];
        
    }
    return self;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 点击事件
//按下
-(void)clickVoiceBtnDown:(UIButton *)btn {
    [btn.layer addAnimation:[PublicObj touchDownAnimation] forKey:nil];
    self.touchUpFlag = NO;
    self.longPressFlag = NO;
    self.longPressTimer = [NSTimer timerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(longPressTimerTriggered) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.longPressTimer forMode:NSRunLoopCommonModes];
    
    
    [self.asrEventManager setParameter:@(NO) forKey:BDS_ASR_ENABLE_LONG_SPEECH];
    [self.asrEventManager setParameter:@(NO) forKey:BDS_ASR_NEED_CACHE_AUDIO];
    [self.asrEventManager setParameter:@"" forKey:BDS_ASR_OFFLINE_ENGINE_TRIGGERED_WAKEUP_WORD];
    [self voiceRecogButtonHelper];
}
- (void)voiceRecogButtonHelper {
    //[self configFileHandler];
    [self.asrEventManager setDelegate:self];
    [self.asrEventManager setParameter:nil forKey:BDS_ASR_AUDIO_FILE_PATH];
    [self.asrEventManager setParameter:nil forKey:BDS_ASR_AUDIO_INPUT_STREAM];
    [self.asrEventManager sendCommand:BDS_ASR_CMD_START];
    
}
- (void)longPressTimerTriggered {
    if (!self.touchUpFlag) {
        self.longPressFlag = YES;
        [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_VAD_ENABLE_LONG_PRESS];
    }
    [self.longPressTimer invalidate];
}
//抬起
-(void)clickVoiceBtnUp:(UIButton *)btn {
    [btn.layer removeAllAnimations];
    self.touchUpFlag = YES;
    if (self.longPressFlag) {
        [self.asrEventManager sendCommand:BDS_ASR_CMD_STOP];
    }
}
//返回
-(void)clickBackBtn {
    if (self.asrEvent) {
        self.asrEvent(@"返回", @"");
    }
}
//清除
-(void)clickClearBtn {
    _endRsStr = @"";
    _textView.text = @"";
    [self noContent];
}
//发送
-(void)clickSendBtn {
    if (self.asrEvent) {
        self.asrEvent(YZMsg(@"发送"), _textView.text);
        [self clickClearBtn];
    }
}

-(void)haveContent {
    _backBtn.hidden = YES;
    _clearBtn.hidden = NO;
    _sendBtn.hidden = NO;
}
-(void)noContent {
    _backBtn.hidden = NO;
    _clearBtn.hidden = YES;
    _sendBtn.hidden = YES;
}

#pragma mark - textView 代理


#pragma mark - Private: Configuration

- (void)configVoiceRecognitionClient {
    //设置DEBUG_LOG的级别
    [self.asrEventManager setParameter:@(EVRDebugLogLevelTrace) forKey:BDS_ASR_DEBUG_LOG_LEVEL];
    //配置API_KEY 和 SECRET_KEY 和 APP_ID
    [self.asrEventManager setParameter:@[ASR_API_KEY, ASR_SECRET_KEY] forKey:BDS_ASR_API_SECRET_KEYS];
    [self.asrEventManager setParameter:ASR_APP_ID forKey:BDS_ASR_OFFLINE_APP_CODE];
    //配置端点检测（二选一）
//    [self configModelVAD];
    [self configDNNMFE];
    
    //[self.asrEventManager setParameter:@"15361" forKey:BDS_ASR_PRODUCT_ID];
    // ---- 语义与标点 -----
    //[self enableNLU];
    [self enablePunctuation];
    // ------------------------
}

- (void) enableNLU {
    // ---- 开启语义理解 -----
    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_NLU];
    [self.asrEventManager setParameter:@"1536" forKey:BDS_ASR_PRODUCT_ID];
}

- (void) enablePunctuation {
    // ---- 开启标点输出 -----
    [self.asrEventManager setParameter:@(NO) forKey:BDS_ASR_DISABLE_PUNCTUATION];
    // 普通话标点
    [self.asrEventManager setParameter:@"1537" forKey:BDS_ASR_PRODUCT_ID];
    // 英文标点
    //[self.asrEventManager setParameter:@"1737" forKey:BDS_ASR_PRODUCT_ID];
    
}

- (void)configModelVAD {
    NSString *modelVAD_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_basic_model" ofType:@"dat"];
    [self.asrEventManager setParameter:modelVAD_filepath forKey:BDS_ASR_MODEL_VAD_DAT_FILE];
    [self.asrEventManager setParameter:@(YES) forKey:BDS_ASR_ENABLE_MODEL_VAD];
}

- (void)configDNNMFE {
    NSString *mfe_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_dnn" ofType:@"dat"];
    [self.asrEventManager setParameter:mfe_dnn_filepath forKey:BDS_ASR_MFE_DNN_DAT_FILE];
    NSString *cmvn_dnn_filepath = [[NSBundle mainBundle] pathForResource:@"bds_easr_mfe_cmvn" ofType:@"dat"];
    [self.asrEventManager setParameter:cmvn_dnn_filepath forKey:BDS_ASR_MFE_CMVN_DAT_FILE];
    
    [self.asrEventManager setParameter:@(NO) forKey:BDS_ASR_ENABLE_MODEL_VAD];
    // MFE支持自定义静音时长
    [self.asrEventManager setParameter:@(5000.f) forKey:BDS_ASR_MFE_MAX_SPEECH_PAUSE];
    [self.asrEventManager setParameter:@(5000.f) forKey:BDS_ASR_MFE_MAX_WAIT_DURATION];
}
#pragma mark - MVoiceRecognitionClientDelegate
- (void)VoiceRecognitionClientWorkStatus:(int)workStatus obj:(id)aObj {
    switch (workStatus) {
        case EVoiceRecognitionClientWorkStatusNewRecordData: {
            [self.fileHandler writeData:(NSData *)aObj];
            break;
        }case EVoiceRecognitionClientWorkStatusStartWorkIng: {
            _textView.placeholder = YZMsg(@"初始化中...");
            NSDictionary *logDic = [self parseLogToDic:aObj];
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: start vr, log: %@\n", logDic]];
//            [self onStartWorking];
            break;
        }case EVoiceRecognitionClientWorkStatusStart: {
            _textView.placeholder = YZMsg(@"长按识别...");
            [self printLogTextView:@"CALLBACK: detect voice start point.\n"];
            break;
        }case EVoiceRecognitionClientWorkStatusEnd: {
            [self printLogTextView:@"CALLBACK: detect voice end point.\n"];
            break;
        }case EVoiceRecognitionClientWorkStatusFlushData: {
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: partial result - %@.\n\n", [self getDescriptionObj:aObj]]];
            if (aObj) {
                _textView.text = [self getDescriptionObj:aObj];
                [self haveContent];
            }
            break;
        }case EVoiceRecognitionClientWorkStatusFinish: {
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: final result - %@.\n\n", [self getDescriptionObj:aObj]]];
//            if (aObj) {
//                _textView.text = [_textView.text stringByAppendingString:[self getDescriptionObj:aObj]];
//            }
            if (!self.longSpeechFlag) {
//                [self onEnd];
            }
            break;
        }case EVoiceRecognitionClientWorkStatusMeterLevel: {
            break;
        }case EVoiceRecognitionClientWorkStatusCancel: {
            [self printLogTextView:@"CALLBACK: user press cancel.\n"];
//            [self onEnd];
            break;
        }case EVoiceRecognitionClientWorkStatusError: {
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: encount error - %@.\n", (NSError *)aObj]];
//            [self onEnd];
            break;
        }case EVoiceRecognitionClientWorkStatusLoaded: {
            [self printLogTextView:@"CALLBACK: offline engine loaded.\n"];
            break;
        }case EVoiceRecognitionClientWorkStatusUnLoaded: {
            [self printLogTextView:@"CALLBACK: offline engine unLoaded.\n"];
            break;
        }case EVoiceRecognitionClientWorkStatusChunkThirdData: {
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: Chunk 3-party data length: %lu\n", (unsigned long)[(NSData *)aObj length]]];
            break;
        }case EVoiceRecognitionClientWorkStatusChunkNlu: {
            NSString *nlu = [[NSString alloc] initWithData:(NSData *)aObj encoding:NSUTF8StringEncoding];
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: Chunk NLU data: %@\n", nlu]];
            NSLog(@"%@", nlu);
            break;
        }case EVoiceRecognitionClientWorkStatusChunkEnd: {
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK: Chunk end, sn: %@.\n", aObj]];
            if (!self.longSpeechFlag) {
//                [self onEnd];
            }
            break;
        }case EVoiceRecognitionClientWorkStatusFeedback: {
            NSDictionary *logDic = [self parseLogToDic:aObj];
            [self printLogTextView:[NSString stringWithFormat:@"CALLBACK Feedback: %@\n", logDic]];
            break;
        }case EVoiceRecognitionClientWorkStatusRecorderEnd: {
            [self printLogTextView:@"CALLBACK: recorder closed.\n"];
            break;
        }case EVoiceRecognitionClientWorkStatusLongSpeechEnd: {
            [self printLogTextView:@"CALLBACK: Long Speech end.\n"];
//            [self onEnd];
            break;
        }default:
            break;
    }
}

- (NSDictionary *)parseLogToDic:(NSString *)logString {
    NSArray *tmp = NULL;
    NSMutableDictionary *logDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    NSArray *items = [logString componentsSeparatedByString:@"&"];
    for (NSString *item in items) {
        tmp = [item componentsSeparatedByString:@"="];
        if (tmp.count == 2) {
            [logDic setObject:tmp.lastObject forKey:tmp.firstObject];
        }
    }
    return logDic;
}

- (void)printLogTextView:(NSString *)logString {
    NSLog(@"asr-log:%@",logString);
    
}
- (NSString *)getDescriptionObj:(id)obj {
    if (obj) {
        NSString *words = [NSString stringWithFormat:@"%@",[[obj valueForKey:@"results_recognition"] firstObject]];
        return words;
    }
    return YZMsg(@"解析错误");
}

#pragma mark - set/get
- (UIView *)botMixView {
    if (!_botMixView) {
        _botMixView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-ASRHeight-ShowDiff, self.width, ASRHeight+ShowDiff)];
        _botMixView.backgroundColor = [UIColor whiteColor];
        
        //输入框  15+100+20+15+80
        _textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, 15, self.width-30, 110)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.font = SYS_Font(16);
        _textView.textColor = RGB_COLOR(@"#959697", 1);
        [_botMixView addSubview:_textView];
        
        _explainL = [[UILabel alloc]initWithFrame:CGRectMake(0, _textView.bottom, self.width, 20)];
        _explainL.text = YZMsg(@"请说话");
        _explainL.textColor = RGB_COLOR(@"#8c8c8c", 1);
        _explainL.textAlignment = NSTextAlignmentCenter;
        [_botMixView addSubview:_explainL];
        
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(self.width/2-40, _explainL.bottom+15, 80, 80);
        [_voiceBtn setImage:[UIImage imageNamed:@"asr_record"] forState:0];
        [_voiceBtn addTarget:self action:@selector(clickVoiceBtnDown:) forControlEvents:UIControlEventTouchDown];
        [_voiceBtn addTarget:self action:@selector(clickVoiceBtnUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [_botMixView addSubview:_voiceBtn];
        
        //返回按钮
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"asr_arrow"] forState:0];
        [_backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
        [_botMixView addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(48);
            make.height.mas_equalTo(24);
            make.left.mas_equalTo(_botMixView.mas_left).offset(30);
            make.centerY.mas_equalTo(_voiceBtn.mas_centerY);
        }];
        
        //取消
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setTitle:YZMsg(@"清除") forState:0];
        _clearBtn.titleLabel.font = SYS_Font(15);
        [_clearBtn setTitleColor:RGB_COLOR(@"#8c8c8c", 1) forState:0];
        [_clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        [_botMixView addSubview:_clearBtn];
        _clearBtn.hidden = YES;
        [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.left.mas_equalTo(_botMixView.mas_left).offset(30);
            make.centerY.mas_equalTo(_voiceBtn.mas_centerY);
        }];
        
        //发送
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:YZMsg(@"发送") forState:0];
        _sendBtn.titleLabel.font = SYS_Font(15);
        [_sendBtn setTitleColor:Pink_Cor forState:0];
        [_sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
        [_botMixView addSubview:_sendBtn];
        _sendBtn.hidden = YES;
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(60);
            make.right.mas_equalTo(_botMixView.mas_right).offset(-30);
            make.centerY.mas_equalTo(_voiceBtn.mas_centerY);
        }];
    }
    return _botMixView;
}


@end
