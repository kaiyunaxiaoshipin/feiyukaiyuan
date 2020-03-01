#import "Livebroadcast.h"
/********************  TiFaceSDK添加 开始 ********************/
#include "TiUIView.h"
#include "TiSDKInterface.h"
/********************  TiFaceSDK添加 结束 ********************/
#import "startLiveClassVC.h"

/***********************  腾讯SDK start ********************/

#import <TXLiteAVSDK_Professional/TXLivePush.h>
#import <TXLiteAVSDK_Professional/TXLiveBase.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import "V8HorizontalPickerView.h"

#import "KSYStreamerTiFilter.h"

typedef NS_ENUM(NSInteger,TCLVFilterType) {
    FilterType_None         = 0,
    FilterType_white        ,   //美白滤镜
    FilterType_langman         ,   //浪漫滤镜
    FilterType_qingxin         ,   //清新滤镜
    FilterType_weimei         ,   //唯美滤镜
    FilterType_fennen         ,   //粉嫩滤镜
    FilterType_huaijiu         ,   //怀旧滤镜
    FilterType_landiao         ,   //蓝调滤镜
    FilterType_qingliang     ,   //清凉滤镜
    FilterType_rixi         ,   //日系滤镜
};
/***********************  腾讯SDK end **********************/

//#import <GPUImage/GPUImage.h>
#define upViewW  _window_width*0.8
@import CoreTelephony;
@interface Livebroadcast ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,catSwitchDelegate,haohuadelegate,socketLiveDelegate,listDelegate,upmessageKickAndShutUp,listDelegate,gameDelegate,WPFRotateViewDelegate,shangzhuangdelegate,gameselected,TiUIViewDelegate,js_play_linkmic,tx_play_linkmic,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,adminDelegate,guardShowDelegate,anchorOnlineDelegate,redListViewDelegate,anchorPKViewDelegate,anchorPKAlertDelegate,TXVideoCustomProcessDelegate,TXLivePushListener,V8HorizontalPickerViewDelegate,V8HorizontalPickerViewDataSource,JackpotViewDelegate>

/********************  TiFaceSDK添加 开始 ********************/
@property(nonatomic, strong) TiUIView *tiUIView; // TiFaceSDK UI
@property(nonatomic, strong) TiSDKManager *tiSDKManager;
/******************** TiFaceSDK添加 结束 ********************/
@property (nonatomic,strong)UIView *preFrontView;
//@property(nonatomic, strong) GPUImageView *gpuPreviewView;
//@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
//@property (nonatomic, strong) CIImage *outputImage;
//@property (nonatomic, assign) size_t outputWidth;
//@property (nonatomic, assign) size_t outputheight;

/***********************  腾讯SDK start **********************/
@property TXLivePushConfig* txLivePushonfig;
@property TXLivePush*       txLivePublisher;
@property(nonatomic,strong)NSMutableArray *filterArray;//美颜数组
@property (nonatomic,strong)UIView     *vBeauty;

/***********************  腾讯SDK end **********************/

@end
@implementation Livebroadcast
{
    NSMutableArray *msgList;
    CGSize roomsize;
    UILabel *roomID;
    UIView *bgmView;
    //预览的视图
    UIButton *preThumbBtn;//上传封面按钮
    UILabel *thumbLabel;//上传封面状态的label
    UIImage *thumbImage;
    UILabel *liveClassLabel;
    UITextView *liveTitleTextView;
    UILabel *textPlaceholdLabel;
    
    NSMutableArray *preShareBtnArray;//分享按钮数组
    NSString *selectShareName;//选择分享的名称
    
    UIButton *preTypeBtn;
    UIScrollView *roomTypeView;//选择房间类型
    NSMutableArray *roomTypeBtnArray;//房间类型按钮
    NSString *roomType;//房间类型
    NSString *roomTypeValue;//房间价值
    
    NSString *liveClassID;
    //预览的视图结束
    //直播时长
    UIView *liveTimeBGView;
    UILabel *liveTimeLabel;
    int liveTime;
    NSTimer *liveTimer;
    BOOL isTorch;
    
    /***********************  腾讯SDK start **********************/
    float  _tx_beauty_level;
    float  _tx_whitening_level;
    float  _tx_eye_level;
    float  _tx_face_level;
    UIButton              *_beautyBtn;
    UIButton              *_filterBtn;
    UILabel               *_beautyLabel;
    UILabel               *_whiteLabel;
    UILabel               *_bigEyeLabel;
    UILabel               *_slimFaceLabel;
    UISlider              *_sdBeauty;
    UISlider              *_sdWhitening;
    UISlider              *_sdBigEye;
    UISlider              *_sdSlimFace;
    V8HorizontalPickerView  *_filterPickerView;
    NSInteger    _filterType;

    /***********************  腾讯SDK end **********************/

}
#pragma mark ================ tiuivew代理 ===============
-(void)showPreFrontView{
    if (_preFrontView) {
        _preFrontView.hidden = NO;
    }
}
#pragma mark ================ 直播开始之前的预览 ===============
- (void)creatPreFrontView{
    _preFrontView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _preFrontView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_preFrontView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePreTextView)];
    [_preFrontView addGestureRecognizer:tap];
    
    UIImageView *loactionImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 44+statusbarHeight, 20, 20)];
    loactionImgView.image = [UIImage imageNamed:@"pre_location"];
    [_preFrontView addSubview:loactionImgView];
    UILabel *locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(loactionImgView.right-10, loactionImgView.top+3, [[YBToolClass sharedInstance] widthOfString:[cityDefault getMyCity] andFont:[UIFont systemFontOfSize:13] andHeight:16]+18, 14)];
    locationLabel.font = [UIFont systemFontOfSize:11];
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.backgroundColor = RGB_COLOR(@"#000000", 0.3);
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.layer.cornerRadius = 7;
    locationLabel.layer.masksToBounds = YES;
    locationLabel.text = [cityDefault getMyCity];
    [_preFrontView addSubview:locationLabel];
    [_preFrontView insertSubview:locationLabel belowSubview:loactionImgView];
    UIButton *switchBtn = [UIButton buttonWithType:0];
    switchBtn.frame = CGRectMake(locationLabel.right+20, loactionImgView.top, loactionImgView.height, loactionImgView.height);
    [switchBtn setImage:[UIImage imageNamed:@"pre_camer"] forState:0];
    [switchBtn addTarget:self action:@selector(rotateCamera) forControlEvents:UIControlEventTouchUpInside];
    [_preFrontView addSubview:switchBtn];
    
    UIButton *preCloseBtn = [UIButton buttonWithType:0];
    preCloseBtn.frame = CGRectMake(_window_width-30, loactionImgView.top, loactionImgView.height, loactionImgView.height);
    [preCloseBtn setImage:[UIImage imageNamed:@"live_close"] forState:0];
    [preCloseBtn addTarget:self action:@selector(doClosePreView) forControlEvents:UIControlEventTouchUpInside];
    [_preFrontView addSubview:preCloseBtn];

    UIView *preMiddleView = [[UIView alloc]initWithFrame:CGRectMake(10, _window_height/2-(_window_width-20)*38/71, _window_width-20, (_window_width-20)*38/71)];
    preMiddleView.backgroundColor = RGB_COLOR(@"#0000000", 0.3);
    preMiddleView.layer.cornerRadius = 5;
    [_preFrontView addSubview:preMiddleView];
    
    preThumbBtn = [UIButton buttonWithType:0];
    preThumbBtn.frame = CGRectMake(10, preMiddleView.height*2/19, preMiddleView.height*10/19, preMiddleView.height*10/19);
    [preThumbBtn setImage:[UIImage imageNamed:@"pre_uploadThumb"] forState:0];
    [preThumbBtn addTarget:self action:@selector(doUploadPicture) forControlEvents:UIControlEventTouchUpInside];
    preThumbBtn.layer.cornerRadius = 5.0;
    preThumbBtn.layer.masksToBounds = YES;
    [preMiddleView addSubview:preThumbBtn];
    
    thumbLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, preThumbBtn.height*0.75, preThumbBtn.width, preThumbBtn.height/4)];
    thumbLabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
    thumbLabel.textAlignment = NSTextAlignmentCenter;
    thumbLabel.text = YZMsg(@"直播封面");
    thumbLabel.font = [UIFont systemFontOfSize:13];
    [preThumbBtn addSubview:thumbLabel];
    
    UIButton *liveClassBtn = [UIButton buttonWithType:0];
    liveClassBtn.frame = CGRectMake(preMiddleView.width-80, 0, 70, 30);
    [liveClassBtn addTarget:self action:@selector(showAllClassView) forControlEvents:UIControlEventTouchUpInside];
    [preMiddleView addSubview:liveClassBtn];
    liveClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    liveClassLabel.text = YZMsg(@"频道");
    liveClassLabel.textAlignment = NSTextAlignmentRight;
    liveClassLabel.textColor = normalColors;
    liveClassLabel.font = [UIFont systemFontOfSize:14];
    [liveClassBtn addSubview:liveClassLabel];
    
    UIImageView *rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(liveClassLabel.right+1, 8, 14, 14)];
    rightImgView.image = [UIImage imageNamed:@"pre_right"];
    rightImgView.userInteractionEnabled = YES;
    [liveClassBtn addSubview:rightImgView];

    UILabel *preTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(preThumbBtn.right+5, preThumbBtn.top, 100, preThumbBtn.height/4)];
    preTitlelabel.font = [UIFont systemFontOfSize:13];
    preTitlelabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
    preTitlelabel.text = YZMsg(@"直播标题");
    [preMiddleView addSubview:preTitlelabel];
    liveTitleTextView = [[UITextView alloc]initWithFrame:CGRectMake(preTitlelabel.left, preTitlelabel.bottom, preMiddleView.width-10-preThumbBtn.right, preThumbBtn.height*0.75)];
    liveTitleTextView.delegate = self;
    liveTitleTextView.font = [UIFont systemFontOfSize:20];
    liveTitleTextView.textColor = [UIColor whiteColor];
    liveTitleTextView.backgroundColor = [UIColor clearColor];
    [preMiddleView addSubview:liveTitleTextView];
    textPlaceholdLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, liveTitleTextView.width, 22)];
    textPlaceholdLabel.font = [UIFont systemFontOfSize:20];
    textPlaceholdLabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
    textPlaceholdLabel.text = YZMsg(@"给直播写个标题吧");
    [liveTitleTextView addSubview:textPlaceholdLabel];

    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(10, preMiddleView.height*14/19, preMiddleView.width-20, 1) andColor:RGB_COLOR(@"#ffffff", 0.3) andView:preMiddleView];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, preMiddleView.height*14/19, 50, preMiddleView.height*5/19)];
    shareLabel.font = [UIFont systemFontOfSize:13];
    shareLabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
    shareLabel.text = YZMsg(@"分享到");
    [preMiddleView addSubview:shareLabel];
    NSArray *shareArray = [common share_type];
    CGFloat speace = (preMiddleView.width-70-180)/5;
    preShareBtnArray = [NSMutableArray array];
    if ([shareArray isKindOfClass:[NSArray class]]) {
        for (int i = 0; i<shareArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share%@",shareArray[i]]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"share_%@",shareArray[i]]] forState:UIControlStateSelected];
            [btn setTitle:shareArray[i] forState:UIControlStateNormal];
            [btn setTitle:shareArray[i] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal|UIControlStateSelected];
            [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:shareArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.frame = CGRectMake(shareLabel.right+i*(30+speace),shareLabel.top+ preMiddleView.height*5/19/2-15, 30, 30);
            [preMiddleView addSubview:btn];
            [preShareBtnArray addObject:btn];
        }

    }
    
    //开播按钮
    UIButton *startLiveBtn = [UIButton buttonWithType:0];
    startLiveBtn.size = CGSizeMake(_window_width*0.8,40);
    startLiveBtn.center = CGPointMake(_window_width*0.5, _window_height*0.8);
    startLiveBtn.layer.cornerRadius = 20.0;
    startLiveBtn.layer.masksToBounds = YES;
    [startLiveBtn setBackgroundColor:normalColors];
    [startLiveBtn addTarget:self action:@selector(doHidden:) forControlEvents:UIControlEventTouchUpInside];
    [startLiveBtn setTitle:YZMsg(@"开始直播") forState:0];
    startLiveBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_preFrontView addSubview:startLiveBtn];
    
    //美颜
    UIButton *preFitterBtn = [UIButton buttonWithType:0];
    preFitterBtn.frame = CGRectMake(_window_width*0.2, startLiveBtn.top-35, 60, 30);
    [preFitterBtn setTitle:YZMsg(@"美颜") forState:0];
    [preFitterBtn setImage:[UIImage imageNamed:@"pre_fitter"] forState:0];
    preFitterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [preFitterBtn addTarget:self action:@selector(showFitterView) forControlEvents:UIControlEventTouchUpInside];
    preFitterBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 40);
    preFitterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -13, 0, 0);
    [_preFrontView addSubview:preFitterBtn];
    //房间类型
    preTypeBtn = [UIButton buttonWithType:0];
    preTypeBtn.frame = CGRectMake(_window_width*0.8-60, startLiveBtn.top-35, 80, 30);
    [preTypeBtn setTitle:YZMsg(@"房间类型") forState:0];
    [preTypeBtn setImage:[UIImage imageNamed:@"pre_room"] forState:0];
    preTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [preTypeBtn addTarget:self action:@selector(dochangelivetype) forControlEvents:UIControlEventTouchUpInside];
    preTypeBtn.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 5, 60);
    preTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    [_preFrontView addSubview:preTypeBtn];

}
-(void)dochangelivetype{
    NSArray *arrays = [common live_type];
    NSMutableArray *roomTypeArr = [NSMutableArray array];
    
    for (NSArray *arr in arrays) {
        NSString *typestring = arr[0];
        int types = [typestring intValue];
        switch (types) {
            case 0:
                [roomTypeArr addObject:@"普通"];
                break;
            case 1:
                [roomTypeArr addObject:@"密码"];
                break;
            case 2:
                [roomTypeArr addObject:@"门票"];
                break;
            case 3:
                [roomTypeArr addObject:@"计时"];
                break;
            default:
                break;
        }
    }
    if (!roomTypeView) {
        roomTypeView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, _window_height*0.15)];
        roomTypeView.backgroundColor = RGB_COLOR(@"#000000", 0.7);
        roomTypeView.contentSize = CGSizeMake(_window_width/4*roomTypeArr.count, 0);
        [_preFrontView addSubview:roomTypeView];
        CGFloat speace;
        if (roomTypeArr.count > 3) {
            speace = 0;
        }else{
            speace = (_window_width-_window_width/4*roomTypeArr.count)/2;
        }
        roomTypeBtnArray = [NSMutableArray array];
        for (int i = 0; i < roomTypeArr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.frame = CGRectMake(speace+i*_window_width/4, 0, _window_width/4, roomTypeView.height);
            [btn addTarget:self action:@selector(doRoomType:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[NSString stringWithFormat:@"%@房间",roomTypeArr[i]] forState:UIControlStateSelected];
            [btn setTitle:[NSString stringWithFormat:@"%@房间",roomTypeArr[i]] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:normalColors forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"room_%@_nor",roomTypeArr[i]]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"room_%@_sel",roomTypeArr[i]]] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.imageEdgeInsets = UIEdgeInsetsMake(7.5, _window_width/8-10, 22.5, 10);
            btn.titleEdgeInsets = UIEdgeInsetsMake(30, -22.5, 0, 0);

            if (i == 0) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
            [roomTypeView addSubview:btn];
            [roomTypeBtnArray addObject:btn];
        }
        [UIView animateWithDuration:0.5 animations:^{
            roomTypeView.y = _window_height*0.85;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            roomTypeView.y = _window_height*0.85;
        }];

    }
}
- (void)doRoomType:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqual:@"普通房间"]) {
        [self changeRoomBtnState:@"普通房间"];
        roomType = @"0";
        roomTypeValue = @"";
    }
    if ([sender.titleLabel.text isEqual:@"密码房间"]) {
        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"请设置房间密码"    message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContro addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {                textField.placeholder = @"请输入密码";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *envirnmentNameTextField = alertContro.textFields.firstObject;
            if (envirnmentNameTextField.text == nil || envirnmentNameTextField.text == NULL || envirnmentNameTextField.text.length == 0) {
                [MBProgressHUD showError:@"请输入正确的密码"];
                [self presentViewController:alertContro animated:YES completion:nil];
            }else{
                roomTypeValue = envirnmentNameTextField.text;
                roomType = @"1";
                [self changeRoomBtnState:@"密码房间"];
            }
        }];
        [alertContro addAction:sureAction];
        [self presentViewController:alertContro animated:YES completion:nil];
    }
    if ([sender.titleLabel.text isEqual:@"门票房间"]) {
        UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"请设置房间门票价格"    message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertContro addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {                textField.placeholder = @"请输入价格";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertContro addAction:cancleAction];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *envirnmentNameTextField = alertContro.textFields.firstObject;
            if (envirnmentNameTextField.text == nil || envirnmentNameTextField.text == NULL || envirnmentNameTextField.text.length == 0) {
                [MBProgressHUD showError:@"请输入正确的门票价格"];
                [self presentViewController:alertContro animated:YES completion:nil];
            }else{
                roomTypeValue = envirnmentNameTextField.text;
                roomType = @"2";
                [self changeRoomBtnState:@"门票房间"];
            }
        }];
        [alertContro addAction:sureAction];
        [self presentViewController:alertContro animated:YES completion:nil];

    }
    if ([sender.titleLabel.text isEqual:@"计时房间"]) {
        [self doupcoast];
    }
}
- (void)changeRoomBtnState:(NSString *)roomName{
    for (UIButton *btn  in roomTypeBtnArray) {
        if ([btn.titleLabel.text isEqual:roomName]) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        roomTypeView.y = _window_height*2;
    } completion:^(BOOL finished) {
        [preTypeBtn setTitle:roomName forState:0];
    }];

}
- (void)showFitterView{
    _preFrontView.hidden = YES;
    if (![[common getIsTXfiter]isEqual:@"1"]) {
        [self initTiFaceUI];//萌颜
    }else{
        if ([_sdkType isEqual:@"1"]) {
            [self userTXBase];
        }else{
            [self OnChoseFilter:nil];//美颜
        }
    }
}
//创建房间
-(void)createroom{
    NSString *deviceinfo = [NSString stringWithFormat:@"%@_%@_%@",[YBNetworking iphoneType],[[UIDevice currentDevice] systemVersion],[YBNetworking getNetworkType]];

    NSString *title = [liveTitleTextView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.createRoom&uid=%@&token=%@&user_nicename=%@&title=%@&province=%@&city=%@&lng=%@&lat=%@&type=%@&type_val=%@&liveclassid=%@&deviceinfo=%@",[Config getOwnID],[Config getOwnToken],[Config getOwnNicename],title,@"",[cityDefault getMyCity],[cityDefault getMylng],[cityDefault getMylat],roomType,roomTypeValue,liveClassID,deviceinfo];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *subDic = @{
                             @"avatar":minstr([Config getavatar]),
                             @"avatar_thumb":minstr([Config getavatarThumb])
                             };
    [session POST:url parameters:subDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (thumbImage) {
            [formData appendPartWithFileData:[Utils compressImage:thumbImage] name:@"file" fileName:@"duibinaf.png" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];

        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
        if ([code isEqual:@"0"]) {
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            
//            NSString *shut_time = [NSString stringWithFormat:@"%@",[info valueForKey:@"shut_time"]];//禁言时间
            jackpot_level = minstr([info valueForKey:@"jackpot_level"]);

            NSString *coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_coin"]];
            NSString *game_banker_limit = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_limit"]];
            NSString *uname = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_name"]];
            NSString *uhead = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_avatar"]];
            NSString *uid = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_bankerid"]];
            NSDictionary *zhuangdic = @{
                                        @"coin":coin,
                                        @"game_banker_limit":game_banker_limit,
                                        @"user_nicename":uname,
                                        @"avatar":uhead,
                                        @"id":uid
                                        };
            
            NSString *agorakitid = [NSString stringWithFormat:@"%@",[info valueForKey:@"agorakitid"]];
            [common saveagorakitid:agorakitid];//保存声网ID
            NSString *tx_appid = minstr([info valueForKey:@"tx_appid"]);
            [common saveTXSDKAppID:tx_appid];
            //保存靓号和vip信息
            NSDictionary *liang = [info valueForKey:@"liang"];
            NSString *liangnum = minstr([liang valueForKey:@"name"]);
            NSDictionary *vip = [info valueForKey:@"vip"];
            NSString *type = minstr([vip valueForKey:@"type"]);
            NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
            [Config saveVipandliang:subdic];
            NSString *auction_switch = minstr([info valueForKey:@"auction_switch"]);//竞拍开关
            NSArray *game_switch = [info valueForKey:@"game_switch"];//游戏开关
            _type = [roomType intValue];
//            _shut_time = shut_time;
            _roomDic = info;
            if (_type == 0 || _type == 2) {
                _canFee = YES;
            }else{
                _canFee = NO;
            }
            _auction_switch = auction_switch;
            _game_switch = game_switch;
            _zhuangDic = zhuangdic;
            //移除预览UI
            [_preFrontView removeFromSuperview];
            _preFrontView = nil;
            //注册通知
            [self nsnotifition];
            //开始直播
            [self startUI];
        }else{
            [MBProgressHUD showError:[data valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:YZMsg(@"网络错误")];
    }];

}
//分享
- (void)share:(UIButton *)sender{
    if ([selectShareName isEqual:sender.titleLabel.text]) {
        sender.selected = NO;
        selectShareName = @"";
    }else{
        sender.selected = YES;
        selectShareName = sender.titleLabel.text;
        for (UIButton *btn in preShareBtnArray) {
            if (btn != sender) {
                btn.selected = NO;
            }
        }
    }
}
-(void)doHidden:(UIButton *)sender{
    if ([liveClassID isEqual:@"-99999999"]) {
        [MBProgressHUD showError:YZMsg(@"请选择频道")];
        return;
    }

    
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"相机权限受限");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"权限受阻") message:YZMsg(@"请在设置中开启相机权限") delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        [alert show];
        
        
        return;
    }
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        
        if (granted) {
            
            // 用户同意获取麦克风
            
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"权限受阻") message:YZMsg(@"请在设置中开启麦克风权限") delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
            
            [alert show];
            
            return ;
            
        }
        
    }];
    [MBProgressHUD showMessage:@""];
    if ([selectShareName isEqual:@""]) {
        [self createroom];
    }else if([selectShareName isEqual:@"qq"]){
        [self simplyShare:SSDKPlatformSubTypeQQFriend];
    }else if([selectShareName isEqual:@"qzone"]){
        [self simplyShare:SSDKPlatformSubTypeQZone];
    }else if([selectShareName isEqual:@"wx"]){
        [self simplyShare:SSDKPlatformSubTypeWechatSession];
    }else if([selectShareName isEqual:@"wchat"]){
        [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
    }else if([selectShareName isEqual:@"facebook"]){
        [self simplyShare:SSDKPlatformTypeFacebook];
    }else if([selectShareName isEqual:@"twitter"]){
        [self simplyShare:SSDKPlatformTypeTwitter];
    }else if([selectShareName isEqual:@"weibo"]){
        [self simplyShare:SSDKPlatformTypeSinaWeibo];
    }
}
- (void)simplyShare:(int)SSDKPlatformType
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    
    int SSDKContentType = SSDKContentTypeAuto;
    
    NSURL *ParamsURL;
    
    
    if(SSDKPlatformType == SSDKPlatformTypeSinaWeibo)
    {
        SSDKContentType = SSDKContentTypeImage;
    }
    else if((SSDKPlatformType == SSDKPlatformSubTypeWechatSession || SSDKPlatformType == SSDKPlatformSubTypeWechatTimeline))
    {
        NSString *strFullUrl = [[common wx_siteurl] stringByAppendingFormat:@"%@",[Config getOwnID]];
        ParamsURL = [NSURL URLWithString:strFullUrl];
    }else{
        
        ParamsURL = [NSURL URLWithString:[common app_ios]];
    }
    //获取我的头像
    LiveUser *user = [Config myProfile];
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",[Config getOwnNicename],[common share_des]]
                                     images:user.avatar_thumb
                                        url:ParamsURL
                                      title:[common share_title]
                                       type:SSDKContentType];
    [shareParams SSDKEnableUseClientShare];
    [MBProgressHUD hideHUD];

    [ShareSDK share:SSDKPlatformType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            [MBProgressHUD showError:YZMsg(@"分享成功")];
        }
        else if (state == SSDKResponseStateFail){
            [MBProgressHUD showError:YZMsg(@"分享失败")];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createroom];
        });
    }];
}

- (void)hidePreTextView{
    [liveTitleTextView resignFirstResponder];
    if (roomTypeView) {
        [UIView animateWithDuration:0.5 animations:^{
            roomTypeView.y = _window_height;
        }];

    }
}
- (void)textViewDidChange:(UITextView *)textView

{
    if (textView.text.length == 0) {
        textPlaceholdLabel.text = YZMsg(@"给直播写个标题吧");
    }else{
        textPlaceholdLabel.text = @"";
    }
    
}


//选择频道
- (void)showAllClassView{
    startLiveClassVC *vc = [[startLiveClassVC alloc]init];
    vc.classID = liveClassID;
    vc.block = ^(NSDictionary * _Nonnull dic) {
        liveClassID = minstr([dic valueForKey:@"id"]);
        liveClassLabel.text = minstr([dic valueForKey:@"name"]);
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:vc];
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.4f;
    vc.transitioningDelegate = self.animator;
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionRight;
    [self presentViewController:vc animated:YES completion:nil];

}
//选择封面
-(void)doUploadPicture{
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"选择上传方式") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *picAction = [UIAlertAction actionWithTitle:YZMsg(@"相册") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectThumbWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertContro addAction:picAction];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:YZMsg(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectThumbWithType:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertContro addAction:photoAction];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];

    [self presentViewController:alertContro animated:YES completion:nil];
}
- (void)selectThumbWithType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = type;
    imagePickerController.allowsEditing = YES;
    if (type == UIImagePickerControllerSourceTypeCamera) {
        imagePickerController.showsCameraControls = YES;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        thumbImage = image;
        [preThumbBtn setImage:image forState:UIControlStateNormal];
        thumbLabel.text = YZMsg(@"更换封面");
        thumbLabel.backgroundColor = RGB_COLOR(@"#0000000", 0.3);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}

//退出预览
- (void)doClosePreView{
    
    if ([_sdkType isEqual:@"1"]) {
        [self txStopRtmp];
    }
    
    self.isRedayCloseRoom = YES;
    if (_gpuStreamer) {
        [_gpuStreamer stopPreview];
        _gpuStreamer = nil;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.tiSDKManager) {
            [self.tiSDKManager destroy];
            self.tiSDKManager = nil;
            NSLog(@"[self.tiSDKManager destroy];");
        }
    });
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLiveing"];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ================ 预览结束 ===============

#pragma mark ================ 直播结束 ===============
- (void)requestLiveAllTimeandVotes{
    NSString *url = [NSString stringWithFormat:@"Live.stopInfo&stream=%@",minstr([_roomDic valueForKey:@"stream"])];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subdic = [info firstObject];
            [self lastview:subdic];
        }else{
            [self lastview:nil];
        }
    } fail:^{
        [self lastview:nil];
    }];

}
-(void)lastview:(NSDictionary *)dic{
    //无数据都显示0
    if (!dic) {
        dic = @{@"votes":@"0",@"nums":@"0",@"length":@"0"};
    }
    UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    lastView.userInteractionEnabled = YES;
    [lastView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [lastView addSubview:effectview];
    
    
    UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,24+statusbarHeight, _window_width, _window_height*0.17)];
    labell.textColor = RGB_COLOR(@"#cacbcc", 1);
    labell.text = YZMsg(@"直播已结束");
    labell.textAlignment = NSTextAlignmentCenter;
    labell.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [lastView addSubview:labell];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.1, labell.bottom+50, _window_width*0.8, _window_width*0.8*8/13)];
    backView.backgroundColor = RGB_COLOR(@"#000000", 0.2);
    backView.layer.cornerRadius = 5.0;
    backView.layer.masksToBounds = YES;
    [lastView addSubview:backView];
    
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width/2-50, labell.bottom, 100, 100)];
    [headerImgView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]] placeholderImage:[UIImage imageNamed:@"bg1"]];
    headerImgView.layer.masksToBounds = YES;
    headerImgView.layer.cornerRadius = 50;
    [lastView addSubview:headerImgView];

    
    UILabel *nameL= [[UILabel alloc]initWithFrame:CGRectMake(0,50, backView.width, backView.height*0.55-50)];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = [Config getOwnNicename];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [backView addSubview:nameL];

    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(10, nameL.bottom, backView.width-20, 1) andColor:RGB_COLOR(@"#585452", 1) andView:backView];
    
    NSArray *labelArray = @[YZMsg(@"直播时长"),[NSString stringWithFormat:@"%@%@",YZMsg(@"收获"),[common name_votes]],YZMsg(@"观看人数")];
    for (int i = 0; i < labelArray.count; i++) {
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*backView.width/3, nameL.bottom, backView.width/3, backView.height/4)];
        topLabel.font = [UIFont boldSystemFontOfSize:18];
        topLabel.textColor = normalColors;
        topLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            topLabel.text = minstr([dic valueForKey:@"length"]);
        }
        if (i == 1) {
            topLabel.text = minstr([dic valueForKey:@"votes"]);
        }
        if (i == 2) {
            topLabel.text = minstr([dic valueForKey:@"nums"]);
        }
        [backView addSubview:topLabel];
        UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(topLabel.left, topLabel.bottom, topLabel.width, 14)];
        footLabel.font = [UIFont systemFontOfSize:13];
        footLabel.textColor = RGB_COLOR(@"#cacbcc", 1);
        footLabel.textAlignment = NSTextAlignmentCenter;
        footLabel.text = labelArray[i];
        [backView addSubview:footLabel];
    }
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_window_width*0.1,_window_height *0.75, _window_width*0.8,50);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(docancle) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:normalColors];
    [button setTitle:YZMsg(@"返回首页") forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds  =YES;
    [lastView addSubview:button];
    [self.view addSubview:lastView];
    
}
- (void)docancle{
    self.isRedayCloseRoom = YES;
    if (self.tiSDKManager) {
        [self.tiSDKManager destroy];
        self.tiSDKManager = nil;
    }
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark ================ 直播结束 ===============

-(void)sendBarrage:(NSDictionary *)msg{
    NSString *text = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [msg valueForKey:@"uname"];
    NSString *icon = [msg valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    [danmuview setModel:userinfo];
}
-(void)sendMessage:(NSDictionary *)dic{
    [msgList addObject:dic];
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
}
-(void)sendDanMu:(NSDictionary *)dic{
    NSString *text = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [dic valueForKey:@"uname"];
    NSString *icon = [dic valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    [danmuview setModel:userinfo];
    long totalcoin = [self.danmuPrice intValue];//
    [self addCoin:totalcoin];
}
-(void)getZombieList:(NSArray *)list{
    NSArray *arrays =[list firstObject];
    userCount += arrays.count;
//    onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (!listView) {
        listView = [[ListCollection alloc]initWithListArray:list andID:[Config getOwnID] andStream:[NSString stringWithFormat:@"%@",[self.roomDic valueForKey:@"stream"]]];
        listView.delegate = self;
        listView.frame = CGRectMake(130, 20+statusbarHeight, _window_width-130, 40);
        [frontView addSubview:listView];
    }
      [listView listarrayAddArray:[list firstObject]];
}
-(void)jumpLast:(UITableView *)tableView
{
    if (_canScrollToBottom) {
    NSUInteger sectionCount = [tableView numberOfSections];
    if (sectionCount) {
        
        NSUInteger rowCount = [tableView numberOfRowsInSection:0];
        if (rowCount) {
            
            NSUInteger ii[2] = {sectionCount-1, 0};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
    }
}
-(void)quickSort1:(NSMutableArray *)userlist
{
    for (int i = 0; i<userlist.count; i++)
    {
        for (int j=i+1; j<[userlist count]; j++)
        {
            int aac = [[[userlist objectAtIndex:i] valueForKey:@"level"] intValue];
            int bbc = [[[userlist objectAtIndex:j] valueForKey:@"level"] intValue];
            NSDictionary *da = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:i]];
            NSDictionary *db = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:j]];
            if (aac >= bbc)
            {
                [userlist replaceObjectAtIndex:i withObject:da];
                [userlist replaceObjectAtIndex:j withObject:db];
            }else{
                [userlist replaceObjectAtIndex:j withObject:da];
                [userlist replaceObjectAtIndex:i withObject:db];
            }
        }
    }
}
-(void)socketUserLive:(NSString *)ID and:(NSDictionary *)msg{
    userCount -= 1;
//    onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (listView) {
        [listView userLive:msg];
    }
    if (_js_playrtmp) {
        if ([ID integerValue] == _js_playrtmp.tag-1500) {
            [_js_playrtmp stopConnect];
            [_js_playrtmp stopPush];
            [_js_playrtmp removeFromSuperview];
            _js_playrtmp = nil;
        }
    }

}
-(void)socketUserLogin:(NSString *)ID andDic:(NSDictionary *)dic{
    userCount += 1;
    if (listView) {
        [listView userAccess:dic];
    }
//    onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    //进场动画级别限制
//    NSString *levelLimit = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"level"]];
//    int levelLimits = [levelLimit intValue];
//    int levelLimitsLocal = [[common enter_tip_level] intValue];
//    if (levelLimitsLocal >levelLimits) {
//    }
//    else{
    NSString *vipType = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"vip_type"]];
    NSString *guard_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"guard_type"]];
    if ([vipType isEqual:@"1"] || [guard_type isEqual:@"1"] || [guard_type isEqual:@"2"]) {
        [useraimation addUserMove:dic];
        useraimation.frame = CGRectMake(10,self.tableView.top - 40,_window_width,20);
    }
    NSString *car_id = minstr([[dic valueForKey:@"ct"] valueForKey:@"car_id"]);
    if (![car_id isEqual:@"0"]) {
        if (!vipanimation) {
            vipanimation = [[viplogin alloc]initWithFrame:CGRectMake(0,80,_window_width,_window_width*0.8) andBlock:^(id arrays) {
                [vipanimation removeFromSuperview];
                vipanimation = nil;
            }];
            vipanimation.frame =CGRectMake(0,80,_window_width,_window_width*0.8);
            [self.view insertSubview:vipanimation atIndex:10];
            [self.view bringSubviewToFront:vipanimation];
        }
        [vipanimation addUserMove:dic];
    }
    
    [self userLoginSendMSG:dic];
    
}
//用户进入直播间发送XXX进入了直播间
-(void)userLoginSendMSG:(NSDictionary *)dic {
    titleColor = @"userLogin";
    NSString *uname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"user_nicename"]];
    NSString *levell = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"level"]];
    NSString *ID = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"id"]];
    NSString *vip_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"vip_type"]];
    NSString *liangname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"liangname"]];
    NSString *usertype = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"usertype"]];
    NSString *guard_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"guard_type"]];

    NSString *conttt = YZMsg(@" 进入了直播间");
    NSString *isadmin;
    if ([[NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"usertype"]] isEqual:@"40"]) {
        isadmin = @"1";
    }else{
        isadmin = @"0";
    }
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",conttt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",guard_type,@"guard_type",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
}
-(void)socketSystem:(NSString *)ct{
    titleColor = @"firstlogin";
    NSString *uname = YZMsg(@"直播间消息");
    NSString *levell = @" ";
    NSString *ID = @" ";
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];
}
-(void)socketLight{
    starX = closeLiveBtn.frame.origin.x ;
    starY = closeLiveBtn.frame.origin.y - 30;
    starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX, starY, 30, 30)];
    starImage.contentMode = UIViewContentModeScaleAspectFit;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_cyan.png",@"plane_heart_pink.png",@"plane_heart_red.png",@"plane_heart_yellow.png",@"plane_heart_heart.png", nil];
    NSInteger random = arc4random()%array.count;
    starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    [UIView animateWithDuration:0.2 animations:^{
        starImage.alpha = 1.0;
        starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self.view insertSubview:starImage atIndex:10];
    CGFloat finishX = _window_width - round(arc4random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 200;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(arc4random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(arc4random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(starImage)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    
    //  设置imageView的结束frame
    starImage.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        starImage.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
-(void)sendGift:(NSDictionary *)msg{
    titleColor = @"2";
    NSString *haohualiwuss =  [NSString stringWithFormat:@"%@",[msg valueForKey:@"evensend"]];
    NSDictionary *ct = [msg valueForKey:@"ct"];
    NSDictionary *GiftInfo = @{@"uid":[msg valueForKey:@"uid"],
                               @"nicename":[msg valueForKey:@"uname"],
                               @"giftname":[ct valueForKey:@"giftname"],
                               @"gifticon":[ct valueForKey:@"gifticon"],
                               @"giftcount":[ct valueForKey:@"giftcount"],
                               @"giftid":[ct valueForKey:@"giftid"],
                               @"level":[msg valueForKey:@"level"],
                               @"avatar":[msg valueForKey:@"uhead"],
                               @"type":[ct valueForKey:@"type"],
                               @"swf":minstr([ct valueForKey:@"swf"]),
                               @"swftime":minstr([ct valueForKey:@"swftime"]),
                               @"swftype":minstr([ct valueForKey:@"swftype"]),
                               @"isluck":minstr([ct valueForKey:@"isluck"]),
                               @"lucktimes":minstr([ct valueForKey:@"lucktimes"]),
                               @"mark":minstr([ct valueForKey:@"mark"])

                               };
    _voteNums = minstr([ct valueForKey:@"votestotal"]);
    [self changeState];

    if (  [[ct valueForKey:@"type"] isEqual:@"1"]) {
        [self expensiveGift:GiftInfo];
    }else{
        if (!continueGifts) {
            continueGifts = [[continueGift alloc]init];
            [liansongliwubottomview addSubview:continueGifts];
            //初始化礼物空位
            [continueGifts initGift];
        }
        if (pkView) {
            [self.view insertSubview:liansongliwubottomview aboveSubview:pkView];
        }
        [continueGifts GiftPopView:GiftInfo andLianSong:haohualiwuss];
    }
//聊天区域显示送礼物去除
//    NSString *ctt = [NSString stringWithFormat:@"送了一个%@",[ct valueForKey:@"giftname"]];
//    NSString* uname = [msg valueForKey:@"uname"];
//    NSString *levell = [msg valueForKey:@"level"];
//    NSString *ID = [msg valueForKey:@"uid"];
//    NSString *avatar = [msg valueForKey:@"uhead"];
//    NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
//    NSString *liangname =minstr([msg valueForKey:@"liangname"]);
//
//    NSDictionary *chat6 = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ctt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",avatar,@"avatar",vip_type,@"vip_type",liangname,@"liangname",nil];
//    [msgList addObject:chat6];
//    titleColor = @"0";
//    if(msgList.count>30)
//    {
//        [msgList removeObjectAtIndex:0];
//    }
//    [self.tableView reloadData];
//    [self jumpLast:self.tableView];
    
}
//懒加载
-(NSArray *)chatModels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in msgList) {
        chatModel *model = [chatModel modelWithDic:dic];
        [model setChatFrame:[_chatModels lastObject]];
        [array addObject:model];
    }
    _chatModels = array;
    return _chatModels;
}
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID andType:(NSString *)type{
    [socketL shutUp:ID andName:name andType:type];
}
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID{
    [socketL kickuser:ID andName:name];
}
static int startKeyboard = 0;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _canScrollToBottom = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _canScrollToBottom = YES;
}
-(void)chushihua{

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLiveing"];
    self.isRedayCloseRoom = NO;
    backTime = 0;
    [gameState saveProfile:@"0"];//重置游戏状态
    _canScrollToBottom = YES;
    _voteNums = @"0";//主播一开始的收获数
    userCount = 0;//用户人数计算
    haohualiwuV.expensiveGiftCount = [NSMutableArray array];//豪华礼物数组
    titleColor = @"0";//用此字段来判别文字颜色
    msgList = [[NSMutableArray alloc] init];//聊天数组
    _chatModels = [NSArray array];//聊天模型
    ismessgaeshow = NO;
    isLianmai = NO;
    //预览界面的信息
    liveClassID = @"-99999999";
    roomType = @"0";
    roomTypeValue = @"";
    selectShareName = @"";
    thumbImage = nil;
    isAnchorLink = NO;
    isTorch = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate =nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.unRead = [[JMSGConversation getAllUnreadCount] intValue];
        [self labeiHid];
    });
    if (huanxinviews != nil && chatsmall != nil) {
        huanxinviews.view.frame = CGRectMake(0, _window_height*5, _window_width, _window_height*0.4);
        chatsmall.view.frame = CGRectMake(0, _window_height*5, _window_width, _window_height*0.4);
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    //弹出相机权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
     
    }];
    //弹出麦克风权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
      
    }];

    isclosenetwork = NO;

    [self chushihua];
    [self nsnotifition];
    if ([_sdkType isEqual:@"1"]) {
        //腾讯
        [self txRtmpPush];
    }else{
        //创建推流器-金山
        [self initPushStreamer];
    }
    __block Livebroadcast *weakself = self;
    managerAFH = [AFNetworkReachabilityManager sharedManager];
    [managerAFH setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未识别的网络");
                isclosenetwork = YES;
                [weakself backGround];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                isclosenetwork = YES;
                [weakself backGround];
                break;
            case  AFNetworkReachabilityStatusReachableViaWWAN:
                isclosenetwork = NO;
                [weakself forwardGround];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                isclosenetwork = NO;
                [weakself forwardGround];
                break;
            default:
                break;
        }
    }];
    [managerAFH startMonitoring];
#pragma mark 回到后台+来电话
    [MBProgressHUD hideHUD];
    [self creatPreFrontView];
//    [self startUI];//初始化UI
}
//杀进程
-(void)shajincheng{
    [self getCloseShow];
    [socketL closeRoom];
    [socketL colseSocket];
}
-(void)backgroundselector{
    backTime +=1;
    NSLog(@"返回后台时间%d",backTime);
    if (backTime > 60) {
        [self hostStopRoom];
    }
}
-(void)backGround{
        //进入后台
        if (!backGroundTimer) {
            [self sendEmccBack];
            backGroundTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(backgroundselector) userInfo:nil repeats:YES];
        }
}
-(void)forwardGround{
    if (backTime != 0) {
        [socketL phoneCall:YZMsg(@"主播回来了")];
    }
    //进入前台
    if (backTime > 60) {
        [self hostStopRoom];
    }
    if (isclosenetwork == NO) {
        [backGroundTimer invalidate];
        backGroundTimer  = nil;
        backTime = 0;
    }
}
-(void)appactive{
    NSLog(@"哈哈哈哈哈哈哈哈哈哈哈哈 app回到前台");
    if ([_sdkType isEqual:@"1"]) {
        [_txLivePublisher resumePush];
    }else {
        [_gpuStreamer appBecomeActive];
    }
//    [self forwardGround];
}
-(void)appnoactive{
//    if ([_sdkType isEqual:@"1"]) {
//         [_txLivePublisher pausePush];
//    }else{
//         [_gpuStreamer appEnterBackground];
//    }

//    [self backGround];
    NSLog(@"0000000000000000000 app进入后台");
}
//来电话
-(void)sendEmccBack {
    [socketL phoneCall:YZMsg(@"主播离开一下，精彩不中断，不要走开哦")];
}
-(void)startUI{
    frontView = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
    frontView.clipsToBounds = YES;
    [self.view addSubview:frontView];
    [self.view insertSubview:frontView atIndex:3];

    listView = [[ListCollection alloc]initWithListArray:nil andID:[Config getOwnID] andStream:[NSString stringWithFormat:@"%@",[_roomDic valueForKey:@"stream"]]];
    listView.frame = CGRectMake(130,20+statusbarHeight,_window_width-130,40);
    listView.delegate = self;
    [frontView addSubview:listView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setView];//加载信息页面
    });
    //倒计时动画
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    backView.opaque = YES;
    label1 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:90];
    label1.text = @"3";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.center = backView.center;
    label2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label2.textColor = [UIColor whiteColor];
    label2.font = [UIFont systemFontOfSize:90];
    label2.text = @"2";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.center = backView.center;
    label3 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2 -100, _window_height/2-200, 100, 100)];
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:90];
    label3.text = @"1";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.center = backView.center;
    label1.hidden = YES;
    label2.hidden = YES;
    label3.hidden = YES;
    [backView addSubview:label3];
    [backView addSubview:label1];
    [backView addSubview:label2];
    [frontView addSubview:backView];
    [self creatLiveTimeView];
    [self kaishidonghua];
    self.view.backgroundColor = [UIColor clearColor];
}
//开始321
-(void)kaishidonghua{
    [self hideBTN];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label1.hidden = NO;
        [self donghua:label1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label1.hidden = YES;
        label2.hidden = NO;
        [self donghua:label2];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label2.hidden = YES;
        label3.hidden = NO;
        [self donghua:label3];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        label3.hidden = YES;
        backView.hidden = YES;
        [backView removeFromSuperview];
        [self showBTN];
        [self getStartShow];//请求直播
    });
}
//设置美颜
-(void)setMeiYanData:(int)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            _filter = [[KSYGPUBeautifyExtFilter alloc] init];
        }
            break;
        case 1:
        {
            _filter = [[KSYGPUBeautifyFilter alloc] init];
        }
            break;
        case 2:
        {
            _filter = [[KSYGPUDnoiseFilter alloc] init];
        }
            break;
        case 3:
        {
            _filter = [[KSYGPUBeautifyPlusFilter alloc] init];
        }
            break;
        default:
            _filter = nil;
            _filter = [[KSYGPUFilter alloc] init];
            break;
    }

    [_gpuStreamer setupFilter:_filter];

}
-(void)sliderValueChanged:(float)slider
{
    [(KSYGPUBeautifyExtFilter *)_filter setBeautylevel: slider];
}
-(void)hidebeautifulgirl
{
    beautifulgirl.hidden = YES;
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
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kKSYReachabilityChangedNotification object:nil];
    [backGroundTimer invalidate];
    backGroundTimer  = nil;
    NSLog(@"1212121212121212121");

}
//释放通知
- (void) rmObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYStreamStateDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:KSYNetStateEventNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:@"wangminxindemusicplay"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wangminxindemusicplay" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"shajincheng" object:nil];
    //shajincheng
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sixinok" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"fenxiang" object:nil];
}
//手指拖拽弹窗移动
-(void)message:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x;
    center.y += point.y;
    userView.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}
#pragma mark - UI responde
- (void)onQuit:(id)sender {
    /*
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
     */
    if (_filter) {
        _filter = nil;
    }
    [_gpuStreamer stopPreview];
    _gpuStreamer = nil;
}
////美颜按钮点击事件
-(void)OnChoseFilter:(id)sender {

    if (!beautifulgirl) {
        __weak Livebroadcast *weakself = self;
           beautifulgirl = [[beautifulview alloc]initWithFrame:self.view.bounds andhide:^(NSString *type) {
               [weakself hidebeautifulgirl];
               if (_preFrontView) {
                   _preFrontView.hidden = NO;
               }
          } andslider:^(NSString *type) {
               [weakself sliderValueChanged:[type floatValue]];
          } andtype:^(NSString *type) {
              [weakself setMeiYanData:[type intValue]];
        }];
        [self.view addSubview:beautifulgirl];
    }
    beautifulgirl.hidden = NO;
    [self.view bringSubviewToFront:beautifulgirl];
}
- (void)onStream:(id)sender {
//    if (_gpuStreamer.streamerBase.streamState != KSYStreamStateConnected) {
        [_gpuStreamer.streamerBase startStream: [NSURL URLWithString:_hostURL]];
//    }
//    else {
//        [_gpuStreamer.streamerBase stopStream];
//    }
//    return;
}
//推流成功后更新直播状态 1开播
-(void)changePlayState:(int)status{
    NSDictionary *changelive = @{
                                 @"stream":urlStrtimestring,
                                 @"status":[NSString stringWithFormat:@"%d",status]
                                 };
    [YBToolClass postNetworkWithUrl:@"Live.changeLive" andParameter:changelive success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
//            [self creatLiveTimeView];
        }
    } fail:^{
        
    }];
}
#pragma mark ================ 直播时长的view ===============
- (void)creatLiveTimeView{
    
    liveTimeBGView = [[UIView alloc]initWithFrame:CGRectMake(10, 30+leftW +statusbarHeight+25, 60, 20)];
    liveTimeBGView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    liveTimeBGView.layer.cornerRadius = 10.0;
    liveTimeBGView.layer.masksToBounds = YES;
    [frontView addSubview:liveTimeBGView];
    UIView *pointView = [[UIView alloc]initWithFrame:CGRectMake(10, 8.5, 3, 3)];
    pointView.backgroundColor = normalColors;
    pointView.layer.cornerRadius = 1.5;
    pointView.layer.masksToBounds = YES;
    [liveTimeBGView addSubview:pointView];

    liveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(pointView.right+3, 0, 31, 20)];
    liveTimeLabel.textColor = [UIColor whiteColor];
    liveTimeLabel.font = [UIFont systemFontOfSize:10];
    liveTimeLabel.textAlignment = NSTextAlignmentCenter;
    liveTimeLabel.text = @"00:00";
    [liveTimeBGView addSubview:liveTimeLabel];
    liveTime = 0;
    if (!liveTimer) {
        liveTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(liveTimeChange) userInfo:nil repeats:YES];
    }

}
- (void)liveTimeChange{
    liveTime ++;
    if (liveTime < 3600) {
        liveTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",liveTime/60,liveTime%60];
    }else{
        if (liveTimeBGView.width < 73) {
            liveTimeBGView.width = 73;
            liveTimeLabel.width = 44;
        }
        liveTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",liveTime/3600,(liveTime%3600)/60,(liveTime%3600)%60];
    }
}
#pragma mark - state handle
- (void) onStreamError {
    if (1 ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_gpuStreamer.streamerBase stopStream];
            [_gpuStreamer.streamerBase startStream:[NSURL URLWithString:_hostURL]];
        });
    }
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
        [self changePlayState:1];//推流成功后改变直播状态
        if (_gpuStreamer.streamerBase.streamErrorCode == KSYStreamErrorCode_KSYAUTHFAILED ) {
            //(obsolete)
            NSLog(@"推流错误:(obsolete)");
        }
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateConnecting ) {
        NSLog(@"推流状态:连接中");
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateDisconnecting ) {
        NSLog(@"推流状态:断开连接中");
        [self onStreamError];
    }
    else if (_gpuStreamer.streamerBase.streamState == KSYStreamStateError ) {
        NSLog(@"推流状态:推流出错");
        [self onStreamError];
        return;
    }
}
//直播结束选择 alertview
- (void)onQuit {
    
    
    UIAlertController  *alertlianmaiVCtc = [UIAlertController alertControllerWithTitle:YZMsg(@"确定退出直播吗？") message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self hostStopRoom];
    }];

    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [defaultActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    
    [alertlianmaiVCtc addAction:defaultActionss];
    [alertlianmaiVCtc addAction:cancelActionss];
    [self presentViewController:alertlianmaiVCtc animated:YES completion:nil];

    
}

//关闭直播做的操作
-(void)hostStopRoom{
    [self getCloseShow];//请求关闭直播接口
}
//直播结束时 停止所有计时器
-(void)liveOver{
    if (lrcTimer) {
        [lrcTimer invalidate];
        lrcTimer = nil;
    }
    if (backGroundTimer) {
        [backGroundTimer invalidate];
        backGroundTimer  = nil;
    }
    if (listTimer) {
        [listTimer invalidate];
        listTimer = nil;
    }
    if (liveTimer) {
        [liveTimer invalidate];
        liveTimer = nil;
    }
    if (hartTimer) {
        [hartTimer invalidate];
        hartTimer = nil;
    }
}
//直播结束时退出房间
-(void)dismissVC{
    if ([_sdkType isEqual:@"1"]) {
        [self txStopRtmp];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLiveing"];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
     [managerAFH stopMonitoring];
    if (bottombtnV) {
        [bottombtnV removeFromSuperview];
        bottombtnV = nil;
    }
    [userView removeFromSuperview];
    userView = nil;
    [gameState saveProfile:@"0"];//清除游戏状态
    [managerAFH stopMonitoring];
    managerAFH = nil;
    if (continueGifts) {
        [continueGifts stopTimerAndArray];
        [continueGifts initGift];
        [continueGifts removeFromSuperview];
        continueGifts = nil;
    }
    if (haohualiwuV) {
        [haohualiwuV stopHaoHUaLiwu];
        [haohualiwuV removeFromSuperview];
        haohualiwuV.expensiveGiftCount = nil;
    }
    if (zhuangVC) {
        [zhuangVC dismissroom];
        [zhuangVC removeall];
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
        [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;        
    }
    if (_js_playrtmp) {
        [_js_playrtmp stopConnect];
        [_js_playrtmp stopPush];
        [_js_playrtmp removeFromSuperview];
        _js_playrtmp = nil;
    }
    if (_tx_playrtmp) {
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }

    NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[minstr(urlStrtimestring)] forKeys:@[@"stream"]];
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"coin" object:nil userInfo:subdic];
}
/***********  以上推流  *************/
/***************     以下是信息页面          **************/
//加载信息页面
-(void)zhuboMessage{
    if (userView) {
        [userView removeFromSuperview];
        userView = nil;
    }

    if (!userView) {

        
        //添加用户列表弹窗
        userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height*2, upViewW, upViewW/3*4) andPlayer:@"Livebroadcast"];
        userView.upmessageDelegate = self;
        userView.backgroundColor = [UIColor whiteColor];
        userView.layer.cornerRadius = 10;
        
        
        UIWindow *mainwindows = [UIApplication sharedApplication].delegate.window;
        [mainwindows addSubview:userView];
        
    }
    self.tanChuangID = [Config getOwnID];
    self.tanchuangName = [Config getOwnNicename];
    NSDictionary *subdic = @{@"id":[Config getOwnID]};
    [self GetInformessage:subdic];
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,(_window_height-upViewW*4/3)/2,upViewW,upViewW*4/3);
    }];
}
-(void)GetInformessage:(NSDictionary *)subdic{
    if (userView) {
        [userView removeFromSuperview];
        userView = nil;
    }

    NSDictionary *subdics = @{@"uid":[Config getOwnID],
                             @"avatar":[Config getavatar]
                            };
        if (!userView) {
            //添加用户列表弹窗
            userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height*2, upViewW, upViewW*4/3) andPlayer:@"Livebroadcast"];
            userView.upmessageDelegate = self;
            userView.backgroundColor = [UIColor whiteColor];
            userView.layer.cornerRadius = 10;
            UIWindow *mainwindows = [UIApplication sharedApplication].delegate.window;
            [mainwindows addSubview:userView];
        }
        //用户弹窗
        self.tanChuangID = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
        self.tanchuangName = [subdic valueForKey:@"name"];
        [userView getUpmessgeinfo:subdic andzhuboDic:subdics];
        [UIView animateWithDuration:0.2 animations:^{
            userView.frame = CGRectMake(_window_width*0.1,(_window_height-upViewW*4/3)/2,upViewW,upViewW*4/3);
        }];
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
}
-(void)setView{
  
    //左上角 直播live
    leftView = [[UIView alloc]initWithFrame:CGRectMake(10,25+statusbarHeight,115,leftW)];
    leftView.layer.cornerRadius = leftW/2;
    leftView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    //主播头像button
    UIButton *IconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [IconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];
    IconBTN.frame = CGRectMake(1, 1, leftW-2, leftW-2);
    IconBTN.layer.masksToBounds = YES;
    IconBTN.layer.borderWidth = 1;
    IconBTN.layer.borderColor = normalColors.CGColor;
    IconBTN.layer.cornerRadius = leftW/2-1;
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [leftView addGestureRecognizer:tapleft];
    LiveUser *user = [[LiveUser alloc]init];
    user = [Config myProfile];
    NSString *path = user.avatar;
    NSURL *url = [NSURL URLWithString:path];
    [IconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
    
    
    UIImageView *levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(IconBTN.right - 15,IconBTN.bottom - 15,15,15)];
    NSDictionary *levelDic = [common getAnchorLevelMessage:[Config level_anchor]];
    [levelimage sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb_mark"])]];

    
    //直播live
    UILabel *liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftW+4,0,65,leftW/2)];
    liveLabel.textAlignment = NSTextAlignmentLeft;
    liveLabel.text = [Config getOwnNicename];
    liveLabel.textColor = [UIColor whiteColor];
    //liveLabel.shadowColor = [UIColor lightGrayColor];
    liveLabel.shadowOffset = CGSizeMake(1,1);//设置阴影
    liveLabel.font = fontMT(13);
    //在线人数
    onlineLabel = [[UILabel alloc]init];
    onlineLabel.frame = CGRectMake(leftW+4,leftW/2,65,leftW/2);
    onlineLabel.textAlignment = NSTextAlignmentLeft;
    onlineLabel.textColor = [UIColor whiteColor];
    onlineLabel.font = fontMT(10);
    NSString *liangname = [NSString stringWithFormat:@"%@",[[_roomDic valueForKey:@"liang"] valueForKey:@"name"]];
    if ([liangname isEqual:@"0"]) {
        onlineLabel.text = [NSString stringWithFormat:@"ID:%@",[Config getOwnID]];
    }else{
        onlineLabel.text = [NSString stringWithFormat:@"%@:%@",YZMsg(@"靓"),liangname];
    }
    
    //聊天
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, _window_height - _window_height*0.2 - 50 - ShowDiff,tableWidth,_window_height*0.2) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.clipsToBounds = YES;
    self.tableView.estimatedRowHeight = 80.0;
    //输入框
    keyField = [[UITextField alloc]initWithFrame:CGRectMake(70,7,_window_width-90 - 50, 30)];
    keyField.returnKeyType = UIReturnKeySend;
    keyField.delegate  = self;
    keyField.borderStyle = UITextBorderStyleNone;
    keyField.placeholder = YZMsg(@"和大家说些什么");
    keyField.backgroundColor = [UIColor whiteColor];
    keyField.layer.cornerRadius = 15.0;
    keyField.layer.masksToBounds = YES;
    UIView *fieldLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    fieldLeft.backgroundColor = [UIColor whiteColor];
    keyField.leftView = fieldLeft;
    keyField.leftViewMode = UITextFieldViewModeAlways;
    keyField.font = [UIFont systemFontOfSize:15];

    www = 30;
    //键盘出现
    keyBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBTN.tintColor = [UIColor whiteColor];
    keyBTN.userInteractionEnabled = YES;
    [keyBTN setBackgroundImage:[UIImage imageNamed:@"live_聊天"] forState:UIControlStateNormal];
    [keyBTN addTarget:self action:@selector(showkeyboard:) forControlEvents:UIControlEventTouchUpInside];
    keyBTN.layer.masksToBounds = YES;
    keyBTN.layer.shadowColor = [UIColor blackColor].CGColor;
    keyBTN.layer.shadowOffset = CGSizeMake(1, 1);
    //发送按钮
    pushBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [pushBTN setImage:[UIImage imageNamed:@"chat_send_gray"] forState:UIControlStateNormal];
    [pushBTN setImage:[UIImage imageNamed:@"chat_send_yellow"] forState:UIControlStateSelected];
    pushBTN.imageView.contentMode = UIViewContentModeScaleAspectFit;

    pushBTN.layer.masksToBounds = YES;
    pushBTN.layer.cornerRadius = 5;
    [pushBTN addTarget:self action:@selector(pushMessage:) forControlEvents:UIControlEventTouchUpInside];
    pushBTN.frame = CGRectMake(_window_width-55,7,50,30);
    cs = [[catSwitch alloc] initWithFrame:CGRectMake(6,11,44,22)];
    cs.delegate = self;
    //退出页面按钮
    closeLiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeLiveBtn.tintColor = [UIColor whiteColor];
    [closeLiveBtn setImage:[UIImage imageNamed:@"cancleliveshow"] forState:UIControlStateNormal];
    [closeLiveBtn addTarget:self action:@selector(onQuit) forControlEvents:UIControlEventTouchUpInside];
    //消息按钮
    messageBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBTN setImage:[UIImage imageNamed:@"live_私信"] forState:UIControlStateNormal];
    [messageBTN addTarget:self action:@selector(doMessage) forControlEvents:UIControlEventTouchUpInside];
    self.unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, -5, 16, 16)];
    self.unReadLabel.textAlignment = NSTextAlignmentCenter;
    self.unReadLabel.textColor = [UIColor whiteColor];
    self.unReadLabel.layer.masksToBounds = YES;
    self.unReadLabel.layer.cornerRadius = 8;
    self.unReadLabel.font = [UIFont systemFontOfSize:9];
    self.unReadLabel.backgroundColor = [UIColor redColor];
    self.unReadLabel.hidden = YES;
    [messageBTN addSubview:self.unReadLabel];
    //camera按钮
    moreBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBTN.tintColor = [UIColor whiteColor];
    [moreBTN setBackgroundImage:[UIImage imageNamed:@"功能"] forState:UIControlStateNormal];
    [moreBTN addTarget:self action:@selector(showmoreview) forControlEvents:UIControlEventTouchUpInside];
    
    //camera按钮
    linkSwitchBtn = [UIButton buttonWithType:0];
    [linkSwitchBtn setBackgroundImage:[UIImage imageNamed:@"允许连麦"] forState:UIControlStateNormal];
    [linkSwitchBtn setBackgroundImage:[UIImage imageNamed:@"禁止连麦"] forState:UIControlStateSelected];
    [linkSwitchBtn addTarget:self action:@selector(linkSwitchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    linkSwitchBtn.selected = NO;
    
    //PK按钮
    startPKBtn = [UIButton buttonWithType:0];
    [startPKBtn setBackgroundImage:[UIImage imageNamed:@"发起pk"] forState:UIControlStateNormal];
    [startPKBtn addTarget:self action:@selector(startPKBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    startPKBtn.hidden = YES;
    
    
    //PK按钮
    redBagBtn = [UIButton buttonWithType:0];
    [redBagBtn setBackgroundImage:[UIImage imageNamed:@"红包-右上角"] forState:UIControlStateNormal];
    [redBagBtn addTarget:self action:@selector(redBagBtnClick) forControlEvents:UIControlEventTouchUpInside];
    redBagBtn.hidden = YES;
    redBagBtn.frame = CGRectMake(_window_width-50, 170+statusbarHeight, 40, 50);
    /*==================  连麦  ================*/
    //tool绑定键盘
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height+10, _window_width, 44)];
    toolBar.backgroundColor = [UIColor clearColor];
    UIView *tooBgv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 44)];
    tooBgv.backgroundColor = [UIColor whiteColor];
    tooBgv.alpha = 0.7;
    [toolBar addSubview:tooBgv];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(cs.right+9, cs.top, 1, 20)];
    line1.backgroundColor = RGB(176, 176, 176);
    line1.alpha = 0.5;
    [toolBar addSubview:line1];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(keyField.right+7, line1.top, 1, 20)];
    line2.backgroundColor = line1.backgroundColor;
    line2.alpha = line1.alpha;
    [toolBar addSubview:line2];
    [toolBar addSubview:pushBTN];
    [toolBar addSubview:keyField];
    [toolBar addSubview:cs];
    [frontView addSubview:keyBTN];
    //关闭连麦按钮
    //直播间按钮（竞拍，游戏，扣费，后台控制隐藏,createroom接口传进来）
    [self changeBtnFrame:_window_height - 45];
    [leftView addSubview:onlineLabel];
    [leftView addSubview:liveLabel];
    [leftView addSubview:IconBTN];
    [leftView addSubview:levelimage];
    [frontView addSubview:leftView];
    [frontView addSubview:moreBTN];
    [frontView addSubview:messageBTN];
    [frontView addSubview:closeLiveBtn];
    [frontView addSubview:linkSwitchBtn];
    [self.view addSubview:redBagBtn];

    [self hideBTN];
    /*==================  连麦  ================*/
    [self.view addSubview:toolBar];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangePushBtnState) name:UITextFieldTextDidChangeNotification object:nil];

    [self.view insertSubview:self.tableView atIndex:4];
    useraimation = [[userLoginAnimation alloc]init];
    useraimation.frame = CGRectMake(10,self.tableView.top - 40,_window_width,20);
    [self.view insertSubview:useraimation atIndex:4];
    danmuview = [[GrounderSuperView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 140)];
    [frontView insertSubview:danmuview atIndex:5];
    liansongliwubottomview = [[UIView alloc]init];
    [self.view insertSubview:liansongliwubottomview belowSubview:frontView];
    liansongliwubottomview.frame = CGRectMake(0, self.tableView.top-150,_window_width/2,140);
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSixin:)];
//
//    [self.view addGestureRecognizer:tapGesture];

}
- (void)hideSixin:(UIButton *)sender{
//    [keyField resignFirstResponder];
    [self getweidulabel];

    if (chatsmall||sysView) {
        if (chatsmall) {
            [chatsmall.view endEditing:YES];
        }
        return;
    }
    if (huanxinviews) {
        [huanxinviews.view removeFromSuperview];
        huanxinviews.view = nil;
        huanxinviews = nil;
        [self showBTN];
    }
    [sender removeFromSuperview];
    sender = nil;
}
-(void)hidecoastview{
    [UIView animateWithDuration:0.3 animations:^{
        coastview.frame = CGRectMake(0, -_window_height, _window_width, _window_height);
    }];
}
//弹出收费弹窗
-(void)doupcoast{

    if (!coastview) {
        coastview = [[coastselectview alloc]initWithFrame:CGRectMake(0, -_window_height, _window_width, _window_height) andsureblock:^(NSString *type) {
            if (_preFrontView) {
                roomType = @"3";
                roomTypeValue = type;
                [self changeRoomBtnState:@"计时房间"];
                [self hidecoastview];
            }else{
                coastmoney = type;
                [MBProgressHUD showMessage:@""];
                //Live.changeLiveType
                NSDictionary *subdic = @{
                                         @"stream":urlStrtimestring,
                                         @"type":@"3",
                                         @"type_val":coastmoney
                                         };
                [YBToolClass postNetworkWithUrl:@"Live.changeLiveType" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
                    [MBProgressHUD hideHUD];

                    if (code == 0) {
                        
                        [MBProgressHUD hideHUD];
                        [MBProgressHUD showError:msg];
                        [socketL changeLiveType:coastmoney];
                        //收费金额
                        [self hidecoastview];
                    }

                } fail:^{
                    [MBProgressHUD hideHUD];
                }];
            }
        } andcancleblock:^(NSString *type) {
            //取消
            [self hidecoastview];
        }];
        [self.view addSubview:coastview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        coastview.frame = CGRectMake(0,0, _window_width, _window_height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            coastview.frame = CGRectMake(0,20,_window_width, _window_height);
        }];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.1 animations:^{
            coastview.frame = CGRectMake(0, 0, _window_width, _window_height);
        }];
    });
    coastview.userInteractionEnabled = YES;
}
- (void)doShareViewShow{
    if (!fenxiangV) {
        //分享弹窗
        fenxiangV = [[fenXiangView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
        NSDictionary *mudic = @{
                                @"user_nicename":[Config getOwnNicename],
                                @"avatar_thumb":[Config getavatarThumb],
                                @"uid":[Config getOwnID]
                                };
        
        [fenxiangV GetDIc:mudic];
        [self.view addSubview:fenxiangV];
    }else{
        [fenxiangV show];
    }

}
-(void)toolbarHidden
{
    [self showBTN];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
    [UIView animateWithDuration:0.5 animations:^{
        chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (chatsmall) {
            [chatsmall.view removeFromSuperview];
            chatsmall.view = nil;
            chatsmall = nil;
        }
    });
}
-(void)toolbarClick:(id)sender
{
    [keyField resignFirstResponder];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
}

-(void)changeState{
    if (!yingpiaoLabel) {
        //魅力值//魅力值
        //修改 魅力值 适应字体 欣
        UIFont *font1 = [UIFont systemFontOfSize:12];
        NSString *str = [NSString stringWithFormat:@"%@ %@ >",[common name_votes],_voteNums];
        CGFloat width = [[YBToolClass sharedInstance] widthOfString:str andFont:font1 andHeight:20];
        yingpiaoLabel  = [[UILabel alloc]init];
        yingpiaoLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        yingpiaoLabel.font = font1;
        yingpiaoLabel.text = str;
        yingpiaoLabel.frame = CGRectMake(10,30+leftView.frame.size.height +statusbarHeight, width+30,20);
        yingpiaoLabel.textAlignment = NSTextAlignmentCenter;
        yingpiaoLabel.textColor = [UIColor whiteColor];
        yingpiaoLabel.layer.cornerRadius = 10.0;
        yingpiaoLabel.layer.masksToBounds  =YES;
        UITapGestureRecognizer *yingpiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingpiao)];
        [yingpiaoLabel addGestureRecognizer:yingpiaoTap];
        yingpiaoLabel.userInteractionEnabled = YES;
        [frontView addSubview:yingpiaoLabel];
    }else{
        UIFont *font1 = [UIFont systemFontOfSize:12];
        NSString *str = [NSString stringWithFormat:@"%@ %@ >",[common name_votes],_voteNums];
        CGFloat width = [[YBToolClass sharedInstance] widthOfString:str andFont:font1 andHeight:20]+30;
        yingpiaoLabel.width = width;
        yingpiaoLabel.text = str;
        guardBtn.frame = CGRectMake(yingpiaoLabel.right+5, yingpiaoLabel.top, guardWidth+20, yingpiaoLabel.height);
    }
}
- (void)changeGuardNum:(NSString *)nums{
    if (!guardBtn) {
        guardWidth = [[YBToolClass sharedInstance] widthOfString:YZMsg(@"守护 虚位以待>") andFont:[UIFont systemFontOfSize:12] andHeight:20];
        guardBtn = [UIButton buttonWithType:0];
        guardBtn.frame = CGRectMake(yingpiaoLabel.right+5, yingpiaoLabel.top, guardWidth+20, yingpiaoLabel.height);
        guardBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        [guardBtn addTarget:self action:@selector(guardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [guardBtn setTitle:YZMsg(@"守护 虚位以待>") forState:0];
        guardBtn.layer.cornerRadius = 10;
        guardBtn.layer.masksToBounds = YES;
        guardBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [frontView addSubview:guardBtn];
    }
    if (![nums isEqual:@"0"]) {
        [guardBtn setTitle:[NSString stringWithFormat:@"%@ %@%@ >",YZMsg(@"守护"),nums,YZMsg(@"人")] forState:0];
        guardWidth = [[YBToolClass sharedInstance] widthOfString:guardBtn.titleLabel.text andFont:[UIFont systemFontOfSize:12] andHeight:20];
        guardBtn.frame = CGRectMake(yingpiaoLabel.right+5, yingpiaoLabel.top, guardWidth+20, yingpiaoLabel.height);
    }
}
//跳往魅力值界面
-(void)yingpiao{
//    personList *jumpC = [[personList alloc] init];
//    jumpC.userID = [Config getOwnID];
//    [self presentViewController:jumpC animated:YES completion:nil];
    webH5 *jumpC = [[webH5 alloc]init];
    jumpC.urls = [NSString stringWithFormat:@"%@/index.php?g=Appapi&m=contribute&a=index&uid=%@",h5url,[Config getOwnID]];
    [self.navigationController pushViewController:jumpC animated:YES];

}
-(void)changeMusic:(NSNotification *)notifition{
    _count = 0;
    [musicV removeFromSuperview];
    musicV = nil;

    _isPlayLrcing = NO;
    if (lrcTimer) {
        [lrcTimer invalidate];
        lrcTimer =nil;
    }
    NSDictionary *dic = [notifition userInfo];
    muaicPath  = [dic valueForKey:@"music"];
    //NSString *lrcId = [dic valueForKey:@"lrc"];
    passStr = [dic valueForKey:@"lrc"];
    NSFileManager *managers=[NSFileManager defaultManager];
    
    if ([_sdkType isEqual:@"1"]) {
        [_txLivePublisher stopBGM];
        if ([managers fileExistsAtPath:muaicPath]) {
            [_txLivePublisher playBGM:muaicPath withBeginNotify:^(NSInteger errCode) {
                NSLog(@"yyyyyyyyyyyyyyyyyyy");
                [_txLivePublisher setBGMVolume:1.0];
                [_txLivePublisher setMicVolume:2.0];
                //音乐播放开始
            } withProgressNotify:^(NSInteger progressMS, NSInteger durationMS) {
                //音乐播放进度
                int progress = (int)progressMS/1000;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ((int)progress % 60 < 10) {
                        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)progress / 60, (int)progress % 60];
                    } else {
                        self.timeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)progress / 60, (int)progress % 60];
                    }
                    if (progressMS == durationMS) {
                        [self musicPlay];
                    }
                });
                NSDictionary *dic = self.lrcList[_count];
                NSArray *array = [dic[@"lrctime"] componentsSeparatedByString:@":"];//把时间转换成秒
                NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
                //判断是否播放歌词
                if (progressMS >= currentTime && _isPlayLrcing == NO) {
                    [lrcView beganLrc:self.lrcList];
                    _isPlayLrcing = YES;
                }
            } andCompleteNotify:^(NSInteger errCode) {
            }];
            musicV = [[UIView alloc]initWithFrame:CGRectMake(50, _window_height*0.4, _window_width-50, 100)];
            musicV.backgroundColor = [UIColor clearColor];
            [self.view addSubview:musicV];
            UIPanGestureRecognizer *aPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(musicPan:)];
            aPan.minimumNumberOfTouches = 1;
            aPan.maximumNumberOfTouches = 1;
            [musicV addGestureRecognizer:aPan];
        }else{
            NSLog(@"歌曲不存在");
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        lrcPath = [docDir stringByAppendingFormat:@"/%@.lrc",passStr];//lrcId
        if ([managers fileExistsAtPath:lrcPath]) {
            lrcView = [[YLYOKLRCView alloc]initWithFrame:CGRectMake(0,40,_window_width-50, 30)];
            lrcView.lrcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];//OKlrcLabel
            lrcView.OKlrcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            lrcView.backgroundColor = [UIColor clearColor];
            [musicV addSubview:lrcView];
            YLYMusicLRC *lrc = [[YLYMusicLRC alloc]initWithLRCFile:lrcPath];
            if(lrc.lrcList.count == 0 || !lrc.lrcList) {
                [MBProgressHUD showError:@"暂无歌词"];
                buttonmusic = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonmusic.frame = CGRectMake(80,0,50,30);
                [buttonmusic addTarget:self action:@selector(musicPlay) forControlEvents:UIControlEventTouchUpInside];
                [buttonmusic setTitle:@"结束" forState:UIControlStateNormal];
                buttonmusic.backgroundColor = [UIColor clearColor];
                [buttonmusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                buttonmusic.layer.masksToBounds = YES;
                buttonmusic.layer.cornerRadius = 10;
                buttonmusic.layer.borderWidth = 1;
                buttonmusic.layer.borderColor = [UIColor whiteColor].CGColor;
                [musicV addSubview:buttonmusic];
                return;
            }
            self.lrcList = lrc.lrcList;
            self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(140,0,50,30)];
            self.timeLabel.backgroundColor = [UIColor clearColor];
            self.timeLabel.textAlignment = NSTextAlignmentCenter;
            self.timeLabel.textColor = [UIColor whiteColor];
            self.timeLabel.layer.cornerRadius = 10;
            self.timeLabel.layer.borderWidth = 1;
            self.timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",0,0];
            [musicV addSubview:self.timeLabel];
        }else{
            NSLog(@"歌词不存在");
        }
        buttonmusic = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonmusic.frame = CGRectMake(80,0,50,30);
        [buttonmusic addTarget:self action:@selector(musicPlay) forControlEvents:UIControlEventTouchUpInside];
        [buttonmusic setTitle:@"结束" forState:UIControlStateNormal];
        buttonmusic.backgroundColor = [UIColor clearColor];
        [buttonmusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonmusic.layer.masksToBounds = YES;
        buttonmusic.layer.cornerRadius = 10;
        buttonmusic.layer.borderWidth = 1;
        buttonmusic.layer.borderColor = [UIColor whiteColor].CGColor;
        [musicV addSubview:buttonmusic];
        
    }
    else{
        [_gpuStreamer.bgmPlayer stopPlayBgm];
        if ([managers fileExistsAtPath:muaicPath]) {
            [_gpuStreamer.bgmPlayer startPlayBgm:muaicPath isLoop:NO];
            _gpuStreamer.bgmPlayer.bgmVolume = 0.2;
            [_gpuStreamer.aMixer setMixVolume:0.2 of:_gpuStreamer.bgmTrack];
            [_gpuStreamer.aMixer setMixVolume:1.0 of:_gpuStreamer.micTrack];
            
        }else{
            NSLog(@"歌曲不存在");
        }
    }
}
//手指拖拽音乐移动
-(void)musicPan:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x;
    center.y += point.y;
    musicV.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}
//TODO:更新ing歌曲播放时间
-(void)updateMusicTimeLabel{
    
    if ((int)_gpuStreamer.bgmPlayer.bgmPlayTime % 60 < 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)_gpuStreamer.bgmPlayer.bgmPlayTime / 60, (int)_gpuStreamer.bgmPlayer.bgmPlayTime % 60];
    }else {
        self.timeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)_gpuStreamer.bgmPlayer.bgmPlayTime / 60, (int)_gpuStreamer.bgmPlayer.bgmPlayTime % 60];
    }
    NSDictionary *dic = self.lrcList[_count];
    NSArray *array = [dic[@"lrctime"] componentsSeparatedByString:@":"];//把时间转换成秒
    NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
    //判断是否播放歌词
    if (_gpuStreamer.bgmPlayer.bgmPlayTime >= currentTime && _isPlayLrcing == NO) {
        [lrcView beganLrc:self.lrcList];
        _isPlayLrcing = YES;
    }
    if (_gpuStreamer.bgmPlayer.bgmPlayerState != KSYBgmPlayerStatePlaying) {
        [self musicPlay];
    }
}
//关闭音乐
-(void)musicPlay{
    if (lrcView.timelrc) {
        [lrcView.timelrc invalidate];
        lrcView.timelrc = nil;
    }
    if (lrcView) {
        [lrcView removeFromSuperview];
        lrcView = nil;
    }
    _count = 0;
    /*
    if (self.player) {
        [self.player stop];
        self.player = nil;
    }
     */
    if ([_sdkType isEqual:@"1"]) {
        [_txLivePublisher stopBGM];
    }else{
        [_gpuStreamer.bgmPlayer stopPlayBgm];
    }
    
    [musicV removeFromSuperview];
//    [lrcTimer invalidate];
//    lrcTimer = nil;
}

-(void)showmoreviews{
    //添加的镜像，闪光灯。。。
    __weak Livebroadcast *weakself = self;
    if (!bottombtnV) {
        bottombtnV = [[bottombuttonv alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) music:^(NSString *type) {
            [weakself justplaymusic];//播放音乐
        } meiyan:^(NSString *type) {
            if (![[common getIsTXfiter]isEqual:@"1"]) {
                [weakself initTiFaceUI];//萌颜
            }else{
                if ([_sdkType isEqual:@"1"]) {
                    [weakself userTXBase];
                }else{
                    [weakself OnChoseFilter:nil];//美颜
                }
            }

        } coast:^(NSString *type) {
            [weakself doShareViewShow];//分享
        } light:^(NSString *type) {
            [weakself toggleTorch];//闪光灯
//            [weakself showBGMView];

        } camera:^(NSString *type) {
            [weakself rotateCamera];//切换摄像头
        } game:^(NSString *type) {
            if (isLianmai) {
                [MBProgressHUD showError:YZMsg(@"连麦状态下不能进行游戏哦～")];
                return;
            }

            [weakself startgamepagev];//选择游戏
        } jingpai:^(NSString *type) {
            //开始竞拍
            
        } hongbao:^(NSString *type) {
            //红包
            [weakself showRedView];
        } lianmai:^(NSString *type) {
            
            if (zhuangVC || shell || gameVC || rotationV) {
                [MBProgressHUD showError:@"游戏状态下不能进行连麦哦～"];
                return;
            }
            //连麦
            if (isLianmai) {
                [MBProgressHUD showError:YZMsg(@"当前正在进行连麦～")];
                return;
            }

            [weakself showAnchorView];
        } showjingpai:@"0" showgame:_game_switch showcoase:_type hideself:^(NSString *type) {
            [UIView animateWithDuration:0.4 animations:^{
                bottombtnV.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [moreBTN setBackgroundImage:[UIImage imageNamed:@"功能"] forState:UIControlStateNormal];
                [bottombtnV removeFromSuperview];
                bottombtnV = nil;
            });
        } andIsTorch:isTorch];
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:bottombtnV];
        bottombtnV.hidden = YES;
        [moreBTN setBackgroundImage:[UIImage imageNamed:@"功能_S"] forState:UIControlStateNormal];
    }
}
-(void)toggleTorch{
    if ([_gpuStreamer.vCapDev isTorchSupported] && ![_sdkType isEqual:@"1"]) {
        [_gpuStreamer toggleTorch];
        isTorch = !isTorch;
    }
    if (_txLivePublisher && [_sdkType isEqual:@"1"]) {
        isTorch = !isTorch;
        if (![_txLivePublisher toggleTorch:isTorch]) {
            isTorch = !isTorch;
        }
    }
}
-(void)rotateCamera{
    if ([_sdkType isEqual:@"1"]) {
        [_txLivePublisher switchCamera];
        NSLog(@"_txLivePublisher.config.frontCamera=====%d",_txLivePublisher.config.frontCamera);
        [_txLivePublisher setMirror:_txLivePublisher.config.frontCamera];
    }else{
        [_gpuStreamer.vCapDev rotateCamera];
    }
//    [self.videoCamera rotateCamera];
}
-(void)justplaymusic{
    musicView *music = [[musicView alloc]init];
    music.modalPresentationStyle = UIModalPresentationFullScreen;
    self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:music];
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 1;
    self.animator.behindViewScale = 0.5f;
    self.animator.transitionDuration = 0.4f;
    music.transitioningDelegate = self.animator;
    self.animator.dragable = YES;
    self.animator.direction = ZFModalTransitonDirectionRight;
    [self presentViewController:music animated:YES completion:nil];
}
-(void)showmoreview{
    
    if (!bottombtnV) {
        [self showmoreviews];
    }
    
    if (bottombtnV.hidden == YES) {
        bottombtnV.hidden = NO;
        [UIView animateWithDuration:0.4 animations:^{
            bottombtnV.frame = CGRectMake(0,0, _window_width, _window_height);
        }];
        
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            bottombtnV.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bottombtnV.hidden = YES;
        });
    }
}
-(void)donghua:(UILabel *)labels{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.8;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(4.0, 4.0, 4.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(3.0, 3.0, 3.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 2.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    animation.values = values;
    animation.removedOnCompletion = NO;//是不是移除动画的效果
    animation.fillMode = kCAFillModeForwards;//保持最新状态
    [labels.layer addAnimation:animation forKey:nil];
}
#pragma mark ---- 私信方法
-(void)nsnotifition{
    //注册进入后台的处理
    NSNotificationCenter* notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self
           selector:@selector(appactive)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    [notification addObserver:self
           selector:@selector(appnoactive)
               name:UIApplicationWillResignActiveNotification
             object:nil];

    [notification addObserver:self selector:@selector(changeMusic:) name:@"wangminxindemusicplay" object:nil];
    [notification addObserver:self selector:@selector(shajincheng) name:@"shajincheng" object:nil];
    //@"shajincheng"
    [notification addObserver:self selector:@selector(forsixin:) name:@"sixinok" object:nil];
    [notification addObserver:self selector:@selector(getweidulabel) name:@"gengxinweidu" object:nil];
    [notification addObserver:self selector:@selector(toolbarHidden) name:@"toolbarHidden" object:nil];
    [notification addObserver:self selector:@selector(onAudioStateChange:)name:KSYAudioStateDidChangeNotification object:nil];

}
//更新未读消息
-(void)getweidulabel{
    [self labeiHid];
}

-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    [self labeiHid];
}
-(void)labeiHid{
    
    dispatch_queue_t queue = dispatch_queue_create("GetIMMessage", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        self.unRead = [minstr([JMSGConversation getAllUnreadCount]) intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.unReadLabel.text = [NSString stringWithFormat:@"%d",self.unRead];
            if ([self.unReadLabel.text isEqual:@"0"] || self.unRead == 0) {
                self.unReadLabel.hidden =YES;
            }else {
                self.unReadLabel.hidden = NO;
            }
        });
    });
}
//跳往消息列表
-(void)doMessage{
    [self hideBTN];
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    [huanxinviews.view removeFromSuperview];
    huanxinviews = nil;
    huanxinviews.view = nil;
    if (!huanxinviews) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(0, 0, _window_width, _window_height*0.6);
        [btn addTarget:self action:@selector(hideSixin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        huanxinviews = [[huanxinsixinview alloc]init];
        huanxinviews.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
        huanxinviews.zhuboID = @"";
        [huanxinviews forMessage];
        [self.view insertSubview:huanxinviews.view atIndex:9];

    }
    [UIView animateWithDuration:0.2 animations:^{
        huanxinviews.view.frame = CGRectMake(0, _window_height - _window_height*0.4,_window_width, _window_height*0.4);
    }];
}
//点击用户聊天
-(void)forsixin:(NSNotification *)ns{
    
    NSMutableDictionary *dic = [[ns userInfo] mutableCopy];
    if (sysView.view) {
        [sysView.view removeFromSuperview];
        sysView = nil;
        sysView.view = nil;
        
    }
    __weak Livebroadcast *wSelf = self;

    if ([[dic valueForKey:@"id"] isEqual:@"1"]) {
        if (liansongliwubottomview) {
            [self.view insertSubview:liansongliwubottomview belowSubview:frontView];
        }

        sysView = [[MsgSysVC alloc]init];
        sysView.view.frame = CGRectMake(_window_width, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
        sysView.block = ^(int type) {
            if (type == 0) {
                [wSelf hideSysTemView];
            }
        };
        [sysView reloadSystemView];
        
        [self.view insertSubview:sysView.view atIndex:10];
        [UIView animateWithDuration:0.5 animations:^{
            sysView.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
        }];
        return;
    }

    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;

    if (!chatsmall) {
        chatsmall = [[JCHATConversationViewController alloc]init];

        [dic setObject:minstr([dic valueForKey:@"name"]) forKey:@"user_nicename"];
        MessageListModel *model = [[MessageListModel alloc]initWithDic:dic];
        chatsmall.userModel = model;
        chatsmall.conversation = [dic valueForKey:@"conversation"];
        chatsmall.view.frame = CGRectMake(_window_width, _window_height*0.6, _window_width, _window_height*0.4);
        chatsmall.block = ^(int type) {
            if (type == 0) {
                [wSelf hideChatMall];
            }
        };
        [chatsmall reloadSamllChtaView:@"0"];
        [self.view insertSubview:chatsmall.view atIndex:10];
    }
    chatsmall.view.hidden = NO;
//    NSDictionary *dic = [ns userInfo];
    [UIView animateWithDuration:0.5 animations:^{
        chatsmall.view.frame = CGRectMake(0, _window_height*0.6, _window_width, _window_height*0.4);
    }];
//    chatsmall.icon = [dic valueForKey:@"avatar"];
//    chatsmall.chatID = [dic valueForKey:@"id"];
//    chatsmall.chatname = [dic valueForKey:@"name"];
//    chatsmall.msgConversation = [dic valueForKey:@"Conversation"];
//    [chatsmall changename];
//    [chatsmall formessage];
}
- (void)hideSysTemView{
    [sysView.view removeFromSuperview];
    sysView = nil;
    sysView.view = nil;
    
}

-(void)siXin:(NSString *)icon andName:(NSString *)name andID:(NSString *)ID andIsatt:(NSString *)isatt{
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    [huanxinviews.view removeFromSuperview];
    huanxinviews = nil;
    huanxinviews.view = nil;
    __weak Livebroadcast *wSelf = self;

    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,ID] completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [self doCancle];
            if (!chatsmall) {
                chatsmall = [[JCHATConversationViewController alloc]init];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:minstr(icon) forKey:@"avatar"];
                [dic setObject:minstr(ID) forKey:@"id"];
                [dic setObject:minstr(name) forKey:@"user_nicename"];
                [dic setObject:minstr(name) forKey:@"name"];
                [dic setObject:resultObject forKey:@"conversation"];
                [dic setObject:isatt forKey:@"utot"];
                MessageListModel *model = [[MessageListModel alloc]initWithDic:dic];
                chatsmall.userModel = model;
                chatsmall.conversation = resultObject;
                chatsmall.view.frame = CGRectMake(_window_width, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
                chatsmall.block = ^(int type) {
                    if (type == 0) {
                        [wSelf hideChatMall];
                    }
                };
                [self.view insertSubview:chatsmall.view atIndex:10];
                if ([userView.forceBtn.titleLabel.text isEqual:YZMsg(@"已关注")]) {
                    [chatsmall reloadSamllChtaView:@"1"];
                }
                else{
                    [chatsmall reloadSamllChtaView:@"0"];
                }
                chatsmall.view.hidden =YES;
            }
            chatsmall.view.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                chatsmall.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
            }];
//            chatsmall.msgConversation = resultObject;
//            chatsmall.chatID = ID;
//            chatsmall.icon = icon;
//            chatsmall.chatname = name;
//             [chatsmall changename];
//            [chatsmall formessage];
        }
        else{
           [MBProgressHUD showError:error.localizedDescription];
        }
    }];
}
- (void)hideChatMall{
    if (huanxinviews) {
        [huanxinviews forMessage];
        CATransition *transition = [CATransition animation];    //创建动画效果类
        transition.duration = 0.3; //设置动画时长
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
        transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};设置动画类型，移入，推出等
        //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
        transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
        [chatsmall.view.layer addAnimation:transition forKey:nil];       //在图层增加动画效果
        [chatsmall.view removeFromSuperview];
        chatsmall.view = nil;
        chatsmall = nil;
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            chatsmall.view.frame = CGRectMake(_window_width, _window_height*0.6, _window_width, _window_height*0.4);
        } completion:^(BOOL finished) {
            [chatsmall.view removeFromSuperview];
            chatsmall.view = nil;
            chatsmall = nil;
        }];
    }
}

-(void)doUpMessageGuanZhu{
    if ([userView.forceBtn.titleLabel.text isEqual:YZMsg(@"已关注")]) {
        [userView.forceBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:UIColorFromRGB(0xff9216) forState:UIControlStateNormal];
    }
    else{
        [userView.forceBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        userView.forceBtn.enabled = NO;
    }
}
-(void)pushZhuYe:(NSString *)IDS{
    [self doCancle];
    otherUserMsgVC  *person = [[otherUserMsgVC alloc]init];
    person.userID = IDS;
    [self.navigationController pushViewController:person animated:YES];
}
-(void)doupCancle{
   [self doCancle];
}
//键盘弹出隐藏下面四个按钮
-(void)hideBTN{
    closeLiveBtn.hidden = YES;
    keyBTN.hidden = YES;
    messageBTN.hidden = YES;
    moreBTN.hidden = YES;
    bottombtnV.hidden = YES;
    linkSwitchBtn.hidden = YES;

}
-(void)showBTN{
    closeLiveBtn.hidden = NO;
    keyBTN.hidden = NO;
    messageBTN.hidden = NO;
    moreBTN.hidden = NO;
    linkSwitchBtn.hidden = NO;
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //防止填写竞拍信息的时候弹出私信
    startPKBtn.hidden = YES;
    if (!ismessgaeshow) {
        
        return;
    }
    if (startKeyboard == 1) {
        return;
    }
    if (gameVC) {
        gameVC.hidden = YES;
    }
    if (shell) {
        shell.hidden = YES;
    }
    if (rotationV) {
        rotationV.hidden = YES;
    }
    [self hideBTN];
    [self doCancle];
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    [UIView animateWithDuration:0.3 animations:^{
        toolBar.frame = CGRectMake(0,height-44,_window_width,44);
        frontView.frame = CGRectMake(0,-height, _window_width, _window_height);
        [self tableviewheight:_window_height - _window_height*0.2 - keyboardRect.size.height - 40];
        [self.view bringSubviewToFront:toolBar];
        [self.view bringSubviewToFront:self.tableView];
        [self changecontinuegiftframe];
        if (zhuangVC) {
            zhuangVC.frame =  CGRectMake(10,20, _window_width/4, _window_width/4 + 20 + _window_width/8);
        }
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    startPKBtn.hidden = NO;

    ismessgaeshow = NO;
    [self showBTN];
    if (gameVC) {
        gameVC.hidden = NO;
    }
    if (shell) {
        shell.hidden = NO;
    }
    if (rotationV) {
        rotationV.hidden = NO;
    }

    [UIView animateWithDuration:0.1 animations:^{
        toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
        if (gameVC || shell) {
            [self tableviewheight:_window_height - _window_height*0.2 - 240-www];

        }else if (rotationV){
            [self tableviewheight:_window_height - _window_height*0.2 - _window_width/1.8 - www];
        }
        else{
            [self tableviewheight:_window_height - _window_height*0.2 - 50 - ShowDiff];
        }
        
        frontView.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self changecontinuegiftframe];
        if (zhuangVC) {
            zhuangVC.frame =  CGRectMake(10,90, _window_width/4, _window_width/4 + 20 + _window_width/8);
        }
    }];
}
-(void)adminZhezhao{
    zhezhaoList.view.hidden = YES;
    self.tableView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        adminlist.view.frame = CGRectMake(0,_window_height*2, _window_width, _window_height*0.3);
    }];
}
//管理员列表
-(void)adminList{
    if (!adminlist) {
        //管理员列表
        zhezhaoList  = [[UIViewController alloc]init];
        zhezhaoList.view.frame = CGRectMake(0, 0, _window_width, _window_height);
        [self.view addSubview:zhezhaoList.view];
        zhezhaoList.view.hidden = YES;
        adminlist = [[adminLists alloc]init];
        adminlist.delegate = self;
        adminlist.view.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
        [self.view addSubview:adminlist.view];
        UITapGestureRecognizer *tapAdmin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adminZhezhao)];
        [zhezhaoList.view addGestureRecognizer:tapAdmin];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"adminlist" object:nil];
    [self doCancle];
    self.tableView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        zhezhaoList.view.hidden = NO;
        adminlist.view.frame = CGRectMake(0,0, _window_width, _window_height);
    }];
}
-(void)setAdminSuccess:(NSString *)isadmin andName:(NSString *)name andID:(NSString *)ID{
//    NSString *cts;
//    if ([isadmin isEqual:@"0"]) {
//        //不是管理员
//         cts = @"被取消管理员";
//        [MBProgressHUD showError:YZMsg(@"取消管理员成功")];
//    }else{
//        //是管理员
//          cts = @"被设为管理员";
//        [MBProgressHUD showError:@"设置管理员成功"];
//    }
     [socketL setAdminID:ID andName:name andCt:isadmin];
}
//弹窗退出
-(void)doCancle{
    userView.forceBtn.enabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,_window_height*2,upViewW, upViewW*4/3);
    }];
    self.tableView.userInteractionEnabled = YES;
}
-(void)superStopRoom:(NSString *)state{
    [self hostStopRoom];
}
//发送消息
-(void)sendBarrage
{
    /*******发送弹幕开始 **********/
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.sendBarrage"];
    NSDictionary *subdic = @{
                             @"liveuid":[Config getOwnID],
                             @"stream":urlStrtimestring,
                             @"giftid":@"1",
                             @"giftcount":@"1",
                             @"content":keyField.text
                             };
    [YBToolClass postNetworkWithUrl:@"Live.sendBarrage" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSString *barragetoken = [[info firstObject] valueForKey:@"barragetoken"];
            //刷新本地魅力值
            LiveUser *liveUser = [Config myProfile];
            liveUser.coin = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"coin"]];
            [Config updateProfile:liveUser];
            [socketL sendBarrage:barragetoken];
            if (gameVC) {
                [gameVC reloadcoins];
            }
            if (shell) {
                [shell reloadcoins];
            }
            if (rotationV) {
                [rotationV reloadcoins];
            }

        }
    } fail:^{
        
    }];
    
    /*********************发送礼物结束 ************************/
}
-(void)pushMessage:(UITextField *)sender{
    if (keyField.text.length >50) {
        [MBProgressHUD showError:YZMsg(@"字数最多50字")];
        return;
    }
    pushBTN.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pushBTN.enabled = YES;
    });
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [keyField.text stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        
        return ;
    }
    if(cs.state == YES)//发送弹幕
    {
        
        if (keyField.text.length <=0) {
            return;
        }
        [self sendBarrage];
        keyField.text = @"";
        pushBTN.selected = NO;
        return;
    }
    [socketL sendMessage:keyField.text];
    keyField.text = @"";
    pushBTN.selected = NO;
}
//聊天输入框
-(void)showkeyboard:(UIButton *)sender{
    if (chatsmall) {
        chatsmall.view.hidden = YES;
        [chatsmall.view removeFromSuperview];
        chatsmall.view = nil;
        chatsmall = nil;
    }
    ismessgaeshow = YES;
    [keyField becomeFirstResponder];
    
}
// 以下是 tableview的方法
///*******    连麦 注意下面的tableview方法    *******/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.chatModels.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    chatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"chatMsgCell" owner:nil options:nil] lastObject];
    }
    cell.model = self.chatModels[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    chatModel *model = self.chatModels[indexPath.section];
    [keyField resignFirstResponder];
    if ([model.userName isEqual:YZMsg(@"直播间消息")]) {
        return;
    }
    NSString *IsUser = [NSString stringWithFormat:@"%@",model.userID];
    if (IsUser.length > 1) {
        NSDictionary *subdic = @{@"id":model.userID,
                                 @"name":model.userName
                                 };
            [self GetInformessage:subdic];
    }
}
//请求直播
-(void)getStartShow
{
    _hostURL = minstr([_roomDic valueForKey:@"push"]);
    urlStrtimestring = [_roomDic valueForKey:@"stream"];
    _socketUrl = [_roomDic valueForKey:@"chatserver"];
    _danmuPrice = [_roomDic valueForKey:@"barrage_fee"];
    if (![jackpot_level isEqual:@"-1"]) {
        [self JackpotLevelUp:@{@"uplevel":jackpot_level}];
    }

    [self onStream:nil];
    _voteNums = [NSString stringWithFormat:@"%@",[_roomDic valueForKey:@"votestotal"]];
    [self changeState];
    [self changeGuardNum:minstr([_roomDic valueForKey:@"guard_nums"])];
    socketL = [[socketLive alloc]init];
    socketL.delegate = self;
    socketL.zhuboDic = _roomDic;
    [socketL getshut_time:_shut_time];//获取禁言时间
    [socketL addNodeListen:_socketUrl andTimeString:urlStrtimestring];
    userlist_time = [[_roomDic valueForKey:@"userlist_time"] intValue];
    if (!listTimer) {
        listTimer = [NSTimer scheduledTimerWithTimeInterval:userlist_time target:self selector:@selector(reloadUserList) userInfo:nil repeats:YES];
    }
    if (!hartTimer) {
        hartTimer = [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(socketLight) userInfo:nil repeats:YES];
    }

    if ([_sdkType isEqual:@"1"]) {
        [self txStartRtmp];
    }
}
//********************************炸金花*******************************************************************//
-(void)startgamepagev{
    [UIView animateWithDuration:0.4 animations:^{
        bottombtnV.frame = CGRectMake(0, _window_height*2, _window_width, _window_height);
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        bottombtnV.hidden = YES;
    });
    self.tableView.hidden = YES;
    if (!gameselectedVC) {
        gameselectedVC = [[gameselected alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) andArray:_game_switch];
        gameselectedVC.delegate = self;
        [self.view insertSubview:gameselectedVC atIndex:10];
    }
    gameselectedVC.hidden = NO;
    
}
-(void)reloadcoinsdelegate{
    if (gameVC) {
        [gameVC reloadcoins];
    }
}
//更换庄家信息
-(void)changebank:(NSDictionary *)subdic{
    [zhuangVC getNewZhuang:subdic];
}
-(void)changebankall:(NSDictionary *)subdic{
      [socketL getzhuangjianewmessagem:subdic];
      [zhuangVC getNewZhuang:subdic];
}
-(void)getzhuangjianewmessagedelegate:(NSDictionary *)subdic{
    [zhuangVC getNewZhuang:subdic];
}
-(void)gameselect:(int)action{
    //1炸金花  2海盗  3转盘  4牛牛  5二八贝
    self.tableView.hidden = NO;
    switch (action) {
        case 1:
            _method = @"startGame";
            _msgtype = @"15";
            [self startGame];
            break;
        case 2:
            _method = @"startLodumaniGame";
            _msgtype = @"18";
            [self startGame];
            break;
        case 3:
             [self getRotation];
            break;
        case 4:
            _method = @"startCattleGame";
            _msgtype = @"17";
            [self startGame];
            break;
        case 5:
            _method = @"startShellGame";
            _msgtype = @"19";
            [self startsheelGame];
            break;
            
        default:
            break;
    }
    gameselectedVC.hidden = YES;
}
-(void)hideself{

    self.tableView.hidden = NO;
    gameselectedVC.hidden = YES;
}
//********************************转盘*******************************************************************//
-(void)stopRotationgameBySelf{
    [rotationV stopRotatipnGameInt];
     [rotationV stoplasttimer];
    [socketL stopRotationGame];//关闭游戏socket
    [rotationV removeFromSuperview];
    [rotationV removeall];
    rotationV = nil;
    [gameState saveProfile:@"0"];
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight: _window_height - _window_height*0.2 - 50 - ShowDiff];
}
-(void)getRotation{
  
    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
        [gameState saveProfile:@"0"];
    }
    rotationV = [WPFRotateView rotateView];
    [rotationV setlayoutview];
    [rotationV isHost:YES andHostDic:[_roomDic valueForKey:@"stream"]];
    [rotationV hostgetstart];
    rotationV.delegate = self;
    rotationV.frame = CGRectMake(0, _window_height - _window_width/1.8, _window_width, _window_width);
    [self.view insertSubview:rotationV atIndex:6];
    [self changeBtnFrame:_window_height - _window_width/1.8 - www];
    [self tableviewheight: _window_height - _window_height*0.2 - _window_width/1.8 - www];
    [socketL prepRotationGame];
    [self changecontinuegiftframe];
}
//改变tableview高度
-(void)tableviewheight:(CGFloat)h{
    self.tableView.frame = CGRectMake(10,h,tableWidth,_window_height*0.2);
    useraimation.frame = CGRectMake(10,self.tableView.top - 40,_window_width,20);
}
//改变连送礼物的frame
-(void)changecontinuegiftframe{
    liansongliwubottomview.frame = CGRectMake(0, self.tableView.top - 150,_window_width/2,140);
    if (zhuangVC) {
        liansongliwubottomview.frame = CGRectMake(0,self.tableView.top,_window_width/2,140);
    }
}
//更新押注数量
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money{
    [rotationV getRotationCoinType:type andMoney:money];
}
-(void)getRotationResult:(NSArray *)array{
    [rotationV getRotationResult:array];
}
//开始倒计时
-(void)startRotationGameSocketToken:(NSString *)token andGameID:(NSString *)ID andTime:(NSString *)time{
    [socketL RotatuonGame:ID andTime:time androtationtoken:token];
}
-(void)changeBtnFrame:(CGFloat)bottombtnH{
    //bottombtnH = bottombtnH-ShowDiff;
    if(bottombtnH == _window_height - 45){
        bottombtnH = bottombtnH-ShowDiff;
    }
    keyBTN.frame = CGRectMake(10, bottombtnH, www, www);
    closeLiveBtn.frame = CGRectMake(_window_width - www- 10,bottombtnH, www, www);
    moreBTN.frame = CGRectMake(_window_width - www*3-30,bottombtnH, www, www);
    messageBTN.frame = CGRectMake(_window_width - www*2 - 20,bottombtnH, www, www);
    startPKBtn.frame = CGRectMake(_window_width - www*5-40 - 20,bottombtnH, www*2, www);

    linkSwitchBtn.frame = CGRectMake(_window_width - www*1.5-10,bottombtnH-10-www*1.5, www*1.5, www*1.5);

    [frontView insertSubview:keyBTN atIndex:6];
    [frontView insertSubview:closeLiveBtn atIndex:6];
    [frontView insertSubview:messageBTN atIndex:6];
    [frontView insertSubview:moreBTN atIndex:6];
    [frontView insertSubview:linkSwitchBtn atIndex:6];
//    [frontView insertSubview:startPKBtn atIndex:6];

    [self showBTN];
    
}
//二八贝游戏********************************************************************************************
-(void)startsheelGame{

    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
        [gameState saveProfile:@"0"];
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell gameOver];
        [shell removeFromSuperview];
        shell = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
        [gameState saveProfile:@"0"];//保存游戏开始状态
    }

    if (!shell) {
        shell = [[shellGame alloc]initWIthDic:_roomDic andIsHost:YES andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
        shell.delagate = self;
        [self.view insertSubview:shell atIndex:5];
        [socketL prepGameandMethod:_method andMsgtype:_msgtype];
        shell.frame = CGRectMake(0, _window_height - 260, _window_width,260);
        [self changeBtnFrame:_window_height - 260-www];
        [self tableviewheight:_window_height - _window_height*0.2 - 260-www];
        [self changecontinuegiftframe];
    }
}
//二八贝更新押注数量
-(void)getShellCoin:(NSString *)type andMoney:(NSString *)money{
    [shell getShellCoin:type andMoney:money];
}
-(void)getShellResult:(NSArray *)array{
    [shell getShellResult:array];
}
//二八贝游戏********************************************************************************************
//********************************转盘*******************************************************************//
//********************************炸金花   牛仔*******************************************************************//
-(void)startGame{
 
    NSString *games = [NSString stringWithFormat:@"%@",[gameState getGameState]];
    if ([games isEqual:@"1"] ) {
        [MBProgressHUD showError:YZMsg(@"请等待游戏结束")];
        return;
    }
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [socketL stopRotationGame];//关闭游戏socket
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell gameOver];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC stopGame];
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    
    
    [gameState saveProfile:@"0"];//保存游戏开始状态
    
    
    //出现游戏界面
    gameVC = [[gameBottomVC alloc]initWIthDic:_roomDic andIsHost:YES andMethod:_method andMsgtype:_msgtype];
    [socketL prepGameandMethod:_method andMsgtype:_msgtype];
    //判断开始哪个游戏
    gameVC.delagate = self;
    gameVC.frame = CGRectMake(0, _window_height - 230, _window_width,230);
    [self.view insertSubview:gameVC atIndex:5];
    [self changeBtnFrame:_window_height - 230-www];
    [self tableviewheight:_window_height - _window_height*0.2 -230-www];
    [self changecontinuegiftframe];
    if ([_method isEqual:@"startCattleGame"]) {
        //上庄玩法
        zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:YES withstreame:[_roomDic valueForKey:@"stream"]];
        zhuangVC.deleagte = self;
        [self.view insertSubview:zhuangVC atIndex:6];
        [zhuangVC addPoker];
        [zhuangVC addtableview];
        [zhuangVC getbanksCoin:_zhuangDic];
        [self changecontinuegiftframe];
    }
}
//主播广播准备开始游戏
-(void)prepGame:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist{
    [socketL takePoker:gameid ndMethod:method andMsgtype:msgtype andBanklist:banklist];
}
//游戏开始，开始倒数计时
-(void)startGameSocketToken:(NSString *)token andGameID:(NSString *)ID andTime:(NSString *)time ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketL zhaJinHua:ID andTime:time andJinhuatoken:token ndMethod:method andMsgtype:msgtype];
}
-(void)skate:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketL stakePoke:type andMoney:money andMethod:method andMsgtype:msgtype];
}
-(void)getCoin:(NSString *)type andMoney:(NSString *)money{
    [gameVC getCoinType:type andMoney:money];
}
//得到游戏结果
-(void)getResult:(NSArray *)array{
    [gameVC getResult:array];
    if (zhuangVC) {
        [zhuangVC getresult:array];
    }
}
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketL stopGamendMethod:method andMsgtype:msgtype];
 
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (shell) {
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight:_window_height - _window_height*0.2 - 50 - ShowDiff];
    [self changecontinuegiftframe];
}
-(void)pushCoinV{
    CoinVeiw *coin = [[CoinVeiw alloc] init];
    [self presentViewController:coin animated:YES completion:nil];
}
//********************************转盘*******************************************************************//
-(void)reloadUserList{
    if (listView) {
    [listView listReloadNoew];
    }
}
- (void)loginOnOtherDevice{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:YZMsg(@"当前账号已在其他设备登录") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self hostStopRoom];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//请求关闭直播
-(void)getCloseShow
{
    [self musicPlay];
    [socketL closeRoom];//发送关闭直播的socket
    NSString *url = [NSString stringWithFormat:@"Live.stopRoom&uid=%@&token=%@&stream=%@",[Config getOwnID],[Config getOwnToken],urlStrtimestring];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];

        [self dismissVC];
        [self liveOver];//停止计时器
        [socketL colseSocket];//注销socket
        socketL = nil;//注销socket
        //直播结束
        [self onQuit:nil];//停止音乐、停止推流
        [self rmObservers];//释放通知
        //            [self.navigationController popViewControllerAnimated:YES];
        [self requestLiveAllTimeandVotes];
    } fail:^{
        [MBProgressHUD hideHUD];
        [self dismissVC];
        [self liveOver];//停止计时器
        [socketL colseSocket];//注销socket
        socketL = nil;//注销socket
        //直播结束
        [self onQuit:nil];//停止音乐、停止推流
        [self rmObservers];//释放通知
        //        [self.navigationController popViewControllerAnimated:YES];
        [self requestLiveAllTimeandVotes];

    }];
    
}
//礼物效果
/************ 礼物弹出及队列显示开始 *************/
//红包
-(void)redbag{
    
}
-(void)expensiveGiftdelegate:(NSDictionary *)giftData{
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
        [self.view insertSubview:haohualiwuV atIndex:8];
    }
    if (giftData == nil) {
        
        
        
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive];
    }
}
-(void)expensiveGift:(NSDictionary *)giftData{
    
    
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
        [self.view insertSubview:haohualiwuV atIndex:8];
    }
    if (giftData == nil) {
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive];
    }
}
/*
 *添加魅力值数
 */
-(void)addCoin:(long)coin
{
    long long ordDate = [_voteNums longLongValue];
    long long newDate = ordDate + coin;
    _voteNums = [NSString stringWithFormat:@"%lld",newDate];
    [self changeState];
}
-(void)addvotesdelegate:(NSString *)votes{
    [self addCoin:[votes longLongValue]];
}
-(void)switchState:(BOOL)state
{
    NSLog(@"%d",state);
    if(!state)
    {
        keyField.placeholder = YZMsg(@"和大家说些什么");
    }
    else
    {
        keyField.placeholder = [NSString stringWithFormat:@"%@，%@%@/%@",YZMsg(@"开启大喇叭"),_danmuPrice,[common name_coin],YZMsg(@"条")];
    }
}
- (BOOL)shouldAutorotate {
    return YES;
}
/*************** 以上视频播放 ***************/
/*
//加载拍照,视频录制摄像头工具类
- (GPUImageStillCamera *)videoCamera {
    if (!_videoCamera) {
        _videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280X720
                                                           cameraPosition:AVCaptureDevicePositionFront];
        _videoCamera.frameRate = 25;
        _videoCamera.outputImageOrientation = (UIInterfaceOrientation)UIDeviceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;   //unmirrored
        
        [_videoCamera addAudioInputsAndOutputs];
        
        _videoCamera.delegate = self;
        
        [_videoCamera startCameraCapture];
        
        [self.gpuPreviewView setHidden:NO];
        
        [_videoCamera addTarget:self.gpuPreviewView];
        
    }
    return _videoCamera;
}
- (GPUImageView *)gpuPreviewView {
    if (!_gpuPreviewView) {
        _gpuPreviewView = [[GPUImageView alloc] initWithFrame:self.view.frame];
        _gpuPreviewView.fillMode = kGPUImageFillModeStretch;
        _gpuPreviewView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _gpuPreviewView;
}

- (void)initGpuPreviewStreamr{
    [self initCamera];
    //采集相关设置初始化
    [self setCaptureCfg];
    NSLog(@"ksy版本号---------%@",[_gpuStreamer getKSYVersion]);
    [self addObservers];
    
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    self.videoCamera = self.videoCamera;

    NSString* license = @"f9b7b0e82f1a4160b29247c98c79d7b1";
    [TiSDK init:license];
    self.tiSDKManager = [[TiSDKManager alloc]init];
    [self.tiSDKManager destroy];
    self.tiSDKManager = nil;
    self.tiSDKManager = [[TiSDKManager alloc]init];
    self.tiUIView = [[TiUIView alloc]initTiUIViewWith:self.tiSDKManager delegate:self superView:self.view];
    self.tiUIView.isClearOldUI = NO;
    [_gpuStreamer startAudioCap];

    
}
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    TiRotationEnum rotation = CLOCKWISE_0;
    // 视频帧格式
    TiImageFormatEnum format = BGRA;
    int imageWidth, imageHeight;
    imageWidth = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
    imageHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    /////////////////// TiFaceSDK 添加 开始 ///////////////////
    [self.tiSDKManager renderPixels:baseAddress Format:format Width:imageWidth Height:imageHeight Rotation:rotation Mirror:NO];
    /////////////////// TiFaceSDK 添加 结束 ///////////////////
    
    self.outputWidth = CVPixelBufferGetWidth(pixelBuffer);
    self.outputheight = CVPixelBufferGetHeight(pixelBuffer);

    
    //推流
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    unsigned char *bytes = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);

    NSDictionary* pixelBufferOptions = @{
                                         (NSString*) kCVPixelBufferWidthKey : @(self.outputheight),
                                         (NSString*) kCVPixelBufferHeightKey : @(self.outputWidth),
                                         (NSString*) kCVPixelBufferOpenGLESCompatibilityKey : @YES,
                                         (NSString*) kCVPixelBufferIOSurfacePropertiesKey : @{}};
    CVPixelBufferRef streamerBuffer = NULL;
    CVReturn ret = CVPixelBufferCreate(NULL, self.outputWidth, self.outputheight, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)pixelBufferOptions, &streamerBuffer);
    if (ret!= noErr) {
        NSLog(@"创建streamer buffer失败");
        streamerBuffer = NULL;
        return;
    }
    
    int length = (int)self.outputheight * (int)self.outputWidth *4;
    
    CVPixelBufferLockBaseAddress(streamerBuffer, 0);
    unsigned char *streamerBytes = (unsigned char *)CVPixelBufferGetBaseAddress(streamerBuffer);
    memcpy(streamerBytes, bytes, length);
    
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

    if (_gpuStreamer) {
        [_gpuStreamer.capToGpu processPixelBuffer:streamerBuffer time:pts];
        _gpuStreamer.capToGpu.outputRotation = kGPUImageRotateRight;

    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CVPixelBufferUnlockBaseAddress(streamerBuffer, 0);
    
    CFRelease(streamerBuffer);
}
 */
/***************************** TiSDK 添加结束 *****************************/



/*
#pragma mark - 初始化相机
- (void)initCamera{
    
    self.videoCamera.delegate = self;
    
    [self.view addSubview:self.gpuPreviewView];
}
*/
/*==================  连麦  ================*/
-(void)setBgAndPreview {
    pushbottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    pushbottomV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:pushbottomV];
    
    pkBackImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,_window_width,_window_height)];
    pkBackImgView.image = [UIImage imageNamed:@"pk背景"];
    pkBackImgView.userInteractionEnabled = YES;
    pkBackImgView.hidden = YES;
    [pushbottomV addSubview:pkBackImgView];
    
    _pushPreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    _pushPreview.backgroundColor = [UIColor clearColor];
    [pushbottomV addSubview:_pushPreview];
}
-(void)initPushStreamer {
    
    [self setBgAndPreview];
    
    _gpuStreamer = [[KSYGPUStreamerKit alloc]initWithDefaultCfg];
    [_gpuStreamer.preview setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
    _gpuStreamer.aCapDev.micVolume = 1.0;
    
    [_gpuStreamer startPreview:_pushPreview];

    if ([[common getIsTXfiter]isEqual:@"1"]) {
        _filter = [[KSYGPUBeautifyExtFilter alloc] init];
        [_gpuStreamer setupFilter: _filter];
        [(KSYGPUBeautifyExtFilter *)_filter setBeautylevel:4];//level 1.0 ~ 5.0
    }else{
        
        
        self.tiSDKManager = [[TiSDKManager alloc]init];
        self.tiUIView = [[TiUIView alloc]initTiUIViewWith:self.tiSDKManager delegate:self superView:self.view];
        self.tiUIView.isClearOldUI = NO;

        //--------TiFaceSDK--------------------------
        /*
        __weak Livebroadcast *weakSelf = self;
        _gpuStreamer.videoProcessingCallback = ^(CMSampleBufferRef sampleBuffer) {

            if (!weakSelf.tiSDKManager || !sampleBuffer) {
                return ;
            }
            CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
            BOOL isMirror = NO;
            CVPixelBufferLockBaseAddress(pixelBuffer, 0);
            unsigned char *baseAddress = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
            int iWidth = (int)CVPixelBufferGetBytesPerRow(pixelBuffer) / 4;
            int iHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
            /////////////////// TiFaceSDK 添加 开始 ///////////////////
            if (weakSelf.tiSDKManager != nil) {
                if (weakSelf.isRedayCloseRoom) {
                    return;
                }
                [weakSelf.tiSDKManager renderPixels:baseAddress Format:BGRA Width:iWidth Height:iHeight Rotation:CLOCKWISE_0 Mirror:isMirror];
            }
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        };
        */
        KSYStreamerTiFilter *tiSDKFilter = [[KSYStreamerTiFilter alloc] initTiSDK:_tiSDKManager];
        [_gpuStreamer setupFilter:tiSDKFilter];
        
    }
    
    //采集相关设置初始化
    [self setCaptureCfg];
    NSLog(@"ksy版本号---------%@",[_gpuStreamer getKSYVersion]);
    [self addObservers];
    //启动金山音频视频采集
//    [_gpuStreamer startVideoCap];
    [_gpuStreamer startAudioCap];

}
//设置videoview拖拽点击
-(void)addvideoswipe{
    [self showBTN];
    if (!videopan) {
        videopan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlepanss:)];
        [pushbottomV addGestureRecognizer:videopan];
    }
    if (!videotap) {
        videotap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videotap)];
    }
    
}
-(void)videotap{
    useraimation.hidden = NO;
    vipanimation.hidden = NO;
    [pushbottomV removeGestureRecognizer:videopan];
    videopan = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    pushbottomV.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0f, 1.0f);
    [UIView commitAnimations];
    pushbottomV.frame = CGRectMake(0,0,_window_width,_window_height);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden = NO;
        listView.hidden       = NO;
        frontView.hidden      = NO;
        danmuview.hidden      = NO;
        if (gameVC) {
            gameVC.hidden = NO;
        }
        if (shell) {
            shell.hidden = NO;
        }
        if (rotationV) {
            rotationV.hidden = NO;
        }
        if (zhuangVC) {
            zhuangVC.hidden = NO;
        }
        liansongliwubottomview.hidden = NO;
        haohualiwuV.hidden = NO;
        [self showBTN];
    });
}
- (void) handlepanss: (UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x/3;
    center.y += point.y/3;
    if (center.x <0 ) {
        center.x = 0;
    }
    if (center.x >_window_width) {
        center.x = _window_width - _window_width*0.3;
    }
    if (center.y <0) {
        center.y = 0;
    }
    if ( center.y > _window_height ) {
        center.y = _window_height - _window_height*0.3;
    }
    pushbottomV.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    CGPoint origin = [[touches anyObject] locationInView:self.view];
    CGPoint location;
    location.x = origin.x/self.view.frame.size.width;
    location.y = origin.y/self.view.frame.size.height;
    [self onSwitchRtcView:location];
    
    //腾讯基础美颜
    if (_vBeauty && _vBeauty.hidden == NO) {
        _vBeauty.hidden = YES;
         _preFrontView.hidden = NO;
    }
}

// 采集相关设置初始化
- (void) setCaptureCfg {
    if (![[common getIsTXfiter]isEqual:@"1"]) {
        if (!_gpuStreamer) {
            _gpuStreamer = [[KSYGPUStreamerKit alloc]initWithDefaultCfg];
        }
        _gpuStreamer.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        _gpuStreamer.videoFPS = 15;
        _gpuStreamer.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
        _gpuStreamer.capturePixelFormat   = kCVPixelFormatType_32BGRA;
        _gpuStreamer.previewDimension = CGSizeMake(_window_height, _window_width);
        _gpuStreamer.streamDimension = CGSizeMake(640, 360);
        _gpuStreamer.cameraPosition = AVCaptureDevicePositionFront;
        _gpuStreamer.streamerBase.videoCodec = KSYVideoCodec_VT264;
        _gpuStreamer.streamerBase.videoInitBitrate = [minstr([_pushSettings valueForKey:@"bitrate"]) intValue];
        _gpuStreamer.streamerBase.videoMaxBitrate  = [minstr([_pushSettings valueForKey:@"bitrate_max"]) intValue];
        _gpuStreamer.streamerBase.videoMinBitrate  = [minstr([_pushSettings valueForKey:@"bitrate_min"]) intValue];
        _gpuStreamer.streamerBase.videoFPS = [minstr([_pushSettings valueForKey:@"fps"]) intValue];
        _gpuStreamer.streamerBase.videoMinFPS = [minstr([_pushSettings valueForKey:@"fps_min"]) intValue];
        _gpuStreamer.streamerBase.videoMaxFPS = [minstr([_pushSettings valueForKey:@"fps_max"]) intValue];
        _gpuStreamer.streamerBase.maxKeyInterval = [minstr([_pushSettings valueForKey:@"gop"]) floatValue];
        _gpuStreamer.streamerBase.audiokBPS = [minstr([_pushSettings valueForKey:@"audiobitrate"]) intValue];
        switch ([minstr([_pushSettings valueForKey:@"resolution"]) intValue]) {
            case 1:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset352x288;
                break;
            case 2:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset352x288;
                break;
            case 3:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset640x480;
                break;
            case 4:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset1280x720;
                break;
            case 5:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset1280x720;
                break;
            case 6:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset1920x1080;
                break;
            case 7:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset3840x2160;
                break;
            case 8:
                _gpuStreamer.capPreset =  AVCaptureSessionPresetiFrame960x540;
                break;
            case 9:
                _gpuStreamer.capPreset =  AVCaptureSessionPresetiFrame1280x720;
                break;
            default:
                break;
        }
    }else{
        _gpuStreamer.videoOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        _gpuStreamer.videoFPS = 15;
        _gpuStreamer.gpuOutputPixelFormat = kCVPixelFormatType_32BGRA;
        _gpuStreamer.capturePixelFormat   = kCVPixelFormatType_32BGRA;
        _gpuStreamer.previewDimension = CGSizeMake(_window_height, _window_width);
        _gpuStreamer.streamDimension = CGSizeMake(640, 360);
        _gpuStreamer.cameraPosition = AVCaptureDevicePositionFront;
        _gpuStreamer.streamerBase.videoCodec = KSYVideoCodec_VT264;
        _gpuStreamer.streamerBase.videoInitBitrate = [minstr([_pushSettings valueForKey:@"bitrate"]) intValue];
        _gpuStreamer.streamerBase.videoMaxBitrate  = [minstr([_pushSettings valueForKey:@"bitrate_max"]) intValue];
        _gpuStreamer.streamerBase.videoMinBitrate  = [minstr([_pushSettings valueForKey:@"bitrate_min"]) intValue];
        _gpuStreamer.streamerBase.videoFPS = [minstr([_pushSettings valueForKey:@"fps"]) intValue];
        _gpuStreamer.streamerBase.videoMinFPS = [minstr([_pushSettings valueForKey:@"fps_min"]) intValue];
        _gpuStreamer.streamerBase.videoMaxFPS = [minstr([_pushSettings valueForKey:@"fps_max"]) intValue];
        _gpuStreamer.streamerBase.maxKeyInterval = [minstr([_pushSettings valueForKey:@"gop"]) floatValue];
        _gpuStreamer.streamerBase.audiokBPS = [minstr([_pushSettings valueForKey:@"audiobitrate"]) intValue];
        switch ([minstr([_pushSettings valueForKey:@"resolution"]) intValue]) {
            case 1:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset352x288;
                break;
            case 2:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset352x288;
                break;
            case 3:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset640x480;
                break;
            case 4:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset1280x720;
                break;
            case 5:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset1280x720;
                break;
            case 6:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset1920x1080;
                break;
            case 7:
                _gpuStreamer.capPreset =  AVCaptureSessionPreset3840x2160;
                break;
            case 8:
                _gpuStreamer.capPreset =  AVCaptureSessionPresetiFrame960x540;
                break;
            case 9:
                _gpuStreamer.capPreset =  AVCaptureSessionPresetiFrame1280x720;
                break;
            default:
                break;
        }
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == keyField) {
        [self pushMessage:nil];
    }
    return YES;
}
-(void) onSwitchRtcView:(CGPoint)location
{
    
}



#pragma mark -初始化TillusorySDK的演示UI
- (void)initTiFaceUI{

    [self.tiUIView createTiUIView];
}


#pragma mark ================ bgm监听 ===============
- (void) onAudioStateChange:(NSNotification *)notification {
    NSLog(@"bgmState:%ld %@",_gpuStreamer.bgmPlayer.bgmPlayerState, [_gpuStreamer.bgmPlayer getCurBgmStateName]);
    if (KSYBgmPlayerStatePlaying == _gpuStreamer.bgmPlayer.bgmPlayerState) {
        if (musicV) {
            return;
        }
        musicV = [[UIView alloc]initWithFrame:CGRectMake(50, _window_height*0.3, _window_width-50, 100)];
        musicV.backgroundColor = [UIColor clearColor];
        [self.view addSubview:musicV];
        UIPanGestureRecognizer *aPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(musicPan:)];
        aPan.minimumNumberOfTouches = 1;
        aPan.maximumNumberOfTouches = 1;
        [musicV addGestureRecognizer:aPan];
        
        NSFileManager *managers=[NSFileManager defaultManager];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        lrcPath = [docDir stringByAppendingFormat:@"/%@.lrc",passStr];//muaicPath
        if ([managers fileExistsAtPath:lrcPath]) {
            lrcView = [[YLYOKLRCView alloc]initWithFrame:CGRectMake(0,40,_window_width-50, 30)];
            lrcView.lrcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];//OKlrcLabel
            lrcView.OKlrcLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            lrcView.backgroundColor = [UIColor clearColor];
            [musicV addSubview:lrcView];
            YLYMusicLRC *lrc = [[YLYMusicLRC alloc]initWithLRCFile:lrcPath];
            if(lrc.lrcList.count == 0 || !lrc.lrcList)
            {
                [MBProgressHUD showError:YZMsg(@"暂无歌词")];
                buttonmusic = [UIButton buttonWithType:UIButtonTypeCustom];
                buttonmusic.frame = CGRectMake(80,0,50,30);
                [buttonmusic addTarget:self action:@selector(musicPlay) forControlEvents:UIControlEventTouchUpInside];
                [buttonmusic setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
                buttonmusic.backgroundColor = [UIColor clearColor];
                [buttonmusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                buttonmusic.layer.masksToBounds = YES;
                buttonmusic.layer.cornerRadius = 10;
                buttonmusic.layer.borderWidth = 1;
                buttonmusic.layer.borderColor = [UIColor whiteColor].CGColor;
                [musicV addSubview:buttonmusic];
                return;
            }
            self.lrcList = lrc.lrcList;
            self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(140,0,50,30)];
            self.timeLabel.backgroundColor = [UIColor clearColor];
            self.timeLabel.textAlignment = NSTextAlignmentCenter;
            self.timeLabel.textColor = [UIColor whiteColor];
            self.timeLabel.layer.cornerRadius = 10;
            self.timeLabel.layer.borderWidth = 1;
            self.timeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            self.timeLabel.text = [NSString stringWithFormat:@"%d:0%d",0,0];
            [musicV addSubview:self.timeLabel];
        }
        else{
            NSLog(@"歌词不存在");
        }
        buttonmusic = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonmusic.frame = CGRectMake(80,0,50,30);
        [buttonmusic addTarget:self action:@selector(musicPlay) forControlEvents:UIControlEventTouchUpInside];
        [buttonmusic setTitle:YZMsg(@"结束") forState:UIControlStateNormal];
        buttonmusic.backgroundColor = [UIColor clearColor];
        [buttonmusic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonmusic.layer.masksToBounds = YES;
        buttonmusic.layer.cornerRadius = 10;
        buttonmusic.layer.borderWidth = 1;
        buttonmusic.layer.borderColor = [UIColor whiteColor].CGColor;
        [musicV addSubview:buttonmusic];
        
        if (!lrcTimer) {
            lrcTimer= [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMusicTimeLabel) userInfo:self repeats:YES];
        }
        
    }else{
        [musicV removeFromSuperview];
        musicV = nil;
        [lrcTimer invalidate];
        lrcTimer = nil;
    }
}
- (void)showBGMView{
    if (!bgmView) {
        bgmView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        bgmView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bgmView];
        UIButton *bgmHideBtn = [UIButton buttonWithType:0];
        bgmHideBtn.frame = CGRectMake(0, 0, _window_width, _window_height-150);
        [bgmHideBtn addTarget:self action:@selector(hideBgmView) forControlEvents:UIControlEventTouchUpInside];
        [bgmView addSubview:bgmHideBtn];
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height-150, _window_width, 150)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [bgmView addSubview:whiteView];
        NSArray *titleArr = @[YZMsg(@"麦克风音量"),YZMsg(@"背景音乐音量")];
        for (int i = 0; i<titleArr.count; i++) {
            UILabel *label =[[ UILabel alloc]initWithFrame:CGRectMake(10, i*50, 100, 50)];
            label.font = [UIFont systemFontOfSize:12];
            label.text = titleArr[i];
            [whiteView addSubview:label];
            UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(110, label.top+15, _window_width-130, 20)];
            slider.tag = 18526+i;
            slider.minimumValue = 0;// 设置最小值
            slider.maximumValue = 1;// 设置最大值
            if (i == 0) {
                slider.value = 1;// 设置初始值
            }else{
                slider.value = 0.2;// 设置初始值
            }
            slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
            slider.maximumTrackTintColor = [UIColor grayColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
            [slider setThumbImage:[UIImage imageNamed:@"play_seekbar_icon"] forState:0];
            [slider addTarget:self action:@selector(sliderValueChangeddddddd:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
            [whiteView addSubview:slider];
        }
        [UIView animateWithDuration:0.3 animations:^{
            bgmView.frame = CGRectMake(0, 0, _window_width, _window_height);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            bgmView.frame = CGRectMake(0, 0, _window_width, _window_height);
        } completion:^(BOOL finished) {
            [self.view bringSubviewToFront:bgmView];
        }];
        
    }
}
- (void)hideBgmView{
    [UIView animateWithDuration:0.3 animations:^{
        bgmView.frame = CGRectMake(0, _window_height, _window_width, _window_height);
    }];
}
- (void)sliderValueChangeddddddd:(UISlider *)slider{
    
    if (slider.tag == 18526) {
        [_gpuStreamer.aMixer setMixVolume:slider.value of:_gpuStreamer.micTrack];
    }else{
        [_gpuStreamer.aMixer setMixVolume:slider.value of:_gpuStreamer.bgmTrack];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

#pragma mark ================ 连麦 ===============
/**
 连麦成功，拉取连麦用户的流
 
 @param playurl 流地址
 @param userid 用户ID
 */
-(void)getSmallRTMP_URL:(NSString *)playurl andUserID:(NSString *)userid{
    isAnchorLink = NO;
    if ([_sdkType isEqual:@"1"]) {
        if (_tx_playrtmp) {
            [_tx_playrtmp stopConnect];
            [_tx_playrtmp stopPush];
            [_tx_playrtmp removeFromSuperview];
            _tx_playrtmp = nil;
        }
        _tx_playrtmp = [[TXPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":playurl,@"pushurl":@"0",@"userid":userid} andFrame:CGRectMake(_window_width - 100, _window_height - 110 -statusbarHeight - 150 , 100, 150) andisHOST:YES];
        _tx_playrtmp.delegate = self;
        _tx_playrtmp.tag = 1500 + [userid intValue];
        [self.view addSubview:_tx_playrtmp];
        [self.view insertSubview:_tx_playrtmp aboveSubview:self.tableView];
        //混流
        NSDictionary *hunDic = @{@"selfUrl":_hostURL,@"otherUrl":playurl};
        [_tx_playrtmp hunliu:hunDic andHost:NO];
        [self huanCunLianMaiMessage:playurl andUserID:userid];
    }else{
        if (_js_playrtmp) {
            [_js_playrtmp stopConnect];
            [_js_playrtmp stopPush];
            [_js_playrtmp removeFromSuperview];
            _js_playrtmp = nil;
        }
        _js_playrtmp = [[JSPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":playurl,@"pushurl":@"0",@"userid":userid} andFrame:CGRectMake(_window_width - 100, _window_height - 110 -statusbarHeight - 150 , 100, 150) andisHOST:YES];
        _js_playrtmp.delegate = self;
        _js_playrtmp.tag = 1500 + [userid intValue];
        [self.view addSubview:_js_playrtmp];
        [self.view insertSubview:_js_playrtmp aboveSubview:self.tableView];
        [self huanCunLianMaiMessage:playurl andUserID:userid];
    }
    
    
    
}
#pragma mark -  腾讯连麦start
-(void)tx_closeuserconnect:(NSString *)uid{
    if (pkAlertView) {
        return;
    }
    if ([_sdkType isEqual:@"1"] && _tx_playrtmp) {
        NSDictionary *hunDic = @{@"selfUrl":_hostURL,@"otherUrl":@""};
        [_tx_playrtmp hunliu:hunDic andHost:YES];
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }
    //主播端
    if (isAnchorLink) {
        [socketL anchor_DuankaiLink];
    }else{
        [socketL closeconnectuser:uid];
    }
    [self changeLivebroadcastLinkState:NO];
}

#pragma mark -  腾讯连麦end

/**
 有人下麦
 
 @param uid UID
 */
-(void)usercloseConnect:(NSString *)uid{
    if (_js_playrtmp) {
        [_js_playrtmp stopConnect];
        [_js_playrtmp stopPush];
        [_js_playrtmp removeFromSuperview];
        _js_playrtmp = nil;
    }
    if (_tx_playrtmp) {
        NSDictionary *hunDic = @{@"selfUrl":_hostURL,@"otherUrl":@""};
        [_tx_playrtmp hunliu:hunDic andHost:NO];
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}
//主播关闭某人的连麦
-(void)js_closeuserconnect:(NSString *)uid{
    if (pkAlertView) {
        return;
    }
    if ([_sdkType isEqual:@"1"] && _tx_playrtmp) {
        NSDictionary *hunDic = @{@"selfUrl":_hostURL,@"otherUrl":@""};
        [_tx_playrtmp hunliu:hunDic andHost:YES];
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }
    if (isAnchorLink) {
        [socketL anchor_DuankaiLink];
    }else{
        [socketL closeconnectuser:uid];
    }
    [self changeLivebroadcastLinkState:NO];
}
//请求接口，服务器缓存连麦者信息
- (void)huanCunLianMaiMessage:(NSString *)playurl andUserID:(NSString *)touid{
    
    NSDictionary *parameterDic = @{
                                   @"pull_url":playurl,
                                   @"touid":touid
                                   };
    [YBToolClass postNetworkWithUrl:@"Live.showVideo" andParameter:parameterDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
    

}
/**
 更改Livebroadcast中的连麦状态
 
 @param islianmai 是否在连麦
 */
- (void)changeLivebroadcastLinkState:(BOOL)islianmai{
    isLianmai = islianmai;
}
#pragma mark ================ 改变发送按钮图片 ===============
- (void)ChangePushBtnState{
    if (keyField.text.length > 0) {
        pushBTN.selected = YES;
    }else{
        pushBTN.selected = NO;
    }
}
#pragma mark ================ 守护 ===============
- (void)guardBtnClick{
    gShowView = [[guardShowView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andUserGuardMsg:nil andLiveUid:[Config getOwnID]];
    gShowView.delegate = self;
    [self.view addSubview:gShowView];
    [gShowView show];
}
- (void)removeShouhuView{
    if (gShowView) {
        [gShowView removeFromSuperview];
        gShowView = nil;
    }
    if (anchorView) {
        [anchorView removeFromSuperview];
        anchorView = nil;
    }
    if (redList) {
        [redList removeFromSuperview];
        redList = nil;
    }
    if (pkAlertView) {
        [pkAlertView removeTimer];
        [pkAlertView removeFromSuperview];
        pkAlertView = nil;
//        startPKBtn.hidden = NO;
        [frontView addSubview:startPKBtn];

    }

}
- (void)updateGuardMsg:(NSDictionary *)dic{
    _voteNums = minstr([dic valueForKey:@"votestotal"]);
    [self changeState];
    [self changeGuardNum:minstr([dic valueForKey:@"guard_nums"])];
    if (listView) {
        [listView listReloadNoew];
    }
    
}
#pragma mark ================ 主播连麦 ===============
//检查游戏状态
-(BOOL)checkGameState {
    if (zhuangVC || shell || gameVC || rotationV) {
        return YES;
    }
    return NO;
}
- (void)showAnchorView{
    anchorView = [[anchorOnline alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    anchorView.delegate = self;
    anchorView.myStream = minstr([_roomDic valueForKey:@"stream"]);
    [self.view addSubview:anchorView];
    [anchorView show];
}
- (void)startLink:(NSDictionary *)dic andMyInfo:(NSDictionary *)myInfo{
    [socketL anchor_startLink:dic andMyInfo:myInfo];
}
- (void)anchor_agreeLink:(NSDictionary *)dic{
    isAnchorLink = YES;
    pkBackImgView.hidden = NO;
    isLianmai = YES;
    [UIView animateWithDuration:0.3 animations:^{
        _pushPreview.frame = CGRectMake(0, 130+statusbarHeight, _window_width/2, _window_width*2/3);
        if (![_sdkType isEqual:@"1"]) {
            _gpuStreamer.preview.size = CGSizeMake(_window_width/2, _window_width*2/3);
        }

    }];
    if ([_sdkType isEqual:@"1"]) {
        if (_tx_playrtmp) {
            [_tx_playrtmp stopConnect];
            [_tx_playrtmp stopPush];
            [_tx_playrtmp removeFromSuperview];
            _tx_playrtmp = nil;
        }
        _tx_playrtmp = [[TXPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":minstr([dic valueForKey:@"pkpull"]),@"pushurl":@"0",@"userid":minstr([dic valueForKey:@"pkuid"])} andFrame:CGRectMake(_window_width/2, 130+statusbarHeight , _window_width/2, _window_width*2/3) andisHOST:YES];
        _tx_playrtmp.delegate = self;
        _tx_playrtmp.tag = 1500 + [minstr([dic valueForKey:@"pkuid"]) intValue];
        [self.view addSubview:_tx_playrtmp];
        [self.view insertSubview:redBagBtn aboveSubview:_tx_playrtmp];
        [self.view insertSubview:toolBar aboveSubview:_tx_playrtmp];
        
        NSDictionary *hunDic = @{@"selfUrl":_hostURL,@"otherUrl":minstr([dic valueForKey:@"pkpull"])};
        [_tx_playrtmp hunliu:hunDic andHost:YES];
    }else{
        if (_js_playrtmp) {
            [_js_playrtmp stopConnect];
            [_js_playrtmp stopPush];
            [_js_playrtmp removeFromSuperview];
            _js_playrtmp = nil;
        }
        _js_playrtmp = [[JSPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":minstr([dic valueForKey:@"pkpull"]),@"pushurl":@"0",@"userid":minstr([dic valueForKey:@"pkuid"])} andFrame:CGRectMake(_window_width/2, 130+statusbarHeight , _window_width/2, _window_width*2/3) andisHOST:YES];
        _js_playrtmp.delegate = self;
        _js_playrtmp.tag = 1500 + [minstr([dic valueForKey:@"pkuid"]) intValue];
        [self.view addSubview:_js_playrtmp];
        [self.view insertSubview:redBagBtn aboveSubview:_js_playrtmp];
        [self.view insertSubview:toolBar aboveSubview:_js_playrtmp];
    }
    //startPKBtn.hidden = NO;
    [frontView addSubview:startPKBtn];

}
- (void)anchor_stopLink:(NSDictionary *)dic{
//    startPKBtn.hidden = YES;
    [startPKBtn removeFromSuperview];
    if (_js_playrtmp) {
        [_js_playrtmp stopConnect];
        [_js_playrtmp stopPush];
        [_js_playrtmp removeFromSuperview];
        _js_playrtmp = nil;
    }
    if (_tx_playrtmp) {
        NSDictionary *hunDic = @{@"selfUrl":_hostURL,@"otherUrl":@""};
        [_tx_playrtmp hunliu:hunDic andHost:YES];
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }
    if (pkView) {
        [pkView removeFromSuperview];
        pkView = nil;
    }

    [UIView animateWithDuration:0.3 animations:^{
        _pushPreview.frame = CGRectMake(0, 0, _window_width, _window_height);
        if (![_sdkType isEqual:@"1"]) {
             _gpuStreamer.preview.size = CGSizeMake(_window_width, _window_height);
        }
    }];
    isAnchorLink = NO;
    [self changeLivebroadcastLinkState:NO];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}
#pragma mark ================ PK ===============
-(void)removePKView{
    if (pkView) {
        [pkView removeFromSuperview];
        pkView = nil;
        if (isAnchorLink) {
            //            startPKBtn.hidden = NO;
            [frontView addSubview:startPKBtn];
            
        }
    }
}
- (void)startPKBtnClick{
//    startPKBtn.hidden = YES;
    [startPKBtn removeFromSuperview];
    if (pkAlertView) {
        [pkAlertView removeFromSuperview];
        pkAlertView = nil;
    }
    pkAlertView = [[anchorPKAlert alloc]initWithFrame:CGRectMake(0, 130+statusbarHeight+_window_width*2/6, _window_width, 70) andIsStart:YES];
    pkAlertView.delegate = self;
    [self.view addSubview:pkAlertView];
    [socketL launchPK];
}
- (void)showPKView{
    if (pkAlertView) {
        [pkAlertView removeTimer];
        [pkAlertView removeFromSuperview];
        pkAlertView = nil;
    }

//    startPKBtn.hidden = YES;
    [startPKBtn removeFromSuperview];
    if (pkView) {
        [pkView removeFromSuperview];
        pkView = nil;
    }
    pkView = [[anchorPKView alloc]initWithFrame:CGRectMake(0, 130+statusbarHeight, _window_width, _window_width*2/3+20) andTime:@"300"];
    pkView.delegate = self;
    [self.view addSubview:pkView];
}
- (void)showPKButton{
    if (pkAlertView) {
        [pkAlertView removeTimer];
        [pkAlertView removeFromSuperview];
        pkAlertView = nil;
    }
//    startPKBtn.hidden = NO;
    [frontView addSubview:startPKBtn];

}
- (void)showPKResult:(NSDictionary *)dic{
    int win;
    if ([minstr([dic valueForKey:@"win_uid"]) isEqual:@"0"]) {
        win = 0;
    }else if ([minstr([dic valueForKey:@"win_uid"]) isEqual:[Config getOwnID]]) {
        win = 1;
    }else{
        win = 2;
    }

    [pkView showPkResult:dic andWin:win];
}
- (void)changePkProgressViewValue:(NSDictionary *)dic{
    NSString *blueNum;
    NSString *redNum;
    CGFloat progress = 0.0;
    if ([minstr([dic valueForKey:@"pkuid1"]) isEqual:[Config getOwnID]]) {
        blueNum = minstr([dic valueForKey:@"pktotal1"]);
        redNum = minstr([dic valueForKey:@"pktotal2"]);
    }else{
        redNum = minstr([dic valueForKey:@"pktotal1"]);
        blueNum = minstr([dic valueForKey:@"pktotal2"]);
    }
    if ([blueNum isEqual:@"0"]) {
        progress = 0.2;
    }else if ([redNum isEqual:@"0"]) {
        progress = 0.8;
    }else{
        CGFloat ppp = [blueNum floatValue]/([blueNum floatValue] + [redNum floatValue]);
        if (ppp < 0.2) {
            progress = 0.2;
        }else if (ppp > 0.8){
            progress = 0.8;
        }else{
            progress = ppp;
        }
    }

    [pkView updateProgress:progress withBlueNum:blueNum withRedNum:redNum];
}
- (void)duifangjujuePK{
    if (pkAlertView) {
        [pkAlertView removeTimer];
        [pkAlertView removeFromSuperview];
        pkAlertView = nil;
    }
//    startPKBtn.hidden = NO;
    [frontView addSubview:startPKBtn];

}
#pragma mark ================ 红包 ===============
- (void)showRedView{
    redBview = [[redBagView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    __weak Livebroadcast *wSelf = self;
    redBview.block = ^(NSString *type) {
        [wSelf sendRedBagSuccess:type];
    };
    redBview.zhuboDic = _roomDic;
    [self.view addSubview:redBview];
}
- (void)sendRedBagSuccess:(NSString *)type{
    [redBview removeFromSuperview];
    redBview = nil;
    if ([type isEqual:@"909"]) {
        return;
    }
    [socketL fahongbaola];
}
- (void)showRedbag:(NSDictionary *)dic{
    redBagBtn.hidden = NO;
    NSString *uname;
    if ([minstr([dic valueForKey:@"uid"]) isEqual:[Config getOwnID]]) {
        uname = YZMsg(@"主播");
    }else{
        uname = minstr([dic valueForKey:@"uname"]);
    }
    NSString *levell = @" ";
    NSString *ID = @" ";
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",minstr([dic valueForKey:@"ct"]),@"contentChat",levell,@"levelI",ID,@"id",@"redbag",@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast:self.tableView];

}
- (void)redBagBtnClick{
    redList = [[redListView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) withZHuboMsg:_roomDic];
    redList.delegate =self;
    [self.view addSubview:redList];
}

#pragma mark ============连麦开关n按钮点击=============
- (void)linkSwitchBtnClick:(UIButton *)sender{
    [YBToolClass postNetworkWithUrl:@"Linkmic.setMic" andParameter:@{@"ismic":@(!sender.selected)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            sender.selected = !sender.selected;
        }
        [MBProgressHUD showError:msg];
        
    } fail:^{
        
    }];
}



#pragma mark ===========================   腾讯推流start   =======================================

-(void)txBaseBeauty {
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
    
    
    
    //美颜拉杆浮层
    float   beauty_btn_width  = 65;
    float   beauty_btn_height = 30;//19;
    
    float   beauty_btn_count  = 2;
    
    float   beauty_center_interval = (self.view.width - 30 - beauty_btn_width)/(beauty_btn_count - 1);
    float   first_beauty_center_x  = 15 + beauty_btn_width/2;
    int ib = 0;
    _vBeauty = [[UIView  alloc] init];
    _vBeauty.frame = CGRectMake(0, self.view.height-185-statusbarHeight, self.view.width, 185+statusbarHeight);
    [_vBeauty setBackgroundColor:[UIColor whiteColor]];
    float   beauty_center_y = _vBeauty.height - 30;//35;
    _beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _beautyBtn.center = CGPointMake(first_beauty_center_x, beauty_center_y);
    _beautyBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_beautyBtn setImage:[UIImage imageNamed:@"white_beauty"] forState:UIControlStateNormal];
    [_beautyBtn setImage:[UIImage imageNamed:@"white_beauty_press"] forState:UIControlStateSelected];
    [_beautyBtn setTitle:@"美颜" forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_beautyBtn setTitleColor:normalColors forState:UIControlStateSelected];
    _beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _beautyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _beautyBtn.tag = 0;
    _beautyBtn.selected = YES;
    [_beautyBtn addTarget:self action:@selector(selectBeauty:) forControlEvents:UIControlEventTouchUpInside];
    ib++;
    _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _filterBtn.center = CGPointMake(first_beauty_center_x + ib*beauty_center_interval, beauty_center_y);
    _filterBtn.bounds = CGRectMake(0, 0, beauty_btn_width, beauty_btn_height);
    [_filterBtn setImage:[UIImage imageNamed:@"beautiful"] forState:UIControlStateNormal];
    [_filterBtn setImage:[UIImage imageNamed:@"beautiful_press"] forState:UIControlStateSelected];
    [_filterBtn setTitle:@"滤镜" forState:UIControlStateNormal];
    [_filterBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_filterBtn setTitleColor:normalColors forState:UIControlStateSelected];
    _filterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    _filterBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _filterBtn.tag = 1;
    [_filterBtn addTarget:self action:@selector(selectBeauty:) forControlEvents:UIControlEventTouchUpInside];
    ib++;
    _beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  _beautyBtn.top - 95, 40, 20)];
    _beautyLabel.text = @"美白";
    _beautyLabel.font = [UIFont systemFontOfSize:12];
    _sdBeauty = [[UISlider alloc] init];
    _sdBeauty.frame = CGRectMake(_beautyLabel.right, _beautyBtn.top - 95, self.view.width - _beautyLabel.right - 10, 20);
    _sdBeauty.minimumValue = 0;
    _sdBeauty.maximumValue = 9;
    _sdBeauty.value = 6.3;
    [_sdBeauty setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdBeauty setMinimumTrackImage:[PublicObj getImgWithColor:normalColors] forState:UIControlStateNormal];
    [_sdBeauty setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdBeauty addTarget:self action:@selector(txsliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdBeauty.tag = 0;
    
    
    _whiteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _beautyBtn.top - 55, 40, 20)];
    
    _whiteLabel.text = @"美颜";
    _whiteLabel.font = [UIFont systemFontOfSize:12];
    _sdWhitening = [[UISlider alloc] init];
    
    _sdWhitening.frame =  CGRectMake(_whiteLabel.right, _beautyBtn.top - 55, self.view.width - _whiteLabel.right - 10, 20);
    
    _sdWhitening.minimumValue = 0;
    _sdWhitening.maximumValue = 9;
    _sdWhitening.value = 2.7;
    [_sdWhitening setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [_sdWhitening setMinimumTrackImage:[PublicObj getImgWithColor:normalColors] forState:UIControlStateNormal];//[UIImage imageNamed:@"green"]
    [_sdWhitening setMaximumTrackImage:[UIImage imageNamed:@"gray"] forState:UIControlStateNormal];
    [_sdWhitening addTarget:self action:@selector(txsliderValueChange:) forControlEvents:UIControlEventValueChanged];
    _sdWhitening.tag = 1;
    
    _filterPickerView = [[V8HorizontalPickerView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, 115)];
    _filterPickerView.textColor = [UIColor grayColor];
    _filterPickerView.elementFont = [UIFont fontWithName:@"" size:14];
    _filterPickerView.delegate = self;
    _filterPickerView.dataSource = self;
    _filterPickerView.hidden = YES;
    
    UIImageView *sel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_selected"]];
    
    _filterPickerView.selectedMaskView = sel;
    _filterType = 0;
    
    [_vBeauty addSubview:_beautyLabel];
    [_vBeauty addSubview:_whiteLabel];
    [_vBeauty addSubview:_sdWhitening];
    [_vBeauty addSubview:_sdBeauty];
    [_vBeauty addSubview:_beautyBtn];
    [_vBeauty addSubview:_bigEyeLabel];
    [_vBeauty addSubview:_sdBigEye];
    [_vBeauty addSubview:_slimFaceLabel];
    [_vBeauty addSubview:_sdSlimFace];
    [_vBeauty addSubview:_filterPickerView];
    [_vBeauty addSubview:_filterBtn];
    _vBeauty.hidden = YES;
    [self.view addSubview: _vBeauty];
}
-(void)userTXBase {
    if (!_vBeauty) {
        [self txBaseBeauty];
    }
    _preFrontView.hidden = YES;
    _vBeauty.hidden = NO;
    [self.view bringSubviewToFront:_vBeauty];
}
-(void)txRtmpPush{
    [self setBgAndPreview];
    //配置推流参数
    _txLivePushonfig = [[TXLivePushConfig alloc] init];
    _txLivePushonfig.frontCamera = YES;
    _txLivePushonfig.enableAutoBitrate = YES;
    /*
     {
     "codingmode": "2",
     "resolution": "5",
     "fps": "15",
     "fps_min": "15",
     "fps_max": "30",
     "gop": "3",
     "bitrate": "800",
     "bitrate_min": "800",
     "bitrate_max": "1200",
     "audiorate": "44100",
     "audiobitrate": "48",
     "preview_fps": "15",
     "preview_resolution": "1"
     }
     */
    int videoResolution = [minstr([_pushSettings valueForKey:@"resolution"]) intValue];
    if (videoResolution <= 3) {
        _txLivePushonfig.videoResolution = VIDEO_RESOLUTION_TYPE_360_640 ;
    }
    else if (videoResolution == 4){
        _txLivePushonfig.videoResolution = VIDEO_RESOLUTION_TYPE_540_960 ;
    }
    else if (videoResolution >= 5){
        _txLivePushonfig.videoResolution = VIDEO_RESOLUTION_TYPE_720_1280 ;
    }
    _txLivePushonfig.videoEncodeGop = [minstr([_pushSettings valueForKey:@"gop"]) intValue];
    _txLivePushonfig.videoFPS = [minstr([_pushSettings valueForKey:@"fps"]) intValue];
    _txLivePushonfig.videoBitratePIN = [minstr([_pushSettings valueForKey:@"bitrate"]) intValue];
    _txLivePushonfig.videoBitrateMax = [minstr([_pushSettings valueForKey:@"bitrate_max"]) intValue];
    _txLivePushonfig.videoBitrateMin = [minstr([_pushSettings valueForKey:@"bitrate_min"]) intValue];
    _txLivePushonfig.audioSampleRate = [minstr([_pushSettings valueForKey:@"audiorate"]) intValue];
    
    //background push
    _txLivePushonfig.pauseFps = 5;
    _txLivePushonfig.pauseTime = 300;
    //耳返
    _txLivePushonfig.enableAudioPreview = NO;
    _txLivePushonfig.pauseImg = [UIImage imageNamed:@"pause_publish.jpg"];
    _txLivePublisher = [[TXLivePush alloc] initWithConfig:_txLivePushonfig];
    if ([[common getIsTXfiter]isEqual:@"1"]) {
        _tx_beauty_level = 9;
        _tx_whitening_level = 3;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:_tx_beauty_level whitenessLevel:_tx_whitening_level ruddinessLevel:0];
    }else{
        _txLivePublisher.videoProcessDelegate = self;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:0 whitenessLevel:0 ruddinessLevel:0];
        [_txLivePublisher setMirror:YES];
        
        [self.tiSDKManager destroy];
        self.tiSDKManager = nil;
        self.tiSDKManager = [[TiSDKManager alloc]init];
        self.tiUIView = [[TiUIView alloc]initTiUIViewWith:self.tiSDKManager delegate:self superView:self.view];
        self.tiUIView.isClearOldUI = NO;
    }
    
    [_txLivePublisher startPreview:_pushPreview];
    //[self txStartRtmp];
    _notification = [CWStatusBarNotification new];
    _notification.notificationLabelBackgroundColor = [UIColor redColor];
    _notification.notificationLabelTextColor = [UIColor whiteColor];
}
-(void)txStartRtmp{
    if(_txLivePublisher != nil)
    {
        _txLivePublisher.delegate = self;
        [self.txLivePublisher setVideoQuality:VIDEO_QUALITY_HIGH_DEFINITION adjustBitrate:YES adjustResolution:YES];
        //连麦混流
        _hostURL = [NSString stringWithFormat:@"%@&mix=session_id:%@",_hostURL,[Config getOwnID]];
        [_txLivePublisher startPush:_hostURL];
        if ([_txLivePublisher startPush:_hostURL] != 0) {
            [_notification displayNotificationWithMessage:@"推流器启动失败" forDuration:5];
            NSLog(@"推流器启动失败");
        }
        if ([[common getIsTXfiter]isEqual:@"1"]) {
            [_txLivePublisher setEyeScaleLevel:_tx_eye_level];
            [_txLivePublisher setFaceScaleLevel:_tx_face_level];
        }
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}
- (void)txStopRtmp {
    if(_txLivePublisher != nil)
    {
        [_txLivePublisher stopBGM];
        _txLivePublisher.delegate = nil;
        [_txLivePublisher stopPreview];
        [_txLivePublisher stopPush];
        _txLivePublisher.config.pauseImg = nil;
        _txLivePublisher = nil;
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    for (TXPlayLinkMic *playv in self.view.subviews) {
        if ([playv isKindOfClass:[TXPlayLinkMic class]]) {
            [playv stopConnect];
            [playv stopPush];
            [playv removeFromSuperview];
        }
    }
}
#pragma tx_play_linkmic 代理
-(void)tx_closeUserbyVideo:(NSDictionary *)subdic{
    [MBProgressHUD showError:@"播放失败"];
}
-(void) onNetStatus:(NSDictionary*) param{
    
}
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID >= 0) {
            if (EvtID == PUSH_WARNING_HW_ACCELERATION_FAIL) {
                _txLivePublisher.config.enableHWAcceleration = false;
                NSLog(@"PUSH_EVT_PUSH_BEGIN硬编码启动失败，采用软编码");
            }else if (EvtID == PUSH_EVT_CONNECT_SUCC) {
                // 已经连接推流服务器
                NSLog(@" PUSH_EVT_PUSH_BEGIN已经连接推流服务器");
            }else if (EvtID == PUSH_EVT_PUSH_BEGIN) {
                // 已经与服务器握手完毕,开始推流
                [self changePlayState:1];
                NSLog(@"liveshow已经与服务器握手完毕,开始推流");
            }else if (EvtID == PUSH_WARNING_RECONNECT){
                // 网络断连, 已启动自动重连 (自动重连连续失败超过三次会放弃)
                NSLog(@"网络断连, 已启动自动重连 (自动重连连续失败超过三次会放弃)");
            }else if (EvtID == PUSH_WARNING_NET_BUSY) {
                //[_notification displayNotificationWithMessage:@"您当前的网络环境不佳，请尽快更换网络保证正常直播" forDuration:5];
            }
        }else {
            if (EvtID == PUSH_ERR_NET_DISCONNECT) {
                NSLog(@"PUSH_EVT_PUSH_BEGIN网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启推流");
                [_notification displayNotificationWithMessage:@"网络断连" forDuration:5];
                [self hostStopRoom];
            }
        }
    });
}
-(void) txsliderValueChange:(UISlider*) obj {
    // todo
    if (obj.tag == 1) { //美颜
        _tx_beauty_level = obj.value;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:_tx_beauty_level whitenessLevel:_tx_whitening_level ruddinessLevel:0];
        // [_txLivePublisher setBeautyFilterDepth:_beauty_level setWhiteningFilterDepth:_whitening_level];
    } else if (obj.tag == 0) { //美白
        _tx_whitening_level = obj.value;
        [_txLivePublisher setBeautyStyle:0 beautyLevel:_tx_beauty_level whitenessLevel:_tx_whitening_level ruddinessLevel:0];
        // [_txLivePublisher setBeautyFilterDepth:_beauty_level setWhiteningFilterDepth:_whitening_level];
    } else if (obj.tag == 2) { //大眼
        _tx_eye_level = obj.value;
        [_txLivePublisher setEyeScaleLevel:_tx_eye_level];
    } else if (obj.tag == 3) { //瘦脸
        _tx_face_level = obj.value;
        [_txLivePublisher setFaceScaleLevel:_tx_face_level];
    } else if (obj.tag == 4) {// 背景音乐音量
        [_txLivePublisher setBGMVolume:(obj.value/obj.maximumValue)];
    } else if (obj.tag == 5) { // 麦克风音量
        [_txLivePublisher setMicVolume:(obj.value/obj.maximumValue)];
    }
}

-(void)selectBeauty:(UIButton *)button{
    switch (button.tag) {
        case 0: {
            _sdWhitening.hidden = NO;
            _sdBeauty.hidden    = NO;
            _beautyLabel.hidden = NO;
            _whiteLabel.hidden  = NO;
            _bigEyeLabel.hidden = NO;
            _sdBigEye.hidden    = NO;
            _slimFaceLabel.hidden = NO;
            _sdSlimFace.hidden    = NO;
            _beautyBtn.selected  = YES;
            _filterBtn.selected = NO;
            _filterPickerView.hidden = YES;
            _vBeauty.frame = CGRectMake(0, self.view.height-185-statusbarHeight, self.view.width, 185+statusbarHeight);
        }break;
        case 1: {
            _sdWhitening.hidden = YES;
            _sdBeauty.hidden    = YES;
            _beautyLabel.hidden = YES;
            _whiteLabel.hidden  = YES;
            _bigEyeLabel.hidden = YES;
            _sdBigEye.hidden    = YES;
            _slimFaceLabel.hidden = YES;
            _sdSlimFace.hidden    = YES;
            _beautyBtn.selected  = NO;
            _filterBtn.selected = YES;
            _filterPickerView.hidden = NO;
            [_filterPickerView scrollToElement:_filterType animated:NO];
        }
            _beautyBtn.center = CGPointMake(_beautyBtn.center.x, _vBeauty.frame.size.height - 35-statusbarHeight);
            _filterBtn.center = CGPointMake(_filterBtn.center.x, _vBeauty.frame.size.height - 35-statusbarHeight);
    }
}
//设置美颜滤镜
#pragma mark - HorizontalPickerView DataSource Methods/Users/annidy/Work/RTMPDemo_PituMerge/RTMPSDK/webrtc
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [_filterArray count];
}
#pragma mark - HorizontalPickerView Delegate Methods
- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    
    V8LabelNode *v = [_filterArray objectAtIndex:index];
    return [[UIImageView alloc] initWithImage:v.face];
    
}
- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    
    return 90;
}
- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    _filterType = index;
    [self filterSelected:index];
}
- (void)filterSelected:(NSInteger)index {
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
    if (path != nil && index != FilterType_None && _txLivePublisher != nil) {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [_txLivePublisher setFilter:image];
    }
    else if(_txLivePublisher != nil) {
        [_txLivePublisher setFilter:nil];
    }
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
#pragma mark ===========================   腾讯推流end   =======================================


#pragma mark ============奖池View=============
- (void)JackpotLevelUp:(NSDictionary *)dic{
    if (!JackpotBtn) {
        JackpotBtn = [[JackpotButton alloc]init];
        JackpotBtn.frame = CGRectMake(10, statusbarHeight + 135, 60, 30);
        [JackpotBtn setBackgroundImage:[UIImage imageNamed:@"Jackpot_btnBack"]];
        [JackpotBtn addTarget:self action:@selector(showJackpotView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:JackpotBtn];
    }
    [JackpotBtn showLightAnimationWithLevel:minstr([dic valueForKey:@"uplevel"])];
    
}
- (void)WinningPrize:(NSDictionary *)dic{
    if (winningView) {
        [winningView removeFromSuperview];
        winningView = nil;
    }
    winningView = [[WinningPrizeView alloc]initWithFrame:CGRectMake(0, 130+statusbarHeight, _window_width, _window_width) andMsg:dic];
    [self.view addSubview:winningView];
    [self.view bringSubviewToFront:winningView];
    
}
- (void)showJackpotView{
    if (jackV) {
        [jackV removeFromSuperview];
        jackV = nil;
    }
    [YBToolClass postNetworkWithUrl:@"Jackpot.getJackpot" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infoDic = [info firstObject];
            jackV = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JackpotView class]) owner:nil options:nil] lastObject];
            jackV.delegate = self;
            jackV.levelL.text = [NSString stringWithFormat:@"Lv.%@",minstr([infoDic valueForKey:@"level"])];
            jackV.coinL.text = minstr([infoDic valueForKey:@"total"]);
            jackV.frame = CGRectMake(_window_width*0.2, 135+statusbarHeight, _window_width*0.6+20, _window_width*0.6);
            [self.view addSubview:jackV];
        }else{
            [MBProgressHUD  showError:msg];
        }
    } fail:^{
        
    }];
}
-(void)jackpotViewClose{
    [jackV removeFromSuperview];
    jackV = nil;
}
#pragma mark ============幸运礼物全站效果=============
- (void)showAllLuckygift:(NSDictionary *)dic{
    if (!luckyGift) {
        luckyGift = [[AllRoomShowLuckyGift alloc]initWithFrame:CGRectMake(guardBtn.right+5, guardBtn.top-2.5, _window_width-(guardBtn.right+5), guardBtn.height+5)];
        [frontView addSubview:luckyGift];
    }
    [luckyGift addLuckyGiftMove:dic];
}



@end
