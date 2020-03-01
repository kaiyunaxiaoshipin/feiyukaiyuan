//
//  TCBottomTabBar.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCBottomTabBar.h"
#import "ColorMacro.h"
#import "UIView+Additions.h"

#define kButtonCount 3 //6
#define kButtonNormalColor UIColorFromRGB(0x181818);

@implementation TCBottomTabBar
{
    
    UIButton*       _btnFilter;
    UIButton*       _btnMusic;
    UIButton*       _btnText;
    
    UIButton*       _btnCut;
    UILabel*        _btnCLL;        //按钮左边线
    UIButton*       _btnTime;       //时间特效
    UILabel*        _btnTLL;        //按钮左边线
    UIButton*       _btnEffect;     //特效
    UILabel*        _btnELL;        //按钮左边线
    UIView*         _x_bot_bg;      //补充背景
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        _btnCut = [[UIButton alloc] init];
        //_btnCut.backgroundColor = kButtonNormalColor;
        //[_btnCut setImage:[UIImage imageNamed:@"cut_nor"] forState:UIControlStateNormal];
        //[_btnCut setImage:[UIImage imageNamed:@"cut_pressed"] forState:UIControlStateHighlighted];
        [_btnCut setTitle:@"剪裁" forState:0];
        [_btnCut setTitleColor:GrayText forState:0];
        [_btnCut setTitleColor:Pink_Cor forState:UIControlStateSelected];
        _btnCut.titleLabel.font = SYS_Font(16);
        [_btnCut addTarget:self action:@selector(onCutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCut];
        _btnCLL = [[UILabel alloc]init];
        _btnCLL.backgroundColor = RGB(98, 98, 98);
        //[_btnCut addSubview:_btnCLL];
        
        _btnTime = [[UIButton alloc] init];
        //_btnCut.backgroundColor = kButtonNormalColor;
        //[_btnTime setImage:[UIImage imageNamed:@"time_press"] forState:UIControlStateNormal];
        //[_btnTime setImage:[UIImage imageNamed:@"time_press"] forState:UIControlStateHighlighted];
        [_btnTime setTitle:@"时间特效" forState:0];
        [_btnTime setTitleColor:GrayText forState:0];
        [_btnTime setTitleColor:Pink_Cor forState:UIControlStateSelected];
        _btnTime.titleLabel.font = SYS_Font(16);
        [_btnTime addTarget:self action:@selector(onTimeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnTime];
        _btnTLL = [[UILabel alloc]init];
        _btnTLL.backgroundColor = RGB(98, 98, 98);
        [_btnTime addSubview:_btnTLL];
        
        _btnEffect = [[UIButton alloc] init];
        //_btnMusic.backgroundColor = kButtonNormalColor;
        //[_btnEffect setImage:[UIImage imageNamed:@"music_pressed"] forState:UIControlStateNormal];
        //[_btnEffect setImage:[UIImage imageNamed:@"music_pressed"] forState:UIControlStateHighlighted];
        [_btnEffect setTitle:@"其他特效" forState:0];
        [_btnEffect setTitleColor:GrayText forState:0];
        [_btnEffect setTitleColor:Pink_Cor forState:UIControlStateSelected];
        _btnEffect.titleLabel.font = SYS_Font(16);
        [_btnEffect addTarget:self action:@selector(onEffectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnEffect];
        _btnELL = [[UILabel alloc]init];
        _btnELL.backgroundColor = RGB(98, 98, 98);
        [_btnEffect addSubview:_btnELL];
        
        //补充背景
        _x_bot_bg = [[UIView alloc]init];
        _x_bot_bg.backgroundColor = RGBA(0, 0, 0, 0.6);
        [self addSubview:_x_bot_bg];
        
        /*
        _btnFilter = [[UIButton alloc] init];
        //_btnFilter.backgroundColor = kButtonNormalColor;
        [_btnFilter setImage:[UIImage imageNamed:@"beautiful_nor"] forState:UIControlStateNormal];
        [_btnFilter setImage:[UIImage imageNamed:@"beautiful_pressed"] forState:UIControlStateNormal];
        [_btnFilter addTarget:self action:@selector(onFilterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnFilter];
        
        _btnMusic = [[UIButton alloc] init];
        //_btnMusic.backgroundColor = kButtonNormalColor;
        [_btnMusic setImage:[UIImage imageNamed:@"music_wihte"] forState:UIControlStateNormal];
        [_btnMusic setTintColor:[UIColor whiteColor]];
        [_btnMusic addTarget:self action:@selector(onMusicBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnMusic];
        
        _btnText = [[UIButton alloc] init];
        //_btnText.backgroundColor = kButtonNormalColor;
        [_btnText setImage:[UIImage imageNamed:@"word"] forState:UIControlStateNormal];
        [_btnText addTarget:self action:@selector(onTextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnText];
        */
        [self onCutBtnClicked];
        
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonWidth= self.width / kButtonCount;
    _btnCut.frame = CGRectMake(0, 0, buttonWidth, self.height-ShowDiff);
    _btnCLL.frame = CGRectMake(0, 15, 1, self.height-30-ShowDiff);
    _btnTime.frame = CGRectMake(buttonWidth * 1, 0, buttonWidth, self.height-ShowDiff);
    _btnTLL.frame = CGRectMake(0, 15, 1, self.height-30-ShowDiff);
    _btnEffect.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, self.height-ShowDiff);
    _btnELL.frame = CGRectMake(0, 15, 1, self.height-30-ShowDiff);
    
    _x_bot_bg.frame = CGRectMake(0, self.height-ShowDiff, self.width, ShowDiff);
    /*
    _btnFilter.frame = CGRectMake(buttonWidth*3, 0,buttonWidth, self.height-ShowDiff);
    _btnMusic.frame = CGRectMake(buttonWidth * 4, 0, buttonWidth, self.height-ShowDiff);
    _btnText.frame = CGRectMake(buttonWidth * 5, 0, buttonWidth, self.height-ShowDiff);
     */
}

- (void)resetButtonNormal
{
    _btnCut.selected = NO;
    _btnFilter.selected = NO;
    _btnMusic.selected = NO;
    _btnText.selected = NO;
    _btnEffect.selected = NO;
    _btnTime.selected = NO;
    [_btnCut setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnFilter setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnMusic setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnText setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnEffect setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
    [_btnTime setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
}


#pragma mark - click handle
- (void)onCutBtnClicked
{
    [self resetButtonNormal];
    _btnCut.selected = YES;
    [_btnCut setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onCutBtnClicked];
}
- (void)onTimeBtnClicked
{
    [self resetButtonNormal];
    _btnTime.selected = YES;
    [_btnTime setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onTimeBtnClicked];
}

- (void)onEffectBtnClicked
{
    [self resetButtonNormal];
    _btnEffect.selected = YES;
    [_btnEffect setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onEffectBtnClicked];
}

- (void)onFilterBtnClicked
{
    [self resetButtonNormal];
    _btnFilter.selected = YES;
    [_btnFilter setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onFilterBtnClicked];
}

- (void)onMusicBtnClicked
{
    [self resetButtonNormal];
    _btnMusic.selected = YES;
    [_btnMusic setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onMusicBtnClicked];
}

- (void)onTextBtnClicked
{
    [self resetButtonNormal];
    _btnText.selected = YES;
    [_btnText setBackgroundImage:[UIImage imageNamed:@"tab"] forState:UIControlStateNormal];
    [self.delegate onTextBtnClicked];
}

@end

