//
//  JCHATMessageContentView.h
//  JChat
//
//  Created by HuminiOS on 15/11/2.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatImageBubble.h"


@interface JCHATMessageContentView :UIImageView
@property(assign, nonatomic)BOOL isReceivedSide;


@property (nonatomic,strong)UIImageView *mapIV;              //地址截图
@property(nonatomic,strong)UIImageView *imageViewAnntation;  //大头针

@property(strong, nonatomic)UILabel *textContent;
@property(nonatomic,strong)UILabel *infoL;                   //当消息为定位类型时用作显示详情
@property(strong, nonatomic)UIImageView *voiceConent;
@property(strong, nonatomic)JMSGMessage *message;
- (void)setMessageContentWith:(JMSGMessage *)message;

- (void)setMessageContentWith:(JMSGMessage *)message handler:(void(^)(NSUInteger messageMediaDataLength))block;

@end
