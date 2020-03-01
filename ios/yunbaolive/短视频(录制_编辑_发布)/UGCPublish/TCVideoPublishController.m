
//#import <TXLiteAVSDK_UGC/TXUGCPublish.h>
//#import <TXRTMPSDK/TXUGCRecord.h>
//#import <TXRTMPSDK/TXUGCPublish.h>
//#import <TXRTMPSDK/TXLivePlayer.h>

#import "TCVideoPublishController.h"
#import "UIView+CustomAutoLayout.h"
#import "TCVideoRecordViewController.h"

//#import <TXLiteAVSDK_UGC/TXUGCRecord.h>
//#import <TXLiteAVSDK_UGC/TXLivePlayer.h>
#import <TXLiteAVSDK_Professional/TXUGCRecord.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <Qiniu/QiniuSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>
//#import <COSClient.h>
#import "QCloudCore.h"
#import <QCloudCOSXML/QCloudCOSXML.h>

#import "PublishShareV.h"
#import "ZYTabBarController.h"
#import "AFNetworking.h"

@interface TCVideoPublishController()<TXLivePlayListener,QCloudSignatureProvider>
@property BOOL isNetWorkErr;
@property UIImageView      *imgPublishState;

@property (nonatomic,strong) NSString *imagekey;
@property (nonatomic,strong) NSString *videokey;
//分享的视频id 和 截图
@property (nonatomic,strong) NSString *videoid;
@property (nonatomic,strong) NSString *image_thumb;

/** 顶部组合：视频预览、视频描述 */
@property(nonatomic,strong)UIView   *topMix;

@property(nonatomic,strong)UIView  *videoPreview;               //视频预览
@property(nonatomic,strong)MyTextView  *videoDesTV;             //视频描述
@property(nonatomic,strong) UILabel *wordsNumL;                 //字符统计

/** 定位组合：图标、位置 */
@property(nonatomic,strong)UIView *locationV;

/** 分享平台组合 */
@property(nonatomic,strong)PublishShareV *platformV;

/** 发布按钮 */
@property(nonatomic,strong)UIButton *publishBtn;

/**
 *  tx上传
 */
@property(nonatomic,strong)NSDictionary *TXSignDic;
@end
@implementation TCVideoPublishController
{
    int sharetype;           //分享类型
    NSString *mytitle;
    
    //TXUGCPublish   *_videoPublish;
    TXLivePlayer     *_livePlayer;
    
    //TXPublishParam   *_videoPublishParams;
    TXRecordResult   *_recordResult;
    
    BOOL            _isPublished;
    BOOL            _playEnable;
    id              _videoRecorder;
    BOOL            _isNetWorkErr;
    NSString *qntoken;                       //七牛token
    
    NSString *filePathhh;                    //图片保存路径
   
    NSString *tengxunID;
    NSString *bucketName;
    NSString *regionName;
}
#define TXYappId @"1255500835"
- (instancetype)initWithPath:(NSString *)videoPath videoMsg:(TXVideoInfo *) videoMsg {
    TXRecordResult *recordResult = [TXRecordResult new];
    recordResult.coverImage = videoMsg.coverImage;
    recordResult.videoPath = videoPath;
    
    return [self init:nil recordType:0
         RecordResult:recordResult
           TCLiveInfo:nil];
    
}

- (instancetype)init:(id)videoRecorder recordType:(NSInteger)recordType RecordResult:(TXRecordResult *)recordResult  TCLiveInfo:(NSDictionary *)liveInfo {
    self = [super init];
    if (self) {

        sharetype = 0;
        //_videoPublishParams = [[TXPublishParam alloc] init];
        
        _recordResult = recordResult;
        _videoRecorder = videoRecorder;
        
        _isPublished = NO;
        _playEnable  = YES;
        _isNetWorkErr = NO;
        
        //_videoPublish = [[TXUGCPublish alloc] initWithUserID:[Config getOwnID]];
        //_videoPublish.delegate = self;
        _livePlayer  = [[TXLivePlayer alloc] init];
        _livePlayer.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _playEnable = YES;
    if (_isPublished == NO) {
        [_livePlayer startPlay:_recordResult.videoPath type:PLAY_TYPE_LOCAL_VIDEO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _playEnable = NO;
    [_livePlayer stopPlay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = Black_Cor;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
    
    [self creatNavi];
    
    //顶部视图：预览、描述
    [self.view addSubview:self.topMix];
    
    //定位
    [self.view addSubview:self.locationV];
    
    //分享平台
    [self.view addSubview:self.platformV];
    if ([common share_type].count==0) {
        self.platformV.hidden = YES;
    }
    //发布
    [self.view addSubview:self.publishBtn];
    
    [_livePlayer setupVideoWidget:CGRectZero containView:_videoPreview insertIndex:0];
    
//    [BGSetting getBgSettingUpdate:NO maintain:NO eventBack:nil];
    
}

- (void)closeKeyboard:(UITapGestureRecognizer *)gestureRecognizer {
    [_videoDesTV resignFirstResponder];
}

#pragma mark - 发布
- (void)clickPublishBtn {

   _publishBtn.enabled = NO;
   [self.view endEditing:YES];
   [MBProgressHUD showMessage:YZMsg(@"发布中，请稍后")];
   mytitle = [NSString stringWithFormat:@"%@",_videoDesTV.text];//标题
    __weak TCVideoPublishController *weakself = self;
    if ([[common cloudtype] isEqualToString:@"2"]) {

        NSString *url = [purl stringByAppendingFormat:@"?service=Video.getCreateNonreusableSignature"];

        NSString *imgName = [PublicObj getNameBaseCurrentTime:@".png"];
        NSString *videoName = [PublicObj getNameBaseCurrentTime:@".mp4"];
        NSDictionary *parameters = @{@"imgname":imgName,
                                     @"videoname":videoName,
                                     @"folderimg":[common getTximgfolder],
                                     @"foldervideo":[common getTxvideofolder],
                                     };

        [YBNetworking postWithUrl:url Dic:parameters Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
            if ([code isEqual:@"0"]) {
                NSDictionary *info =  [[data valueForKey:@"info"] firstObject];
                bucketName = minstr([info valueForKey:@"bucketname"]);
                tengxunID = minstr([info valueForKey:@"appid"]);
                regionName = minstr([info valueForKey:@"region"]);

                if ([PublicObj checkNull:bucketName] || [PublicObj checkNull:tengxunID] || [PublicObj checkNull:regionName]) {
                    NSLog(@"未配置腾讯云");
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"未配置腾讯云"];
                    weakself.publishBtn.enabled = YES;
                }else{
                    //初始化上传参数
                    [self txUplode];
                    [weakself uploadTCWithImgsign:[info valueForKey:@"imgsign"] andVideosign:[info valueForKey:@"videosign"] andImageName:imgName andVideoName:videoName];
                }
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                weakself.publishBtn.enabled = YES;
            }
        } Fail:^(id fail) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
            weakself.publishBtn.enabled = YES;
        }];

        [self networkState];

    }else{
        NSString *url = [purl stringByAppendingFormat:@"?service=Video.getQiniuToken"];
        [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
            if ([code isEqual:@"0"]) {
                NSDictionary *info =  [[data valueForKey:@"info"] firstObject];
                qntoken = [NSString stringWithFormat:@"%@",[info valueForKey:@"token"]];
                [weakself uploadqn];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                weakself.publishBtn.enabled = YES;
            }
        } Fail:^(id fail) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
            weakself.publishBtn.enabled = YES;
        }];
        
        [self networkState];
    }

}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView {

    NSString *toBeString = textView.text;
    NSString *lang = [[[UITextInputMode activeInputModes]firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];//获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 50) {
                textView.text = [toBeString substringToIndex:50];
                _wordsNumL.text = [NSString stringWithFormat:@"%lu/50",(50-textView.text.length)];
            }else{
                _wordsNumL.text = [NSString stringWithFormat:@"%lu/50",(50-toBeString.length)];
            }
        }else{
            //有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 50) {
            textView.text = [toBeString substringToIndex:50];
            _wordsNumL.text = [NSString stringWithFormat:@"%lu/50",(50-textView.text.length)];
        }else{
            _wordsNumL.text = [NSString stringWithFormat:@"%lu/50",(50-toBeString.length)];
        }
    }
    
}


- (void)applicationWillEnterForeground:(NSNotification *)noti {
    //temporary fix bug
    if ([self.navigationItem.title isEqualToString:YZMsg(@"发布中")])
        return;
    
    if (_isPublished == NO) {

        [_livePlayer startPlay:_recordResult.videoPath type:PLAY_TYPE_LOCAL_VIDEO];
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)noti {
    [_livePlayer stopPlay];
    
}
#pragma mark TXLivePlayListener
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_END && _playEnable) {
            [_livePlayer startPlay:_recordResult.videoPath type:PLAY_TYPE_LOCAL_VIDEO];
            return;
        }
    });

}
-(void) onNetStatus:(NSDictionary*) param {
    return;
}


#pragma mark - 上传七牛start
-(void)uploadqn{
    __weak TCVideoPublishController *weakself = self;
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.zone = [QNFixedZone zone0];
    }];
    QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
        
    } params:nil checkCrc:NO cancellationSignal:nil];
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    //获取视频和图片
    NSString *filePath =_recordResult.videoPath;
    NSData *imageData = UIImagePNGRepresentation(_recordResult.coverImage);
    NSString *imageName = [PublicObj getNameBaseCurrentTime:@".png"];
    //传图片
    [upManager putData:imageData key:[NSString stringWithFormat:@"image_%@",imageName] token:qntoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (info.ok) {
            //图片成功
            [weakself uploadimagesuccess:key];
            //传视频
            NSString *videoName = [PublicObj getNameBaseCurrentTime:@".mp4"];
            [upManager putFile:filePath key:[NSString stringWithFormat:@"video_%@",videoName] token:qntoken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok) {
                    //成功
                    NSLog(@"qn_upload_suc:%@",key);
                    //请求app业务服务器给标题
                    [weakself uploadvideosuccess:key andTitle:mytitle];
                }else {
                    //失败
                    [MBProgressHUD showError:YZMsg(@"上传失败")];
                    _publishBtn.enabled = YES;
                }
                NSLog(@"info ===== %@", info);
                NSLog(@"resp ===== %@", resp);
            } option:option];
        }
        else {
            [MBProgressHUD hideHUD];
            //图片失败
            NSLog(@"%@",info.error);
            [MBProgressHUD showError:YZMsg(@"上传失败")];
            _publishBtn.enabled = YES;
        }
    } option:option];
}
-(void)uploadimagesuccess:(NSString *)key {
    _imagekey = [NSString stringWithFormat:@"%@/%@",[common qiniu_domain],key];
    
}
-(void)uploadvideosuccess:(NSString *)key andTitle:(NSString *)myTitle {
    _videokey = [NSString stringWithFormat:@"%@/%@",[common qiniu_domain],key];;
    [self requstAPPServceTitle:myTitle andVideo:_videokey andImage:_imagekey];
}
#pragma mark - 上传七牛end
#pragma mark -
#pragma mark - 腾讯云上传start
-(void)txUplode {
    
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = tengxunID;//@"1258210369";
    configuration.signatureProvider = self;
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = regionName;//@"ap-shanghai";
    configuration.endpoint = endpoint;
    
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
    
    self.TXSignDic = [NSDictionary dictionary];
    
}

- (void)signatureWithFields:(QCloudSignatureFields*)fileds request:(QCloudBizHTTPRequest*)request urlRequest:(NSMutableURLRequest*)urlRequst compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock {
    
    NSString *url = [h5url stringByAppendingFormat:@":8088/cam"];
    [YBNetworking getQCloudWithUrl:url Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            _TXSignDic = [data valueForKey:@"credentials"];
            QCloudCredential* credential = [QCloudCredential new];
            credential.secretID  = [NSString stringWithFormat:@"%@",[_TXSignDic valueForKey:@"tmpSecretId"]];
            credential.secretKey = [NSString stringWithFormat:@"%@",[_TXSignDic valueForKey:@"tmpSecretKey"]];
            credential.token = [NSString stringWithFormat:@"%@",[_TXSignDic valueForKey:@"sessionToken"]];
            QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
            QCloudSignature* signature =  [creator signatureForData:urlRequst];
            continueBlock(signature, nil);
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
    
}
-(void)uploadTCWithImgsign:(NSString *)imgSign andVideosign:(NSString *)videoSign andImageName:(NSString *)imgName andVideoName:(NSString *)videoName{
    UIImage *saveImg = _recordResult.coverImage;
    if (!_recordResult.coverImage) {
        saveImg = [TXVideoInfoReader getSampleImage:0.0 videoPath:_recordResult.videoPath];
    }
    NSData *imageData = UIImagePNGRepresentation(saveImg);
    if (saveImg) {
        YBWeakSelf;
        QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
        put.object = imgName;//[NSString stringWithFormat:@"dspdemo/%@",imgName];
        put.bucket = bucketName;
        put.body =  imageData;
        [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"rk;;upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
        }];
        [put setFinishBlock:^(id outputObject, NSError* error) {
            QCloudUploadObjectResult *rst = outputObject;
            NSLog(@"rk;;111111:\nlocation:%@\n%@",rst.location,rst.key);
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:@"上传失败"];
                    _publishBtn.enabled = YES;
                });
            }else{
                [weakSelf uploadVideowithImgurl:rst.location andVideosign:videoSign andvideoName:videoName];
            }
            
        }];
        [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
    }else{
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"上传失败"];
        _publishBtn.enabled = YES;
    }
    
}
- (void)uploadVideowithImgurl:(NSString *)imgurl andVideosign:(NSString *)videoSign andvideoName:(NSString *)videoName {
    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    NSURL* sssssurl = [NSURL fileURLWithPath:_recordResult.videoPath];
    put.object = videoName;
    put.bucket = bucketName;//@"rk-1258210369";
    put.body =  sssssurl;
    [put setSendProcessBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"rk;;upload %lld totalSend %lld aim %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
    }];
    YBWeakSelf;
    [put setFinishBlock:^(id outputObject, NSError* error) {
        QCloudUploadObjectResult *rst = outputObject;
        NSLog(@"rk;;111111:\nlocation:%@\n%@",rst.location,rst.key);
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"上传失败"];
                _publishBtn.enabled = YES;
            });
        }else{
            [weakSelf requstAPPServceTitle:mytitle andVideo:rst.location andImage:imgurl];
        }
        
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
}
#pragma mark - 腾讯云上传end
#pragma mark -
#pragma mark - 上传七牛或者腾讯云存储成功后把视频地址、封面地址反馈给自己的服务器
-(void)requstAPPServceTitle:(NSString *)myTile andVideo:(NSString *)video andImage:(NSString *)image {
    
    __weak TCVideoPublishController *weakself = self;
    NSDictionary *pullDic = @{
                              @"uid":[Config getOwnID],
                              @"token":[Config getOwnToken],
                              @"title":minstr(myTile),
                              @"href":minstr(video),
                              @"thumb":minstr(image),
                              @"lng":[NSString stringWithFormat:@"%@",[cityDefault getMylng]],
                              @"lat":[NSString stringWithFormat:@"%@",[cityDefault getMylat]],
                              @"city":[NSString stringWithFormat:@"%@",[cityDefault getMyCity]?[cityDefault getMyCity]:YZMsg(@"好像在火星")],
                              @"music_id":_musicID ? _musicID : @"0",
                              };
    NSString *url = [purl stringByAppendingFormat:@"?service=Video.setVideo"];
    
    [YBNetworking postWithUrl:url Dic:pullDic Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            [MBProgressHUD hideHUD];
            NSString *audit_switch = [NSString stringWithFormat:@"%@",[common getAuditSwitch]];
            if ([audit_switch isEqual:@"1"]) {
                [MBProgressHUD showSuccess:YZMsg(@"上传成功，请等待审核")];
            }else{
                [MBProgressHUD showSuccess:YZMsg(@"发布成功")];
            }
            
            BOOL isOk = [[NSFileManager defaultManager] removeItemAtPath:_recordResult.videoPath error:nil];
            NSLog(@"%d shanchushanchushanchu",isOk);
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:filePathhh error:nil];
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            _videoid = [NSString stringWithFormat:@"%@",[info valueForKey:@"id"]];
            _image_thumb = [NSString stringWithFormat:@"%@",[info valueForKey:@"thumb_s"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakself pushshare];
                //发布成功后刷新首页
                [[NSNotificationCenter defaultCenter]postNotificationName:@"popRootVC" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadlist" object:nil];
                weakself.publishBtn.enabled = NO;
            });
        }else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[data valueForKey:@"msg"]];
            weakself.publishBtn.enabled = YES;
        }
    } Fail:^(id fail) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
        weakself.publishBtn.enabled = YES;
    }];
    
}

#pragma mark - 分享
-(void)root {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_livePlayer) {
            [_livePlayer stopPlay];
            _livePlayer = nil;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
//        [PublicObj resetVC:[[ZYTabBarController alloc]init]];
    });
}
-(void)pushshare {
    switch (sharetype) {
        case 0:
            [self root];
            break;
        case 1:
            [self simplyShare:SSDKPlatformSubTypeQQFriend];
            break;
        case 2:
            [self simplyShare:SSDKPlatformSubTypeQZone];
            break;
        case 3:
            [self simplyShare:SSDKPlatformSubTypeWechatSession];
            break;
        case 4:
            [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
            break;
        case 5:
            [self simplyShare:SSDKPlatformTypeFacebook];
            break;
        case 6:
            [self simplyShare:SSDKPlatformTypeTwitter];
            break;
        default:
            break;
    }
}

- (void)simplyShare:(int)SSDKPlatformType {
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    int SSDKContentType = SSDKContentTypeAuto;
    NSURL *ParamsURL = [NSURL URLWithString:[h5url stringByAppendingFormat:@"/index.php?g=appapi&m=video&a=index&videoid=%@",_videoid]];
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    NSString *titles = _videoDesTV.text;
    if (_videoDesTV.text.length == 0) {
        titles = [NSString stringWithFormat:@"%@%@",[Config getOwnNicename],[common video_share_des]];
    }
    [shareParams SSDKSetupShareParamsByText:titles
                                     images:_image_thumb
                                        url:ParamsURL
                                      title:[common video_share_title]
                                       type:SSDKContentType];
    [ShareSDK share:SSDKPlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {

        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showSuccess:YZMsg(@"分享成功")];
        }
        else if (state == SSDKResponseStateFail){
            [MBProgressHUD showError:YZMsg(@"分享失败")];
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


#pragma mark - set/get
-(UIView *)topMix {
    if (!_topMix) {
        _topMix = [[UIView alloc] initWithFrame:CGRectMake(15, 64+statusbarHeight+5, _window_width-30, 180)];
        _topMix.backgroundColor = [UIColor whiteColor];
        _topMix.layer.cornerRadius = 5.0;
        _topMix.layer.masksToBounds = YES;
        //视频预览
        _videoPreview = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 100, 150)];
        _videoPreview.layer.cornerRadius = 5.0;
        _videoPreview.layer.masksToBounds = YES;

        
        //视频描述
        _videoDesTV = [[MyTextView alloc] initWithFrame:CGRectMake(_videoPreview.right+10, 15, _topMix.width-_videoPreview.width - 35, _videoPreview.height)];
        _videoDesTV.backgroundColor = [UIColor clearColor];//RGB(242, 242, 242);
        _videoDesTV.delegate = self;
        _videoDesTV.layer.borderColor = _topMix.backgroundColor.CGColor;
        _videoDesTV.font = SYS_Font(16);
        _videoDesTV.textColor = RGB_COLOR(@"#969696", 1);
        _videoDesTV.placeholder = YZMsg(@"添加视频描述~");
        _videoDesTV.placeholderColor = RGB_COLOR(@"#969696", 1);
        
        _wordsNumL = [[UILabel alloc] initWithFrame:CGRectMake(_videoDesTV.right-50, _videoDesTV.bottom-12, 50, 12)];
        _wordsNumL.text = @"0/50";
        _wordsNumL.textColor = RGB_COLOR(@"#969696", 1);
        _wordsNumL.font = [UIFont systemFontOfSize:12];
        _wordsNumL.backgroundColor =[UIColor clearColor];
        _wordsNumL.textAlignment = NSTextAlignmentRight;
        
        [_topMix addSubview:_videoPreview];
        [_topMix addSubview:_videoDesTV];
        [_topMix addSubview:_wordsNumL];
        
    }
    return _topMix;
}

-(UIView *)locationV {
    if (!_locationV) {
        //显示定位
        _locationV = [[UIView alloc]initWithFrame:CGRectMake(15, _topMix.bottom+5, _window_width-30, 50)];
        _locationV.backgroundColor = [UIColor whiteColor];;
        _locationV.layer.cornerRadius = 5.0;
        _locationV.layer.masksToBounds = YES;

        UIImageView *imageloca = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pink_location"]];
        imageloca.contentMode = UIViewContentModeScaleAspectFit;
        imageloca.frame = CGRectMake(15,_locationV.height/2-7.5,15,15);
        [_locationV addSubview:imageloca];
        
        UILabel *locationlabels = [[UILabel alloc]initWithFrame:CGRectMake(imageloca.right+5, 0, _window_width-50, 50)];
        locationlabels.font = SYS_Font(15);
        locationlabels.text = [NSString stringWithFormat:@"%@",[cityDefault getMyCity]?[cityDefault getMyCity]:YZMsg(@"好像在火星")];
        locationlabels.textColor = RGB_COLOR(@"#969798", 1);
        
        [_locationV addSubview:locationlabels];
    }
    return _locationV;
}

- (PublishShareV *)platformV {
    if (!_platformV) {
        _platformV = [[PublishShareV alloc]initWithFrame:CGRectMake(15,_locationV.bottom+15, _window_width-30, _window_width/4+30)];
        _platformV.backgroundColor = [UIColor clearColor];
        _platformV.shareEvent = ^(NSString *type) {
            if ([type isEqual:@"qq"]) {
                sharetype = 1;
            }else if ([type isEqual:@"qzone"]) {
                sharetype = 2;
            }else if ([type isEqual:@"wx"]) {
                sharetype = 3;
            }else if ([type isEqual:@"wchat"]) {
                sharetype = 4;
            }else if ([type isEqual:@"facebook"]) {
                sharetype = 5;
            }else if ([type isEqual:@"twitter"]) {
                sharetype = 6;
            }else if([type isEqual:@"qx"]){
                sharetype = 0;
            }
        };
    }
    return _platformV;
}

-(UIButton *)publishBtn {
    if (!_publishBtn) {
        _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishBtn.frame = CGRectMake(40, _platformV.bottom+20, _window_width-80, 40);
        [_publishBtn setTitle:@"确认发布" forState:0];
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:0];
        _publishBtn.backgroundColor = normalColors;
        _publishBtn.layer.masksToBounds = YES;
        _publishBtn.layer.cornerRadius = 20;
        [_publishBtn addTarget:self action:@selector(clickPublishBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

#pragma mark - 导航
-(void)creatNavi {
    YBNavi *navi = [[YBNavi alloc]init];
    navi.leftHidden = NO;
    navi.rightHidden = YES;
//    navi.imgTitleSameR = YES;
    [navi ybNaviLeft:^(id btnBack) {
        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"是否放弃发布此条视频") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"放弃") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self fangqi];
        }];
        [alertContro addAction:sureAction];
        [self presentViewController:alertContro animated:YES completion:nil];

    } andRightName:@"" andRight:^(id btnBack) {
        
    } andMidTitle:YZMsg(@"发布视频")];
    [self.view addSubview:navi];
}
- (void)fangqi{
    BOOL isOk = [[NSFileManager defaultManager] removeItemAtPath:_recordResult.videoPath error:nil];
    NSLog(@"%d shanchushanchushanchu",isOk);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:filePathhh error:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"popRootVC" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadlist" object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)networkState{
    __weak typeof(self) wkSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD showError:YZMsg(@"网络连接断开，视频上传失败")];
                wkSelf.imgPublishState.hidden = YES;
                wkSelf.isNetWorkErr = YES;
                break;
            default:
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring]; //开启网络监控
}

- (void)dealloc {
    [_livePlayer removeVideoWidget];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
