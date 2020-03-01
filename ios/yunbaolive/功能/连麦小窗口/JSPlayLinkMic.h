//
//  JSPlayLinkMic.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/6/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CWStatusBarNotification/CWStatusBarNotification.h>
//金山推流
#import <libksygpulive/KSYGPUStreamerKit.h>
#import "libksygpulive/KSYMoviePlayerController.h"
#import <libksygpulive/libksygpulive.h>




@protocol js_play_linkmic <NSObject>
@optional;
-(void)js_startConnectRtmpForLink_mic;//开始连麦推流
-(void)js_stoppushlink;//停止推流
-(void)js_closeuserconnect:(NSString *)uid;//主播关闭某人的连麦

-(void)js_closeUserbyVideo:(NSDictionary *)subdic;//视频播放失败

@end

@interface JSPlayLinkMic : UIView
{
    KSYMoviePlayerController *       _player;
    CWStatusBarNotification *_notification;
    UIImageView *loadingImage;
    BOOL _ishost;//判断是不是主播
}

@property KSYGPUStreamerKit * gpuStreamer;

@property(nonatomic,strong)NSDictionary *subdic;
@property(nonatomic,weak)id<js_play_linkmic>delegate;
//@property TXLivePushConfig* txLivePushonfig;
//@property TXLivePush*       txLivePush;
@property(nonatomic,strong)NSString *playurl;
@property(nonatomic,strong)NSString *pushurl;

-(instancetype)initWithRTMPURL:(NSDictionary *)dic andFrame:(CGRect)frames andisHOST:(BOOL)ishost;

-(void)stopConnect;
-(void)stopPush;

@end
