//
//  TCTextAddView.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/18.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCTextAddViewDelegate <NSObject>

- (void)onAddTextBtnClicked;

@end

@interface TCTextAddView : UIView

@property (nonatomic, weak) id<TCTextAddViewDelegate> delegate;

- (void)setEdited:(BOOL)isEdited;

@end
