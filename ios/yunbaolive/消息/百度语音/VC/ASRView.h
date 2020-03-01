//
//  ASRView.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/31.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ASRHeight  260


typedef void (^ASRBlock)(NSString *type,NSString *content);

@interface ASRView : UIView

@property(nonatomic,copy)ASRBlock asrEvent;

@property(nonatomic,strong)MyTextView *textView;                 //输入框


- (instancetype)initWithFrame:(CGRect)frame callBack:(ASRBlock)asrBack;


@end
