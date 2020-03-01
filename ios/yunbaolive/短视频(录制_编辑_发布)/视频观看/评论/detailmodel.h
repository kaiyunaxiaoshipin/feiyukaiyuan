//
//  detailmodel.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailmodel : NSObject

@property(nonatomic,strong)NSString *at_info;      //被@的人的uid、uname的json数据

@property(nonatomic,copy)NSString *avatar_thumb;

@property(nonatomic,copy)NSString *user_nicename;

@property(nonatomic,copy)NSString *content;//内容

@property(nonatomic,copy)NSString *datetime;//时间

@property(nonatomic,copy)NSString *likes;//点赞数

@property(nonatomic,copy)NSString *islike;

@property(nonatomic,assign)CGRect contentRect;

@property(nonatomic,assign)CGRect ReplyRect;

@property(nonatomic,assign)CGFloat  rowH;//返回行高

@property(nonatomic,copy)NSString *touid;//如果大于0 则说明是回复的回复

@property(nonatomic,copy)NSString *parentid;//

@property(nonatomic,copy)NSString *ID;//

@property(nonatomic,strong)NSDictionary *touserinfo;//回复的评论

@property(nonatomic,strong)NSDictionary *tocommentinfo;//回复的评论

-(void)setmyframe:(detailmodel *)model;

-(instancetype)initWithDic:(NSDictionary *)subdic;

+(instancetype)modelWithDic:(NSDictionary *)subdic;

@end
