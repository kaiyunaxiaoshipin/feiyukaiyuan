//
//  TCFilterSettingView.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCFilterSettingView.h"

#import "V8HorizontalPickerView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"



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

@interface TCFilterSettingView ()<V8HorizontalPickerViewDelegate, V8HorizontalPickerViewDataSource>
{
    V8HorizontalPickerView *        _filterPickerView;
    NSMutableArray *                _filterArray;
    NSInteger                       _filterIndex;
    UILabel*                        _titleLabel;
    
    
    
//    UIButton*     _beautyBtn;
//    UIView*       _beautyView;
//    UILabel*      _beautyLabel;
//    UISlider*     _beautySlider;
//    UILabel*      _whiteLabel;
//    UISlider*     _whiteSlider;
}


@end

@implementation TCFilterSettingView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
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
        
        [self initUI];
    }
    
    return self;
}

- (void)initUI
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];//UIColor.blackColor;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"视频滤镜";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = UIColorFromRGB(0x777777);
//    [self addSubview:_titleLabel];
    
    _filterPickerView = [[V8HorizontalPickerView alloc] init];
    _filterPickerView.textColor = [UIColor grayColor];
    _filterPickerView.elementFont = [UIFont fontWithName:@"" size:14];
    _filterPickerView.delegate = self;
    _filterPickerView.dataSource = self;
    _filterPickerView.selectedMaskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"filter_selected"]];
    [self addSubview:_filterPickerView];
    
    
//    _beautyBtn = [UIButton new];
//    [_beautyBtn setImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateNormal];
//    _beautyBtn.backgroundColor = UIColorFromRGB(0x777777);
//    
//    [_beautyBtn setTitle:YZMsg(@"美颜") forState:UIControlStateNormal];
//    _beautyBtn.titleLabel.font = [UIFont systemFontOfSize:17];
//    [_beautyBtn setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
//    _beautyBtn.imageEdgeInsets = UIEdgeInsetsMake(- (_beautyBtn.titleLabel.intrinsicContentSize.height + 5), 0, 0, -_beautyBtn.titleLabel.intrinsicContentSize.width);
//    _beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(_beautyBtn.currentImage.size.height + 10, -_beautyBtn.currentImage.size.width, 0, 0);
//    [_beautyBtn addTarget:self action:@selector(onBeautyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_beautyBtn];
    
//    _beautyView = [UIView new];
//    _beautyView.backgroundColor = UIColor.whiteColor;
//    _beautyView.hidden = YES;
//    
//    _whiteLabel = [UILabel new];
//    _whiteLabel.text = @"美白效果";
//    _whiteLabel.textAlignment = NSTextAlignmentCenter;
//    [_beautyView addSubview:_whiteLabel];
//    
//    _whiteSlider = [UISlider new];
//    _whiteSlider.minimumValue = 0.f;
//    _whiteSlider.maximumValue = 9.f;
//    _whiteSlider.tag = 1;
//    _whiteSlider.tintColor = UIColor.blackColor;
//    [_whiteSlider setThumbImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
//    [_whiteSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [_beautyView addSubview:_whiteSlider];
//    
//    
//    _beautyLabel = [UILabel new];
//    _beautyLabel.text = @"美颜效果";
//    _beautyLabel.textColor = UIColor.darkTextColor;
//    _beautyLabel.textAlignment = NSTextAlignmentCenter;
//    [_beautyView addSubview:_beautyLabel];
//    
//    _beautySlider = [UISlider new];
//    _beautySlider.minimumValue = 0.f;
//    _beautySlider.maximumValue = 9.f;
//    _beautySlider.tag = 2;
//    _beautySlider.tintColor = UIColor.darkTextColor;
//    [_beautySlider setThumbImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
//    [_beautySlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//    [_beautyView addSubview:_beautySlider];
//    
//    [self addSubview:_beautyView];
    
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(0, 0, self.width, 14);
//    _beautyBtn.frame = CGRectMake(5, _titleLabel.bottom + 50 * kScaleY, 82, 120);
    
//    _filterPickerView.frame = CGRectMake( 5, _titleLabel.bottom + 50 * kScaleY, self.width - 10, 120);
    _filterPickerView.frame = CGRectMake( 5, 5, self.width - 10, 80);
    [_filterPickerView scrollToElement:_filterIndex animated:NO];
    
//    _beautyView.frame = _filterPickerView.frame;
//    _whiteLabel.frame = CGRectMake(0, 10, _beautyView.width, 20);
//    _whiteSlider.frame = CGRectMake(5, _whiteLabel.bottom, _beautyView.width - 10, 20);
//    _beautyLabel.frame = CGRectMake(0, _whiteSlider.bottom + 20 , _whiteLabel.width, 20);
//    _beautySlider.frame = CGRectMake(5, _beautyLabel.bottom, _whiteSlider.width, 20);
}


- (void)dealloc
{
    NSLog(@"FilterSettingView dealloc");
}

#pragma mark - HorizontalPickerView DataSource
- (NSInteger)numberOfElementsInHorizontalPickerView:(V8HorizontalPickerView *)picker {
    return [_filterArray count];
}

#pragma mark - HorizontalPickerView Delegate Methods
- (UIView *)horizontalPickerView:(V8HorizontalPickerView *)picker viewForElementAtIndex:(NSInteger)index {
    V8LabelNode *v = [_filterArray objectAtIndex:index];
    return [[UIImageView alloc] initWithImage:v.face];
}

- (NSInteger) horizontalPickerView:(V8HorizontalPickerView *)picker widthForElementAtIndex:(NSInteger)index {
    return 60;
}

- (void)horizontalPickerView:(V8HorizontalPickerView *)picker didSelectElementAtIndex:(NSInteger)index {
    _filterIndex = index;
    [self setFilter:_filterIndex];
}

- (void)setFilter:(NSInteger)index
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
    
    UIImage* image;
    if (path != nil && index != FilterType_None) {
        image = [UIImage imageWithContentsOfFile:path];
        
    } else {
        image = nil;
    }
    
    [self.delegate onSetFilterWithImage:image];
}


//#pragma mark - UI event handle
//- (void)onBeautyBtnClicked:(UIButton*)sender
//{
//    _beautyView.hidden = !_beautyView.hidden;
//}
//
//- (void)onSliderValueChanged:(UISlider*)slider
//{
//    [self.delegate onSetBeautyDepth:_beautySlider.value WhiteningDepth:_whiteSlider.value];
//}

@end
