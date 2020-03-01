//
//  TCVideoTextFiled.h
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/22.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCVideoTextFiled;

@protocol TCVideoTextFieldDelegate <NSObject>

- (void)onTextInputDone:(NSString*)text;
- (void)onRemoveTextField:(TCVideoTextFiled*)textField;

@end

@interface TCVideoTextFiled : UIView

@property (nonatomic, weak) id<TCVideoTextFieldDelegate> delegate;
@property (nonatomic, copy, readonly) NSString* text;
@property (nonatomic, readonly) UIImage* textImage;

- (CGRect)textFrameOnView:(UIView*)view;

- (void)resignFirstResponser;

@end
