//
//  VideoEffectSlider.h
//  TXLiteAVDemo
//
//  Created by xiang zhang on 2017/11/3.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <TXLiteAVSDK_UGC/TXVideoEditer.h>
#import <TXLiteAVSDK_Professional/TXVideoEditer.h>
@protocol VideoEffectViewDelegate <NSObject>
- (void)onVideoEffectBeginClick:(TXEffectType)effectType;
- (void)onVideoEffectEndClick:(TXEffectType)effectType;

- (void)onEffectSelDelete;

@end

@interface EffectSelectView : UIView

@property(nonatomic,strong)UIButton *delEffectBtn;

@property (nonatomic,strong) id <VideoEffectViewDelegate> delegate;
@end
