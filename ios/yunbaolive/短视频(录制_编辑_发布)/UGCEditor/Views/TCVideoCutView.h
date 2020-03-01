//
//  TCVideoCutView.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCVideoRangeSlider.h"
#import <AVFoundation/AVFoundation.h>
@protocol TCVideoCutViewDelegate <NSObject>

//- (void)onVideoLeftCutChanged:(TCVideoRangeSlider*)sender;
//- (void)onVideoRightCutChanged:(TCVideoRangeSlider*)sender;
//- (void)onVideoCutChangedEnd:(TCVideoRangeSlider*)sender;
//- (void)onVideoCutChange:(TCVideoRangeSlider*)sender seekToPos:(CGFloat)pos;
//
//- (void)onSetSpeedUp:(BOOL)isSpeedUp;
//- (void)onSetSpeedUpLevel:(CGFloat)level;
- (void)onVideoLeftCutChanged:(TCVideoRangeSlider*)sender;
- (void)onVideoRightCutChanged:(TCVideoRangeSlider*)sender;
- (void)onVideoCenterRepeatChanged:(TCVideoRangeSlider*)sender;

- (void)onVideoCutChangedEnd:(TCVideoRangeSlider*)sender;
- (void)onVideoCutChange:(TCVideoRangeSlider*)sender seekToPos:(CGFloat)pos;
- (void)onVideoCenterRepeatEnd:(TCVideoRangeSlider*)sender;

- (void)onSetSpeedUp:(BOOL)isSpeedUp;
- (void)onSetSpeedUpLevel:(CGFloat)level;
- (void)onEffectDelete; 

@end

@interface TCVideoCutView : UIView

@property (nonatomic, strong)  TCVideoRangeSlider *videoRangeSlider;
@property (nonatomic, weak) id<TCVideoCutViewDelegate> delegate;
@property (nonatomic, strong)  NSMutableArray  *imageList;         //缩略图列表

- (id)initWithFrame:(CGRect)frame videoPath:(NSString *)videoPath  videoAssert:(AVAsset *)videoAssert;
//- (void)setPlayTime:(CGFloat)time;
- (void)stopGetImageList;

- (void)setPlayTime:(CGFloat)time;
- (void)setCenterPanHidden:(BOOL)isHidden;
- (void)setCenterPanFrame:(CGFloat)time;
- (void)setEffectDeleteBtnHidden:(BOOL)isHidden;

- (void)startColoration:(UIColor *)color alpha:(CGFloat)alpha;
- (void)stopColoration;
- (void)removeLastColoration;

@end

