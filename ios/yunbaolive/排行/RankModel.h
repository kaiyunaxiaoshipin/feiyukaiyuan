//
//  RankModel.h
//  yunbaolive
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject

@property (nonatomic,strong) NSString *type;  //收益榜-0 消费榜-1

@property (nonatomic,strong) NSString *totalCoinStr;
@property (nonatomic,strong) NSString *uidStr;
@property (nonatomic,strong) NSString *unameStr;
@property (nonatomic,strong) NSString *iconStr;
@property (nonatomic,strong) NSString *levelStr;
@property (nonatomic,strong) NSString *isAttentionStr;
@property (nonatomic,strong) NSString *sex;

-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
