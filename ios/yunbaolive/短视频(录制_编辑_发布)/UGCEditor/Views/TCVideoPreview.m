//
//  TCVideoPreview.m
//  TCLVBIMDemo
//
//  Created by xiang zhang on 2017/4/18.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCVideoPreview.h"
#import "UIView+Additions.h"
#import <AVFoundation/AVFoundation.h>

#undef _MODULE_
#define _MODULE_ "TXVideoPreview"

#define playBtnWidth   42 //34
#define playBtnHeight  42 //46

#define pauseBtnWidth  42 //27
#define pauseBtnHeight 42

#undef _MODULE_
#define _MODULE_ "TXVideoPreview"

@interface TCVideoPreview()

@end

@implementation TCVideoPreview
{
    UIButton    *_playBtn;
    UIImageView *_coverView;
    CGFloat     _currentTime;
    BOOL        _videoIsPlay;
    BOOL        _appInbackground;
}
- (instancetype)initWithFrame:(CGRect)frame coverImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [self addSubview:_renderView];
        
        if (image != nil) {
            _coverView = [[UIImageView alloc] initWithFrame:_renderView.frame];
            _coverView.contentMode = UIViewContentModeScaleAspectFill;//UIViewContentModeScaleAspectFit;
            _coverView.image = image;
            _coverView.hidden = NO;
            [self addSubview:_coverView];
        }
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self setPlayBtn:_videoIsPlay];
        [_playBtn  addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playBtn];
                
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillEnterForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(onAudioSessionEvent:)
                                                      name:AVAudioSessionInterruptionNotification
                                                    object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _renderView.frame = CGRectMake(0, 0, self.width, self.height);
    _coverView.frame = _renderView.frame;
    if (_videoIsPlay) {
        _playBtn.frame = CGRectMake((self.frame.size.width - pauseBtnWidth)/2, (self.frame.size.height - pauseBtnHeight)/2.5 , pauseBtnWidth, pauseBtnHeight);
    } else {
        _playBtn.frame = CGRectMake((self.frame.size.width - playBtnWidth)/2, (self.frame.size.height - playBtnHeight)/2.5 , playBtnWidth, playBtnHeight);
    }
    
}

- (BOOL)isPlaying
{
    return _videoIsPlay;
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillEnterForeground:(NSNotification *)noti
{
    _appInbackground = NO;
}

- (void)applicationDidEnterBackground:(NSNotification *)noti
{
    if (_videoIsPlay) {
        [self playBtnClick];
    }
    if (!_appInbackground) {
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoEnterBackground)]) {
            [_delegate onVideoEnterBackground];
        }
        _appInbackground = YES;
    }
}

- (void)applicationWillResignActive:(NSNotification *)noti
{
    if (_videoIsPlay) {
        [self playBtnClick];
    }
    if (!_appInbackground) {
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoEnterBackground)]) {
            [_delegate onVideoEnterBackground];
        }
        _appInbackground = YES;
    }
}

- (void) onAudioSessionEvent: (NSNotification *) notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (!_appInbackground) {
            if (_delegate && [_delegate respondsToSelector:@selector(onVideoEnterBackground)]) {
                [_delegate onVideoEnterBackground];
            }
            _appInbackground = YES;
        }
        _coverView.hidden = YES;
        if (_videoIsPlay) {
            _videoIsPlay = NO;
            [self setPlayBtn:_videoIsPlay];
        }

    }
}


- (void)setPlayBtnHidden:(BOOL)isHidden
{
    _playBtn.hidden = isHidden;
}

- (void)playVideo
{
    [self playBtnClick];
}

- (void)playBtnClick
{
    _coverView.hidden = YES;
    
    if (_videoIsPlay) {
        _videoIsPlay = NO;
        [self setPlayBtn:_videoIsPlay];
        
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoPause)]) {
            [_delegate onVideoPause];
        }
    }else{
        _videoIsPlay = YES;
        [self setPlayBtn:_videoIsPlay];
        
        if (_currentTime == 0) {
            if (_delegate && [_delegate respondsToSelector:@selector(onVideoPlay)]) {
                [_delegate onVideoPlay];
            }
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(onVideoResume)]) {
                [_delegate onVideoResume];
            }
        }
    }
}

-(void) setPlayBtn:(BOOL)videoIsPlay
{
    if (videoIsPlay) {//pause_ugc_edit
        //暂停
        [_playBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
          _coverView.hidden = YES;
    }else{
        //play_ugc_edit
        //播放
        [_playBtn setImage:[UIImage imageNamed:@"ask_play"] forState:UIControlStateNormal];
    }
    _videoIsPlay = videoIsPlay;
}

-(void) onPreviewProgress:(CGFloat)time
{
    _currentTime = time;
    if (_delegate && [_delegate respondsToSelector:@selector(onVideoPlayProgress:)]) {
        [_delegate onVideoPlayProgress:time];
    }
}

-(void) onPreviewFinished
{
    if (_delegate && [_delegate respondsToSelector:@selector(onVideoPlayFinished)]) {
        [_delegate onVideoPlayFinished];
    }
}
@end
