//
//  TCVideoPreview.h
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/18.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TXLiteAVSDK.h"
@protocol TXVideoPreviewListener;

@protocol TCVideoPreviewDelegate <NSObject>
- (void)onVideoPlay;
- (void)onVideoPause;
- (void)onVideoResume;
- (void)onVideoPlayProgress:(CGFloat)time;
- (void)onVideoPlayFinished;

@optional
- (void)onVideoEnterBackground;
@end

@interface TCVideoPreview : UIView<TXVideoPreviewListener>

@property(nonatomic,weak) id<TCVideoPreviewDelegate> delegate;
@property(nonatomic,strong) UIView *renderView;
@property(nonatomic, readonly, assign) BOOL isPlaying;


- (instancetype)initWithFrame:(CGRect)frame coverImage:(UIImage *)image;

- (void)setPlayBtnHidden:(BOOL)isHidden;

- (void)setPlayBtn:(BOOL)videoIsPlay;

- (void)playVideo;

- (void)removeNotification;
@end
