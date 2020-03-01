//
//  TiUI.m
//  TiSDK
//
//  Created by Cat66 on 2018/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import "TiUIView.h"
#import "TiSaveData.h"
#import "TiUICell.h"
#import "TiStickerManager.h"
#import "TiStickerCell.h"
#import "TiStickerDownloadManager.h"
#import "TiFitterCell.h"
#import "TIRecordCell.h"

@interface TiUIView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) TiSDKManager *tiSDKManager;
@property(nonatomic, weak) id <TiUIViewDelegate> delegate;
@property(nonatomic, strong) UIView *superView;

@property(nonatomic, weak) UIView *currentPopView;
@property(nonatomic, weak) UIView *nextPopView;
@property(nonatomic, strong) UIView *currentMainMenuPopView;

@property(nonatomic, assign) BOOL isSystemEnglish; // 系统是否为英文

@property(nonatomic, assign) NSInteger rockEnumIndex; // rock特效索引
@property(nonatomic, assign) NSInteger filterEnumIndex; // 滤镜特效索引
@property(nonatomic, assign) NSInteger distortionEnumIndex; // 哈哈镜特效索引
@property(nonatomic, assign) NSInteger greenScreenEnumIndex; // 绿幕特效索引

@property(nonatomic, strong) UIButton *mainSwitchButton; // 总开关

@property(nonatomic, strong) UIScrollView *mainMenuView; // 菜单栏
@property(nonatomic, strong) UIButton *selectBeautyButton; // 美颜-选择按钮
@property(nonatomic, strong) UIButton *selectFaceTrimButton; // 美型-选择按钮
@property(nonatomic, strong) UIButton *selectStickerButton; // 贴纸-选择按钮
@property(nonatomic, strong) UIButton *selectFilterButton; // 滤镜-选择按钮
@property(nonatomic, strong) UIButton *selectRockButton; // Rock-选择按钮
@property(nonatomic, strong) UIButton *selectDistortionButton; // 哈哈镜-选择按钮
@property(nonatomic, strong) UIButton *selectGreenScreenButton; // 绿幕-选择按钮

@property(nonatomic, strong) UIView *beautyView; // 美颜窗口
@property(nonatomic, strong) UIView *faceTrimView; // 美型窗口
@property(nonatomic, strong) UIView *stickerView; // 贴纸窗口
@property(nonatomic, strong) UIView *filterView; // 滤镜窗口
@property(nonatomic, strong) UIView *rockView; // Rock窗口
@property(nonatomic, strong) UIView *distortionView; // 哈哈镜窗口
@property(nonatomic, strong) UIView *greenScreenView; // 绿幕窗口

@property(nonatomic, strong) UIButton *beautySwitchButton; // 美颜开关
@property(nonatomic, strong) UILabel *beautySwitchButtonLabel; // 美颜开关标签
@property(nonatomic, strong) UISlider *beautySkinWhiteningSlider; // 美颜-美白拉条
@property(nonatomic, strong) UILabel *beautySkinWhiteningLabel; // 美颜-美白标签
@property(nonatomic, strong) UISlider *beautySkinBlemishRemovalSlider; // 美颜-磨皮拉条
@property(nonatomic, strong) UILabel *beautySkinBlemishRemovalLabel; // 美颜-磨皮标签
@property(nonatomic, strong) UISlider *beautySkinSaturationSlider; // 美颜-饱和拉条
@property(nonatomic, strong) UILabel *beautySkinSaturationLabel; // 美颜-饱和标签
@property(nonatomic, strong) UISlider *beautySkinTendernessSlider; // 美颜-粉嫩拉条
@property(nonatomic, strong) UILabel *beautySkinTendernessLabel; // 美颜-粉嫩标签

@property(nonatomic, strong) UIButton *faceTrimSwitchButton; // 美型开关
@property(nonatomic, strong) UILabel *faceTrimSwitchButtonLabel; // 美型开关
@property(nonatomic, strong) UISlider *faceTrimEyeMagnifyingSlider; // 美型-大眼拉条
@property(nonatomic, strong) UILabel *faceTrimEyeMagnifyingLabel; // 美型-大眼标签
@property(nonatomic, strong) UISlider *faceTrimChinSlimmingSlider; // 美型-瘦脸拉条
@property(nonatomic, strong) UILabel *faceTrimChinSlimmingLabel; // 美型-瘦脸标签

@property(nonatomic, strong) UICollectionView *stickerCollectionView;
@property(nonatomic, strong) UICollectionView *filterCollectionView; // 滤镜选择窗口
@property(nonatomic, strong) UICollectionView *rockCollectionView; // Rock选择窗口
@property(nonatomic, strong) UICollectionView *distortionCollectionView; // 哈哈镜选择窗口
@property(nonatomic, strong) UICollectionView *greenScreenCollectionView; // 绿幕选择窗口

@property(nonatomic, strong) NSArray *fitterNameArray; // 滤镜d数组


@property(nonatomic, strong) UIView *selectLine; // 选中的line

@property(nonatomic, strong) NSMutableArray<TiSticker *> *stickerArray;
@property(nonatomic) NSInteger currentStickerIndex;

@end
#define btnKuan _window_width/4
@implementation TiUIView

UIView *tapView;

- (instancetype)initTiUIViewWith:(TiSDKManager *)tiSDKManager delegate:(id<TiUIViewDelegate>)delegate superView:(UIView *)superView {
    if (self = [super init]) {
        self.tiSDKManager = tiSDKManager;
        self.delegate = delegate;
        self.superView = superView;
    }
    
    // 判定系统语言是否为英文
    if ([[[[NSLocale preferredLanguages] objectAtIndex:0] substringToIndex:2] isEqual: @"en"]) {
        _isSystemEnglish = true;
    } else {
        _isSystemEnglish = false;
    }
    
    [self.tiSDKManager setBeautyEnable:YES];
    [self.tiSDKManager setFaceTrimEnable: YES];
    _fitterNameArray = @[@"orginal",@"langman",@"qingxin",@"weimei",@"fennen",@"huaijiu",@"qingliang",@"landiao",@"meibai",@"rixi"];
    _rockEnumIndex = -1;
    _filterEnumIndex = -1;
    _distortionEnumIndex = -1;
    _greenScreenEnumIndex = -1;
    _currentStickerIndex = -1;
    [self.tiSDKManager setFilterEnum:_filterEnumIndex];
    [self.tiSDKManager setRockEnum:_rockEnumIndex];
    [self.tiSDKManager setDistortionEnum:_distortionEnumIndex];
    [self.tiSDKManager setStickerName:@""];
    [self.tiSDKManager setEyeMagnifying:-1];
    [self.tiSDKManager setChinSlimming:-1];
    [self.tiSDKManager setEyeMagnifying:-1];
    [self.tiSDKManager setChinSlimming:-1];
    [self.tiSDKManager setSkinWhitening:-1];
    [self.tiSDKManager setSkinBlemishRemoval:-1];
    [self.tiSDKManager setSkinSaturation:-1];
    [self.tiSDKManager setSkinTenderness:-1];
    [TiSaveData setFloat:[[common sprout_white] intValue] forKey:@"TiSliderWhitening"];
    [TiSaveData setFloat:[[common sprout_skin] intValue] forKey:@"TiSliderMicrodermabrasion"];
    [TiSaveData setFloat:[[common sprout_saturated] intValue] forKey:@"TiSliderSaturation"];
    [TiSaveData setFloat:[[common sprout_pink] intValue] forKey:@"TiSliderPinkistender"];
    [TiSaveData setFloat:[[common sprout_eye] intValue] forKey:@"TiSliderEyeMagnifying"];
    [TiSaveData setFloat:[[common sprout_face] intValue] forKey:@"TiSliderChinSlimming"];

    __weak typeof(self) __weakSelf = self;
    [[TiStickerManager sharedManager] loadStickersWithCompletion:^(NSMutableArray<TiSticker *> *stickerArray) {
        __weakSelf.stickerArray = stickerArray;
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [[NSNotificationCenter defaultCenter] postNotificationName:@"Ti_STICKERSLOADED_COMPLETE" object:nil];
        //            });
    }];
    
    return self;
}

- (void)createTiUIView {
    if (self.superView != nil) {
        if (self.isClearOldUI) {
            [self clearAllViews];
        }
        
        tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TiScreenWidth, TiScreenHeight)];
        tapView.userInteractionEnabled = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)]];
        [self.superView addSubview:tapView];
        [tapView setHidden:YES];
        
//        [self.superView addSubview:self.mainSwitchButton];
        [self.superView addSubview:self.mainMenuView];
        [self.superView addSubview:self.beautyView];
        [self.superView addSubview:self.faceTrimView];
        [self.superView addSubview:self.stickerView];
        [self.superView addSubview:self.filterView];
        [self.superView addSubview:self.rockView];
        [self.superView addSubview:self.distortionView];
        [self.superView addSubview:self.greenScreenView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stickersLoadedComplete:) name:@"Ti_STICKERSLOADED_COMPLETE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resourceURLLoadedComplete:) name:TiResourceURLNotificationName object:nil];

        [self onMainSwitchButtonClick:nil];
//        __weak typeof(self) __weakSelf = self;
//        [[TiStickerManager sharedManager] loadStickersWithCompletion:^(NSMutableArray<TiSticker *> *stickerArray) {
//            __weakSelf.stickerArray = stickerArray;
////            dispatch_async(dispatch_get_main_queue(), ^{
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"Ti_STICKERSLOADED_COMPLETE" object:nil];
////            });
//        }];
//        //////////////// 测试 ////////////////
//
//        UIButton *buttonA = [UIButton buttonWithType:UIButtonTypeSystem];
//        [buttonA setTitle:@"无抖音" forState:UIControlStateNormal];
//
//        CGFloat buttonWidth = 60;
//        CGFloat buttonHeight = 20;
//        CGFloat buttonTopView = 240;
//
//        buttonA.frame = CGRectMake((TiScreenWidth - buttonWidth)/2, buttonTopView, buttonWidth, buttonHeight);
//        [buttonA addTarget:self action:@selector(onClickNoRock:) forControlEvents:UIControlEventTouchUpInside];
//        [self.superView addSubview:buttonA];
//
//        UIButton *buttonB = [UIButton buttonWithType:UIButtonTypeSystem];
//        [buttonB setTitle:@"抖音一" forState:UIControlStateNormal];
//
//        buttonTopView = 270;
//
//        buttonB.frame = CGRectMake((TiScreenWidth - buttonWidth)/2, buttonTopView, buttonWidth, buttonHeight);
//        [buttonB addTarget:self action:@selector(onClickRockOne:) forControlEvents:UIControlEventTouchUpInside];
//        [self.superView addSubview:buttonB];
//
//        UIButton *buttonC = [UIButton buttonWithType:UIButtonTypeSystem];
//        [buttonC setTitle:@"抖音二" forState:UIControlStateNormal];
//
//        buttonTopView = 210;
//
//        buttonC.frame = CGRectMake((TiScreenWidth - buttonWidth)/2, buttonTopView, buttonWidth, buttonHeight);
//        [buttonC addTarget:self action:@selector(onClickRockTwo:) forControlEvents:UIControlEventTouchUpInside];
//        [self.superView addSubview:buttonC];
//
//        //////////////// 测试 ////////////////
    }
}

- (void)stickersLoadedComplete:(NSNotification *)noti {
    [self.stickerCollectionView reloadData];
    [self.stickerCollectionView scrollsToTop];
}
- (void)resourceURLLoadedComplete:(NSNotification *)noti {
    [self.stickerCollectionView reloadData];
}

////////////////// 测试 ////////////////
//- (void)onClickNoRock:(UIButton *)sender{
//    [self.tiSDKManager setRockEnum:DAZZLED_COLOR_ROCK];
//}
//
//- (void)onClickRockOne:(UIButton *)sender{
//    [self.tiSDKManager setFilterEnum:GRASS_FILTER];
//}
//
//- (void)onClickRockTwo:(UIButton *)sender{
//    [self.tiSDKManager setDistortionEnum:PEAR_FACE_DISTORTION];
//}
////////////////// 测试 ////////////////

/////////////////////// UI绘制 开始 ///////////////////////
// 绘制总开关
- (UIButton *)mainSwitchButton {
    if (!_mainSwitchButton) {
        _mainSwitchButton = [[UIButton alloc] initWithFrame:CGRectMake(50, TiScreenHeight - 100, 36, 36)];
        [_mainSwitchButton setImage:[UIImage imageNamed:@"ic_beauty_unselected"] forState:UIControlStateNormal];
        [_mainSwitchButton setImage:[UIImage imageNamed:@"ic_beauty_selected"] forState:UIControlStateSelected];
        
        _mainSwitchButton.titleLabel.font = [UIFont systemFontOfSize:8];
        
        CGSize imageSize = _mainSwitchButton.imageView.frame.size;
        CGSize titleSize = _mainSwitchButton.titleLabel.frame.size;
        CGFloat totalHeight = imageSize.height + titleSize.height + 3;
        
        _mainSwitchButton.imageEdgeInsets =
        UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
        _mainSwitchButton.titleEdgeInsets =
        UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);
        
        [_mainSwitchButton addTarget:self action:@selector(onMainSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _mainSwitchButton;
}

// 绘制主菜单栏
- (UIScrollView *)mainMenuView {
    if (!_mainMenuView) {
        _mainMenuView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 42)];
        [_mainMenuView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_mainMenuView setBackgroundColor:[UIColor blackColor]];
        _mainMenuView.contentSize = CGSizeMake(TiScreenWidth*1.5, 42);
        _mainMenuView.showsHorizontalScrollIndicator=YES; // 显示水平滚动条
        [_mainMenuView addSubview:self.selectBeautyButton];
        [_mainMenuView addSubview:self.selectFaceTrimButton];
        [_mainMenuView addSubview:self.selectStickerButton];
        [_mainMenuView addSubview:self.selectFilterButton];
        [_mainMenuView addSubview:self.selectRockButton];
        [_mainMenuView addSubview:self.selectDistortionButton];
        [_mainMenuView addSubview:self.selectLine];

//        [_mainMenuView addSubview:self.selectGreenScreenButton];
    }
    return _mainMenuView;
}
- (UIView *)selectLine{
    if (!_selectLine) {
        _selectLine = [[UIView alloc]initWithFrame:CGRectMake(btnKuan/2-10, 35, 20, 2)];
        _selectLine.backgroundColor = normalColors;
    }
    return _selectLine;
}
// 绘制美颜选择按钮
- (UIButton *)selectBeautyButton {
    if (!_selectBeautyButton) {
        _selectBeautyButton =
        [[UIButton alloc] initWithFrame:CGRectMake(0, 8, btnKuan, 25)];
        if (_isSystemEnglish) {
            [_selectBeautyButton setTitle:@"Beauty" forState:UIControlStateNormal];
        }
        else{
            [_selectBeautyButton setTitle:YZMsg(@"美颜") forState:UIControlStateNormal];
        }
        [_selectBeautyButton setTitleColor:RGB_COLOR(@"#777879", 1) forState:0];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(_selectBeautyButton.right, _selectBeautyButton.top, 1, _selectBeautyButton.height) andColor:RGB_COLOR(@"#777879", 1) andView:_mainMenuView];
        [_selectBeautyButton setTitleColor:normalColors forState:UIControlStateSelected];
        _selectBeautyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectBeautyButton addTarget:self action:@selector(onSelectBeautyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectBeautyButton;
}

//  绘制美型选择按钮
- (UIButton *)selectFaceTrimButton {
    if (!_selectFaceTrimButton) {
        _selectFaceTrimButton =
        [[UIButton alloc] initWithFrame:CGRectMake(btnKuan, 8, btnKuan, 25)];
        if (_isSystemEnglish) {
            [_selectFaceTrimButton setTitle:@"Face Trim" forState:UIControlStateNormal];
        }
        else{
            [_selectFaceTrimButton setTitle:@"美型" forState:UIControlStateNormal];
        }
        [_selectFaceTrimButton setTitleColor:RGB_COLOR(@"#777879", 1) forState:0];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(_selectFaceTrimButton.right, _selectFaceTrimButton.top, 1, _selectFaceTrimButton.height) andColor:RGB_COLOR(@"#777879", 1) andView:_mainMenuView];
        _selectFaceTrimButton.titleLabel.font = [UIFont systemFontOfSize:15];

        [_selectFaceTrimButton setTitleColor:normalColors forState:UIControlStateSelected];
        [_selectFaceTrimButton addTarget:self action:@selector(onSelectFaceTrimButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectFaceTrimButton;
}

// 绘制贴纸选择按钮
- (UIButton *)selectStickerButton {
    if (!_selectStickerButton) {
        _selectStickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectStickerButton.frame = CGRectMake(btnKuan* 2, 8, btnKuan, 25);
        if (_isSystemEnglish) {
            [_selectStickerButton setTitle:@"Sticker" forState:UIControlStateNormal];
        }
        else{
            [_selectStickerButton setTitle:@"萌颜" forState:UIControlStateNormal];
        }
        [_selectStickerButton setTitleColor:RGB_COLOR(@"#777879", 1) forState:0];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(_selectStickerButton.right, _selectStickerButton.top, 1, _selectStickerButton.height) andColor:RGB_COLOR(@"#777879", 1) andView:_mainMenuView];
        _selectStickerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectStickerButton setTitleColor:normalColors forState:UIControlStateSelected];
        [_selectStickerButton addTarget:self action:@selector(onSelectStickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectStickerButton;
}

// 绘制滤镜选择按钮
- (UIButton *)selectFilterButton {
    if (!_selectFilterButton) {
        _selectFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectFilterButton.frame =CGRectMake(btnKuan * 3, 8, btnKuan, 25);

        if (_isSystemEnglish) {
            [_selectFilterButton setTitle:@"Filter" forState:UIControlStateNormal];
        }
        else{
            [_selectFilterButton setTitle:YZMsg(@"滤镜") forState:UIControlStateNormal];
        }
        [_selectFilterButton setTitleColor:RGB_COLOR(@"#777879", 1) forState:0];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(_selectFilterButton.right, _selectFilterButton.top, 1, _selectFilterButton.height) andColor:RGB_COLOR(@"#777879", 1) andView:_mainMenuView];
        _selectFilterButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectFilterButton setTitleColor:normalColors forState:UIControlStateSelected];
        [_selectFilterButton addTarget:self action:@selector(onSelectFilterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectFilterButton;
}

// 绘制Rock选择按钮
- (UIButton *)selectRockButton {
    if (!_selectRockButton) {
        _selectRockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectRockButton.frame = CGRectMake(btnKuan * 4, 8, btnKuan, 25);
        
        if (_isSystemEnglish) {
            [_selectRockButton setTitle:@"Rock" forState:UIControlStateNormal];
        }
        else{
            [_selectRockButton setTitle:@"抖动" forState:UIControlStateNormal];
        }
        [_selectRockButton setTitleColor:RGB_COLOR(@"#777879", 1) forState:0];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(_selectRockButton.right, _selectRockButton.top, 1, _selectRockButton.height) andColor:RGB_COLOR(@"#777879", 1) andView:_mainMenuView];
        _selectRockButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectRockButton setTitleColor:normalColors forState:UIControlStateSelected];
        [_selectRockButton addTarget:self action:@selector(onSelectRockButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectRockButton;
}

// 绘制哈哈镜选择按钮
- (UIButton *)selectDistortionButton {
    if (!_selectDistortionButton) {
        _selectDistortionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectDistortionButton.frame = CGRectMake(btnKuan * 5, 8, btnKuan, 25);
    
        if (_isSystemEnglish) {
            [_selectDistortionButton setTitle:@"Distortion" forState:UIControlStateNormal];
        }
        else{
            [_selectDistortionButton setTitle:@"哈哈镜" forState:UIControlStateNormal];
        }
        [_selectDistortionButton setTitleColor:RGB_COLOR(@"#777879", 1) forState:0];
//        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(_selectRockButton.right, _selectRockButton.top, 1, _selectRockButton.height) andColor:RGB_COLOR(@"#777879", 1) andView:_mainMenuView];
        _selectDistortionButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectDistortionButton setTitleColor:normalColors forState:UIControlStateSelected];
        [_selectDistortionButton addTarget:self action:@selector(onSelectDistortionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectDistortionButton;
}

// 绘制绿幕选择按钮
- (UIButton *)selectGreenScreenButton {
    if (!_selectGreenScreenButton) {
        _selectGreenScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectGreenScreenButton.frame = CGRectMake(btnKuan* 6, 8, btnKuan, 25);
        
        if (_isSystemEnglish) {
            [_selectGreenScreenButton setTitle:@"Green Screen" forState:UIControlStateNormal];
        }
        else{
            [_selectGreenScreenButton setTitle:@"绿幕" forState:UIControlStateNormal];
        }
        [_selectGreenScreenButton setTitleColor:normalColors forState:UIControlStateSelected];
        [_selectGreenScreenButton addTarget:self action:@selector(onSelectGreenScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectGreenScreenButton;
}

// 绘制美颜窗口
- (UIView *)beautyView {
    if (!_beautyView) {
        _beautyView = [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 200)];
        _beautyView.userInteractionEnabled = YES;
        [_beautyView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];

        [_beautyView addSubview:self.beautySkinWhiteningSlider];
        [_beautyView addSubview:self.beautySkinBlemishRemovalSlider];
        [_beautyView addSubview:self.beautySkinSaturationSlider];
        [_beautyView addSubview:self.beautySkinTendernessSlider];
        
        UILabel *labTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 12 + 3 + 12 + 15, 100, 16)];
        [labTitle1 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle1 setTextColor:[UIColor whiteColor]];
        if (_isSystemEnglish) {
            [labTitle1 setText:@"Skin whitening"];
        } else {
            [labTitle1 setText:@"美白"];
        };
        [labTitle1 setTextAlignment:NSTextAlignmentCenter];
        [_beautyView addSubview:labTitle1];
        
        UILabel *labTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 54 + 3 + 12 + 15, 100, 16)];
        [labTitle2 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle2 setTextColor:[UIColor whiteColor]];
        [labTitle2 setTextAlignment:NSTextAlignmentCenter];
        if (_isSystemEnglish) {
            [labTitle2 setText:@"Blemish removal"];
        } else {
            [labTitle2 setText:@"磨皮"];
        }
        [_beautyView addSubview:labTitle2];
        
        UILabel *labTitle3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 95 + 3 + 12 + 15, 100, 16)];
        [labTitle3 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle3 setTextColor:[UIColor whiteColor]];
        [labTitle3 setTextAlignment:NSTextAlignmentCenter];
        if (_isSystemEnglish) {
            [labTitle3 setText:@"Skin saturation"];
        } else {
            [labTitle3 setText:@"饱和"];
        }
        [_beautyView addSubview:labTitle3];
        
        UILabel *labTitle4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 137 + 3 + 12 + 15, 100, 16)];
        [labTitle4 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle4 setTextColor:[UIColor whiteColor]];
        [labTitle4 setTextAlignment:NSTextAlignmentCenter];
        if (_isSystemEnglish) {
            [labTitle4 setText:@"Skin tenderness"];
        } else {
            [labTitle4 setText:@"粉嫩"];
        }
        [_beautyView addSubview:labTitle4];
        
        self.beautySwitchButtonLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(32, 12 + 3 + 52 - 39 + 15, 40, 15)];
        [self.beautySwitchButtonLabel setFont:[UIFont systemFontOfSize:15.f]];
        [self.beautySwitchButtonLabel setTextColor:[UIColor whiteColor]];
        if (_isSystemEnglish) {
            [self.beautySwitchButtonLabel setText:@"Off"];
        } else {
            [self.beautySwitchButtonLabel setText:@"关"];
        }
        
        if (!_isSystemEnglish) {
            self.beautySkinWhiteningSlider.frame =
            CGRectMake(120 - 60, 12 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 + 60 - 20, 20);
            self.beautySkinBlemishRemovalSlider.frame =
            CGRectMake(120 - 60, 54 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 + 60 - 20, 20);
            self.beautySkinSaturationSlider.frame =
            CGRectMake(120 - 60, 96 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 + 60 - 20, 20);
            self.beautySkinTendernessSlider.frame =
            CGRectMake(120 - 60, 138 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 + 60 - 20, 20);
            
            labTitle1.frame = CGRectMake(0, 12 + 3 + 12 + 15, 125 - 60, 16);
            labTitle2.frame = CGRectMake(0, 54 + 3 + 12 + 15, 125 - 60, 16);
            labTitle3.frame = CGRectMake(0, 96 + 3 + 12 + 15, 125 - 60, 16);
            labTitle4.frame = CGRectMake(0, 138 + 3 + 12 + 15, 125 - 60, 16);
            
        }
        
        UILabel *countLabel1 =
        [[UILabel alloc] initWithFrame:CGRectMake(TiScreenWidth - 50, 12 + 3 + 12 + 15, 50, 13)];
        self.beautySkinWhiteningLabel = countLabel1;
        [countLabel1 setText:[NSString stringWithFormat:@"%d", (int) self.beautySkinWhiteningSlider.value]];
        [countLabel1 setTextColor:[UIColor whiteColor]];
        [countLabel1 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel1 setTextAlignment:NSTextAlignmentCenter];
        [_beautyView addSubview:countLabel1];
        
        UILabel *countLabel2 =
        [[UILabel alloc] initWithFrame:CGRectMake(TiScreenWidth - 50, 54 + 3 + 12 + 15, 50, 13)];
        self.beautySkinBlemishRemovalLabel = countLabel2;
        [countLabel2 setText:[NSString stringWithFormat:@"%d", (int) self.beautySkinBlemishRemovalSlider.value]];
        [countLabel2 setTextColor:[UIColor whiteColor]];
        [countLabel2 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_beautyView addSubview:countLabel2];
        
        UILabel *countLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(TiScreenWidth - 50, 96 + 3 + 12 + 15, 50, 13)];
        self.beautySkinSaturationLabel = countLabel3;
        [countLabel3 setText:[NSString stringWithFormat:@"%d", (int) self.beautySkinSaturationSlider.value]];
        [countLabel3 setTextColor:[UIColor whiteColor]];
        [countLabel3 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel3 setTextAlignment:NSTextAlignmentCenter];
        [_beautyView addSubview:countLabel3];
        
        UILabel *countLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(TiScreenWidth - 50, 138 + 3 + 12 + 15, 50, 13)];
        self.beautySkinTendernessLabel = countLabel4;
        [countLabel4 setText:[NSString stringWithFormat:@"%d", (int) self.beautySkinTendernessSlider.value]];
        [countLabel4 setTextColor:[UIColor whiteColor]];
        [countLabel4 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel4 setTextAlignment:NSTextAlignmentCenter];
        [_beautyView addSubview:countLabel4];
        
//        [_beautyView addSubview:self.beautySwitchButton];
    }
    return _beautyView;
}

// 绘制美颜开关按钮
- (UIButton *)beautySwitchButton {
    if (!_beautySwitchButton) {
        _beautySwitchButton =
        [[UIButton alloc] initWithFrame:CGRectMake((TiScreenWidth - 43) / 2, 30, 33, 33)];
        [_beautySwitchButton setImage:[UIImage imageNamed:@"ic_enable_unselected"] forState:UIControlStateNormal];
        [_beautySwitchButton setImage:[UIImage imageNamed:@"ic_enable_selected"] forState:UIControlStateSelected];
        [_beautySwitchButton setSelected:YES];
        _beautySwitchButton.layer.masksToBounds = YES;
        [_beautySwitchButton addTarget:self action:@selector(onBeautySwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautySwitchButton;
}

// 绘制美颜-美白拉条
- (UISlider *)beautySkinWhiteningSlider {
    if (!_beautySkinWhiteningSlider) {
        _beautySkinWhiteningSlider =
        [[UISlider alloc] initWithFrame:CGRectMake(120 - 10, 12 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 - 20, 20)];
        
        //美白指定可变最小值
        _beautySkinWhiteningSlider.minimumValue = 0;
        //美白指定可变最大值
        _beautySkinWhiteningSlider.maximumValue = 100;
        //美白指定初始值
        if (![TiSaveData floatForKey:@"TiSliderWhitening"]) {
            _beautySkinWhiteningSlider.value = 0;
            [TiSaveData setFloat:0 forKey:@"TiSliderWhitening"];
        } else {
            _beautySkinWhiteningSlider.value = [TiSaveData floatForKey:@"TiSliderWhitening"];
        }
  
        [self.tiSDKManager setSkinWhitening:_beautySkinWhiteningSlider.value];
        [_beautySkinWhiteningSlider setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_beautySkinWhiteningSlider setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        [_beautySkinWhiteningSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_beautySkinWhiteningSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_beautySkinWhiteningSlider addTarget:self action:@selector(onBeautySkinWhiteningSliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySkinWhiteningSlider;
}

// 绘制美颜-磨皮拉条
- (UISlider *)beautySkinBlemishRemovalSlider {
    if (!_beautySkinBlemishRemovalSlider) {
        _beautySkinBlemishRemovalSlider =
        [[UISlider alloc] initWithFrame:CGRectMake(120 - 10, 54 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 - 20, 20)];
        //磨皮指定可变最小值
        _beautySkinBlemishRemovalSlider.minimumValue = 0;
        //磨皮指定可变最大值
        _beautySkinBlemishRemovalSlider.maximumValue = 100;
        if (![TiSaveData floatForKey:@"TiSliderMicrodermabrasion"]) {
            _beautySkinBlemishRemovalSlider.value = 0;
            [TiSaveData setFloat:0 forKey:@"TiSliderMicrodermabrasion"];
        } else {
            _beautySkinBlemishRemovalSlider.value = [TiSaveData floatForKey:@"TiSliderMicrodermabrasion"];
        }
        
        [self.tiSDKManager setSkinBlemishRemoval:_beautySkinBlemishRemovalSlider.value];
        [_beautySkinBlemishRemovalSlider setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_beautySkinBlemishRemovalSlider setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        [_beautySkinBlemishRemovalSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_beautySkinBlemishRemovalSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_beautySkinBlemishRemovalSlider addTarget:self action:@selector(onBeautySkinBlemishRemovalSliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySkinBlemishRemovalSlider;
}

// 绘制美颜-饱和拉条
- (UISlider *)beautySkinSaturationSlider {
    if (!_beautySkinSaturationSlider) {
        _beautySkinSaturationSlider =
        [[UISlider alloc] initWithFrame:CGRectMake(120 - 10, 96 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 - 20, 20)];
        //饱和指定可变最小值
        _beautySkinSaturationSlider.minimumValue = 0;
        //饱和指定可变最大值
        _beautySkinSaturationSlider.maximumValue = 100;
        //饱和指定初始值
        if (![TiSaveData floatForKey:@"TiSliderSaturation"]) {
            _beautySkinSaturationSlider.value = 0;
            [TiSaveData setFloat:0 forKey:@"TiSliderSaturation"];
        } else {
            _beautySkinSaturationSlider.value = [TiSaveData floatForKey:@"TiSliderSaturation"];
        }
        
        [self.tiSDKManager setSkinSaturation:_beautySkinSaturationSlider.value];
        [_beautySkinSaturationSlider setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_beautySkinSaturationSlider setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_beautySkinSaturationSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_beautySkinSaturationSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_beautySkinSaturationSlider addTarget:self action:@selector(onBeautySkinSaturationSliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySkinSaturationSlider;
}

// 绘制美颜-粉嫩拉条
- (UISlider *)beautySkinTendernessSlider {
    if (!_beautySkinTendernessSlider) {
        _beautySkinTendernessSlider =
        [[UISlider alloc] initWithFrame:CGRectMake(120 - 10, 138 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 - 20, 20)];
        //磨皮指定可变最小值
        _beautySkinTendernessSlider.minimumValue = 0;
        //磨皮指定可变最大值
        _beautySkinTendernessSlider.maximumValue = 100;
        //磨皮指定初始值
        if (![TiSaveData floatForKey:@"TiSliderPinkistender"]) {
            _beautySkinTendernessSlider.value = 0;
            [TiSaveData setFloat:0 forKey:@"TiSliderPinkistender"];
        } else {
            _beautySkinTendernessSlider.value = [TiSaveData floatForKey:@"TiSliderPinkistender"];
        }
        
        [self.tiSDKManager setSkinTenderness:_beautySkinTendernessSlider.value];
        
        [_beautySkinTendernessSlider setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_beautySkinTendernessSlider setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_beautySkinTendernessSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_beautySkinTendernessSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_beautySkinTendernessSlider addTarget:self action:@selector(onBeautySkinTendernessSliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _beautySkinTendernessSlider;
}

// 绘制美型窗口
- (UIView *)faceTrimView {
    if (!_faceTrimView) {
        _faceTrimView =
        [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 112)];
        [_faceTrimView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_faceTrimView setBackgroundColor:[UIColor blackColor]];

        [_faceTrimView addSubview:self.faceTrimEyeMagnifyingSlider];
        [_faceTrimView addSubview:self.faceTrimChinSlimmingSlider];
        
        UILabel *labTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 100, 16)];
        [labTitle1 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle1 setTextColor:[UIColor whiteColor]];
        if (_isSystemEnglish) {
            [labTitle1 setText:@"Eye magnifying"];
        } else {
            [labTitle1 setText:@"大眼"];
        }
        
        [labTitle1 setTextAlignment:NSTextAlignmentCenter];
        [_faceTrimView addSubview:labTitle1];
        
        UILabel *labTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 100, 16)];
        [labTitle2 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle2 setTextColor:[UIColor whiteColor]];
        [labTitle2 setTextAlignment:NSTextAlignmentCenter];
        if (_isSystemEnglish) {
            [labTitle2 setText:@"Chin slimming"];
        } else {
            [labTitle2 setText:@"瘦脸"];
        }
        
        [_faceTrimView addSubview:labTitle2];
        
        self.faceTrimSwitchButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 43, 40, 15)];
        [self.faceTrimSwitchButtonLabel setFont:[UIFont systemFontOfSize:15.f]];
        [self.faceTrimSwitchButtonLabel setTextColor:[UIColor whiteColor]];
        if (_isSystemEnglish) {
            [self.faceTrimSwitchButtonLabel setText:@"On"];
        } else {
            [self.faceTrimSwitchButtonLabel setText:@"开"];
        }
        
        if (!_isSystemEnglish) {
            labTitle1.frame = CGRectMake(0, 12 + 3 + 12 + 15, 125 - 60, 16);
            labTitle2.frame = CGRectMake(0, 54 + 3 + 12 + 15, 125 - 60, 16);
            
            self.faceTrimEyeMagnifyingSlider.frame =
            CGRectMake(120 - 60, 12 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 + 60 - 20, 20);
            self.faceTrimChinSlimmingSlider.frame =
            CGRectMake(120 - 60, 54 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 + 60 - 20, 20);
        }
        
        UILabel *eyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(TiScreenWidth - 50, 12 + 3 + 12 + 15, 50, 13)];
        self.faceTrimEyeMagnifyingLabel = eyeLabel;
        [eyeLabel setText:[NSString stringWithFormat:@"%d", (int) self.faceTrimEyeMagnifyingSlider.value]];
        [eyeLabel setTextColor:[UIColor whiteColor]];
        [eyeLabel setFont:[UIFont systemFontOfSize:11.f]];
        [eyeLabel setTextAlignment:NSTextAlignmentCenter];
        [_faceTrimView addSubview:eyeLabel];
        
        UILabel *faceLabel = [[UILabel alloc] initWithFrame:CGRectMake(TiScreenWidth - 50, 54 + 3 + 12 + 15, 50, 13)];
        self.faceTrimChinSlimmingLabel = faceLabel;
        [faceLabel setText:[NSString stringWithFormat:@"%d", (int) self.faceTrimChinSlimmingSlider.value]];
        [faceLabel setTextColor:[UIColor whiteColor]];
        [faceLabel setFont:[UIFont systemFontOfSize:11.f]];
        [faceLabel setTextAlignment:NSTextAlignmentCenter];
        [_faceTrimView addSubview:faceLabel];
        
//        [_faceTrimView addSubview:self.faceTrimSwitchButton];
    }
    return _faceTrimView;
}

// 绘制美型开关按钮
- (UIButton *)faceTrimSwitchButton {
    if (!_faceTrimSwitchButton) {
        _faceTrimSwitchButton = [[UIButton alloc] initWithFrame:CGRectMake((TiScreenWidth - 43) / 2, 30, 33, 33)];
        [_faceTrimSwitchButton setImage:[UIImage imageNamed:@"ic_enable_unselected"] forState:UIControlStateNormal];
        [_faceTrimSwitchButton setImage:[UIImage imageNamed:@"ic_enable_selected"] forState:UIControlStateSelected];
        [_faceTrimSwitchButton setSelected:YES];
        _faceTrimSwitchButton.layer.masksToBounds = YES;
        [_faceTrimSwitchButton addTarget:self action:@selector(onFaceTrimSwitchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceTrimSwitchButton;
}

// 绘制美型-大眼拉条
- (UISlider *)faceTrimEyeMagnifyingSlider {
    if (!_faceTrimEyeMagnifyingSlider) {
        _faceTrimEyeMagnifyingSlider =
        [[UISlider alloc] initWithFrame:CGRectMake(120 - 10, 12 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 - 20, 20)];
        
        _faceTrimEyeMagnifyingSlider.minimumValue = 0;
        _faceTrimEyeMagnifyingSlider.maximumValue = 100;
        
        if (![TiSaveData floatForKey:@"TiSliderEyeMagnifying"]) {
            _faceTrimEyeMagnifyingSlider.value = 0;
            [TiSaveData setFloat:0 forKey:@"TiSliderEyeMagnifying"];
        } else {
            _faceTrimEyeMagnifyingSlider.value = [TiSaveData floatForKey:@"TiSliderEyeMagnifying"];
        }
    
        [self.tiSDKManager setEyeMagnifying:_faceTrimEyeMagnifyingSlider.value];
        
        [_faceTrimEyeMagnifyingSlider setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_faceTrimEyeMagnifyingSlider setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        [_faceTrimEyeMagnifyingSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_faceTrimEyeMagnifyingSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_faceTrimEyeMagnifyingSlider addTarget:self action:@selector(onFaceTrimEyeMagnifyingSliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _faceTrimEyeMagnifyingSlider;
}

// 绘制美型-瘦脸拉条
- (UISlider *)faceTrimChinSlimmingSlider {
    if (!_faceTrimChinSlimmingSlider) {
        _faceTrimChinSlimmingSlider =
        [[UISlider alloc] initWithFrame:CGRectMake(120 - 10, 54 + 12 + 15, TiScreenWidth - 67 - 32 - 20 - 30 - 20, 20)];
        
        //瘦脸指定可变最小值
        _faceTrimChinSlimmingSlider.minimumValue = 0;
        //瘦脸指定可变最大值
        _faceTrimChinSlimmingSlider.maximumValue = 100;
    
        if (![TiSaveData floatForKey:@"TiSliderChinSlimming"]) {
            _faceTrimChinSlimmingSlider.value = 0;
            [TiSaveData setFloat:0 forKey:@"TiSliderChinSlimming"];
        } else {
            _faceTrimChinSlimmingSlider.value = [TiSaveData floatForKey:@"TiSliderChinSlimming"];
        }
        
        [self.tiSDKManager setChinSlimming:_faceTrimChinSlimmingSlider.value];
        
        [_faceTrimChinSlimmingSlider setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_faceTrimChinSlimmingSlider setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        [_faceTrimChinSlimmingSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_faceTrimChinSlimmingSlider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_faceTrimChinSlimmingSlider addTarget:self action:@selector(onFaceTrimChinSlimmingSliderClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _faceTrimChinSlimmingSlider;
}

// 绘制贴纸窗口
- (UIView *)stickerView {
    if (!_stickerView) {
        _stickerView = [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 240)];
        [_stickerView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_stickerView setBackgroundColor:[UIColor blackColor]];

        _stickerView.userInteractionEnabled = YES;
        [_stickerView addSubview:self.stickerCollectionView];
    }
    return _stickerView;
}

// 绘制贴纸选择窗口
- (UICollectionView *)stickerCollectionView {
    if (!_stickerCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionCell 的大小
        flowLayout.itemSize = CGSizeMake((TiScreenWidth) / 7, (TiScreenWidth) / 7);
        //定义每个UICollectionCell 横向的间距
        flowLayout.minimumLineSpacing = 10;
        //定义每个UICollectionCell 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个UICollectionCell 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 40, 20);//上左下右
        
        _stickerCollectionView =
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, TiScreenWidth, 200) collectionViewLayout:flowLayout];
        
        //注册cell
        [_stickerCollectionView registerClass:[TiStickerCell class] forCellWithReuseIdentifier:TiStickerCellIdentifier];
        
        //设置代理
        _stickerCollectionView.delegate = self;
        _stickerCollectionView.dataSource = self;
        
        //背景颜色
        _stickerCollectionView.backgroundColor = [UIColor clearColor];
        
        //自适应大小
        _stickerCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    return _stickerCollectionView;
}

// 绘制滤镜窗口
- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 90)];
        [_filterView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_filterView setBackgroundColor:[UIColor blackColor]];

        [_filterView addSubview:self.filterCollectionView];
    }
    return _filterView;
}

// 绘制滤镜选择窗口
- (UICollectionView *)filterCollectionView {
    if (!_filterCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(55, 80);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 10;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(21, 16, 24, 21);//上左下右
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
        _filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TiScreenWidth, 101) collectionViewLayout:flowLayout];
        //注册cell
//        [_filterCollectionView registerClass:[TiUICell class] forCellWithReuseIdentifier:TiUICellIdentifier];
        [_filterCollectionView registerNib:[UINib nibWithNibName:@"TiFitterCell" bundle:nil] forCellWithReuseIdentifier:TiUICellIdentifier];

        //设置代理
        _filterCollectionView.delegate = self;
        _filterCollectionView.dataSource = self;
        //背景颜色
        _filterCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _filterCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _filterCollectionView;

}

// 绘制Rock 窗口
- (UIView *)rockView {
    if (!_rockView) {
        _rockView = [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 90)];
        [_rockView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_rockView setBackgroundColor:[UIColor blackColor]];

        [_rockView addSubview:self.rockCollectionView];
    }
    return _rockView;
}

// 绘制Rock选择窗口
- (UICollectionView *)rockCollectionView {
    if (!_rockCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((TiScreenWidth) / 7 + 10, (TiScreenWidth) / 7);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 15;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 15;
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(21, 16, 24, 21);//上左下右
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
        
        _rockCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TiScreenWidth, 101) collectionViewLayout:flowLayout];
        //注册cell
        [_rockCollectionView registerClass:[TiUICell class] forCellWithReuseIdentifier:TiUICellIdentifier];
        
        //设置代理
        _rockCollectionView.delegate = self;
        _rockCollectionView.dataSource = self;
        
        //背景颜色
        _rockCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _rockCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _rockCollectionView;
}

// 绘制哈哈镜窗口
- (UIView *)distortionView {
    if (!_distortionView) {
        _distortionView = [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 110)];
        [_distortionView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_distortionView setBackgroundColor:[UIColor blackColor]];

        [_distortionView addSubview:self.distortionCollectionView];
    }
    return _distortionView;
}

// 绘制哈哈镜选择窗口
- (UICollectionView *)distortionCollectionView {
    if (!_distortionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake(80, 100);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 10;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
//        flowLayout.sectionInset = UIEdgeInsetsMake(21, 16, 24, 21);//上左下右
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
        
        _distortionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TiScreenWidth, 100) collectionViewLayout:flowLayout];
        //注册cell
//        [_distortionCollectionView registerClass:[TiUICell class] forCellWithReuseIdentifier:TiUICellIdentifier];
        [_distortionCollectionView registerNib:[UINib nibWithNibName:@"TIRecordCell" bundle:nil] forCellWithReuseIdentifier:@"TIRecordCELL"];

        //设置代理
        _distortionCollectionView.delegate = self;
        _distortionCollectionView.dataSource = self;
        
        //背景颜色
        _distortionCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _distortionCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _distortionCollectionView;
}

// 绘制绿幕窗口
- (UIView *)greenScreenView {
    if (!_greenScreenView) {
        _greenScreenView = [[UIView alloc] initWithFrame:CGRectMake(0, TiScreenHeight, TiScreenWidth, 90)];
        [_greenScreenView setBackgroundColor:TiRGBA(0, 0, 0, 0.5)];
//        [_greenScreenView setBackgroundColor:[UIColor blackColor]];

        [_greenScreenView addSubview:self.greenScreenCollectionView];
    }
    return _greenScreenView;
}

// 绘制绿幕选择窗口
- (UICollectionView *)greenScreenCollectionView {
    if (!_greenScreenCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((TiScreenWidth) / 7 + 10, (TiScreenWidth) / 7);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 15;
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 15;
        flowLayout.sectionInset = UIEdgeInsetsMake(21, 16, 24, 21);//上左下右
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
        
        _greenScreenCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, TiScreenWidth, 101) collectionViewLayout:flowLayout];
        //注册cell
        [_greenScreenCollectionView registerClass:[TiUICell class] forCellWithReuseIdentifier:TiUICellIdentifier];
        
        //设置代理
        _greenScreenCollectionView.delegate = self;
        _greenScreenCollectionView.dataSource = self;
        
        //背景颜色
        _greenScreenCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _greenScreenCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _greenScreenCollectionView;
}

/////////////////////// UI绘制 开始 ///////////////////////

/////////////////////// 响应事件 开始 ///////////////////////
// tap手势响应事件
- (void)onTap:(UITapGestureRecognizer *)recognizer {
    [self popAllViews];
}

// 总开关响应事件
- (void)onMainSwitchButtonClick:(UIButton *)sender {
    [self pushMainMenuView:YES];
}

// 美颜选择按钮响应事件
- (void)onSelectBeautyButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
}

// 美型选择按钮响应事件
- (void)onSelectFaceTrimButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
}

// 贴纸选择按钮响应事件
- (void)onSelectStickerButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
}

// 滤镜选择按钮响应事件
- (void)onSelectFilterButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
}

// Rock选择按钮响应事件
- (void)onSelectRockButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
}

// 哈哈镜选择按钮响应事件
- (void)onSelectDistortionButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
}

// 绿幕选择按钮响应事件
- (void)onSelectGreenScreenButtonClick:(UIButton *)sender {
    [self switchButtonInMainMenu:sender];
} 

// 美颜开关按钮响应实现
- (void)onBeautySwitchButtonClick:(UIButton *)sender {
    [TiSaveData setValue:[NSNumber numberWithBool:sender.isSelected] forKey:@"TiEnableBeautyFilter"];
    
    [sender setSelected:!sender.isSelected];
    
    BOOL enable = sender.isSelected;
    
    [self.tiSDKManager setBeautyEnable:enable];
    [self.beautySkinWhiteningSlider setEnabled:enable];
    [self.beautySkinBlemishRemovalSlider setEnabled:enable];
    [self.beautySkinSaturationSlider setEnabled:enable];
    [self.beautySkinTendernessSlider setEnabled:enable];
}

// 美颜-美白拉条响应事件
- (void)onBeautySkinWhiteningSliderClick:(UISlider *)sender {
    self.beautySkinWhiteningLabel.text = [NSString stringWithFormat:@"%d", (int) sender.value];
    
    [self.tiSDKManager setSkinWhitening:sender.value];
    
    [TiSaveData setFloat:sender.value forKey:@"TiSliderWhitening"];
    if (sender.value == 0) {
        [TiSaveData setFloat:0.01 forKey:@"TiSliderWhitening"];
    }
}

// 美颜-磨皮拉条响应事件
- (void)onBeautySkinBlemishRemovalSliderClick:(UISlider *)sender {
    self.beautySkinBlemishRemovalLabel.text = [NSString stringWithFormat:@"%d", (int) sender.value];
    [self.tiSDKManager setSkinBlemishRemoval:sender.value];
    
    [TiSaveData setFloat:sender.value forKey:@"TiSliderMicrodermabrasion"];
    if (sender.value == 0) {
        [TiSaveData setFloat:0.01 forKey:@"TiSliderMicrodermabrasion"];
    }
}

// 美颜-饱和拉条响应事件
- (void)onBeautySkinSaturationSliderClick:(UISlider *)sender {
    self.beautySkinSaturationLabel.text = [NSString stringWithFormat:@"%d", (int) sender.value];
    [self.tiSDKManager setSkinSaturation:sender.value];
    
    [TiSaveData setFloat:sender.value forKey:@"TiSliderSaturation"];
    if (sender.value == 0) {
        [TiSaveData setFloat:0.01 forKey:@"TiSliderSaturation"];
    }
}

// 美颜-粉嫩拉条响应事件
- (void)onBeautySkinTendernessSliderClick:(UISlider *)sender {
    self.beautySkinTendernessLabel.text = [NSString stringWithFormat:@"%d", (int) sender.value];
    [self.tiSDKManager setSkinTenderness:sender.value];
    
    [TiSaveData setFloat:sender.value forKey:@"TiSliderPinkistender"];
    if (sender.value == 0) {
        [TiSaveData setFloat:0.01 forKey:@"TiSliderPinkistender"];
    }
}

// 美型开关按钮响应事件
- (void)onFaceTrimSwitchButtonClick:(UIButton *)sender {
    [TiSaveData setValue:[NSNumber numberWithBool:sender.isSelected] forKey:@"TiEnableBigEyeSlimChin"];
   
    [sender setSelected:!sender.isSelected];
    
    BOOL enable = sender.isSelected;
    
    [self.tiSDKManager setFaceTrimEnable:enable];
    [self.faceTrimEyeMagnifyingSlider setEnabled:enable];
    [self.faceTrimChinSlimmingSlider setEnabled:enable];
}

// 美型-大眼拉条响应事件
- (void)onFaceTrimEyeMagnifyingSliderClick:(UISlider *)sender {
    self.faceTrimEyeMagnifyingLabel.text = [NSString stringWithFormat:@"%d", (int) sender.value];
    
    [self.tiSDKManager setEyeMagnifying:sender.value];
    [TiSaveData setFloat:sender.value forKey:@"TiSliderEyeMagnifying"];
    
    if (sender.value == 0) {
        [TiSaveData setFloat:0.01 forKey:@"TiSliderEyeMagnifying"];
    }
}

// 美型-瘦脸拉条响应事件
- (void)onFaceTrimChinSlimmingSliderClick:(UISlider *)sender {
    self.faceTrimChinSlimmingLabel.text = [NSString stringWithFormat:@"%d", (int) sender.value];
    
    [self.tiSDKManager setChinSlimming:sender.value];
    [TiSaveData setFloat:sender.value forKey:@"TiSliderChinSlimming"];
    if (sender.value == 0) {
        [TiSaveData setFloat:0.01 forKey:@"TiSliderChinSlimming"];
    }
}

/////////////////////// 响应事件 结束 ///////////////////////

/////////////////////// UI控制 开始 ///////////////////////
- (void)clearAllViews {
    for (UIView *subView in self.superView.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)popAllViews {
    if (self.currentPopView != nil) {
        [self turnOffAllButtonsInMainMenu];
        
        [self hideSubview:self.currentPopView];
        self.currentPopView = nil;
    }
    
    if (self.currentMainMenuPopView != nil) {
        if ([self.currentMainMenuPopView isEqual:self.mainMenuView]) {
            [self pushMainMenuView:NO];
        } else {
            [self pushFilterView:NO];
        }
        
        [self havePushed:NO];
    }
    [self.delegate showPreFrontView];

}

- (void)turnOffAllButtonsInMainMenu {
    [self.selectBeautyButton setSelected:NO];
    [self.selectFaceTrimButton setSelected:NO];
    [self.selectStickerButton setSelected:NO];
    [self.selectFilterButton setSelected:NO];
    [self.selectRockButton setSelected:NO];
    [self.selectDistortionButton setSelected:NO];
    [self.selectGreenScreenButton setSelected:NO];
}

- (void)hideSubview:(UIView *)view {
    CGRect frame = view.frame;
    frame.origin.y = TiScreenHeight;
    view.frame = frame;
}

- (void)showSubview:(UIView *)view {
    [view setHidden:NO];
    CGRect frame = view.frame;
    
    if ([view isEqual:self.beautyView]) {
        frame.origin.y = TiScreenHeight - 200 - 42 -ShowDiff;
    } else if ([view isEqual:self.faceTrimView]) {
        frame.origin.y = TiScreenHeight - 175 - 42 - 12 - 15 + 90-ShowDiff;
    } else if ([view isEqual:self.stickerView]) {
        frame.origin.y = TiScreenHeight - 240 - 42-ShowDiff;
    } else if ([view isEqual:self.filterView]) {
        frame.origin.y = TiScreenHeight - 130-ShowDiff;
    } else if ([view isEqual:self.rockView]) {
        frame.origin.y = TiScreenHeight - 130-ShowDiff;
    } else if ([view isEqual:self.distortionView]) {
        frame.origin.y = TiScreenHeight - 150-ShowDiff;
    } else if ([view isEqual:self.greenScreenView]) {
        frame.origin.y = TiScreenHeight - 130-ShowDiff;
    }
    else {
        frame.origin.y = TiScreenHeight - 185 - 42-ShowDiff;
    }
    
    view.frame = frame;
}

- (void)pushMainMenuView:(BOOL)isPop {
    [self havePushed:YES];
    
    if (isPop) {
        self.currentMainMenuPopView = self.mainMenuView;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.filterView.frame;
            frame.origin.y = TiScreenHeight - 42-ShowDiff;
            self.mainMenuView.frame = frame;
            [self onSelectBeautyButtonClick:self.selectBeautyButton];
        }];
    } else {
        self.currentMainMenuPopView = nil;
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.filterView.frame;
            frame.origin.y = TiScreenHeight;
            self.mainMenuView.frame = frame;
        }];
    }
}

- (void)pushFilterView:(BOOL)isPop {
    [self havePushed:YES];
    
    if (isPop) {
        self.currentMainMenuPopView = self.filterView;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.filterView.frame;
            frame.origin.y = TiScreenHeight - 99 -ShowDiff;
            self.filterView.frame = frame;
        }];
    } else {
        self.currentMainMenuPopView = nil;
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.filterView.frame;
            frame.origin.y = TiScreenHeight;
            self.filterView.frame = frame;
        }];
    }
}

- (void)havePushed:(BOOL)isPush {
    if (!isPush) {
        [self.mainSwitchButton setAlpha:0];
        [self.mainSwitchButton setHidden:isPush];
        [UIView animateWithDuration:0.6 animations:^{
            [self.mainSwitchButton setAlpha:1];
        }];
        
        [tapView setHidden:YES];
    } else {
        [self.mainSwitchButton setHidden:isPush];
        
        [tapView setHidden:NO];
        
    }
}

- (void)switchButtonInMainMenu:(UIButton *)sender {
    BOOL enable = sender.isSelected;
    
    [self turnOffAllButtonsInMainMenu];
    if (enable) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    int i = 0;
    if ([sender isEqual:self.selectBeautyButton]) {
        self.nextPopView = self.beautyView;
        i = 0;
    } else if ([sender isEqual:self.selectFaceTrimButton]) {
        self.nextPopView = self.faceTrimView;
        i = 1;
    } else if ([sender isEqual:self.selectStickerButton]) {
        self.nextPopView = self.stickerView;
        i = 2;
    } else if ([sender isEqual:self.selectFilterButton]) {
        self.nextPopView = self.filterView;
        i = 3;
    } else if ([sender isEqual:self.selectRockButton]) {
        self.nextPopView = self.rockView;
        i = 4;
    } else if ([sender isEqual:self.selectDistortionButton]) {
        self.nextPopView = self.distortionView;
        i = 5;
    } else if ([sender isEqual:self.selectGreenScreenButton]) {
        self.nextPopView = self.greenScreenView;
        i = 6;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.selectLine.x = btnKuan*i+(btnKuan/2-10);
    }];
    [self lockButtonsInMainMenu:NO];
    
    if (self.currentPopView != nil) {
        if (self.nextPopView != nil) {
            if (![self.currentPopView isEqual:self.nextPopView]) {
                [UIView animateWithDuration:0.3 animations:^{
                    [self hideSubview:self.currentPopView];
                    [self showSubview:self.nextPopView];
                } completion:^(BOOL finished) {
                    [self lockButtonsInMainMenu:YES];
                }];
            } else {
                //判断是否被选中 如果非选中状态 则隐藏当前窗口
                if (!sender.isSelected) {
                    [UIView animateWithDuration:0.1 animations:^{
                        [self hideSubview:self.currentPopView];
                    }                completion:^(BOOL finished) {
                        [self lockButtonsInMainMenu:YES];
                    }];
                } else {
                    [UIView animateWithDuration:0.3 animations:^{
                        [self showSubview:self.currentPopView];
                    }                completion:^(BOOL finished) {
                        [self lockButtonsInMainMenu:YES];
                    }];
                }
            }
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                [self hideSubview:self.currentPopView];
            }                completion:^(BOOL finished) {
                [self lockButtonsInMainMenu:YES];
            }];
        }
    } else {
        if (self.nextPopView != nil) {
            [UIView animateWithDuration:0.3 animations:^{
                [self showSubview:self.nextPopView];
            }                completion:^(BOOL finished) {
                [self lockButtonsInMainMenu:YES];
            }];
        } else {
            [self lockButtonsInMainMenu:YES];
        }
    }
    
    self.currentPopView = self.nextPopView;
    self.nextPopView = nil;
}

- (void)lockButtonsInMainMenu:(BOOL)isEnable {
    [self.selectBeautyButton setEnabled:isEnable];
    [self.selectFaceTrimButton setEnabled:isEnable];
    [self.selectStickerButton setEnabled:isEnable];
    [self.selectFilterButton setEnabled:isEnable];
    [self.selectRockButton setEnabled:isEnable];
    [self.selectDistortionButton setEnabled:isEnable];
    [self.selectGreenScreenButton setEnabled:isEnable];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (collectionView == self.stickerCollectionView) {
        if (section == 0) {
            count = self.stickerArray.count + 1;
        }
    } else if (collectionView == self.filterCollectionView) {
        if (section == 0) {
//            count = FILTER_CELL_COUNTER + 1;
            count = _fitterNameArray.count;
        }
    } else if (collectionView == self.rockCollectionView) {
        if (section == 0) {
            count = ROCK_CELL_COUNTER + 1;
        }
    } else if (collectionView == self.distortionCollectionView) {
        if (section == 0) {
            count = DISTORTION_CELL_COUNTER + 1;
        }
    } else if (collectionView == self.greenScreenCollectionView) {
        if (section == 0) {
            count = GREEN_SCREEN_CELL_COUNTER + 1;
        }
    }
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    
    if (collectionView == self.stickerCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiStickerCellIdentifier forIndexPath:indexPath];
        [cell sizeToFit];
        
        if (indexPath.item <= 0) {
            [((TiStickerCell *) cell) setSticker:nil index:indexPath.item];
        } else {
            TiSticker *sticker = self.stickerArray[indexPath.item - 1];
            [((TiStickerCell *) cell) setSticker:sticker index:indexPath.item];
        }
        
        if (self.currentStickerIndex == indexPath.item - 1) {
            [((TiStickerCell *) cell) hideBackView:NO];
        } else {
            [((TiStickerCell *) cell) hideBackView:YES];
        }
    } else if (collectionView == self.filterCollectionView) {
//        cell = (TiFitterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:TiUICellIdentifier forIndexPath:indexPath];
//        [cell sizeToFit];
        TiFitterCell *fcell = (TiFitterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TiUICellIdentifier" forIndexPath:indexPath];
        fcell.thumbImageView.image = [UIImage imageNamed:_fitterNameArray[indexPath.row]];
        if (_filterEnumIndex == indexPath.item - 1) {
            [((TiUICell *) cell) changeCellEffect:NO];
            fcell.selectImageView.hidden = NO;
        } else {
            fcell.selectImageView.hidden = YES;
//            [((TiUICell *) cell) changeCellEffect:YES];
        }
        return  fcell;
//        [((TiUICell *) cell) setFilterUICellByIndex:indexPath.item];
        
    } else if (collectionView == self.rockCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUICellIdentifier forIndexPath:indexPath];
        [cell sizeToFit];
        
        if (_rockEnumIndex == indexPath.item - 1) {
            [((TiUICell *) cell) changeCellEffect:NO];
        } else {
            [((TiUICell *) cell) changeCellEffect:YES];
        }
        
        [((TiUICell *) cell) setRockUICellByIndex:indexPath.item];
        
    } else if (collectionView == self.distortionCollectionView) {
        TIRecordCell *fcell = (TIRecordCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TIRecordCELL" forIndexPath:indexPath];

        if (_distortionEnumIndex == indexPath.item - 1) {
            [((TIRecordCell *) fcell) changeCellEffect:NO];
        } else {
            [((TIRecordCell *) fcell) changeCellEffect:YES];
        }
        
        [((TIRecordCell *) fcell) setDistortionUICellByIndex:indexPath.item];
        return fcell;
    } else if (collectionView == self.greenScreenCollectionView) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:TiUICellIdentifier forIndexPath:indexPath];
        [cell sizeToFit];
        
        if (_greenScreenEnumIndex == indexPath.item - 1) {
            [((TiUICell *) cell) changeCellEffect:NO];
        } else {
            [((TiUICell *) cell) changeCellEffect:YES];
        }
        
        [((TiUICell *) cell) setGreenScreenUICellByIndex:indexPath.item];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.stickerCollectionView) {
        //选中同一个cell不做处理
        if (self.currentStickerIndex == indexPath.item - 1 ) {
            return;
        }
        
        if (indexPath.item > 0) {
            TiSticker *sticker = self.stickerArray[indexPath.item - 1];
            if (sticker.isDownload == NO) {
                [[TiStickerDownloadManager sharedInstance] downloadSticker:sticker index:indexPath.item  - 1 withAnimation:^(NSInteger index) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index  + 1 inSection:0];
                    TiStickerCell *cell = (TiStickerCell *) [self.stickerCollectionView cellForItemAtIndexPath:indexPath];
                    [cell startDownload];
                } successed:^(TiSticker *sticker, NSInteger index) {
                    sticker.downloadState = TiStickerDownloadStateDownoadDone;

                    [self.stickerArray replaceObjectAtIndex:index withObject:sticker];

                    //回到主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (collectionView) {
                            for (NSIndexPath *path in collectionView.indexPathsForVisibleItems) {
                                if (index == path.item) {
                                    [collectionView reloadData];
                                    break;
                                }
                            }
                        }
                    });
                } failed:^(TiSticker *sticker, NSInteger index) {
                    sticker.downloadState = TiStickerDownloadStateDownoadNot;
                    //回到主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectionView reloadData];
                        // TODO: 提示用户网络不给力
                    });
                }];
                return;
            }
        }
        
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.currentStickerIndex+1  inSection:0];
        TiStickerCell *lastCell = (TiStickerCell *) [collectionView cellForItemAtIndexPath:lastPath];
        [lastCell hideBackView:YES];
        
        //渲染指定贴纸
        // TODO
        self.currentStickerIndex = indexPath.item-1;
        
        if (self.currentStickerIndex >= 0 && self.currentStickerIndex < self.stickerArray.count + 1) {
             [self.tiSDKManager setStickerName:[self.stickerArray objectAtIndex:self.currentStickerIndex].stickerName];
        } else {
            [self.tiSDKManager setStickerName:@""];
        }
        
        //显示选中cell的背景
        TiStickerCell *cell = (TiStickerCell *) [collectionView cellForItemAtIndexPath:indexPath];
        [cell hideBackView:NO];
        
        //不刷新会导致背景框显示错误
        [collectionView reloadItemsAtIndexPaths:@[indexPath, lastPath]];
    } else if (collectionView == self.filterCollectionView) {
        if (_filterEnumIndex == indexPath.item - 1) {
            return;
        }
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_filterEnumIndex + 1 inSection:0];
        TiFitterCell *lastCell = (TiFitterCell *) [collectionView cellForItemAtIndexPath:lastPath];
//        [lastCell changeCellEffect:YES];
        lastCell.selectImageView.hidden = YES;
        _filterEnumIndex = indexPath.item -1;
        
        if (indexPath.item -1 >= -1) {
            [self.tiSDKManager setFilterEnum:[self setFilterEnumByIndex:(int)indexPath.item]];
        }
        
        TiFitterCell *cell = (TiFitterCell *) [collectionView cellForItemAtIndexPath:indexPath];
//        [cell changeCellEffect:NO];
        cell.selectImageView.hidden = NO;
        [collectionView reloadItemsAtIndexPaths:@[indexPath, lastPath]];
        
    } else if (collectionView == self.rockCollectionView) {
        if (_rockEnumIndex == indexPath.item - 1) {
            return;
        }
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_rockEnumIndex +1 inSection:0];
        
        TiUICell *lastCell = (TiUICell *) [collectionView cellForItemAtIndexPath:lastPath];
        [lastCell changeCellEffect:YES];
        _rockEnumIndex = indexPath.item -1;
        if (indexPath.item -1 >= -1) {
            [self.tiSDKManager setRockEnum:[self setRockEnumByIndex:(int)indexPath.item]];
        }
        TiUICell *cell = (TiUICell *) [collectionView cellForItemAtIndexPath:indexPath];
        [cell changeCellEffect:NO];
        [collectionView reloadItemsAtIndexPaths:@[indexPath, lastPath]];
        
    } else if (collectionView == self.distortionCollectionView) {
        if (_distortionEnumIndex == indexPath.item - 1) {
            return;
        }
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_distortionEnumIndex +1 inSection:0];
        
        TIRecordCell *lastCell = (TIRecordCell *) [collectionView cellForItemAtIndexPath:lastPath];
        [lastCell changeCellEffect:YES];
        _distortionEnumIndex = indexPath.item -1;
        if (indexPath.item -1 >= -1) {
            [self.tiSDKManager setDistortionEnum:[self setDistortionEnumByIndex:(int)indexPath.item]];
        }
        TIRecordCell *cell = (TIRecordCell *) [collectionView cellForItemAtIndexPath:indexPath];
        [cell changeCellEffect:NO];
        [collectionView reloadItemsAtIndexPaths:@[indexPath, lastPath]];
    } else if (collectionView == self.greenScreenCollectionView) {
        if (_greenScreenEnumIndex == indexPath.item - 1) {
            return;
        }
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_greenScreenEnumIndex +1 inSection:0];
        
        TiUICell *lastCell = (TiUICell *) [collectionView cellForItemAtIndexPath:lastPath];
        [lastCell changeCellEffect:YES];
        _greenScreenEnumIndex = indexPath.item -1;
        if (indexPath.item -1 >= -1) {
            [self.tiSDKManager setGreenScreenEnum:[self setGreenScreenEnumByIndex:(int)indexPath.item]];
        }
        TiUICell *cell = (TiUICell *) [collectionView cellForItemAtIndexPath:indexPath];
        [cell changeCellEffect:NO];
        [collectionView reloadItemsAtIndexPaths:@[indexPath, lastPath]];
    }
}

- (void)releaseTiUIView {
    self.superView = nil;
    self.currentPopView = nil;
    self.nextPopView = nil;
    self.currentMainMenuPopView = nil;
    self.mainSwitchButton = nil; // 总开关
    self.mainMenuView = nil; // 菜单栏
    self.selectBeautyButton = nil; // 美颜-选择按钮
    self.selectFaceTrimButton = nil; // 美型-选择按钮
    self.selectStickerButton = nil; // 贴纸-选择按钮
    self.selectFilterButton = nil; // 滤镜-选择按钮
    self.selectRockButton = nil; // Rock-选择按钮
    self.selectDistortionButton = nil; // 哈哈镜-选择按钮
    self.selectGreenScreenButton = nil; // 绿幕-选择按钮
    self.beautyView = nil; // 美颜窗口
    self.faceTrimView = nil; // 美型窗口
    self.stickerView = nil; // 贴纸窗口
    self.filterView = nil; // 滤镜窗口
    self.rockView = nil; // Rock窗口
    self.distortionView = nil; // 哈哈镜窗口
    self.greenScreenView = nil; // 绿幕窗口
    self.beautySwitchButton = nil; // 美颜开关
    self.beautySwitchButtonLabel = nil; // 美颜开关标签
    self.beautySkinWhiteningSlider = nil; // 美颜-美白拉条
    self.beautySkinWhiteningLabel = nil; // 美颜-美白标签
    self.beautySkinBlemishRemovalSlider = nil; // 美颜-磨皮拉条
    self.beautySkinBlemishRemovalLabel = nil; // 美颜-磨皮标签
    self.beautySkinSaturationSlider = nil; // 美颜-饱和拉条
    self.beautySkinSaturationLabel = nil; // 美颜-饱和标签
    self.beautySkinTendernessSlider = nil; // 美颜-粉嫩拉条
    self.beautySkinTendernessLabel = nil; // 美颜-粉嫩标签
    self.faceTrimSwitchButton = nil; // 美型开关
    self.faceTrimSwitchButtonLabel = nil; // 美型开关
    self.faceTrimEyeMagnifyingSlider = nil; // 美型-大眼拉条
    self.faceTrimEyeMagnifyingLabel = nil; // 美型-大眼标签
    self.faceTrimChinSlimmingSlider = nil; // 美型-瘦脸拉条
    self.faceTrimChinSlimmingLabel = nil; // 美型-瘦脸标签
    self.stickerCollectionView = nil;
    self.filterCollectionView = nil; // 滤镜选择窗口
    self.rockCollectionView = nil; // Rock选择窗口
    self.distortionCollectionView = nil; // 哈哈镜选择窗口
    self.greenScreenCollectionView = nil; // 绿幕选择窗口
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Ti_STICKERSLOADED_COMPLETE" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:TiResourceURLNotificationName object:nil];

}

- (void)dealloc {
    [self popAllViews];
    [self releaseTiUIView];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Ti_STICKERSLOADED_COMPLETE" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:TiResourceURLNotificationName object:nil];

    tapView = nil;
}

- (TiFilterEnum)setFilterEnumByIndex:(int)index {
    switch(index) {
        case 0:
            return NO_FILTER;
            break;
        case 1:
            return FOREST_FILTER;
            break;
        case 2:
            return LOLITA_FILTER;
            break;
        case 3:
            return OXGEN_FILTER;
            break;
        case 4:
            return CHOCOLATE_FILTER;
            break;
        case 5:
            return DELICIOUS_FILTER;
            break;
        case 6:
            return KISS_FILTER;
            break;
        case 7:
            return FIRSTLOVE_FILTER;
            break;
        case 8:
            return GRASS_FILTER;
            break;
        case 9:
            return MOUSSE_FILTER;
            break;
        case 10:
            return COFFEE_FILTER;
            break;
        case 11:
            return CHOCOLATE_FILTER;
            break;
        case 12:
            return COCO_FILTER;
            break;
        case 13:
            return DELICIOUS_FILTER;
            break;
        case 14:
            return FIRSTLOVE_FILTER;
            break;
        case 15:
            return FOREST_FILTER;
            break;
        case 16:
            return GLOSSY_FILTER;
            break;
        case 17:
            return GRASS_FILTER;
            break;
        case 18:
            return HOLIDAY_FILTER;
            break;
        case 19:
            return KISS_FILTER;
            break;
        case 20:
            return LOLITA_FILTER;
            break;
        case 21:
            return MEMORY_FILTER;
            break;
        case 22:
            return MOUSSE_FILTER;
            break;
        case 23:
            return NORMAL_FILTER;
            break;
        case 24:
            return OXGEN_FILTER;
            break;
        case 25:
            return PLATYCODON_FILTER;
            break;
        case 26:
            return RED_FILTER;
            break;
        case 27:
            return SUNLESS_FILTER;
            break;
        case 28:
            return PINCH_DISTORTION_FILTER;
            break;
        case 29:
            return KUWAHARA_FILTER; // 油画
            break;
        case 30:
            return POSTERIZE_FILTER; // 分色
            break;
        case 31:
            return SWIRL_DISTORTION_FILTER; // 漩涡
            break;
        case 32:
            return VIGNETTE_FILTER; // 光晕
            break;
        case 33:
            return ZOOM_BLUR_FILTER; // 眩晕
            break;
        case 34:
            return POLKA_DOT_FILTER; // 圆点
            break;
        case 35:
            return POLAR_PIXELLATE_FILTER; // 极坐标
            break;
        case 36:
            return GLASS_SPHERE_REFRACTION_FILTER; // 水晶球
            break;
        case 37:
            return SOLARIZE_FILTER; // 曝光
            break;
        case 38:
            return INK_WASH_PAINTING_FILTER;
            break;
        default:
            return NO_FILTER;
            break;
    }
}

- (TiRockEnum)setRockEnumByIndex:(int)index {
    switch(index) {
        case 0:
            return NO_ROCK;
            break;
        case 1:
            return DAZZLED_COLOR_ROCK;
            break;
        case 2:
            return LIGHT_COLOR_ROCK;
            break;
        case 3:
            return DIZZY_GIDDY_ROCK;
            break;
        case 4:
            return ASTRAL_PROJECTION_ROCK;
            break;
        case 5:
            return BLACK_MAGIC_ROCK;
            break;
        case 6:
            return VIRTUAL_MIRROR_ROCK;
            break;
        case 7:
            return DYNAMIC_SPLIT_SCREEN_ROCK;
            break;
        case 8:
            return BLACK_WHITE_FILM_ROCK;
            break;
        case 9:
            return GRAY_PETRIFACTION_ROCK; // 瞬间石化
            break;
        case 10:
            return BULGE_DISTORTION__ROCK; // 魔法镜面
            break;
        default:
            return NO_ROCK;
            break;
    }
}

- (TiDistortionEnum)setDistortionEnumByIndex:(int)index {
    switch(index) {
        case 0:
            return NO_DISTORTION;
            break;
        case 1:
            return ET_DISTORTION;
            break;
        case 2:
            return PEAR_FACE_DISTORTION;
            break;
        case 3:
            return SLIM_FACE_DISTORTION;
            break;
        case 4:
            return SQUARE_FACE_DISTORTION;
            break;
        default:
            return NO_DISTORTION;
            break;
    }
}

- (TiGreenScreenEnum)setGreenScreenEnumByIndex:(int)index {
    switch(index) {
        case 0:
            return NO_GREEN_SCREEN;
            break;
        case 1:
            return STARRY_SKY_GREEN_SCREEN;
            break;
        case 2:
            return BLACK_BOARD_GREEN_SCREEN;
            break;
        default:
            return NO_GREEN_SCREEN;
            break;
    }
}
/////////////////////// UI控制 结束 ///////////////////////

@end
