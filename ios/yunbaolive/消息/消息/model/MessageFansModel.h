//
//  MessageFansModel.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageFansModel : NSObject

@property(nonatomic,strong)NSString *uidStr;
@property(nonatomic,strong)NSString *unameStr;
@property(nonatomic,strong)NSString *iconStr;
@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,strong)NSString *isAttentStr;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
