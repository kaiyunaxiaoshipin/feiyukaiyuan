//
//  JCHATChatModel.h
//  test project
//
//  Created by guan jingFen on 14-3-10.
//  Copyright (c) 2014年 guan jingFen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MessageListModel.h"

@interface JCHATChatModel : NSObject
@property (nonatomic, strong) JMSGMessage * message;

@property (nonatomic, strong) NSNumber *messageTime;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, assign) BOOL isTime;

@property (nonatomic, assign) BOOL isDefaultAvatar;
@property (nonatomic, assign) NSUInteger avatarDataLength;
@property (nonatomic, assign) NSUInteger messageMediaDataLength;

@property (nonatomic, assign) BOOL isErrorMessage;
@property (nonatomic, strong) NSError *messageError;

//增加字段
/** 业务服务器用户id(不是极光IM中的id) */
@property(nonatomic,strong)NSString *uidStr;
/** 业务服务器中用户的头像(不是极光IM中的头像) */
@property(nonatomic,strong)NSString *uiconStr;


- (float)getTextHeight;
- (void)setupImageSize;

- (void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation userModel:(MessageListModel *)userModel;
- (void)setErrorMessageChatModelWithError:(NSError *)error;
@end
