//
//  MsgSysModel.h
//  iphoneLive
//
//  Created by YunBao on 2018/8/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageListModel.h"

@interface MsgSysModel : NSObject

@property(nonatomic,strong)NSString *idStr;            //消息id
@property(nonatomic,strong)NSString *uidStr;           //官方、系统
@property(nonatomic,strong)NSString *iconStr;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *timeStr;

//官方
@property(nonatomic,strong)NSString *briefStr;          //简介
@property(nonatomic,strong)NSString *urlStr;

//系统通知
@property(nonatomic,strong)NSString *contentStr;        //内容

@property(nonatomic,assign)CGFloat rowH;                //行高


- (instancetype)initWithDic:(NSDictionary *)dic lisModel:(MessageListModel *)listModel;
+ (instancetype)modelWithDic:(NSDictionary *)dic lisModel:(MessageListModel *)listModel;

@end
