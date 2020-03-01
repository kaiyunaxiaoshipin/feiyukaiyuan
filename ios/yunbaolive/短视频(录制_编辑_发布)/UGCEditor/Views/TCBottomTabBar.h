//
//  TCBottomTabBar.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCBottomTabBarDelegate <NSObject>

- (void)onCutBtnClicked;
- (void)onFilterBtnClicked;
- (void)onMusicBtnClicked;
- (void)onTextBtnClicked;
- (void)onEffectBtnClicked;
- (void)onTimeBtnClicked;

@end

@interface TCBottomTabBar : UIView

@property (nonatomic, weak) id<TCBottomTabBarDelegate> delegate;

@end

