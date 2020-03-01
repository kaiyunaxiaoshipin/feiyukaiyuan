//
//  MusicMixView.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/12.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCMusicMixView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"
#import "TCRangeContent.h"
#import "TCMusicCollectionCell.h"
#import <AVFoundation/AVFoundation.h>


#define PIN_WIDTH 13
#define THUMB_HEIGHT 60
#define BORDER_HEIGHT 2

@interface TCMusicMixView()<TCRangeContentDelegate>
@end

@implementation TCMusicMixView
{
    
    NSString*   _selectedFilePath;
    CGFloat     _musicDuration;
    
    //UIView*     _editView;     //放到.h在外部需要控制其hidden属性
    UIImageView* _musicIcon;
    UILabel*     _songName;
    UIButton*    _deleteBtn;
    UILabel*     _cutTitleLabel;
    
    TCRangeContent* _musicCutSlider;
    UILabel*     _startTimeLabel;
    UILabel*     _endTimeLabel;
    
    UIView*      _voiceView;
    UILabel*     _originalL;
    UILabel*     _bgmL;
    UISlider*    _originalSlider;
    UISlider*    _bgmSlider;
    UILabel*     oriValueL;
    UILabel*     bgmValueL;

    
    CGFloat _originalVolume;   //原声音量
    CGFloat _bgmVolume;        //背景音乐音量
    
}

- (id)initWithFrame:(CGRect)frame haveBgm:(BOOL)haveBGM{
    if (self = [super initWithFrame:frame]) {
        //默认
        _originalVolume = 0.5;
        _bgmVolume = 0.5;
        if (haveBGM==YES) {
            _originalVolume = 0.0;
            _bgmVolume = 0.8;
        }
        
        _editView = [[UIView alloc] init];
        _editView.backgroundColor = [UIColor blackColor];
        [self addSubview:_editView];
        //外部（edit）控制其显示和隐藏
        _editView.hidden = YES;
        
        _musicIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice"]];
        [_editView addSubview:_musicIcon];
        
        _songName = [[UILabel alloc] init];
        _songName.text = @"歌曲名";
        _songName.textColor = UIColorFromRGB(0x777777);
        _songName.font = [UIFont systemFontOfSize:14];
        _songName.textAlignment = NSTextAlignmentLeft;
        [_editView addSubview:_songName];
        
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setTitle:YZMsg(@"删除") forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteBtn setTitleColor:normalColors forState:UIControlStateNormal];//UIColorFromRGB(0x0accac)
        [_deleteBtn addTarget:self action:@selector(onDeleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:_deleteBtn];
        
        _cutTitleLabel = [[UILabel alloc] init];
        _cutTitleLabel.textColor = UIColorFromRGB(0xcccccc);
        _cutTitleLabel.text = @"截取所需音频片段";
        _cutTitleLabel.textAlignment = NSTextAlignmentCenter;
        _cutTitleLabel.font = [UIFont systemFontOfSize:14];
        [_editView addSubview:_cutTitleLabel];
        
        TCRangeContentConfig* sliderConfig = [TCRangeContentConfig new];
        sliderConfig.pinWidth = 16;
        sliderConfig.borderHeight = 1;
        sliderConfig.thumbHeight = 58;
        sliderConfig.leftPinImage = [UIImage imageNamed:@"left"];
        sliderConfig.rightPigImage = [UIImage imageNamed:@"right"];
        
        _musicCutSlider = [[TCRangeContent alloc] initWithImageList:@[[UIImage imageNamed:@"wave_chosen"]] config:sliderConfig];
        [_musicCutSlider updateLineFrame];
        _musicCutSlider.middleLine.hidden = YES;
        _musicCutSlider.delegate = self;
        [_editView addSubview:_musicCutSlider];
        
        
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.textColor = [UIColor whiteColor];
        _startTimeLabel.font = [UIFont systemFontOfSize:10];
        _startTimeLabel.text = @"0:00";
        [_editView addSubview:_startTimeLabel];
        
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.font = [UIFont systemFontOfSize:10];
        _endTimeLabel.text = @"0:00";
        [_editView addSubview:_endTimeLabel];
        
        
        _voiceView = [[UIView alloc]init];
        _voiceView.backgroundColor = [UIColor blackColor];
        [self addSubview:_voiceView];
        _originalL = [[UILabel alloc] init];
        _originalL.textColor = [UIColor whiteColor];
        _originalL.font = [UIFont systemFontOfSize:14];
        _originalL.text = @"原声";
        [_voiceView addSubview:_originalL];
        
        _bgmL = [[UILabel alloc] init];
        _bgmL.textColor = [UIColor whiteColor];
        _bgmL.font = [UIFont systemFontOfSize:14];
        _bgmL.text = @"配乐";
        [_voiceView addSubview:_bgmL];
        
        
        oriValueL = [[UILabel alloc] init];
        oriValueL.textColor = [UIColor whiteColor];
        oriValueL.font = [UIFont systemFontOfSize:14];
        //oriValueL.text = @"50";
        oriValueL.text = [NSString stringWithFormat:@"%d",(int)(_originalVolume*100)];
        oriValueL.textAlignment = NSTextAlignmentCenter;
        [_voiceView addSubview:oriValueL];
        
        bgmValueL = [[UILabel alloc] init];
        bgmValueL.textColor = [UIColor whiteColor];
        bgmValueL.font = [UIFont systemFontOfSize:14];
        //bgmValueL.text = @"50";
        bgmValueL.text = [NSString stringWithFormat:@"%d",(int)(_bgmVolume*100)];
        bgmValueL.textAlignment = NSTextAlignmentCenter;
        [_voiceView addSubview:bgmValueL];

        _originalSlider = [[UISlider alloc] init];
        _originalSlider.minimumValue = 0;
        _originalSlider.maximumValue = 1;
        _originalSlider.thumbTintColor = normalColors;
        _originalSlider.minimumTrackTintColor = normalColors;
        _originalSlider.maximumTrackTintColor = UIColorFromRGB(0x777777);
        _originalSlider.value = _originalVolume;
        [_originalSlider setThumbImage:[UIImage imageNamed:@"button_slider"] forState:UIControlStateNormal];
        [_originalSlider addTarget:self action:@selector(onOriginalSliderChange:) forControlEvents:UIControlEventValueChanged];
        [_voiceView addSubview:_originalSlider];
        
        
        _bgmSlider = [[UISlider alloc] init];
        _bgmSlider.minimumValue = 0;
        _bgmSlider.maximumValue = 1;
        _bgmSlider.thumbTintColor = normalColors;
        _bgmSlider.minimumTrackTintColor = normalColors;
        _bgmSlider.maximumTrackTintColor = UIColorFromRGB(0x777777);
        _bgmSlider.value = _bgmVolume;
        [_bgmSlider setThumbImage:[UIImage imageNamed:@"button_slider"] forState:UIControlStateNormal];
        [_bgmSlider addTarget:self action:@selector(onBgmSliderChange:) forControlEvents:UIControlEventValueChanged];
        [_voiceView addSubview:_bgmSlider];

        //haveBGM这里初始值一旦为YES“原声”再不可编辑
        if (haveBGM == YES) {
            _originalSlider.enabled = NO;
            _originalSlider.alpha = 0.5;
        }else{
            _bgmSlider.enabled = NO;
            _bgmSlider.alpha = 0.5;
        }
        oriValueL.alpha = _originalSlider.alpha;
        bgmValueL.alpha = _bgmSlider.alpha;
    }
    
    return self;
}

- (void)dealloc {
    NSLog(@"MusicMixView dealloc");
}


- (void)layoutSubviews {
    [super layoutSubviews];
    //数据计算不要随意改动
    //--||_editViewfram              ||原声、背景、底部空白
    //--||5+30 +10+15+5+60 +5+10=140 ||+15+15 +10+15 +20=75   =215
    _editView.frame = CGRectMake(0, 0, self.bounds.size.width, 140);
    _musicIcon.frame = CGRectMake(15, 5+(30-_musicIcon.height)/2, _musicIcon.width, _musicIcon.height);
    _songName.frame = CGRectMake(_musicIcon.right +5, 5, _editView.width / 2, 30);
    _deleteBtn.frame = CGRectMake(_editView.width - 50, 5, 40, 30);
    
    _cutTitleLabel.frame = CGRectMake(15, _musicIcon.bottom + 10, _editView.width - 30, 15);
    _musicCutSlider.frame = CGRectMake((_editView.width - _musicCutSlider.width) / 2, _cutTitleLabel.bottom +5, _musicCutSlider.width, _musicCutSlider.height);
    
    _startTimeLabel.frame = CGRectMake(_musicCutSlider.x + _musicCutSlider.leftScale * _musicCutSlider.width + _musicCutSlider.leftPin.width / 2, _musicCutSlider.bottom + 5, 30, 10);
    _endTimeLabel.frame = CGRectMake(_musicCutSlider.x + _musicCutSlider.rightScale * _musicCutSlider.width - 30 + _musicCutSlider.rightPin.width / 2, _musicCutSlider.bottom + 5, 30, 10);
    
    
    _voiceView.frame = CGRectMake(0, _editView.bottom, self.bounds.size.width, 75+ShowDiff);
    _originalL.frame = CGRectMake(15,15, 0, 15);
    [_originalL sizeToFit];
    _originalSlider.frame = CGRectMake(_originalL.right+5, _originalL.top, _editView.width-30-_originalL.width-5 -40, 15);
    oriValueL.frame = CGRectMake(_originalSlider.right+10, _originalL.top, 30, _originalL.height);
    _bgmL.frame = CGRectMake(15 , _originalL.bottom+10, 0, 15);
    [_bgmL sizeToFit];
    _bgmSlider.frame = CGRectMake(_bgmL.right+5, _bgmL.top, _editView.width-30-_bgmL.width-5 - 40, 15);
    bgmValueL.frame = CGRectMake(_bgmSlider.right+10, _bgmL.top, 30, _bgmL.height);
   
}
- (void)addMusicInfo:(TCMusicInfo *)musicInfo{
    
    _bgmSlider.enabled = YES;
    _bgmSlider.alpha = 1;
    bgmValueL.alpha = _bgmSlider.alpha;
    _bgmVolume = 0.8;
    _bgmSlider.value = _bgmVolume;
    bgmValueL.text = [NSString stringWithFormat:@"%d",(int)(_bgmVolume*100)];
    [self showMusicInfo:musicInfo];
}

- (void)showMusicInfo:(TCMusicInfo *)musicInfo {
    _selectedFilePath = musicInfo.filePath;
    _musicDuration = musicInfo.duration;
    _songName.text = musicInfo.soneName;
    
    
    if (musicInfo.singerName.length > 0) {
        _songName.text = [NSString stringWithFormat:@"%@_%@", musicInfo.soneName, musicInfo.singerName];
    }
    _musicCutSlider.leftPinCenterX = _musicCutSlider.pinWidth / 2;
    _musicCutSlider.rightPinCenterX = _musicCutSlider.width - _musicCutSlider.pinWidth / 2;
    
    [_musicCutSlider setNeedsLayout];
    
    _startTimeLabel.frame = CGRectMake(_musicCutSlider.x + _musicCutSlider.leftPin.x, _musicCutSlider.bottom + 5, 30, 10);
    _startTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)(_musicCutSlider.leftScale *_musicDuration) / 60, (int)(_musicCutSlider.leftScale *_musicDuration) % 60];
    _endTimeLabel.frame = CGRectMake(_musicCutSlider.x + _musicCutSlider.rightPin.x + _musicCutSlider.pinWidth - 30, _musicCutSlider.bottom + 5, 30, 10);
    _endTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)(_musicCutSlider.rightScale *_musicDuration) / 60, (int)(_musicCutSlider.rightScale *_musicDuration) % 60];
    _cutTitleLabel.text = [NSString stringWithFormat:@"截取所需音频片段%.02f'", (_musicCutSlider.rightScale - _musicCutSlider.leftScale) * _musicDuration];
    
    
   
    
    [self.delegate onSetBGMWithFilePath:_selectedFilePath startTime:_musicCutSlider.leftScale * _musicDuration endTime:_musicCutSlider.rightScale * _musicDuration];
    
    [self.delegate onSetVideoVolume:_originalVolume musicVolume:_bgmVolume];
    
}
#pragma mark - UI control event Handle
- (void)onDeleteBtnClicked:(UIButton*)sender {
    _musicDuration = 1;
    _editView.hidden = YES;
    
    _bgmSlider.enabled = NO;
    _bgmSlider.alpha = 0.5;
    bgmValueL.alpha = _bgmSlider.alpha;
    _bgmSlider.value = 0;
    _bgmVolume = 0;
    bgmValueL.text = [NSString stringWithFormat:@"%d",(int)(_bgmVolume*100)];
    //[self.delegate onSetBGMWithFilePath:@"delate" startTime:0 endTime:0];
    //更换收费版SDK 不能用[self.delegate onSetBGMWithFilePath:@"delate" startTime:0 endTime:0];,改为delBGM
    [self.delegate delBGM];
    
}

-(void)onOriginalSliderChange:(UISlider*)sender{
   _originalVolume = sender.value;
    oriValueL.text = [NSString stringWithFormat:@"%d",(int)(sender.value*100)];
    [self.delegate onSetVideoVolume:_originalVolume musicVolume:_bgmVolume];
}
- (void)onBgmSliderChange:(UISlider*)sender {
    _bgmVolume = sender.value;
    bgmValueL.text = [NSString stringWithFormat:@"%d",(int)(sender.value*100)];
    [self.delegate onSetVideoVolume:_originalVolume musicVolume:_bgmVolume];
    
}

#pragma mark - RangeContentDelegate
- (void)onRangeLeftChangeEnded:(TCRangeContent *)sender {
    CGFloat startTime = _musicCutSlider.leftScale *_musicDuration;
    CGFloat endTime = _musicCutSlider.rightScale * _musicDuration;
    
    assert(startTime >= 0 && endTime >= 0 && endTime >= startTime);
    
    _startTimeLabel.frame = CGRectMake(_musicCutSlider.x + _musicCutSlider.leftPin.x, _musicCutSlider.bottom + 5, 30, 10);
    _startTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)(startTime) / 60, (int)(startTime) % 60];
    _cutTitleLabel.text = [NSString stringWithFormat:@"截取所需音频片段%.02f'", (endTime - startTime)];
    
    [self.delegate onSetBGMWithFilePath:_selectedFilePath startTime:startTime endTime:endTime];
    
}
- (void)onRangeRightChangeEnded:(TCRangeContent *)sender {
    CGFloat startTime = _musicCutSlider.leftScale *_musicDuration;
    CGFloat endTime = _musicCutSlider.rightScale * _musicDuration;
    
    assert(startTime >= 0 && endTime >= 0 && endTime >= startTime);
    
    _endTimeLabel.frame = CGRectMake(MAX(_startTimeLabel.right, _musicCutSlider.x + _musicCutSlider.rightPin.x + _musicCutSlider.pinWidth - 30), _musicCutSlider.bottom + 5, 30, 10);
    _endTimeLabel.text = [NSString stringWithFormat:@"%d:%02d", (int)(endTime) / 60, (int)(endTime) % 60];
    _cutTitleLabel.text = [NSString stringWithFormat:@"截取所需音频片段%.02f'", (endTime - startTime)];
    
    [self.delegate onSetBGMWithFilePath:_selectedFilePath startTime:startTime endTime:endTime];
}
@end
