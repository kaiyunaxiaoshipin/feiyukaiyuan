//
//  TXPlayLinkMic.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/6/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <TXLiteAVSDK_Professional/TXLivePlayListener.h>
#import <TXLiteAVSDK_Professional/TXLivePlayConfig.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>
#import <TXLiteAVSDK_Professional/TXLivePush.h>
#import <CWStatusBarNotification/CWStatusBarNotification.h>
#import "V8HorizontalPickerView.h"


@protocol tx_play_linkmic <NSObject>
@optional;
-(void)tx_startConnectRtmpForLink_mic;//开始连麦推流
-(void)tx_stoppushlink;//停止推流
-(void)tx_closeuserconnect:(NSString *)uid;//主播关闭某人的连麦

-(void)tx_closeUserbyVideo:(NSDictionary *)subdic;//视频播放失败

@end

@interface TXPlayLinkMic : UIView<TXLivePlayListener,TXLivePushListener>
{
    TXLivePlayer *       _txLivePlayer;
    TXLivePlayConfig*    _config;
    CWStatusBarNotification *_notification;
    UIImageView *loadingImage;
    BOOL _ishost;//判断是不是主播
}
@property(nonatomic,strong)NSDictionary *subdic;
@property(nonatomic,assign)id<tx_play_linkmic>delegate;
@property TXLivePushConfig* txLivePushonfig;
@property TXLivePush*       txLivePush;
@property(nonatomic,strong)NSString *playurl;
@property(nonatomic,strong)NSString *pushurl;
-(instancetype)initWithRTMPURL:(NSDictionary *)dic andFrame:(CGRect)frames andisHOST:(BOOL)ishost;

-(void)stopConnect;
-(void)stopPush;
//混流
-(void)hunliu:(NSDictionary *)hunDic andHost:(BOOL)isHost;//是否是主播连麦

@end
