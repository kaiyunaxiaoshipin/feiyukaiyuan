//
//  TiUI.h
//  TiSDK
//
//  Created by Cat66 on 2018/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TiSDKInterface.h"

@protocol TiUIViewDelegate <NSObject>
- (void)showPreFrontView;
@end

@interface TiUIView : NSObject

@property(nonatomic, assign) BOOL isClearOldUI;

- (instancetype)initTiUIViewWith:(TiSDKManager *)tiSDKManager delegate:(id<TiUIViewDelegate>)delegate superView:(UIView *)superView;

- (void)createTiUIView;

- (void)releaseTiUIView;

@end

