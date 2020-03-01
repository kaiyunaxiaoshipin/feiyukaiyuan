//
//  commentModel.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface commentModel : NSObject


@property(nonatomic,strong)NSString *at_info;      //被@的人的uid、uname的json数据

@property(nonatomic,copy)NSString *avatar_thumb;

@property(nonatomic,copy)NSString *user_nicename;

@property(nonatomic,copy)NSString *content;//内容

@property(nonatomic,copy)NSString *datetime;//时间

@property(nonatomic,copy)NSString *likes;//点赞数

@property(nonatomic,copy)NSString *islike;//是不是我点的赞 

@property(nonatomic,copy)NSString *replys;//回复数

@property(nonatomic,copy)NSString *commentid;//回复评论使用

@property(nonatomic,copy)NSString *ID;//回复评论使用

@property(nonatomic,copy)NSString *parentid;//回复评论使用

@property(nonatomic,assign)CGRect contentRect;

@property(nonatomic,assign)CGRect ReplyRect;

@property(nonatomic,assign)CGRect ReplyFirstRect;

@property(nonatomic,copy)NSString *replyName;//回复人姓名
@property(nonatomic,copy)NSString *replyContent;//回复内容
@property(nonatomic,copy)NSString *replyDate;//回复时间

@property(nonatomic,copy)NSArray *replyList;//回复时间


@property(nonatomic,assign)CGFloat  rowH;//返回行高

-(void)setmyframe:(commentModel *)model;

-(instancetype)initWithDic:(NSDictionary *)subdic;

+(instancetype)modelWithDic:(NSDictionary *)subdic;

@end
