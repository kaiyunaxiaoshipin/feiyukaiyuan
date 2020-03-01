//
//  TCFilterSettingView.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/11.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TCFilterSettingViewDelegate <NSObject>

- (void)onSetFilterWithImage:(UIImage*)image;
- (void)onSetBeautyDepth:(float)beautyDepth WhiteningDepth:(float)whiteningDepth;

@end

@interface TCFilterSettingView : UIView

@property (nonatomic, weak) id<TCFilterSettingViewDelegate> delegate;



@end
