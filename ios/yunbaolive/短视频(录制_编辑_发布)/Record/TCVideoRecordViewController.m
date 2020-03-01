
#import <Foundation/Foundation.h>
#import "TCVideoRecordViewController.h"
//#import <TXLiteAVSDK_UGC/TXUGCRecord.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
//#import <TXLiteAVSDK_UGC/TXLiveRecordTypeDef.h>
#import <TXLiteAVSDK_Professional/TXLiveRecordTypeDef.h>
#import "TCVideoPublishController.h"
//#import "TCVideoPreviewViewController.h"
#import "V8HorizontalPickerView.h"
#import <AVFoundation/AVFoundation.h>
//#import <TXLiteAVSDK_UGC/TXUGCPartsManager.h>
#import <TXLiteAVSDK_Professional/TXUGCPartsManager.h>

#import "TCVideoEditViewController.h"

/********************  TiFaceSDK添加 开始 ********************/
#include "TiUIView.h"
#include "TiSDKInterface.h"
/********************  TiFaceSDK添加 结束 ********************/

#import "AlbumVideoVC.h"
#import "speedView.h"
#import "musicViewVideo.h"

#define BUTTON_RECORD_SIZE          65
#define BUTTON_CONTROL_SIZE         40


typedef NS_ENUM(NSInteger,TCLVFilterType) {
    FilterType_None 		= 0,
    FilterType_white        ,   //美白滤镜
    FilterType_langman 		,   //浪漫滤镜
    FilterType_qingxin 		,   //清新滤镜
    FilterType_weimei 		,   //唯美滤镜
    FilterType_fennen 		,   //粉嫩滤镜
    FilterType_huaijiu 		,   //怀旧滤镜
    FilterType_landiao 		,   //蓝调滤镜
    FilterType_qingliang 	,   //清凉滤镜
    FilterType_rixi 		,   //日系滤镜
};

#if POD_PITU
#import "MCCameraDynamicView.h"
#import "MaterialManager.h"
#import "MCTip.h"
@interface TCVideoRecordViewController () <MCCameraDynamicDelegate>

@end
#endif

@interface TCVideoRecordViewController()<TXUGCRecordListener,V8HorizontalPickerViewDelegate,V8HorizontalPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TXVideoCustomProcessDelegate,TiUIViewDelegate,UIScrollViewDelegate>
{
    
    UIImage *videobackImage;
    NSString *exportPath;
    BOOL                            _cameraFront;
    BOOL                            _lampOpened;
    BOOL                            _bottomViewShow;
    
    int                             _beautyDepth;
    int                             _whitenDepth;
    
    BOOL                            _cameraPreviewing;
    BOOL                            _videoRecording;
    UIView *                        _videoRecordView;
   
    UIButton *                      _btnCamera;
    
    UIButton *                      _btnLamp;
    UIButton *                      _btnBeauty;
    UIProgressView *                _progressView;
    UIView *                        _minimumView;
    UILabel *                       _recordTimeLabel;
    float                           _currentRecordTime;  //毫秒
    
    UIView *                        _bottomView;
    UIView *                        _beautyPage;
    UIView *                        _filterPage;
    UIButton *                      _beautyBtn;
    UIButton *                      _filterBtn;
    UISlider*                       _sdBeauty;
    UISlider*                       _sdWhitening;
    V8HorizontalPickerView *        _filterPickerView;
    NSMutableArray *                _filterArray;
    int                             _filterIndex;
    
    BOOL                            _navigationBarHidden;
    BOOL                            _statusBarHidden;
    BOOL                            _appForeground;
    BOOL                            _isPaused;
    
    UIButton              *_motionBtn;
#if POD_PITU
    MCCameraDynamicView   *_tmplBar;
    NSString              *_materialID;
#else
    UIView                *_tmplBar;
#endif
    UIButton              *_greenBtn;
    V8HorizontalPickerView  *_greenPickerView;
    NSMutableArray *_greenArray;
    
    UILabel               *_beautyLabel;
    UILabel               *_whiteLabel;
    UILabel               *_bigEyeLabel;
    UILabel               *_slimFaceLabel;
    
    
    UISlider              *_sdBigEye;
    UISlider              *_sdSlimFace;
      UIButton *                      _btnLocalVideo;//获取本地视频
    
    int    _filterType;
    int    _greenIndex;;
    
    float  _eye_level;
    float  _face_level;
    
    BOOL _musicPlayed;
    
    UIButton *deleteBtn;
    NSString *giftImagePath;
    UIButton *musicBtn;
    UIButton * btnClose;
    speedView *_sView;
    CGFloat iphoneXTop;
    BOOL _hasPush;
    
    //停止录制
    NSArray *_stop_imgs;
    NSMutableArray *_stop_record_array;
    BOOL _selAlbum;
    
}
@property(nonatomic,strong) UIButton *btnStartRecord;
@property(nonatomic,strong)UIButton *btnDone;
/********************  TiFaceSDK添加 开始 ********************/
@property(nonatomic, strong) TiUIView *tiUIView; // TiFaceSDK UI
@property(nonatomic, strong) TiSDKManager *tiSDKManager;
/******************** TiFaceSDK添加 结束 ********************/

@end


@implementation TCVideoRecordViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        _musicPlayed = NO;
        
        _cameraFront = YES;
        _lampOpened = NO;
        _bottomViewShow = NO;
        
        _beautyDepth = 6.3;
        _whitenDepth = 2.7;
        
        _cameraPreviewing = NO;
        _videoRecording = NO;

        _currentRecordTime = 0.0;
        _greenArray = [NSMutableArray new];
        //if (isTXfiter) {
        [_greenArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"无";
            v.file = nil;
            v.face = [UIImage imageNamed:@"greens_no"];
            v;
        })];
        [_greenArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"卡通";
            v.file = [[NSBundle mainBundle] URLForResource:@"goodluck" withExtension:@"mp4"];;
            v.face = [UIImage imageNamed:@"greens_1"];
            v;
        })];
        [_greenArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"DJ";
            v.file = [[NSBundle mainBundle] URLForResource:@"2gei_5" withExtension:@"mp4"];
            v.face = [UIImage imageNamed:@"greens_2"];
            v;
        })];
        
        _filterIndex = 0;
        _filterArray = [NSMutableArray new];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"原图";
            v.face = [UIImage imageNamed:@"orginal"];
            v;
        })];
        
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"美白";
            v.face = [UIImage imageNamed:@"fwhite"];
            v;
        })];
        
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"浪漫";
            v.face = [UIImage imageNamed:@"langman"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"清新";
            v.face = [UIImage imageNamed:@"qingxin"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"唯美";
            v.face = [UIImage imageNamed:@"weimei"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"粉嫩";
            v.face = [UIImage imageNamed:@"fennen"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"怀旧";
            v.face = [UIImage imageNamed:@"huaijiu"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"蓝调";
            v.face = [UIImage imageNamed:@"landiao"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"清凉";
            v.face = [UIImage imageNamed:@"qingliang"];
            v;
        })];
        [_filterArray addObject:({
            V8LabelNode *v = [V8LabelNode new];
            v.title = @"日系";
            v.face = [UIImage imageNamed:@"rixi"];
            v;
        })];
        
        //}
        giftImagePath = [[NSBundle mainBundle]pathForResource:@"stoprecord@3x" ofType:@"gif"];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAudioSessionEvent:)
                                                     name:AVAudioSessionInterruptionNotification
                                                   object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xuanzebendishipin:) name:@"bendishipin" object:nil];
        
        _appForeground = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if (_videoRecording) {
        [self stopVideoRecord];
    }
    if (self.tiUIView) {
        [self.tiUIView releaseTiUIView];
        self.tiUIView = nil;
    }
    if (self.tiSDKManager) {
        //[self.tiSDKManager destroyTexture];
        [self.tiSDKManager destroy];
        self.tiSDKManager = nil;
        NSLog(@"self.tiSDKManager = nil;");
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [[TXUGCRecord shareInstance].partsManager deleteAllParts];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    _hasPush = NO;
    _selAlbum = NO;
    if (iPhoneX) {
        iphoneXTop = 20;
    }else{
        iphoneXTop = 0;
    }
    
    _stop_imgs = @[@"录制1",@"录制2",@"录制3",@"录制4",@"录制5",@"录制6",@"录制7",@"录制6",@"录制5",@"录制4",@"录制3",@"录制2",@"录制1"];
    
    _stop_record_array = [NSMutableArray array];
    for (int i=0; i<_stop_imgs.count; i++) {
        UIImage *img = [UIImage imageNamed:_stop_imgs[i]];
        [_stop_record_array addObject:img];
    }
    
    [self initUI];
    
    if ([[common getIsTXfiter]isEqual:@"1"]) {
        [self initBeautyUI];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.view.userInteractionEnabled = YES;

    [self startCameraPreview];
    if (_currentRecordTime < MIN_RECORD_TIME*1000) {
        _btnDone.hidden = YES;
    }
    _selAlbum = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [UIApplication sharedApplication].statusBarHidden = NO;

    [self stopCameraPreview];
}

-(void)viewDidUnload {
    [super viewDidUnload];
}

-(void)onAudioSessionEvent:(NSNotification*)notification {
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        // 在10.3及以上的系统上，分享跳其它app后再回来会收到AVAudioSessionInterruptionWasSuspendedKey的通知，不处理这个事件。
        if ([info objectForKey:@"AVAudioSessionInterruptionWasSuspendedKey"]) {
            return;
        }
        _appForeground = NO;
        if (!_isPaused && _videoRecording)
            [self onBtnRecordStartClicked];
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            _appForeground = YES;
        }
    }
}

- (void)onAppDidEnterBackGround:(UIApplication*)app {
    _appForeground = NO;
    if (!_isPaused && _videoRecording)
        [self onBtnRecordStartClicked];

}

- (void)onAppWillEnterForeground:(UIApplication*)app {
    _appForeground = YES;
}


#pragma mark ---- Common UI ----
-(void)initUI {
    _videoRecordView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_videoRecordView];
    
    UIImageView* mask_top = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, BUTTON_CONTROL_SIZE)];
    [mask_top setImage:[UIImage imageNamed:@"video_record_mask_top"]];
    [self.view addSubview:mask_top];

    UIImageView* mask_buttom = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    [mask_buttom setImage:[UIImage imageNamed:@"video_record_mask_buttom"]];
    [self.view addSubview:mask_buttom];

    _btnStartRecord = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, BUTTON_RECORD_SIZE*1.5, BUTTON_RECORD_SIZE*1.5)];
    _btnStartRecord.center = CGPointMake(self.view.frame.size.width / 2, _window_height - BUTTON_RECORD_SIZE*1.2 -iphoneXTop);
    [_btnStartRecord setImage:[UIImage imageNamed:@"startrecord"] forState:UIControlStateNormal];
    [_btnStartRecord setImage:[UIImage imageNamed:@"startrecord"] forState:UIControlStateSelected];
    [_btnStartRecord addTarget:self action:@selector(onBtnRecordStartClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnStartRecord];
    
    
    btnClose = [[UIButton alloc] initWithFrame:CGRectMake(10, 30+iphoneXTop, BUTTON_CONTROL_SIZE, BUTTON_CONTROL_SIZE)];
    [btnClose setImage:[UIImage imageNamed:@"video_关闭"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(onBtnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];

    
    _btnCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCamera.frame = CGRectMake(_window_width-60, 30+iphoneXTop, 60, 60);
    [_btnCamera setImage:[UIImage imageNamed:@"翻转"] forState:UIControlStateNormal];
    [_btnCamera addTarget:self action:@selector(onBtnCameraClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnCamera setTitle:YZMsg(@"翻转") forState:0];
    _btnCamera.titleLabel.font = SYS_Font(11);
    _btnCamera = [PublicObj setUpImgDownText:_btnCamera];

    [self.view addSubview:_btnCamera];
    
    _btnLamp = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnLamp.frame = CGRectMake(_window_width-60, _btnCamera.bottom+5, 60, 60);
    [_btnLamp setImage:[UIImage imageNamed:@"闪光关"] forState:UIControlStateNormal];
    [_btnLamp addTarget:self action:@selector(onBtnLampClicked) forControlEvents:UIControlEventTouchUpInside];
    [_btnLamp setTitle:YZMsg(@"闪光灯") forState:0];
    _btnLamp.titleLabel.font = SYS_Font(11);

    _btnLamp = [PublicObj setUpImgDownText:_btnLamp];
    [self.view addSubview:_btnLamp];

    
    
    _btnBeauty = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnBeauty.frame = CGRectMake(_window_width-60, _btnLamp.bottom+5, 60, 60);
    [_btnBeauty setImage:[UIImage imageNamed:@"美颜"] forState:UIControlStateNormal];
    [_btnBeauty setTitle:YZMsg(@"美颜") forState:0];
    _btnBeauty.titleLabel.font = SYS_Font(11);
    _btnBeauty = [PublicObj setUpImgDownText:_btnBeauty];
    [_btnBeauty addTarget:self action:@selector(onBtnBeautyClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnBeauty];
    
    musicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    musicBtn.frame = CGRectMake(_window_width-60, _btnBeauty.bottom+5, 60, 60);
    [musicBtn setImage:[UIImage imageNamed:@"音乐"] forState:UIControlStateNormal];
    [musicBtn setTitle:YZMsg(@"音乐") forState:0];
    musicBtn.titleLabel.font = SYS_Font(11);
    musicBtn = [PublicObj setUpImgDownText:musicBtn];
    [musicBtn addTarget:self action:@selector(onBtnMusicClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:musicBtn];

    //获取本地视频
    _btnLocalVideo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _btnLocalVideo.center = CGPointMake(_window_width*0.75, _btnStartRecord.center.y);
    [_btnLocalVideo setImage:[UIImage imageNamed:@"上传"] forState:UIControlStateNormal];
    [_btnLocalVideo setImage:[UIImage imageNamed:@"上传"] forState:UIControlStateSelected];
    [_btnLocalVideo setTitle:YZMsg(@"上传") forState:UIControlStateNormal];
    _btnLocalVideo.titleLabel.font = SYS_Font(11);
    _btnLocalVideo = [PublicObj setUpImgDownText:_btnLocalVideo];
    [_btnLocalVideo addTarget:self action:@selector(onBtnLocalVideoClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnLocalVideo];
    
    //下一步
    deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.bounds = CGRectMake(0, 0, 30, 30);
    deleteBtn.center = CGPointMake(_window_width-110 , _btnStartRecord.center.y);
    [deleteBtn setImage:[UIImage imageNamed:@"video_删除"] forState:0];
    [deleteBtn addTarget:self action:@selector(onDeleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = YES;
    [self.view addSubview:deleteBtn];

    
    
    //下一步
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.bounds = CGRectMake(0, 0, 30, 30);
    _btnDone.center = CGPointMake(_window_width-50 , _btnStartRecord.center.y);
    [_btnDone setImage:[UIImage imageNamed:@"下一步"] forState:0];
    [_btnDone addTarget:self action:@selector(onBtnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
    _btnDone.hidden = YES;
    [self.view addSubview:_btnDone];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, _window_height-2, self.view.frame.size.width, 20)];
    _progressView.progressTintColor = Pink_Cor;//UIColorFromRGB(0X0ACCAC);
    _progressView.tintColor = UIColorFromRGB(0XBBBBBB);
    _progressView.progress = _currentRecordTime / (MAX_RECORD_TIME*1000);
    [self.view addSubview:_progressView];
    
    _minimumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 2)];
    _minimumView.backgroundColor = RGB_COLOR(@"#959396", 1);//UIColorFromRGB(0X0ACCAC);
    _minimumView.center = CGPointMake(_progressView.frame.origin.x + _progressView.width*MIN_RECORD_TIME/ MAX_RECORD_TIME, _progressView.center.y);
    [self.view addSubview:_minimumView];
    
    UILabel * minimumLabel = [[UILabel alloc]init];
    minimumLabel.frame = CGRectMake(5, 1, 150, 150);
    [minimumLabel setText:YZMsg(@"至少要录到这里")];
    [minimumLabel setFont:[UIFont fontWithName:@"" size:14]];
    [minimumLabel setTextColor:[UIColor whiteColor]];
    [minimumLabel sizeToFit];
    UIImageView * minumumImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, minimumLabel.frame.size.width + 10, minimumLabel.frame.size.height + 5)];
    minumumImageView.image = [UIImage imageNamed:@"bubble"];
    [minumumImageView addSubview:minimumLabel];
    minumumImageView.center = CGPointMake(_minimumView.center.x + 13, _minimumView.frame.origin.y - minimumLabel.frame.size.height);
    [self.view addSubview:minumumImageView];
    minumumImageView.hidden = YES;
    minimumLabel.hidden = YES;
    
    _recordTimeLabel = [[UILabel alloc]init];
    _recordTimeLabel.frame = CGRectMake(0, 0, 100, 100);
    [_recordTimeLabel setText:@"0.00s"];
    _recordTimeLabel.font = [UIFont systemFontOfSize:10];
    _recordTimeLabel.textColor = [UIColor whiteColor];
    _recordTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_recordTimeLabel sizeToFit];
    _recordTimeLabel.center = CGPointMake(CGRectGetMaxX(_progressView.frame) - _recordTimeLabel.frame.size.width / 2-10, _progressView.frame.origin.y - _recordTimeLabel.frame.size.height);
    [self.view addSubview:_recordTimeLabel];
    _sView = [[speedView alloc]initWithFrame:CGRectMake(_window_width*0.2, _btnStartRecord.top-35, _window_width*0.6, 30)];
    _sView.block = ^(int type) {
        if (type == 0) {
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_SLOWEST];
        }else if (type == 1){
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_SLOW];
        }else if (type == 2){
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_NOMAL];
        }else if (type == 3){
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_FAST];
        }else if (type == 4){
            [[TXUGCRecord shareInstance] setRecordSpeed:VIDEO_RECORD_SPEED_FASTEST];
        }
    };
    [self.view addSubview:_sView];

    
    

    
}
//本地视频
-(void)onBtnLocalVideoClicked{
    
    if (_videoRecording)    {
        [self stopCameraPreview];
        [self stopVideoRecord];
        [self refreshRecordTime:0];
        [[TXUGCRecord shareInstance].partsManager deleteAllParts];
    }
    _selAlbum = YES;
    
    /** 当用户从音乐界面选择了音乐的时候，这时又点击了从本地上传就把选择的音乐置空 */
    _haveBGM = NO;
    _musicPath=@"";
    
    _btnLocalVideo.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _btnLocalVideo.userInteractionEnabled = YES;
    });
    __weak TCVideoRecordViewController *weakSelf = self;
    AlbumVideoVC *albunVC = [[AlbumVideoVC alloc]init];
    albunVC.selEvent = ^(NSString *path) {
        [weakSelf zhuanma:path];
    };
    
    [self presentViewController:albunVC animated:YES completion:nil];
    
    /*
      UIImagePickerController *imagePickerController = [UIImagePickerController new];
      imagePickerController.delegate = self;
      imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
      imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
      [self presentViewController:imagePickerController animated:YES completion:nil];
    */
    
    
}
-(void)selectedPhoto:(NSDictionary *)subdic{
    
    NSString *videoS = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"videoURL"]];
    [self zhuanma:videoS];
    
}
//需要导入AVFoundation.h
- (UIImage*) getVideoPreViewImageWithPath:(NSURL *)videoPath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time   = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error  = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img   = [[UIImage alloc] initWithCGImage:image];
    return img;
}
-(void)zhuanma:(NSString *)videlPathsss{
    [MBProgressHUD showMessage:YZMsg(@"视频转码中")];
    //转码
    //获取缩略图
    videobackImage = [self getVideoPreViewImageWithPath:[NSURL URLWithString:videlPathsss]];
    // 视频转码
    if ([videlPathsss hasSuffix:@".mp4"] || [videlPathsss hasSuffix:@".MP4"] || [videlPathsss hasSuffix:@".Mp4"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            TXRecordResult *recordResult = [TXRecordResult new];
            recordResult.coverImage = videobackImage;
            recordResult.videoPath  = videlPathsss;
            self.view.userInteractionEnabled = NO;
            [self pushresult:recordResult];
        });

    }else{
    NSString *random = [PublicObj getNameBaseCurrentTime:@""];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:videlPathsss] options:nil];

    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPreset1280x720];
    //exportPath = [NSString stringWithFormat:@"%@/%@.mp4",[NSHomeDirectory() stringByAppendingString:@"/tmp"],random];
     exportPath = [NSString stringWithFormat:@"%@/Library/Caches/movie_%@.mp4",NSHomeDirectory(),random];
    NSLog(@"exportPath=%@",exportPath);
    exportSession.outputURL = [NSURL fileURLWithPath:exportPath];
    exportSession.outputFileType = AVFileTypeMPEG4;
//    exportSession.canPerformMultiplePassesOverSourceMediaData = YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exportSession.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:YZMsg(@"转码失败,请更换视频")];
                });
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Export canceled");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:YZMsg(@"转码失败,请更换视频")];
                });
                break;
            case AVAssetExportSessionStatusCompleted:
                NSLog(@"转换成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    TXRecordResult *recordResult = [TXRecordResult new];
                    recordResult.coverImage = videobackImage;
                    recordResult.videoPath  = exportPath;
                    self.view.userInteractionEnabled = NO;
                    [self pushresult:recordResult];
                });
                break;
        }
    }];
    }
    //如果压缩失败可不压缩直接上传   6.28
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
        TXRecordResult *recordResult = [TXRecordResult new];
        recordResult.coverImage = videobackImage;
        recordResult.videoPath  = videlPathsss;
        self.view.userInteractionEnabled = NO;
        [self pushresult:recordResult];
    });
    */
    
}
-(void)pushresult:(TXRecordResult *)recordResult{
    _hasPush = YES;
    TCVideoEditViewController *vc = [[TCVideoEditViewController alloc] init];
    [vc setVideoPath:recordResult.videoPath];
    vc.musicPath = _musicPath;
    vc.musicID = _musicID;
    vc.haveBGM = _haveBGM;
    _btnDone.hidden = YES;
    deleteBtn.hidden = YES;
    _btnLocalVideo.hidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)onBtnRecordStartClicked {
    
    if (!_videoRecording) {
        [self startVideoRecord];
        deleteBtn.hidden = YES;

    } else {
        if (_isPaused) {
            [[TXUGCRecord shareInstance] resumeRecord];
            if (_musicPath.length>0) {
                [self tcPlayMusic];
            }
            [self hideBtnWhenRecord];
            /* //rk_stop
            [weakSelf.btnStartRecord sd_setImageWithURL:[NSURL fileURLWithPath:giftImagePath] forState:0];
//            weakSelf.btnStartRecord.imageView.yy_imageURL = [NSURL fileURLWithPath:giftImagePath];
             */
            _btnStartRecord.imageView.animationImages = _stop_record_array;
            _btnStartRecord.imageView.animationDuration = _stop_record_array.count*0.1;
            _btnStartRecord.imageView.animationRepeatCount = 0;
            [_btnStartRecord.imageView startAnimating];
            
            _isPaused = NO;
            deleteBtn.hidden = YES;

        }else {
            [self showBtnWhenEnd];
            [[TXUGCRecord shareInstance] pauseRecord];
            //音乐暂停
            if (_musicPath.length>0) {
                [self tcPause];
            }
            [_btnStartRecord.imageView stopAnimating];
            [_btnStartRecord setImage:[UIImage imageNamed:@"startrecord"] forState:UIControlStateNormal];
            _isPaused = YES;
            deleteBtn.hidden = NO;
        }
    }
}
- (void)onBtnDoneClicked {
    
    _btnDone.hidden = YES;
    YBWeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.btnDone.hidden = NO;
    });
    
    if (!_videoRecording)
        return;
    
    if (_currentRecordTime < MIN_RECORD_TIME*1000) {
        [self toastTip:YZMsg(@"至少要录够5秒")];
        return;
    }
    
    [self stopVideoRecord];
    if (_musicPath.length>0) {
        [[TXUGCRecord shareInstance] stopBGM];
        _musicPlayed = NO;
    }
}
-(void)startCameraPreview {
    
    if (_cameraPreviewing == NO) {
        //简单设置
        /*
         TXUGCSimpleConfig * param = [[TXUGCSimpleConfig alloc] init];
         param.videoQuality = VIDEO_QUALITY_MEDIUM;
         [[TXUGCRecord shareInstance] startCameraSimple:param preview:_videoRecordView];
         */
        //自定义设置
        TXUGCCustomConfig * param = [[TXUGCCustomConfig alloc] init];
        param.videoResolution =  VIDEO_RESOLUTION_720_1280;
        param.videoFPS = 20;
        param.videoBitratePIN = 2400;
        param.GOP = 3;
        param.enableAEC = YES;
        param.minDuration = MIN_RECORD_TIME;
        param.maxDuration = MAX_RECORD_TIME;
       int startRes = [[TXUGCRecord shareInstance] startCameraCustom:param preview:_videoRecordView];
        NSLog(@"=====res:%d",startRes);
        if ([[common getIsTXfiter]isEqual:@"1"]) {
            [TXUGCRecord shareInstance].recordDelegate = self;
            [[TXUGCRecord shareInstance] setBeautyStyle:0 beautyLevel:_beautyDepth whitenessLevel:_whitenDepth ruddinessLevel:0];
        }else{
#pragma mark  =============萌颜 strat
            //f9b7b0e82f1a4160b29247c98c79d7b1
            
            [[TXUGCRecord shareInstance] setBeautyStyle:0 beautyLevel:0 whitenessLevel:0 ruddinessLevel:0];
            self.tiSDKManager = [[TiSDKManager alloc]init];
            self.tiUIView = [[TiUIView alloc]initTiUIViewWith:self.tiSDKManager delegate:self superView:self.view];
            self.tiUIView.isClearOldUI = NO;
            [TXUGCRecord shareInstance].recordDelegate = self;
            [TXUGCRecord shareInstance].videoProcessDelegate = self;

#pragma mark  =============萌颜 end
        }
        
        if (_greenIndex >=0 || _greenIndex < _greenArray.count) {
            V8LabelNode *v = [_greenArray objectAtIndex:_greenIndex];
            [[TXUGCRecord shareInstance] setGreenScreenFile:v.file];
        }
        
        [[TXUGCRecord shareInstance] setEyeScaleLevel:_eye_level];
        
        [[TXUGCRecord shareInstance] setFaceScaleLevel:_face_level];
        
        [self setFilter:_filterIndex];
        
#if POD_PITU
        [self motionTmplSelected:_materialID];
#endif
        _cameraPreviewing = YES;
    }
}

-(void)stopCameraPreview
{
    if (_cameraPreviewing == YES)
    {
        [[TXUGCRecord shareInstance] stopCameraPreview];
        _cameraPreviewing = NO;
    }
}

-(void)startVideoRecord {
    
    /*//rk_stop
    [self hideBtnWhenRecord];
    
//    weakSelf.btnStartRecord.imageView.yy_imageURL = [NSURL fileURLWithPath:giftImagePath];
    [weakSelf.btnStartRecord sd_setImageWithURL:[NSURL fileURLWithPath:giftImagePath] forState:0];

    [self refreshRecordTime:0.0];
    [self startCameraPreview];
    [[TXUGCRecord shareInstance] startRecord];
    
    //先开启录制再播放音乐
    //选择音乐了这里就播放
    if (_musicPath.length>0) {
        [self tcPlayMusic];
    }
    
    
    _videoRecording = YES;
    _isPaused = NO;
    */
    [self refreshRecordTime:0.0];
    [self startCameraPreview];
    
    int result =[[TXUGCRecord shareInstance] startRecord];
    if (0 != result) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"启动失败:%d",result]];
    }else{
        [self hideBtnWhenRecord];
        
        _btnStartRecord.imageView.animationImages = _stop_record_array;
        _btnStartRecord.imageView.animationDuration = _stop_record_array.count*0.1;
        _btnStartRecord.imageView.animationRepeatCount = 0;
        [_btnStartRecord.imageView startAnimating];
        
        //先开启录制再播放音乐
        //选择音乐了这里就播放
        if (_musicPath.length>0) {
            [self tcPlayMusic];
        }
        
        _videoRecording = YES;
        _isPaused = NO;
    }
   
}

-(void)stopVideoRecord {
    [self showBtnWhenEnd];
    
    int aaaa = [[TXUGCRecord shareInstance] stopRecord];
    NSLog(@"stopRecord = %d",aaaa);
    if (_musicPath.length>0) {
        [self tcStopMuic];
    }
    [_btnStartRecord.imageView stopAnimating];
    [_btnStartRecord setImage:[UIImage imageNamed:@"startrecord"] forState:UIControlStateNormal];
    [_btnStartRecord setImage:[UIImage imageNamed:@"startrecord_press"] forState:UIControlStateSelected];
    
    _isPaused = NO;
    _videoRecording = NO;
    
    //_btnDone.hidden = YES;

}

-(void)onBtnCloseClicked {
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *restAction = [UIAlertAction actionWithTitle:YZMsg(@"重新拍摄") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TXUGCPartsManager *partsManager = [TXUGCRecord shareInstance].partsManager;
        // 删除最后一段视频
        [partsManager deleteAllParts];
        //获取当前所有视频片段的总时长
        _currentRecordTime = [partsManager getDuration];
        _progressView.progress = (float)_currentRecordTime / (MAX_RECORD_TIME*1000);
        int intSecond = _currentRecordTime /1000;
        int min = ((int)_currentRecordTime % 1000)/10;
        int sec = intSecond % 60;
        [_recordTimeLabel setText:[NSString stringWithFormat:@"%0d:%02ds", sec, min]];
        [_recordTimeLabel sizeToFit];
        deleteBtn.hidden = YES;
        _btnDone.hidden = YES;
        _btnLocalVideo.hidden = NO;
        if (_musicPath) {
            [self tcStopMuic];
        }
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"退出") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self stopCameraPreview];
        [self stopVideoRecord];
#pragma mark ====== 释放UI
        [TXUGCRecord shareInstance].recordDelegate = nil;
        [TXUGCRecord shareInstance].videoProcessDelegate = nil;
        //    [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }];

    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    if (_currentRecordTime>0) {
        [alertContro addAction:restAction];
    }
    [alertContro addAction:sureAction];
    [alertContro addAction:cancleAction];
    [self presentViewController:alertContro animated:YES completion:nil];
}

-(void)onBtnCameraClicked {
    if (_lampOpened) {
        _lampOpened = NO;
         [_btnLamp setImage:[UIImage imageNamed:@"闪光关"] forState:UIControlStateNormal];
    }
    _cameraFront = !_cameraFront;
    if (_cameraFront)    {
        [_btnCamera setImage:[UIImage imageNamed:@"翻转"] forState:UIControlStateNormal];
    }else{
        [_btnCamera setImage:[UIImage imageNamed:@"翻转"] forState:UIControlStateNormal];
    }
    
    [[TXUGCRecord shareInstance] switchCamera:_cameraFront];
}

-(void)onBtnLampClicked {
    
    if (_cameraFront) {
        return;
    }
    _lampOpened = !_lampOpened;
    BOOL result = [[TXUGCRecord shareInstance] toggleTorch:_lampOpened];
    if (result == NO)    {
        _lampOpened = !_lampOpened;
        [self toastTip:YZMsg(@"闪光灯启动失败")];
    }
    
    if (_lampOpened) {
        [_btnLamp setImage:[UIImage imageNamed:@"闪光开"] forState:UIControlStateNormal];
    } else{
        [_btnLamp setImage:[UIImage imageNamed:@"闪光关"] forState:UIControlStateNormal];
    }
    
}

-(void)onBtnBeautyClicked {
    [self hideBotMixAll];
    if ([[common getIsTXfiter]isEqual:@"1"]) {
//        [self initBeautyUI];
        _bottomViewShow = !_bottomViewShow;
        if (_bottomViewShow) {
            [_btnBeauty setImage:[UIImage imageNamed:@"美颜"] forState:UIControlStateNormal];
        }else {
            [_btnBeauty setImage:[UIImage imageNamed:@"美颜"] forState:UIControlStateNormal];
        }
        _bottomView.hidden = !_bottomViewShow;
        _bottomViewShow = !_bottomViewShow;
    }else{
        [self.tiUIView createTiUIView];
    }
}
#pragma mark - 显示、隐藏按钮
-(void)hideBtnWhenRecord{
    _btnLocalVideo.hidden = YES;
    _btnBeauty.hidden = YES;
    _sView.hidden = YES;
    musicBtn.hidden = YES;
    _btnCamera.hidden = YES;
    btnClose.hidden = YES;
    _btnLamp.hidden = YES;
}
-(void)showBtnWhenEnd{
    _btnLamp.hidden = NO;
    _btnCamera.hidden = NO;
    _btnBeauty.hidden = NO;

    _sView.hidden = NO;
    musicBtn.hidden = NO;
    _btnCamera.hidden = NO;
    btnClose.hidden = NO;
    _btnLamp.hidden = NO;

}

-(void)hideBotMixAll{
    //隐藏进度条、上传、美颜、录制、下一步
    _progressView.hidden = YES;
    _minimumView.hidden = YES;
    _recordTimeLabel.hidden = YES;
    _btnLocalVideo.hidden = YES;
    _btnBeauty.hidden = YES;
    _btnStartRecord.hidden = YES;
    _btnDone.hidden = YES;
    deleteBtn.hidden = YES;
    _sView.hidden = YES;
    musicBtn.hidden = YES;
    _btnCamera.hidden = YES;
    btnClose.hidden = YES;
    _btnLamp.hidden = YES;
}
-(void)showBotMixAll{
    _progressView.hidden = NO;
    _minimumView.hidden = NO;
    _recordTimeLabel.hidden = NO;
    _btnBeauty.hidden = NO;
    _btnStartRecord.hidden = NO;
    
    _sView.hidden = NO;
    musicBtn.hidden = NO;
    _btnCamera.hidden = NO;
    btnClose.hidden = NO;
    _btnLamp.hidden = NO;
    if (_currentRecordTime > 0) {
        _btnLocalVideo.hidden = YES;
        deleteBtn.hidden = NO;
        if(_currentRecordTime >= MIN_RECORD_TIME*1000){
            _btnDone.hidden = NO;
        }

    }else{
        _btnDone.hidden = YES;
        deleteBtn.hidden = YES;
        _btnLocalVideo.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //腾讯美颜试图控制
    if (_bottomViewShow) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint _touchPoint = [touch locationInView:self.view];
        if (NO == CGRectContainsPoint(_bottomView.frame, _touchPoint)){
            [self onBtnBeautyClicked];
        }
    }
    if (_bottomView) {
        _bottomView.hidden = YES;
        [self showPreFrontView];
    }
    //萌颜视图控制(由TiUIView代理执行)
    /*
    if (self.tiUIView) {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint _touchPoint = [touch locationInView:self.view];
        if (YES == CGRectContainsPoint(self.view.frame, _touchPoint)){
            [self showBotMixAll];
        }
    }
     */
    
    
    
}

#pragma mark ---- Video Beauty UI ----
-(void)initBeautyUI {
    CGSize size = self.view.frame.size;
    
    int bottomViewHeight = 160+iphoneXTop;
    int bottomButtonHeight = 40;
    
    _bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, size.height- bottomViewHeight, size.width, bottomViewHeight)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    _bottomView.hidden = YES;
    [self.view addSubview:_bottomView];
    
    float   beauty_btn_width  = 65;
    float   beauty_btn_height = 19;
#if POD_PITU
    float   beauty_btn_count  = 4;
#else
    float   beauty_btn_count  = 2;
#endif
    float   beauty_center_interval = (_bottomView.width - 30 - beauty_btn_width)/(beauty_btn_count - 1);
    float   first_beauty_center_x  = 15 + beauty_btn_width/2;
    int ib = 0;
    float   beauty_center_y = _bottomView.height - 25-iphoneXTop;
    
    _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _beautyBtn.center = CGPointMake(first_beauty_center_x, beauty_center_y);
    _beautyBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_beautyBtn setImage:[UIImage imageNamed:@"white_beauty"] forState:UIControlStateNormal];
    [_beautyBtn setImage:[UIImage imageNamed:@"white_beauty_press"] forState:UIControlStateSelected];
    [_beautyBtn setTitle:YZMsg(@"美颜") forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:Pink_Cor forState:UIControlStateSelected];//UIColorFromRGB(0x0ACCAC)
    _beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _beautyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _beautyBtn.tag = 0;
    _beautyBtn.selected = YES;
    [_beautyBtn addTarget:self action:@selector(selectBeautyPage:) forControlEvents:UIControlEventTouchUpInside];
    ++ib;
    
    _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _filterBtn.center = CGPointMake(first_beauty_center_x + ib*beauty_center_interval, beauty_center_y);
    _filterBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_filterBtn setImage:[UIImage imageNamed:@"beautiful"] forState:UIControlStateNormal];
    [_filterBtn setImage:[UIImage imageNamed:@"beautiful_press"] forState:UIControlStateSelected];
    [_filterBtn setTitle:YZMsg(@"滤镜") forState:UIControlStateNormal];
    [_filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_filterBtn setTitleColor:Pink_Cor forState:UIControlStateSelected];//UIColorFromRGB(0x0ACCAC)
    _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _filterBtn.tag = 1;
    [_filterBtn addTarget:self action:@selector(selectBeautyPage:) forControlEvents:UIControlEventTouchUpInside];
    ++ib;
    
#if POD_PITU
    _motionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _motionBtn.center = CGPointMake(first_beauty_center_x + ib*beauty_center_interval, beauty_center_y);
    _motionBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_motionBtn setImage:[UIImage imageNamed:@"move"] forState:UIControlStateNormal];
    [_motionBtn setImage:[UIImage imageNamed:@"move_press"] forState:UIControlStateSelected];
    [_motionBtn setTitle:@"动效" forState:UIControlStateNormal];
    [_motionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_motionBtn setTitleColor:Pink_Cor forState:UIControlStateSelected];//UIColorFromRGB(0x0ACCAC)
    _motionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _motionBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _motionBtn.tag = 2;
    [_motionBtn addTarget:self action:@selector(selectBeautyPage:) forControlEvents:UIControlEventTouchUpInside];
    ib++;

    
    _greenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _greenBtn.center = CGPointMake(first_beauty_center_x + ib*beauty_center_interval, beauty_center_y);
    _greenBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_greenBtn setImage:[UIImage imageNamed:@"greens"] forState:UIControlStateNormal];
    [_greenBtn setImage:[UIImage imageNamed:@"greens_press"] forState:UIControlStateSelected];
    [_greenBtn setTitle:@"绿幕" forState:UIControlStateNormal];
    [_greenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_greenBtn setTitleColor:Pink_Cor forState:UIControlStateSelected];//UIColorFromRGB(0x0ACCAC)
    _greenBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _greenBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _greenBtn.tag = 3;
    [_greenBtn addTarget:self action:@selector(selectBeautyPage:) forControlEvents:UIControlEventTouchUpInside];
    ib++;
#endif
    
    [_bottomView addSubview:_beautyBtn];
    [_bottomView addSubview:_filterBtn];
#if POD_PITU
    [_bottomView addSubview:_motionBtn];
    [_bottomView addSubview:_greenBtn];
#endif
    //美颜 Page
    _beautyPage = [[UIView alloc] init];
    _beautyPage.frame = CGRectMake(0, 0, size.width, bottomViewHeight - bottomButtonHeight-iphoneXTop);
    [_beautyPage setBackgroundColor:[UIColor whiteColor]];
    
    _beautyLabel = [[UILabel alloc]init];
    
#if POD_PITU
    _beautyLabel.frame = CGRectMake(10,  _beautyBtn.top - 40, 40, 20);
#else
    _beautyLabel.frame = CGRectMake(10,  _beautyBtn.top - 95, 40, 20);
#endif
    [_beautyLabel setText:YZMsg(@"美颜")];
    [_beautyLabel setFont:[UIFont systemFontOfSize:12]];
    
    _sdBeauty = [[UISlider alloc] init];
#if POD_PITU
    _sdBeauty.frame = CGRectMake(_beautyLabel.right, _beautyBtn.top - 40, size.width / 2 - _beautyLabel.right - 7, 20);
#else
    _sdBeauty.frame = CGRectMake(_beautyLabel.right, _beautyBtn.top - 95, size.width - _beautyLabel.right - 10, 20);
#endif
    
    _sdBeauty.minimumValue = 0;
    _sdBeauty.maximumValue = 9;
    _sdBeauty.value = _beautyDepth;
    _sdBeauty.center = CGPointMake(_sdBeauty.center.x, _beautyLabel.center.y);
    [_sdBeauty setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdBeauty setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
    [_sdBeauty setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdBeauty addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdBeauty.tag = 0;
    
    _whiteLabel = [[UILabel alloc] init];

#if POD_PITU
    _whiteLabel.frame = CGRectMake(_sdBeauty.right + 15, _beautyBtn.top - 40, 40, 20);
#else
    _whiteLabel.frame = CGRectMake(10, _beautyBtn.top - 55, 40, 20);
#endif
    [_whiteLabel setText:@"美白"];
    [_whiteLabel setFont:[UIFont systemFontOfSize:12]];
    
    _sdWhitening = [[UISlider alloc] init];

#if POD_PITU
    _sdWhitening.frame = CGRectMake(_whiteLabel.right, _beautyBtn.top - 40, size.width - _whiteLabel.right - 10, 20);
#else
    _sdWhitening.frame = CGRectMake(_whiteLabel.right, _beautyBtn.top - 55, size.width - _whiteLabel.right - 10, 20);
#endif
    _sdWhitening.minimumValue = 0;
    _sdWhitening.maximumValue = 9;
    _sdWhitening.value = _whitenDepth;
    _sdWhitening.center = CGPointMake(_sdWhitening.center.x, _whiteLabel.center.y);
    [_sdWhitening setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdWhitening setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
    [_sdWhitening setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdWhitening addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdWhitening.tag = 1;
    
#if POD_PITU
    _bigEyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _sdBeauty.top - 60, 40, 20)];
    _bigEyeLabel.text = @"大眼";
    _bigEyeLabel.font = [UIFont systemFontOfSize:12];
    _sdBigEye = [[UISlider alloc] init];
    _sdBigEye.frame =  CGRectMake(_bigEyeLabel.right, _sdBeauty.top - 60, size.width / 2 - _bigEyeLabel.right - 7, 20);
    _sdBigEye.minimumValue = 0;
    _sdBigEye.maximumValue = 9;
    _sdBigEye.value = 0;
    [_sdBigEye setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdBigEye setMinimumTrackImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_sdBigEye setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdBigEye addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdBigEye.tag = 2;
    
    _slimFaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sdBigEye.right + 15, _sdBeauty.top - 60, 40, 20)];
    _slimFaceLabel.text = @"瘦脸";
    _slimFaceLabel.font = [UIFont systemFontOfSize:12];
    _sdSlimFace = [[UISlider alloc] init];
    _sdSlimFace.frame =  CGRectMake(_slimFaceLabel.right, _sdBeauty.top - 60, size.width - _slimFaceLabel.right - 10, 20);
    _sdSlimFace.minimumValue = 0;
    _sdSlimFace.maximumValue = 9;
    _sdSlimFace.value = 0;
    [_sdSlimFace setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdSlimFace setMinimumTrackImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    [_sdSlimFace setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdSlimFace addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdSlimFace.tag = 3;
#endif
    
    [_beautyPage addSubview:_beautyLabel];
    [_beautyPage addSubview:_sdBeauty];
    [_beautyPage addSubview:_whiteLabel];
    [_beautyPage addSubview:_sdWhitening];
    [_beautyPage addSubview:_bigEyeLabel];
    [_beautyPage addSubview:_sdBigEye];
    [_beautyPage addSubview:_slimFaceLabel];
    [_beautyPage addSubview:_sdSlimFace];
    [_bottomView addSubview:_beautyPage];
    
    //滤镜 Page
    _filterPage = [[UIView alloc] init];
    _filterPage.frame = CGRectMake(0, 0, size.width, bottomViewHeight - bottomButtonHeight-iphoneXTop);
    [_filterPage setBackgroundColor:[UIColor whiteColor]];
    _filterPage.hidden = YES;
    
    _filterPickerView = [[V8HorizontalPickerView alloc] init];
    _filterPickerView.frame = CGRectMake(0, 10, size.width, bottomViewHeight - bottomButtonHeight - 20-iphoneXTop);
//    _filterPickerView.center = _filterPage.center;
    _filterPickerView.textColor = [UIColor grayColor];
    _filterPickerView.elementFont = [UIFont fontWithName:@"" size:14];
    _filterPickerView.delegate = self;
    _filterPickerView.dataSource = self;
    _filterPickerView.selectedMaskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_selected"]];
    
    [_filterPage addSubview:_filterPickerView];
    [_bottomView addSubview:_filterPage];
    
    
#if POD_PITU
    _tmplBar = [[MCCameraDynamicView alloc] initWithFrame:CGRectMake(0.f, 0, size.width, 115.f)];
    _tmplBar.delegate = self;
    _tmplBar.hidden = YES;
    [_bottomView addSubview:_tmplBar];
    
    _greenPickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0, _beautyBtn.top - 96, size.width, 66)];
    _greenPickerView.selectedTextColor = [UIColor blackColor];
    _greenPickerView.textColor = [UIColor grayColor];
    _greenPickerView.elementFont = [UIFont fontWithName:@"" size:14];
    _greenPickerView.delegate = self;
    _greenPickerView.dataSource = self;
    _greenPickerView.hidden = YES;
    _greenPickerView.selectedMaskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greens_selected.png"]];
    _greenIndex = 0;
    [_bottomView addSubview:_greenPickerView];
#endif
}


-(void)selectBeautyPage:(UIButton *)button
{
    switch (button.tag)
    {
        case 0:
            _beautyPage.hidden = NO;
            _beautyBtn.selected = YES;
            
            _filterPage.hidden = YES;
            _filterBtn.selected = NO;
            
            _motionBtn.selected = NO;
            _greenBtn.selected  = NO;
            _tmplBar.hidden = YES;
            _greenPickerView.hidden = YES;
            
            break;
            
        case 1:
            _beautyPage.hidden = YES;
            _beautyBtn.selected = NO;
            
            _filterPage.hidden = NO;
            _filterBtn.selected = YES;
            
            [_filterPickerView scrollToElement:_filterIndex animated:NO];
            
            _motionBtn.selected = NO;
            _greenBtn.selected  = NO;
            _tmplBar.hidden = YES;
            _greenPickerView.hidden = YES;
            break;
            
        case 2: {
            _beautyPage.hidden = YES;
            _beautyBtn.selected = NO;
            
            _filterPage.hidden = YES;
            _filterBtn.selected = NO;
            
            _motionBtn.selected = YES;
            _greenBtn.selected  = NO;
            _tmplBar.hidden = NO;
            _greenPickerView.hidden = YES;
        }
            break;
        case 3: {
            _beautyPage.hidden = YES;
            _beautyBtn.selected = NO;
            
            _filterPage.hidden = YES;
            _filterBtn.selected = NO;
            
            _motionBtn.selected = NO;
            _greenBtn.selected  = YES;
            _tmplBar.hidden = YES;
            _greenPickerView.hidden = NO;
            [_greenPickerView scrollToElement:_greenIndex animated:NO];
        }
    }
}

-(void)sliderValueChange:(UISlider*)obj
{
    int tag = (int)obj.tag;
    float value = obj.value;
    
    switch (tag) {
        case 0:
            _beautyDepth = value;
            [[TXUGCRecord shareInstance] setBeautyStyle:0 beautyLevel:_beautyDepth whitenessLevel:_whitenDepth ruddinessLevel:0];
            break;
            
        case 1:
            _whitenDepth = value;
            [[TXUGCRecord shareInstance] setBeautyStyle:0 beautyLevel:_beautyDepth whitenessLevel:_whitenDepth ruddinessLevel:0];
            break;
        case 2: //大眼
            _eye_level = value;
            [[TXUGCRecord shareInstance] setEyeScaleLevel:_eye_level];
            break;
         case 3:  //瘦脸
            _face_level = value;
            [[TXUGCRecord shareInstance] setFaceScaleLevel:_face_level];
            break;
        default:
            break;
    }
}

-(void)refreshRecordTime:(float)milliSecond {
    int intSecond = milliSecond /1000;
    
    _currentRecordTime = milliSecond;
    
    if (_currentRecordTime>MIN_RECORD_TIME*1000) {
        _btnDone.hidden = NO;
    }else{
        _btnDone.hidden = YES;
    }
    _progressView.progress = (float)_currentRecordTime / (MAX_RECORD_TIME*1000);
    int min = ((int)milliSecond % 1000)/10;
    int sec = intSecond % 60;
    
    [_recordTimeLabel setText:[NSString stringWithFormat:@"%d:%02ds", sec, min]];
    [_recordTimeLabel sizeToFit];
}

#pragma mark ---- VideoRecordListener ----
-(void)onRecordEvent:(NSDictionary *)evt{
    NSLog(@"%@",evt);
}
-(void)onRecordProgress:(NSInteger)milliSecond {
    NSLog(@"=====<><><>==%ld",(long)milliSecond);
    
     [self refreshRecordTime:(float)milliSecond];
}

-(void) onRecordComplete:(TXRecordResult*)result {
    
    if (_appForeground)    {
        if (result.retCode == UGC_RECORD_RESULT_OK) {
            
            if (_hasPush==NO) {
                [self pushresult:result];
            }
            [self refreshRecordTime:0.0];
            
            [self stopCameraPreview];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_BEYOND_MAXDURATION){
            
            if (_hasPush==NO) {
                [self pushresult:result];
            }
            [self refreshRecordTime:0.0];
            
            [self stopCameraPreview];
            [self stopVideoRecord];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_INTERRUPT){
            [MBProgressHUD showError:@"录制被打断"];
        }
        else if(result.retCode == UGC_RECORD_RESULT_OK_UNREACH_MINDURATION){
            [MBProgressHUD showError:[NSString stringWithFormat:@"至少要录够%d秒",MIN_RECORD_TIME]];
        }
        else if(result.retCode == UGC_RECORD_RESULT_FAILED){
            if (_selAlbum==NO) {
                [MBProgressHUD showError:@"视频录制失败"];
            }
        }
    }
    //分片不再使用的时候请主动删除，否则分片会一直存在本地，导致内存占用越来越大，下次startRecord时候，SDK也会默认加载当前分片
    [[TXUGCRecord shareInstance].partsManager deleteAllParts];
    if (_musicPath.length>0) {
        [[TXUGCRecord shareInstance] setBGM:nil];
    }
}
#if POD_PITU
- (void)motionTmplSelected:(NSString *)materialID {
    if (materialID == nil) {
        [MCTip hideText];
    }
    _materialID = materialID;
    if ([MaterialManager isOnlinePackage:materialID]) {
        [[TXUGCRecord shareInstance] selectMotionTmpl:materialID inDir:[MaterialManager packageDownloadDir]];
    } else {
        NSString *localPackageDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Resource"];
        [[TXUGCRecord shareInstance] selectMotionTmpl:materialID inDir:localPackageDir];
    }
}
#endif
#pragma mark - HorizontalPickerView DataSource
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    if (picker == _greenPickerView) {
        return [_greenArray count];
    } else if(picker == _filterPickerView) {
        return [_filterArray count];
    }
    return 0;
}

#pragma mark - HorizontalPickerView Delegate Methods
- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    if (picker == _greenPickerView) {
        V8LabelNode *v = [_greenArray objectAtIndex:index];
        return [[UIImageView alloc] initWithImage:v.face];
    } else if(picker == _filterPickerView) {
        V8LabelNode *v = [_filterArray objectAtIndex:index];
        return [[UIImageView alloc] initWithImage:v.face];
    }
    return nil;
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    if (picker == _greenPickerView) {
        return 70;
    }
    return 90;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index
{
    if (picker == _greenPickerView) {
        _greenIndex = index;
        V8LabelNode *v = [_greenArray objectAtIndex:index];
        [[TXUGCRecord shareInstance] setGreenScreenFile:v.file];
        return;
    }
    if (picker == _filterPickerView) {
        _filterIndex = index;
        
        [self setFilter:_filterIndex];
    }
}

- (void)setFilter:(int)index
{
    NSString* lookupFileName = @"";
    
    switch (index) {
        case FilterType_None:
            break;
        case FilterType_white:
            lookupFileName = @"filter_white";
            break;
        case FilterType_langman:
            lookupFileName = @"filter_langman";
            break;
        case FilterType_qingxin:
            lookupFileName = @"filter_qingxin";
            break;
        case FilterType_weimei:
            lookupFileName = @"filter_weimei";
            break;
        case FilterType_fennen:
            lookupFileName = @"filter_fennen";
            break;
        case FilterType_huaijiu:
            lookupFileName = @"filter_huaijiu";
            break;
        case FilterType_landiao:
            lookupFileName = @"filter_landiao";
            break;
        case FilterType_qingliang:
            lookupFileName = @"filter_qingliang";
            break;
        case FilterType_rixi:
            lookupFileName = @"filter_rixi";
            break;
        default:
            break;
    }
    
    NSString * path = [[NSBundle mainBundle] pathForResource:lookupFileName ofType:@"png"];
    if (path != nil && index != FilterType_None)
    {
        [[TXUGCRecord shareInstance] setFilter:[UIImage imageWithContentsOfFile:path]];
    }
    else
    {
        [[TXUGCRecord shareInstance] setFilter:nil];
    }
}

#pragma mark - Misc Methods

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void) toastTip:(NSString*)toastInfo
{
    CGRect frameRC = [[UIScreen mainScreen] bounds];
    frameRC.origin.y = frameRC.size.height - 100;
    frameRC.size.height -= 100;
    __block UITextView * toastView = [[UITextView alloc] init];
    
    toastView.editable = NO;
    toastView.selectable = NO;
    
    frameRC.size.height = [self heightForString:toastView andWidth:frameRC.size.width];
    
    toastView.frame = frameRC;
    
    toastView.text = toastInfo;
    toastView.backgroundColor = [UIColor whiteColor];
    toastView.alpha = 0.5;
    
    [self.view addSubview:toastView];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(){
        [toastView removeFromSuperview];
        toastView = nil;
    });
}
- (void)xuanzebendishipin:(NSNotification *)notifition{
    
    NSDictionary *subdic = [notifition userInfo];
    NSLog(@"subdic === %@",subdic);
    NSString *videoS = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"videoURL"]];
    [self zhuanma:videoS];
}

#pragma mark ================ TXVideoProcessDelegate ===============

- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{
    
    /******************** TiFaceSDK添加 开始 ********************/
    if (!self.tiSDKManager) {
        return texture;
    }
    return [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO];

    /******************** TiFaceSDK添加 结束 ********************/
}
- (void)onTextureDestoryed{
    if (self.tiSDKManager) {
//        [self.tiSDKManager destroyTexture];
        [self.tiSDKManager destroy];
    }
//    [self.tiSDKManager destroy];
    NSLog(@"[self.tiSDKManager destroy];");
}
#pragma mark ========== 腾讯滤镜 start

- (void)onSetFilterWithImage:(UIImage*)image{
    [[TXUGCRecord shareInstance] setFilter:image];
}
- (void)onSetBeautyDepth:(float)beautyDepth WhiteningDepth:(float)whiteningDepth{

}
-(void)onTiTapEvent {
    [self showBotMixAll];
}
#pragma mark ========== 腾讯滤镜 end

#pragma mark ========== 播放音乐 start

-(void)tcPlayMusic{
    if (_musicPlayed==NO) {
       float length = [[TXUGCRecord shareInstance] setBGM:_musicPath];
        NSLog(@"======%f",length);
        if (length>0) {
            [[TXUGCRecord shareInstance]playBGMFromTime:0 toTime:length withBeginNotify:^(NSInteger errCode) {
                //beginNotify: 音乐播放开始的回调通知
                NSLog(@"开始播音乐");
            } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
                //beginNotify: 音乐播放开始的回调通知
                NSLog(@"音乐进度%ld/%ld",(long)progressMS,(long)durationMS);
            } andCompleteNotify:^(NSInteger errCode) {
                //completeNotify: 音乐播放结束的回调通知
                NSLog(@"播放完毕%ld",errCode);
            }];
        }
        [[TXUGCRecord shareInstance] setBGMVolume:1];
        //播放背景音乐的时候禁止麦克风采集声音
        [[TXUGCRecord shareInstance] setMicVolume:0];
    }else{
        [[TXUGCRecord shareInstance] resumeBGM];
    }
}
-(void)tcPause{
    _musicPlayed = YES;
    [[TXUGCRecord shareInstance] pauseBGM];
}
-(void)tcStopMuic{
    _musicPlayed = NO;
    [[TXUGCRecord shareInstance] stopBGM];
}
#pragma mark ========== 播放音乐 end


- (void)onDeleteBtnClicked{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"确定删除上一段视频") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TXUGCPartsManager *partsManager = [TXUGCRecord shareInstance].partsManager;
        // 删除最后一段视频
        [partsManager deleteLastPart];
        //获取当前所有视频片段的总时长
        _currentRecordTime = [partsManager getDuration];
        _progressView.progress = (float)_currentRecordTime / (MAX_RECORD_TIME*1000);
        int intSecond = _currentRecordTime /1000;
        int min = ((int)_currentRecordTime % 1000)/10;
        int sec = intSecond % 60;
        [_recordTimeLabel setText:[NSString stringWithFormat:@"%0d:%02ds", sec, min]];
        [_recordTimeLabel sizeToFit];
        if (_currentRecordTime == 0) {
            deleteBtn.hidden = YES;
            _btnDone.hidden = YES;
            _btnLocalVideo.hidden = NO;
            NSLog(@"隐藏删除按钮");
        }

    }];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];
}
- (void)showPreFrontView{
    [self showBotMixAll];
}
- (void)onBtnMusicClicked{
    //更改音乐
    musicViewVideo *mVC = [[musicViewVideo alloc]init];
    mVC.fromWhere = @"edit";
    mVC.pathEvent = ^(NSString *event, NSString *musicID) {
        if (_musicPath.length>0) {
            [self tcStopMuic];
        }
        _musicPath = event;
        _musicID = musicID;
        _haveBGM = YES;
    };
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVC];
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:nav animated:YES completion:nil];
    mVC.view.superview.backgroundColor = [UIColor clearColor];
    nav.view.superview.backgroundColor = [UIColor clearColor];

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
