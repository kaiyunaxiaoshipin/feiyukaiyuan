//
//  hotModel.h
//  yunbaolive
//
//  Created by zqm on 16/4/25.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


@interface hotModel : NSObject
@property(nonatomic,strong)NSString *zhuboPlace;//主播位置

@property(nonatomic,assign)NSString *onlineCount;//在线人数

@property(nonatomic,strong)NSString *signature;

@property(nonatomic,strong)NSString *sex;

@property(nonatomic,strong)NSString *level;

@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSString *zhuboStatus;//直播状态

@property(nonatomic,strong)NSString *zhuboImage;//主播图片

@property(nonatomic,strong)NSString *zhuboIcon;//主播头像

@property(nonatomic,strong)NSString *zhuboID;//主播ID

@property(nonatomic,strong)NSString *game_action;//游戏

@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *zhuboName;//主播名字

@property(nonatomic,strong)NSString *avatar_thumb;

@property(nonatomic,strong)NSString *level_anchor;//主播等级

@property(nonatomic,strong)NSString *distance;//距离

@property(nonatomic,assign)CGRect nameR;

@property(nonatomic,assign)CGRect placeR;

@property(nonatomic,assign)CGRect imageR;

@property(nonatomic,assign)CGRect IconR;

@property(nonatomic,assign)CGRect CountR;

@property(nonatomic,assign)CGRect statusR;




-(instancetype)initWithDic:(NSDictionary *)dic;



+(instancetype)modelWithDic:(NSDictionary *)dic;
@end
