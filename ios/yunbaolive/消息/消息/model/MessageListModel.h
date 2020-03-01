//
//  MessageListModel.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListModel : NSObject

@property(nonatomic,strong)NSString *uidStr;
@property(nonatomic,strong)NSString *unameStr;
@property(nonatomic,strong)NSString *iconStr;
@property(nonatomic,strong)NSString *unReadStr;         //未读消息
@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,strong)NSString *contentStr;        //内容
@property(nonatomic,strong)JMSGConversation *conversation;
@property(nonatomic,strong)NSString *sex;        //内容
@property(nonatomic,strong)NSString *level;        //内容
@property(nonatomic,strong)NSString *isAtt;        //内容


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
