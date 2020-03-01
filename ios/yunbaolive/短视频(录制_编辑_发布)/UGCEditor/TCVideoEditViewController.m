//
//  TCVideoEditViewController.m
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/10.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCVideoEditViewController.h"

//#import <TXLiteAVSDK_UGC/TXVideoEditer.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
//#import "TXVideoEditer.h"
#import <MediaPlayer/MPMediaPickerController.h>
#import <AVFoundation/AVFoundation.h>
#import "TCVideoRangeSlider.h"
#import "TCVideoRangeConst.h"
#import "TCVideoPublishController.h"
#import "UIView+Additions.h"
#import "UIColor+MLPFlatColors.h"
#import "TCFilterSettingView.h"
#import "TCVideoPreview.h"
#import "TCBottomTabBar.h"
#import "TCVideoCutView.h"
#import "TCMusicMixView.h"
#import "TCTextAddView.h"
//#import "TCVideoTextViewController.h"
#import "musicViewVideo.h"
#import "EffectSelectView.h"
#import "TimeSelectView.h"

typedef  NS_ENUM(NSInteger,ActionType) {
    ActionType_Save,
    ActionType_Publish,
    ActionType_Save_Publish,
};
typedef  NS_ENUM(NSInteger,TimeType) {
    TimeType_Clear,
    TimeType_Back,
    TimeType_Repeat,
    TimeType_Speed,
};

@interface TCVideoEditViewController ()<TXVideoGenerateListener,TXVideoJoinerListener,TCVideoPreviewDelegate, TCVideoPreviewDelegate, TCFilterSettingViewDelegate, TCBottomTabBarDelegate, TCVideoCutViewDelegate, TCMusicMixViewDelegate, TCTextAddViewDelegate, MPMediaPickerControllerDelegate, UIActionSheetDelegate,VideoEffectViewDelegate,TimeSelectViewDelegate>



@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *selMusicBtn;                   //选择音乐
@property(nonatomic,strong)UIButton *selVolumeBtn;                  //选择音量

/** 底部按钮组合：特效、封面、滤镜、下一步 */
@property(nonatomic,strong)UIView *botBtnMix;

@property(nonatomic,strong)UIButton *effectBtn;
@property(nonatomic,strong)UIButton *coverBtn;
@property(nonatomic,strong)UIButton *filterfBtn;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIButton *jiancaiBtn;


/** 底部功能组合：botBar、videoRangeSlider、剪裁、时间特效、其他特效 */
@property(nonatomic,strong)UIView *botFunctionMix;

@property(nonatomic,strong)TCBottomTabBar *bottomBar;
@property(nonatomic,strong) UILabel  *cutTipsLabel;
@property(nonatomic,strong)TCVideoCutView *videoCutView;


@property(nonatomic,strong)TCFilterSettingView *filterView;
@property(nonatomic,strong)TCMusicMixView *musixMixView;
@property(nonatomic,strong)TCTextAddView *textView;
@property(nonatomic,strong)EffectSelectView *effectSelectView;       //动效选择
@property(nonatomic,strong)TimeSelectView *timeSelectView;           //时间特效栏

@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,assign)ActionType actionType;

@property(nonatomic,strong)UIView *jiancaiView;
@property(nonatomic,strong)UIButton *delEffectBtn;

@end

@implementation TCVideoEditViewController
{
    TXVideoEditer       *_ugcEdit;
    TCVideoPreview      *_videoPreview;
    
    unsigned long long _fileSize;
    NSMutableArray      *_cutPathList;
    NSString            *_videoOutputPath;
    
    UIProgressView* _playProgressView;
    UILabel*        _startTimeLabel;
    UILabel*        _endTimeLabel;
    CGFloat         _leftTime;
    CGFloat         _rightTime;
    
    
    
    UILabel*        _generationTitleLabel;
    UIView*         _generationView;
    UIProgressView* _generateProgressView;
    UIButton*       _generateCannelBtn;
    
    UIColor            *_barTintColor;
   
    
    /*
      UILabel*        _cutTipsLabel;
     TCBottomTabBar*       _bottomBar;
     TCVideoCutView    *_videoCutView;
     TCFilterSettingView*  _filterView;
     
     TCMusicMixView*       _musixMixView;
     TCTextAddView*        _textView;
     EffectSelectView*   _effectSelectView;   //动效选择
     TimeSelectView*     _timeSelectView;     //时间特效栏
     */
    
//    NSMutableArray<TCVideoTextInfo*>* _videoTextInfos;
    int                 _effectType;
    BOOL  _isReverse;
    CGFloat _playTime;
    TimeType            _timeType;
    
    CGFloat iphoneXTop;

    BOOL _isRecordBg;//是否是录制开始设置的背景音乐（改收费版SDK添加）
    
}

static int MIXBTN_W = 55;

#pragma mark - get/set
-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(10, 30+iphoneXTop, 40, 40);
        [_backBtn setImage:[UIImage imageNamed:@"video_返回"] forState:0];
        [_backBtn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)selVolumeBtn {
    if (!_selVolumeBtn) {
        _selVolumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selVolumeBtn.frame = CGRectMake(_window_width-MIXBTN_W*2-8-12, 30+iphoneXTop, MIXBTN_W, MIXBTN_W);
        [_selVolumeBtn setImage:[UIImage imageNamed:@"音量"] forState:0];
        [_selVolumeBtn setTitle:YZMsg(@"音量") forState:0];
        _selVolumeBtn.titleLabel.font = SYS_Font(12);
        [_selVolumeBtn addTarget:self action:@selector(clickSelVolumeBtn) forControlEvents:UIControlEventTouchUpInside];
        _selVolumeBtn = [PublicObj setUpImgDownText:_selVolumeBtn];
    }
    return _selVolumeBtn;
}
- (UIButton *)selMusicBtn {
    if (!_selMusicBtn) {
        _selMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selMusicBtn.frame = CGRectMake(_window_width-MIXBTN_W-8-12, 30+iphoneXTop, MIXBTN_W+12, MIXBTN_W);
        [_selMusicBtn setImage:[UIImage imageNamed:@"音乐"] forState:0];
        [_selMusicBtn setTitle:YZMsg(@"音乐") forState:0];
        _selMusicBtn.titleLabel.font = SYS_Font(12);
        [_selMusicBtn addTarget:self action:@selector(clickMusicBtn) forControlEvents:UIControlEventTouchUpInside];
        _selMusicBtn = [PublicObj setUpImgDownText:_selMusicBtn];
    }
    return _selMusicBtn;
}
-(UIView *)botBtnMix{
    if (!_botBtnMix) {
        _botBtnMix = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height-80-ShowDiff, _window_width, 80+ShowDiff)];
        _botBtnMix.backgroundColor = [UIColor clearColor];
        
        //滤镜
        _filterfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _filterfBtn.frame = CGRectMake(8, 0, MIXBTN_W, MIXBTN_W);
        [_filterfBtn setImage:[UIImage imageNamed:@"滤镜"] forState:0];
        [_filterfBtn setTitle:YZMsg(@"滤镜") forState:0];
        _filterfBtn.titleLabel.font = SYS_Font(13);
        [_filterfBtn addTarget:self action:@selector(clickFilterBtn) forControlEvents:UIControlEventTouchUpInside];
        _filterfBtn = [PublicObj setUpImgDownText:_filterfBtn];
        [_botBtnMix addSubview:_filterfBtn];

        
        //封面（隐藏了 CGRectMake(_effectBtn.right+3, 0, MIXBTN_W, MIXBTN_W);）
        _jiancaiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jiancaiBtn.frame = CGRectMake(_filterfBtn.right+3, 0, MIXBTN_W, MIXBTN_W);
        [_jiancaiBtn setImage:[UIImage imageNamed:@"video_裁剪"] forState:0];
        [_jiancaiBtn setTitle:YZMsg(@"裁剪") forState:0];
        _jiancaiBtn.titleLabel.font = SYS_Font(13);
        [_jiancaiBtn addTarget:self action:@selector(clickJiancaiBtn) forControlEvents:UIControlEventTouchUpInside];
        _jiancaiBtn = [PublicObj setUpImgDownText:_jiancaiBtn];
        [_botBtnMix addSubview:_jiancaiBtn];

        //特效
        _effectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _effectBtn.frame = CGRectMake(_jiancaiBtn.right, 0, MIXBTN_W, MIXBTN_W);
        [_effectBtn setImage:[UIImage imageNamed:@"特效"] forState:0];
        [_effectBtn setTitle:YZMsg(@"特效") forState:0];
        _effectBtn.titleLabel.font = SYS_Font(13);
        [_effectBtn addTarget:self action:@selector(clickEffectBtn) forControlEvents:UIControlEventTouchUpInside];
        _effectBtn = [PublicObj setUpImgDownText:_effectBtn];
        [_botBtnMix addSubview:_effectBtn];
        
        //封面（隐藏了 CGRectMake(_effectBtn.right+3, 0, MIXBTN_W, MIXBTN_W);）
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = CGRectMake(_effectBtn.right+3, 0, 0, 0);
        [_coverBtn setImage:[UIImage imageNamed:@"封面"] forState:0];
        [_coverBtn setTitle:@"封面" forState:0];
        _coverBtn.titleLabel.font = SYS_Font(13);
        [_coverBtn addTarget:self action:@selector(clickCovertBtn) forControlEvents:UIControlEventTouchUpInside];
        _coverBtn = [PublicObj setUpImgDownText:_coverBtn];
        [_botBtnMix addSubview:_coverBtn];
        
        
        //下一步
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(_window_width-10-65, 12.5, 65, 30);
        [_nextBtn setTitle:YZMsg(@"下一步") forState:0];
        _nextBtn.titleLabel.font = SYS_Font(14);
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:0];
        _nextBtn.backgroundColor = Pink_Cor;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 15;
        [_nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
        [_botBtnMix addSubview:_nextBtn];
        
    }
    return _botBtnMix;
}

-(UIView *)botFunctionMix {
    if (!_botFunctionMix) {
        CGFloat botFunH = 170;
        _botFunctionMix = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-botFunH-ShowDiff, _window_width, botFunH+ShowDiff)];
        _botFunctionMix.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
        
         _cutTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_window_width/4, 0, _window_width/2, 35)];
         _cutTipsLabel.textAlignment = NSTextAlignmentCenter;
         _cutTipsLabel.textColor = [UIColor whiteColor];
         _cutTipsLabel.font = [UIFont systemFontOfSize:14];
         [_cutTipsLabel setAdjustsFontSizeToFitWidth:YES];
         [_botFunctionMix addSubview:_cutTipsLabel];
        
        _delEffectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delEffectBtn setImage:[UIImage imageNamed:@"edit_撤销"] forState:0];
        _delEffectBtn.frame = CGRectMake(_botFunctionMix.width-70, 5, 55, 25);
        [_delEffectBtn addTarget:self action:@selector(onEffectSelDelete) forControlEvents:UIControlEventTouchUpInside];
        _delEffectBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_botFunctionMix addSubview:_delEffectBtn];
        _delEffectBtn.hidden = YES;

        if (!_videoCutView) {
            _videoCutView = [[TCVideoCutView alloc] initWithFrame:CGRectMake(0,35, _window_width, 60) videoPath:_videoPath videoAssert:_videoAsset];
        }
        _videoCutView.frame = CGRectMake(0,35, _window_width, 60);
        _videoCutView.delegate = self;
        [_botFunctionMix addSubview:_videoCutView];
        
        
        _effectSelectView = [[EffectSelectView alloc] initWithFrame:CGRectMake(0, 95, _window_width, 70)];
        _effectSelectView.delegate = self;
        [_botFunctionMix addSubview:_effectSelectView];

    }
    return _botFunctionMix;
}
- (void)clickJiancaiBtn{
    _cutTipsLabel.text = YZMsg(@"请拖拽两侧滑块选择裁剪区域");
    _effectSelectView.hidden = YES;
    _botFunctionMix.frame = CGRectMake(0, _window_height - 100 -ShowDiff, _window_width, 100+ShowDiff);
    _delEffectBtn.hidden = YES;
    _botFunctionMix.hidden = NO;
//    if (!_jiancaiView) {
//        _jiancaiView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height - 100 -ShowDiff, _window_width, 100+ShowDiff)];
//        _jiancaiView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.95];
//        [self.view addSubview:_jiancaiView];
//        _cutTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _window_width, 30)];
//        _cutTipsLabel.textAlignment = NSTextAlignmentCenter;
//        _cutTipsLabel.text = @"请拖拽两侧滑块选择裁剪区域";
//        _cutTipsLabel.textColor = [UIColor whiteColor];
//        _cutTipsLabel.font = [UIFont systemFontOfSize:12];
//        [_cutTipsLabel setAdjustsFontSizeToFitWidth:YES];
//        [_jiancaiView addSubview:_cutTipsLabel];
//        if (!_videoCutView) {
//            _videoCutView = [[TCVideoCutView alloc] initWithFrame:CGRectMake(0,35, _window_width, 60) videoPath:_videoPath videoAssert:_videoAsset];
//        }
//        _videoCutView.frame = CGRectMake(0,35, _window_width, 60);
//        _videoCutView.delegate = self;
//        //_videoCutView.backgroundColor = [UIColor grayColor];
//        [_jiancaiView addSubview:_videoCutView];
//    }
//    _jiancaiView.hidden = NO;
}
- (TCMusicMixView *)musixMixView {
    if (!_musixMixView) {
        //haveBGM这里初始值一旦为YES“原声”再不可编辑
        _musixMixView = [[TCMusicMixView alloc] initWithFrame:CGRectMake(0, _window_height-ShowDiff-215, _window_width, 215+ShowDiff)haveBgm:_haveBGM];
        _musixMixView.delegate = self;
        _musixMixView.backgroundColor = [UIColor clearColor];
    }
    return _musixMixView;
}

-(TCFilterSettingView *)filterView {
    if (!_filterView) {
        _filterView = [[TCFilterSettingView alloc] initWithFrame:CGRectMake(0, _window_height-ShowDiff-90, _window_width, 90+ShowDiff)];
        _filterView.delegate = self;
    }
    return _filterView;
}

#pragma mark - 按钮点击事件
-(void)showBotBtnMix{
    _musixMixView.hidden = YES;
    _botFunctionMix.hidden = YES;
    _filterView.hidden = YES;
    _botBtnMix.hidden = NO;
    _jiancaiView.hidden = YES;
    [_ugcEdit resumePlay];
    [_videoPreview setPlayBtn:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_botFunctionMix.hidden == NO ||_filterView.hidden == NO ||_musixMixView.hidden == NO || _jiancaiView.hidden == NO) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint _touchPoint = [touch locationInView:self.view];
        if (YES == CGRectContainsPoint(CGRectMake(0, 64, _window_width, _window_height*2/3), _touchPoint)) {
            [self showBotBtnMix];
        }
    }
}

-(void)clickBackBtn {
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"是否确定退出视频编辑") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定退出") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_ugcEdit setBGM:nil result:nil];
        [self pause];
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];

//    [_ugcEdit setBGM:nil result:nil];
//    [self pause];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clickSelVolumeBtn {
    
    [self showBotBtnMix];
    
    //选择音量-剪辑音乐
    [self cutMusic];
    
}
-(void)clickMusicBtn {
    //暂停播放
    [self onVideoPause];
    [self showBotBtnMix];
    
    //更改音乐
    musicViewVideo *mVC = [[musicViewVideo alloc]init];
    mVC.fromWhere = @"edit";
    __weak TCVideoEditViewController *weakSelf = self;
    mVC.pathEvent = ^(NSString *event, NSString *musicID) {
        weakSelf.musicPath = event;
        weakSelf.musicID = musicID;
        //删除时editView隐藏重新选择后显示
        weakSelf.musixMixView.editView.hidden = NO;
        //重新选择后_filePath 不再是delate状态将其置空
        weakSelf.filePath = nil;
        [self cutMusic];
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVC];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)clickEffectBtn {
    _cutTipsLabel.text = YZMsg(@"长按可添加特效");
    _effectSelectView.hidden = NO;
    _botFunctionMix.frame = CGRectMake(0, _window_height - 170 -ShowDiff, _window_width, 170+ShowDiff);
    if (_videoCutView.videoRangeSlider.colorInfos.count<=0) {
        _delEffectBtn.hidden = YES;
    }else{
        _delEffectBtn.hidden = NO;
    }
    _botFunctionMix.hidden = NO;
}
-(void)clickCovertBtn {
    //封面
//    [MBProgressHUD showError:@"敬请期待"];
}
-(void)clickFilterBtn {
    //滤镜
    self.filterView.hidden = NO;
    self.botBtnMix.hidden = YES;
}
-(void)clickNextBtn {
    //下一步
    [self pause];
    if (_fileSize > 200 * 1024 * 1024) {
        [MBProgressHUD showError:YZMsg(@"视频文件过大,超过200M！")];
        return;
    }
    self.actionType = ActionType_Publish;
    [self clickEvent];

//    __weak TCVideoEditViewController *weakSelf = self;
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *savePublishA = [UIAlertAction actionWithTitle:@"保存并发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        weakSelf.actionType = ActionType_Save_Publish;
//        [self clickEvent];
//    }];
//    UIAlertAction *saveA = [UIAlertAction actionWithTitle:@"仅保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        weakSelf.actionType = ActionType_Save;
//        [self clickEvent];
//    }];
//    UIAlertAction *publishA = [UIAlertAction actionWithTitle:@"仅发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        weakSelf.actionType = ActionType_Publish;
//        [self clickEvent];
//    }];
//    UIAlertAction *cancelA = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:nil];
//
//    [alertC addAction:savePublishA];
//    [alertC addAction:saveA];
//    [alertC addAction:publishA];
//    [alertC addAction:cancelA];
//    [self presentViewController:alertC animated:YES completion:nil];
    
}

-(void)clickEvent {
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager removeItemAtPath:_videoOutputPath error:nil];

    _generationView = [self generatingView];
    _generationView.hidden = NO;
    [_ugcEdit setCutFromTime:_leftTime toTime:_rightTime];
    [_ugcEdit generateVideo:VIDEO_COMPRESSED_720P videoOutputPath:_videoOutputPath];
//    [_ugcEdit quickGenerateVideo:VIDEO_COMPRESSED_720P videoOutputPath:_videoOutputPath];
    [self onVideoPause];
    [_videoPreview setPlayBtn:NO];
}

//返回、音量、音乐保持最前面
-(void)keepViewFront{
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.selVolumeBtn];
    [self.view bringSubviewToFront:self.selMusicBtn];
}



-(instancetype)init {
    self = [super init];
    if (self) {
        _cutPathList = [NSMutableArray array];
        _videoOutputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[PublicObj getNameBaseCurrentTime:@"outputCut.mp4"]];
        _effectType = -1;
//        _videoTextInfos = [NSMutableArray new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    
    [_videoPreview removeNotification];
    _videoPreview = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    self.navigationController.navigationBarHidden = YES;
     _isRecordBg = _haveBGM;
    if (iPhoneX) {
        iphoneXTop = 20;
    }else{
        iphoneXTop = 0;
    }

    if (_videoAsset == nil && _videoPath != nil) {
        NSURL *avUrl = [NSURL fileURLWithPath:_videoPath];
        _videoAsset = [AVAsset assetWithURL:avUrl];
    }
    
    //返回、音量、音乐
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.selVolumeBtn];
    [self.view addSubview:self.selMusicBtn];
   
    
    _videoPreview = [[TCVideoPreview alloc] initWithFrame:CGRectMake(0, 0, _window_width, _window_height) coverImage:nil];
    _videoPreview.delegate = self;
    [self.view addSubview:_videoPreview];
    
    _playProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _window_height-4, _window_width, 6)];
    _playProgressView.trackTintColor = UIColorFromRGB(0xd8d8d8);
    _playProgressView.progressTintColor = Pink_Cor;//UIColorFromRGB(0x0accac);
    [self.view addSubview:_playProgressView];
    
    //保持view-btn不被遮挡
    [self keepViewFront];
    
    //底部按钮区域
    [self.view addSubview:self.botBtnMix];
    //底部功能区域
    [self.view addSubview:self.botFunctionMix];
    self.botFunctionMix.hidden = YES;
    //滤镜种类
    [self.view addSubview:self.filterView];
    self.filterView.hidden = YES;
    //音乐剪辑
    [self.view addSubview:self.musixMixView];
    self.musixMixView.hidden = YES;
    
    TXPreviewParam *param = [[TXPreviewParam alloc] init];
    param.videoView = _videoPreview.renderView;
    param.renderMode =  PREVIEW_RENDER_MODE_FILL_SCREEN;
    _ugcEdit = [[TXVideoEditer alloc] initWithPreview:param];
    _ugcEdit.generateDelegate = self;
    _ugcEdit.previewDelegate = _videoPreview;
    
    [_ugcEdit setVideoAsset:_videoAsset];
    TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:_videoAsset];
    _fileSize   = videoMsg.fileSize;
    CGFloat duration = videoMsg.duration;
    _rightTime = duration;
    _endTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)duration / 60, (int)duration % 60];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(popRootVC) name:@"popRootVC" object:nil];
    
}

-(void)popRootVC {
    [self pauseBack];
}
- (UIView*)generatingView {
    /*用作生成时的提示浮层*/
    if (!_generationView) {
        _generationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 64)];
        _generationView.backgroundColor = UIColor.blackColor;
        _generationView.alpha = 0.9f;
        
        _generateProgressView = [UIProgressView new];
        _generateProgressView.center = CGPointMake(_generationView.width / 2, _generationView.height / 2);
        _generateProgressView.bounds = CGRectMake(0, 0, 225, 20);
        _generateProgressView.progressTintColor = Pink_Cor;//UIColorFromRGB(0x0accac);
        [_generateProgressView setTrackImage:[UIImage imageNamed:@"slide_bar_small"]];
        //_generateProgressView.trackTintColor = UIColor.whiteColor;
        //_generateProgressView.transform = CGAffineTransformMakeScale(1.0, 2.0);
        
        _generationTitleLabel = [UILabel new];
        _generationTitleLabel.font = [UIFont systemFontOfSize:14];
        _generationTitleLabel.text = YZMsg(@"视频生成中");
        _generationTitleLabel.textColor = UIColor.whiteColor;
        _generationTitleLabel.textAlignment = NSTextAlignmentCenter;
        _generationTitleLabel.frame = CGRectMake(0, _generateProgressView.y - 34, _generationView.width, 14);
        
        _generateCannelBtn = [UIButton new];
        [_generateCannelBtn setImage:[UIImage imageNamed:@"cancell"] forState:UIControlStateNormal];
        _generateCannelBtn.frame = CGRectMake(_generateProgressView.right + 15, _generationTitleLabel.bottom + 10, 20, 20);
        [_generateCannelBtn addTarget:self action:@selector(onGenerateCancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [_generationView addSubview:_generationTitleLabel];
        [_generationView addSubview:_generateProgressView];
        [_generationView addSubview:_generateCannelBtn];
    }
    
    _generateProgressView.progress = 0.f;
    [[[UIApplication sharedApplication] delegate].window addSubview:_generationView];
    return _generationView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_videoPreview playVideo];
}

- (void)goBack {
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"是否确定退出视频编辑") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定退出") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_ugcEdit setBGM:nil result:nil];
        [self pauseBack];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];
}


- (void)pause {
    [_ugcEdit stopPlay];
    [_videoPreview setPlayBtn:NO];
}
- (void)pauseBack{
    [_ugcEdit setBGM:nil result:nil];
    [_ugcEdit pausePlay];
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit stopPlay];
    _ugcEdit = nil;
    if (_videoPreview) {
        [_videoPreview removeFromSuperview];
        _videoPreview = nil;
    }
    if (_generationView) {
        [_generationView removeFromSuperview];
        _generationView = nil;
    }
    if (_effectSelectView) {
        [_effectSelectView removeFromSuperview];
        _effectSelectView = nil;
    }
    if (_videoCutView) {
        [_videoCutView removeFromSuperview];
        _videoCutView = nil;
    }
    if (_jiancaiView) {
        [_jiancaiView removeFromSuperview];
        _jiancaiView = nil;
    }
    if (_filterView) {
        [_filterView removeFromSuperview];
        _filterView = nil;
    }
    [[NSFileManager defaultManager] removeItemAtPath:_videoPath error:nil];
    NSLog(@"***************************退出删除***************");
}

- (void)onGenerateCancelBtnClicked:(UIButton*)sender {
    _generationView.hidden = YES;
    [_ugcEdit cancelGenerate];
}

#pragma mark FilterSettingViewDelegate
- (void)onSetFilterWithImage:(UIImage *)image {
    [_ugcEdit setFilter:image];
}

#pragma mark - BottomTabBarDelegate
- (void)onCutBtnClicked {
    //[self pause];
    /*
    [_filterView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_textView removeFromSuperview];
    */
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    [_botFunctionMix addSubview:_videoCutView];
    [_botFunctionMix addSubview:_cutTipsLabel];
    [_videoCutView setEffectDeleteBtnHidden:YES];
    
}

- (void)onFilterBtnClicked {
    //[self pause];
    [_videoCutView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_textView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    
    [_botFunctionMix addSubview:_filterView];
    _videoCutView.videoRangeSlider.hidden = NO;
    
}

- (void)onMusicBtnClicked {
    //[self pause];
    [_filterView removeFromSuperview];
    [_videoCutView removeFromSuperview];
    [_textView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    
    [_botFunctionMix addSubview:_musixMixView];
    _videoCutView.videoRangeSlider.hidden = NO;
    
    
}

- (void)onTextBtnClicked {
    //[self pause];
    [_filterView removeFromSuperview];
    [_videoCutView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    [_effectSelectView removeFromSuperview];
    
    [_botFunctionMix addSubview:_textView];
    _videoCutView.videoRangeSlider.hidden = NO;
    
}
- (void)onEffectBtnClicked {
    /*
    [_filterView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_textView removeFromSuperview];
     */
    [_cutTipsLabel removeFromSuperview];
    [_timeSelectView removeFromSuperview];
    
    [_botFunctionMix addSubview:_videoCutView];
    [_botFunctionMix addSubview:_effectSelectView];
    [_videoCutView setEffectDeleteBtnHidden:NO];
}
-(void)onTimeBtnClicked {
    /*
    [_filterView removeFromSuperview];
    [_musixMixView removeFromSuperview];
    [_textView removeFromSuperview];
     */
    [_effectSelectView removeFromSuperview];
    [_cutTipsLabel removeFromSuperview];
    
    [_botFunctionMix addSubview:_videoCutView];
    [_botFunctionMix addSubview:_timeSelectView];
    [_videoCutView setEffectDeleteBtnHidden:YES];
}


#pragma mark TXVideoGenerateListener
-(void) onGenerateProgress:(float)progress {
    //[MBProgressHUD HUDForView:self.view].progress = progress;
    _generateProgressView.progress = progress;
}
-(void) onGenerateComplete:(TXGenerateResult *)result {
    _generationView.hidden = YES;
    
    if (result.retCode == 0) {
        if (_actionType == ActionType_Save_Publish || _actionType == ActionType_Save) {
            UISaveVideoAtPathToSavedPhotosAlbum(_videoOutputPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }else if (_actionType == ActionType_Publish){
            [self publish];
        }
    }else{
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:YZMsg(@"视频生成失败") message:[NSString stringWithFormat:@"错误码：%ld 错误信息：%@",(long)result.retCode,result.descMsg] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleA = [UIAlertAction actionWithTitle:YZMsg(@"知道了") style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancleA];
        [self presentViewController:alertC animated:YES completion:nil];
        
        
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (_actionType == ActionType_Save) {
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD showError:YZMsg(@"保存成功")];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    [self publish];
}


- (void)publish {
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //TXVideoInfo *videoMsg = [TXUGCVideoInfoReader getVideoInfo:_videoOutputPath];
    TCVideoPublishController *vc = [[TCVideoPublishController alloc] initWithPath:_videoOutputPath
                                                                         videoMsg:[TXVideoInfoReader getVideoInfo:_videoOutputPath]];
    vc.musicID = _musicID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TCVideoPreviewDelegate

- (void)onVideoPlay {
    CGFloat currentPos = _videoCutView.videoRangeSlider.currentPos;
    if (currentPos < _leftTime || currentPos > _rightTime)
        currentPos = _leftTime;
    
    if(_isReverse && currentPos != 0){
        [_ugcEdit startPlayFromTime:0 toTime:currentPos];
    }
    else if(_videoCutView.videoRangeSlider.rightPos != 0){
        [_ugcEdit startPlayFromTime:currentPos toTime:_videoCutView.videoRangeSlider.rightPos];
    }
    else{
        [_ugcEdit startPlayFromTime:currentPos toTime:_rightTime];
    }
}

- (void)onVideoPause {
    [_ugcEdit pausePlay];
}

- (void)onVideoResume {
    //[_ugcEdit resumePlay];
    [self onVideoPlay];
}

- (void)onVideoPlayProgress:(CGFloat)time {
    _playTime = time;
    
    _playProgressView.progress = (time - _leftTime) / (_rightTime - _leftTime);
    [_videoCutView setPlayTime:time];
    
}

- (void)onVideoPlayFinished {
    if (_effectType != -1) {
        [self onVideoEffectEndClick:_effectType];
    }else{
        [_ugcEdit startPlayFromTime:_leftTime toTime:_rightTime];
    }
}

- (void)onVideoEnterBackground {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [self onVideoPause];
    
    //视频生成中不能进后台，因为使用硬编，会导致失败
    if (_generationView && !_generationView.hidden) {
        _generationView.hidden = YES;
        [_ugcEdit cancelGenerate];
        
        UIAlertController * alertC = [UIAlertController alertControllerWithTitle:YZMsg(@"视频生成失败") message:YZMsg(@"中途切后台或则被电话，闹钟等打断导致,请重新生成") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleA = [UIAlertAction actionWithTitle:YZMsg(@"知道了") style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancleA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}
#pragma mark - MusicMixViewDelegate

-(void)cutMusic{
    //当首次进入这里并且没有选择音乐的时候前两个条件就不能满足要求了，这时要加第三个条件（_musicPath.length > 0）
    if (![_musicPath isEqual:_filePath] && ![_filePath isEqual:@"delate"] && _musicPath.length > 0) {
        NSFileManager *managers=[NSFileManager defaultManager];
        NSArray *subArray = [_musicPath componentsSeparatedByString:@"*"];
        NSString *musicNameStr = [subArray objectAtIndex:1];
        NSString *singerStr = [subArray objectAtIndex:2];
        /*
         NSString *timeStr = [subArray objectAtIndex:3];
         NSString *songID = [subArray objectAtIndex:4];
         NSArray *IDArray = [songID componentsSeparatedByString:@"."];
         songID = [IDArray objectAtIndex:0];
         */
        TCMusicInfo* musicInfo = [TCMusicInfo new];
        NSURL *url = [NSURL fileURLWithPath:_musicPath];
        AVURLAsset *musicAsset = [AVURLAsset URLAssetWithURL:url options:nil];
        musicInfo.duration = musicAsset.duration.value / musicAsset.duration.timescale;
        musicInfo.filePath = _musicPath;
        musicInfo.soneName = musicNameStr;
        musicInfo.singerName = singerStr;
        __weak TCVideoEditViewController *weakSelf = self;
        if ([managers fileExistsAtPath:_musicPath]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.musixMixView.editView.hidden = NO;
                [self saveAssetURLToFile:musicInfo assetURL:url];
            });
        }
    }
    self.musixMixView.hidden = NO;
    self.botBtnMix.hidden = YES;
    
}


- (void)onSetVideoVolume:(CGFloat)videoVolume musicVolume:(CGFloat)musicVolume {
    [_ugcEdit setVideoVolume:videoVolume];
    [_ugcEdit setBGMVolume:musicVolume];
}

- (void)onSetBGMWithFilePath:(NSString *)filePath startTime:(CGFloat)startTime endTime:(CGFloat)endTime {
    if (![_filePath isEqualToString:filePath]) {
        __weak __typeof(self) weakSelf = self;
        [_ugcEdit setBGM:filePath result:^(int result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == -1){
                    UIAlertController * alertC = [UIAlertController alertControllerWithTitle:YZMsg(@"设置背景音乐失败") message:YZMsg(@"不支持当前格式的背景音乐!") preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleA = [UIAlertAction actionWithTitle:YZMsg(@"知道了") style:UIAlertActionStyleCancel handler:nil];
                    [alertC addAction:cancleA];
                    [weakSelf presentViewController:alertC animated:YES completion:nil];
                }else{
                    [weakSelf setBGMVolume:filePath startTime:startTime endTime:endTime];
                }
            });
        }];
    }else{
        [self setBGMVolume:filePath startTime:startTime endTime:endTime];
    }
    
}
- (void)delBGM {
    _musicPath = @"";
    _haveBGM = NO;
    
    YBWeakSelf;
    [_ugcEdit setBGM:nil result:^(int result) {
        NSLog(@"del:%d",result);
        [weakSelf setBGMVolume:nil startTime:0 endTime:0];
    }];
    
}
-(void)setBGMVolume:(NSString *)filePath startTime:(CGFloat)startTime endTime:(CGFloat)endTime {
    _filePath = filePath;
    [_ugcEdit setBGMStartTime:startTime endTime:endTime];
    if (_filePath == nil && _isRecordBg==NO) {
        [_ugcEdit setVideoVolume:1.f];
    }
    
    [_ugcEdit startPlayFromTime:_leftTime toTime:_rightTime];
    [_videoPreview setPlayBtn:YES];
}

#pragma mark - TextAddViewDelegate
//- (void)onAddTextBtnClicked {
//    [_videoPreview removeFromSuperview];
//
//    NSMutableArray* inRangeVideoTexts = [NSMutableArray new];
//    for (TCVideoTextInfo* info in _videoTextInfos) {
//        if (info.startTime >= _rightTime || info.endTime <= _leftTime)
//            continue;
//
//        [inRangeVideoTexts addObject:info];
//    }
//
//    [_ugcEdit pausePlay];
//    [_videoPreview setPlayBtn:NO];
//
//    TCVideoTextViewController* vc = [[TCVideoTextViewController alloc] initWithVideoEditer:_ugcEdit previewView:_videoPreview startTime:_leftTime endTime:_rightTime videoTextInfos:inRangeVideoTexts];
//    vc.delegate = self;
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:nil];
//}
//
//#pragma mark - VideoTextViewControllerDelegate
//- (void)onSetVideoTextInfosFinish:(NSArray<TCVideoTextInfo *> *)videoTextInfos {
//    //更新文字信息
//    //新增的
//    for (TCVideoTextInfo* info in videoTextInfos) {
//        if (![_videoTextInfos containsObject:info]) {
//            [_videoTextInfos addObject:info];
//        }
//    }
//
//    NSMutableArray* removedTexts = [NSMutableArray new];
//    for (TCVideoTextInfo* info in _videoTextInfos) {
//        //删除的
//        NSUInteger index = [videoTextInfos indexOfObject:info];
//        if ( index != NSNotFound) {
//            continue;
//        }
//
//        if (info.startTime < _rightTime && info.endTime > _leftTime)
//            [removedTexts addObject:info];
//    }
//
//    if (removedTexts.count > 0)
//        [_videoTextInfos removeObjectsInArray:removedTexts];
//
//    _videoPreview.frame = CGRectMake(0, 0, self.view.width, 225 * kScaleY);
//    _videoPreview.delegate = self;
//    [_videoPreview setPlayBtnHidden:NO];
//    [self.view addSubview:_videoPreview];
//
//    if (videoTextInfos.count > 0) {
//        [_textView setEdited:YES];
//    }
//    else {
//        [_textView setEdited:NO];
//    }
//}



#pragma mark - VideoCutViewDelegate
- (void)onVideoLeftCutChanged:(TCVideoRangeSlider *)sender {
    //[_ugcEdit pausePlay];
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit previewAtTime:sender.leftPos];
}

- (void)onVideoRightCutChanged:(TCVideoRangeSlider *)sender {
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit previewAtTime:sender.rightPos];
}

- (void)onVideoCutChangedEnd:(TCVideoRangeSlider *)sender {
    _leftTime = sender.leftPos;
    _rightTime = sender.rightPos;
    _startTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)sender.leftPos / 60, (int)sender.leftPos % 60];
    _endTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)sender.rightPos / 60, (int)sender.rightPos % 60];
    [_ugcEdit startPlayFromTime:sender.leftPos toTime:sender.rightPos];
    [_videoPreview setPlayBtn:YES];
}
- (void)onVideoCenterRepeatChanged:(TCVideoRangeSlider*)sender {
    [_videoPreview setPlayBtn:NO];
    [_ugcEdit previewAtTime:sender.centerPos];
}

- (void)onVideoCenterRepeatEnd:(TCVideoRangeSlider*)sender {
    _leftTime = sender.leftPos;
    _rightTime = sender.rightPos;
    
    if (_timeType == TimeType_Repeat) {
        TXRepeat *repeat = [[TXRepeat alloc] init];
        repeat.startTime = sender.centerPos;
        repeat.endTime = sender.centerPos + 0.5;
        repeat.repeatTimes = 3;
        [_ugcEdit setRepeatPlay:@[repeat]];
        [_ugcEdit setSpeedList:nil];
    }
    else if (_timeType == TimeType_Speed) {
        TXSpeed *speed = [[TXSpeed alloc] init];
        speed.startTime = sender.centerPos;
        speed.endTime = sender.rightPos;
        speed.speedLevel = SPEED_LEVEL_SLOW;
        [_ugcEdit setSpeedList:@[speed]];
        [_ugcEdit setRepeatPlay:nil];
    }
    
    if (_isReverse) {
        [_ugcEdit startPlayFromTime:sender.leftPos toTime:sender.centerPos + 1.5];
    }else{
        [_ugcEdit startPlayFromTime:sender.centerPos toTime:sender.rightPos];
    }
    [_videoPreview setPlayBtn:YES];
}

- (void)onVideoCutChange:(TCVideoRangeSlider *)sender seekToPos:(CGFloat)pos {
    _playTime = pos;
    
    [_ugcEdit previewAtTime:pos];
    [_videoPreview setPlayBtn:NO];
    _playProgressView.progress = (pos - _leftTime) / (_rightTime - _leftTime);
}

//- (void)onSetSpeedUp:(BOOL)isSpeedUp
//{
//    if (isSpeedUp) {
//        [_ugcEdit setSpeedLevel:2.0];
//    } else {
//        [_ugcEdit setSpeedLevel:1.0];
//    }
//}

//- (void)onSetSpeedUpLevel:(CGFloat)level
//{
//    [_ugcEdit setSpeedLevel:level];
//}

- (void)onSetBeautyDepth:(float)beautyDepth WhiteningDepth:(float)whiteningDepth {
    [_ugcEdit setBeautyFilter:beautyDepth setWhiteningLevel:whiteningDepth];
}

- (void)onEffectDelete {
    [_ugcEdit deleteLastEffect];
}


#pragma mark - MPMediaPickerControllerDelegate
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSArray *items = mediaItemCollection.items;
    MPMediaItem *songItem = [items objectAtIndex:0];
    
    NSURL *url = [songItem valueForProperty:MPMediaItemPropertyAssetURL];
    NSString* songName = [songItem valueForProperty: MPMediaItemPropertyTitle];
    NSString* authorName = [songItem valueForProperty:MPMediaItemPropertyArtist];
    NSNumber* duration = [songItem valueForKey:MPMediaItemPropertyPlaybackDuration];
    NSLog(@"MPMediaItemPropertyAssetURL = %@", url);
    
    TCMusicInfo* musicInfo = [TCMusicInfo new];
    musicInfo.duration = duration.floatValue;
    musicInfo.soneName = songName;
    musicInfo.singerName = authorName;
    
    if (mediaPicker.editing) {
        mediaPicker.editing = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveAssetURLToFile:musicInfo assetURL:url];
        });
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//点击取消时回调
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 将AssetURL(音乐)导出到app的文件夹并播放
- (void)saveAssetURLToFile:(TCMusicInfo*)musicInfo assetURL:(NSURL*)assetURL
{
    
    [_musixMixView addMusicInfo:musicInfo];
    
    //    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    //
    //    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:songAsset presetName:AVAssetExportPresetAppleM4A];
    //    NSLog (@"created exporter. supportedFileTypes: %@", exporter.supportedFileTypes);
    //    exporter.outputFileType = @"com.apple.m4a-audio";
    //
    //    [AVAssetExportSession exportPresetsCompatibleWithAsset:songAsset];
    //    NSString *docDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"LocalMusics/"];
    //    NSString *exportFilePath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.m4a", musicInfo.soneName, musicInfo.singerName]];
    //
    //    exporter.outputURL = [NSURL fileURLWithPath:exportFilePath];
    //    musicInfo.filePath = exportFilePath;
    //
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:exportFilePath]) {
    //        [_musixMixView addMusicInfo:musicInfo];
    //        return;
    //    }
    //
    //    MBProgressHUD* hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //   hub.labelText = @"音频读取中...";
    
    // do the export
    //__weak typeof(self) weakSelf = self;
    //    [exporter exportAsynchronouslyWithCompletionHandler:^{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        });
    //        int exportStatus = exporter.status;
    //        switch (exportStatus) {
    //            case AVAssetExportSessionStatusFailed: {
    //                NSLog (@"AVAssetExportSessionStatusFailed: %@", exporter.error);
    //                break;
    //
    //            }
    //            case AVAssetExportSessionStatusCompleted: {
    //                NSLog(@"AVAssetExportSessionStatusCompleted: %@", exporter.outputURL);
    //
    //                // 播放背景音乐
    //                dispatch_async(dispatch_get_main_queue(), ^{
    //                    [_musixMixView addMusicInfo:musicInfo];
    //                });
    //                break;
    //            }
    //            case AVAssetExportSessionStatusUnknown: { NSLog (@"AVAssetExportSessionStatusUnknown"); break;}
    //            case AVAssetExportSessionStatusExporting: { NSLog (@"AVAssetExportSessionStatusExporting"); break;}
    //            case AVAssetExportSessionStatusCancelled: { NSLog (@"AVAssetExportSessionStatusCancelled"); break;}
    //            case AVAssetExportSessionStatusWaiting: { NSLog (@"AVAssetExportSessionStatusWaiting"); break;}
    //            default: { NSLog (@"didn't get export status"); break;}
    //        }
    //    }];
}
#pragma mark - VideoEffectViewDelegate
- (void)onVideoEffectBeginClick:(TXEffectType)effectType
{
    _effectType = effectType;
    switch ((TXEffectType)_effectType) {
        case TXEffectType_ROCK_LIGHT:
            [_videoCutView startColoration:UIColorFromRGB(0xEC5F9B) alpha:0.7];
            break;
        case TXEffectType_DARK_DRAEM:
            [_videoCutView startColoration:UIColorFromRGB(0xEC8435) alpha:0.7];
            break;
        case TXEffectType_SOUL_OUT:
            [_videoCutView startColoration:UIColorFromRGB(0x1FBCB6) alpha:0.7];
            break;
        case TXEffectType_SCREEN_SPLIT:
            [_videoCutView startColoration:UIColorFromRGB(0x449FF3) alpha:0.7];
            break;
        default:
            break;
    }
    [_ugcEdit startEffect:(TXEffectType)_effectType startTime:_playTime];
    if (!_isReverse) {
        [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.currentPos toTime:_videoCutView.videoRangeSlider.rightPos];
    }else{
        [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.currentPos];
    }
    [_videoPreview setPlayBtn:YES];
}

- (void)onVideoEffectEndClick:(TXEffectType)effectType {
    _delEffectBtn.hidden = NO;
    if (_effectType != -1) {
        [_videoPreview setPlayBtn:NO];
        [_videoCutView stopColoration];
        [_ugcEdit stopEffect:effectType endTime:_playTime];
        [_ugcEdit pausePlay];
        _effectType = -1;
    }
}
-(void)onEffectSelDelete{
    //删除特效
    [_videoCutView.videoRangeSlider removeLastColoration];
    [_ugcEdit deleteLastEffect];
    
    if (_videoCutView.videoRangeSlider.colorInfos.count<=0) {
        _delEffectBtn.hidden = YES;
    }
}
#pragma mark TimeSelectViewDelegate
- (void)onVideoTimeEffectsClear {
    _timeType = TimeType_Clear;
    _isReverse = NO;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setRepeatPlay:nil];
    [_ugcEdit setSpeedList:nil];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:YES];
}
- (void)onVideoTimeEffectsBackPlay {
    _timeType = TimeType_Back;
    _isReverse = YES;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setRepeatPlay:nil];
    [_ugcEdit setSpeedList:nil];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:YES];
    _videoCutView.videoRangeSlider.hidden = NO;
}
- (void)onVideoTimeEffectsRepeat {
    _timeType = TimeType_Repeat;
    _isReverse = NO;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setSpeedList:nil];
    TXRepeat *repeat = [[TXRepeat alloc] init];
    repeat.startTime = _leftTime + (_rightTime - _leftTime) / 5;
    repeat.endTime = repeat.startTime + 0.5;
    repeat.repeatTimes = 3;
    [_ugcEdit setRepeatPlay:@[repeat]];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:NO];
    [_videoCutView setCenterPanFrame:repeat.startTime];
}

- (void)onVideoTimeEffectsSpeed {
    _timeType = TimeType_Speed;
    _isReverse = NO;
    [_ugcEdit setReverse:_isReverse];
    [_ugcEdit setRepeatPlay:nil];
    TXSpeed *speed =[[TXSpeed alloc] init];
    speed.startTime = _leftTime + (_rightTime - _leftTime) * 1.5 / 5;
    speed.endTime = _videoCutView.videoRangeSlider.rightPos;
    speed.speedLevel = SPEED_LEVEL_SLOW;
    [_ugcEdit setSpeedList:@[speed]];
    [_ugcEdit startPlayFromTime:_videoCutView.videoRangeSlider.leftPos toTime:_videoCutView.videoRangeSlider.rightPos];
    
    [_videoPreview setPlayBtn:YES];
    [_videoCutView setCenterPanHidden:NO];
    [_videoCutView setCenterPanFrame:speed.startTime];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//- (BOOL)prefersStatusBarHidden{
//    return NO;
//}
@end
/*
 _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _playProgressView.bottom + 10 * kScaleY, 50, 12)];
 _startTimeLabel.text = @"0:00";
 _startTimeLabel.textAlignment = NSTextAlignmentLeft;
 _startTimeLabel.font = [UIFont systemFontOfSize:12];
 _startTimeLabel.textColor = UIColor.lightTextColor;
 [self.view addSubview:_startTimeLabel];
 
 _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 15 - 50, _playProgressView.bottom + 10, 50, 12)];
 _endTimeLabel.text = @"0:00";
 _endTimeLabel.textAlignment = NSTextAlignmentRight;
 _endTimeLabel.font = [UIFont systemFontOfSize:12];
 _endTimeLabel.textColor = UIColor.lightTextColor;
 [self.view addSubview:_endTimeLabel];
 */
