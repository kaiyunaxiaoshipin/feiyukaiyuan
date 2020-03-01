//
//  TCVideoRangeSlider.h
//  SAVideoRangeSliderExample
//
//  Created by annidyfeng on 2017/4/18.
//  Copyright © 2017年 Andrei Solovjev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRangeContent.h"
#import "VideoColorInfo.h"
/**
 视频缩略条拉条
 */
//@interface VideoColorInfo : NSObject
//@property (nonatomic,strong) UIView *colorView;
//@property (nonatomic,assign) CGFloat startPos;
//@property (nonatomic,assign) CGFloat endPos;
//@end

@protocol TCVideoRangeSliderDelegate;

@interface TCVideoRangeSlider : UIView

@property (weak) id<TCVideoRangeSliderDelegate> delegate;

@property (nonatomic) UIScrollView  *bgScrollView;
@property (nonatomic) UIImageView   *middleLine;
@property (nonatomic) TCRangeContentConfig* appearanceConfig;
@property (nonatomic) TCRangeContent *rangeContent;
@property (nonatomic) CGFloat        durationMs;
@property (nonatomic) CGFloat        currentPos;
@property (readonly)  CGFloat        leftPos;
@property (readonly)  CGFloat        rightPos;
@property (readonly)  CGFloat        centerPos;

@property(nonatomic,strong)NSMutableArray <VideoColorInfo *> *colorInfos;

- (void)setImageList:(NSArray *)images;
- (void)updateImage:(UIImage *)image atIndex:(NSUInteger)index;
//中心滑块
- (void)setCenterPanHidden:(BOOL)isHidden;
- (void)setCenterPanFrame:(CGFloat)time;

//涂色
- (void)startColoration:(UIColor *)color alpha:(CGFloat)alpha;
- (void)stopColoration;
- (void)removeLastColoration;

@end


@protocol TCVideoRangeSliderDelegate <NSObject>
//- (void)onVideoRangeLeftChanged:(TCVideoRangeSlider *)sender;
//- (void)onVideoRangeLeftChangeEnded:(TCVideoRangeSlider *)sender;
//- (void)onVideoRangeRightChanged:(TCVideoRangeSlider *)sender;
//- (void)onVideoRangeRightChangeEnded:(TCVideoRangeSlider *)sender;
//- (void)onVideoRangeLeftAndRightChanged:(TCVideoRangeSlider *)sender;
//- (void)onVideoRange:(TCVideoRangeSlider *)sender seekToPos:(CGFloat)pos;
- (void)onVideoRangeLeftChanged:(TCVideoRangeSlider *)sender;
- (void)onVideoRangeLeftChangeEnded:(TCVideoRangeSlider *)sender;
- (void)onVideoRangeCenterChanged:(TCVideoRangeSlider *)sender;
- (void)onVideoRangeCenterChangeEnded:(TCVideoRangeSlider *)sender;
- (void)onVideoRangeRightChanged:(TCVideoRangeSlider *)sender;
- (void)onVideoRangeRightChangeEnded:(TCVideoRangeSlider *)sender;
- (void)onVideoRangeLeftAndRightChanged:(TCVideoRangeSlider *)sender;
- (void)onVideoRange:(TCVideoRangeSlider *)sender seekToPos:(CGFloat)pos;

@end


