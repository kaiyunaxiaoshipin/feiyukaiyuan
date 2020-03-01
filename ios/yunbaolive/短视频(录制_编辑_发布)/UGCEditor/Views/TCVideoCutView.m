//
//  TCVideoCutView.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCVideoCutView.h"
#import "TCVideoRangeConst.h"
#import "TCVideoRangeSlider.h"
#import "ColorMacro.h"
#import "UIView+Additions.h"

//#import <TXLiteAVSDK_UGC/TXVideoEditer.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
@interface TCVideoCutView ()<TCVideoRangeSliderDelegate>

@end

@implementation TCVideoCutView
{
    //    UILabel*        _cutTipLabel;
    //    NSMutableArray  *_imageList;
    //    CGFloat         _duration;
    //    UILabel         *_timeTipsLabel;
    //    NSString*       _videoPath;
    //    AVAsset*        _videoAssert;
    //
    //    UIButton*      _speedUpBtn;
    //    BOOL           _isSpeedUp;
    //
    //    UILabel*      _speedTipLabel;
    //    UISlider*     _speedUpSlider;
    //    UILabel*      _speedLabel;
    CGFloat         _duration;          //视频时长
    UILabel*        _timeTipsLabel;    //当前播放时间显示
    NSString*       _videoPath;         //视频路径
    AVAsset*        _videoAssert;
    UIButton*       _effectDeleteBtn;
    UILabel *       _cutTipsLabel;
    BOOL            _isContinue;
    
}

- (id)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath  videoAssert:(AVAsset *)videoAssert
{
    if (self = [super initWithFrame:frame]) {
        _videoPath = videoPath;
        _videoAssert = videoAssert;
        
        _timeTipsLabel = [[UILabel alloc] init];
        _timeTipsLabel.text = @"0:00";
        _timeTipsLabel.textAlignment = NSTextAlignmentLeft;
        _timeTipsLabel.font = [UIFont systemFontOfSize:11];
        _timeTipsLabel.textColor = [UIColor whiteColor];//UIColorFromRGB(0x777777);
        [self addSubview:_timeTipsLabel];
        
        UILabel *allTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_window_width-80, 45, 60, 15)];
        allTimeLabel.textAlignment = NSTextAlignmentRight;
        allTimeLabel.font = [UIFont systemFontOfSize:11];
        allTimeLabel.textColor = [UIColor whiteColor];//UIColorFromRGB(0x777777);
        [self addSubview:allTimeLabel];
        _videoRangeSlider = [[TCVideoRangeSlider alloc] init];
        [self addSubview:_videoRangeSlider];
        CGFloat width = 42 * 0.7 * kScaleX;
        CGFloat height = 32 * 0.7 * kScaleY;
        _effectDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_effectDeleteBtn setBackgroundImage:[UIImage imageNamed:@"effectDelete"] forState:UIControlStateNormal];
        _effectDeleteBtn.titleLabel.textColor = [UIColor redColor];
        _effectDeleteBtn.frame = CGRectMake(self.width - width - 20 * kScaleX, 10 * kScaleY, width, height);
        [_effectDeleteBtn addTarget:self action:@selector(onEffectDelete) forControlEvents:UIControlEventTouchUpInside];
        _effectDeleteBtn.hidden = YES;
        [self addSubview:_effectDeleteBtn];
        
        _cutTipsLabel = [[UILabel alloc] init];
        _cutTipsLabel.text = @"请选择视频的剪裁区域";
        _cutTipsLabel.font = [UIFont systemFontOfSize:14];
        _cutTipsLabel.textAlignment = NSTextAlignmentCenter;
//        [self addSubview:_cutTipsLabel];
        
        TXVideoInfo *videoMsg = [TXVideoInfoReader getVideoInfoWithAsset:_videoAssert];
        _duration   = videoMsg.duration;
        allTimeLabel.text = [NSString stringWithFormat:@"%.2f",_duration];

        //显示微缩图列表
        _imageList = [NSMutableArray new];
        int imageNum = 12;
        
        _isContinue = YES;
        [TXVideoInfoReader getSampleImages:imageNum videoAsset:_videoAssert progress:^BOOL(int number, UIImage *image) {
            if (!_isContinue) {
                return NO;
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_isContinue) {
                        return;
                    }
                    if (number == 1) {
                        _videoRangeSlider.delegate = self;
                        for (int i = 0; i < imageNum; i++) {
                            [_imageList addObject:image];
                        }
                        [_videoRangeSlider setImageList:_imageList];
                        [_videoRangeSlider setDurationMs:_duration];
                    } else {
                        _imageList[number-1] = image;
                        [_videoRangeSlider updateImage:image atIndex:number-1];
                    }
                });
                return YES;
            }
        }];
    }
    return self;
}

- (void)stopGetImageList
{
    _isContinue = NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _timeTipsLabel.frame = CGRectMake(20, 45, 60 * kScaleX, 15);
    _videoRangeSlider.frame = CGRectMake(0, 0, self.width,  MIDDLE_LINE_HEIGHT);
}

- (void)dealloc
{
    NSLog(@"VideoCutView dealloc");
}

- (void)setPlayTime:(CGFloat)time
{
    _videoRangeSlider.currentPos = time;
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f",time];
}

- (void)setCenterPanHidden:(BOOL)isHidden
{
    [_videoRangeSlider setCenterPanHidden:isHidden];
}

- (void)setCenterPanFrame:(CGFloat)time
{
    [_videoRangeSlider setCenterPanFrame:time];
}

- (void)setEffectDeleteBtnHidden:(BOOL)isHidden
{
    [_effectDeleteBtn setHidden:isHidden];
}

- (void)startColoration:(UIColor *)color alpha:(CGFloat)alpha
{
    [_videoRangeSlider startColoration:color alpha:alpha];
}
- (void)stopColoration
{
    [_videoRangeSlider stopColoration];
}
- (void)removeLastColoration
{
    [_videoRangeSlider removeLastColoration];
}

- (void)onEffectDelete
{
    [self removeLastColoration];
    [self.delegate onEffectDelete];
}

#pragma mark - VideoRangeDelegate
//左拉
- (void)onVideoRangeLeftChanged:(TCVideoRangeSlider *)sender
{
    [self.delegate onVideoLeftCutChanged:sender];
}

- (void)onVideoRangeLeftChangeEnded:(TCVideoRangeSlider *)sender
{
    _videoRangeSlider.currentPos = sender.leftPos;
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",sender.leftPos];
    [self.delegate onVideoCutChangedEnd:sender];
}

//中拉
- (void)onVideoRangeCenterChanged:(TCVideoRangeSlider *)sender
{
    [self.delegate onVideoCenterRepeatChanged:sender];
}

- (void)onVideoRangeCenterChangeEnded:(TCVideoRangeSlider *)sender
{
    [self.delegate onVideoCenterRepeatEnd:sender];
}

//右拉
- (void)onVideoRangeRightChanged:(TCVideoRangeSlider *)sender {
    [self.delegate onVideoRightCutChanged:sender];
}

- (void)onVideoRangeRightChangeEnded:(TCVideoRangeSlider *)sender
{
    _videoRangeSlider.currentPos = sender.leftPos;
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",sender.leftPos];
    [self.delegate onVideoCutChangedEnd:sender];
}

- (void)onVideoRangeLeftAndRightChanged:(TCVideoRangeSlider *)sender {
    
}

//拖动缩略图条
- (void)onVideoRange:(TCVideoRangeSlider *)sender seekToPos:(CGFloat)pos {
    _timeTipsLabel.text = [NSString stringWithFormat:@"%.2f s",pos];
    [self.delegate onVideoCutChange:sender seekToPos:pos];
}

@end


