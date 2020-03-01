//
//  YBPersonTableViewModel.h
//  TCLVBIMDemo
//
//  Created by 王敏欣 on 2016/11/19.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPersonTableViewModel : NSObject

//用户基本信息
@property(nonatomic,copy)NSString *avatar;

@property(nonatomic,copy)NSString *user_nicename;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *level;

@property(nonatomic,copy)NSString *level_anchor;

@property(nonatomic,copy)NSString *ID;

@property(nonatomic,copy)NSString *fans;

@property(nonatomic,copy)NSString *follows;

@property(nonatomic,copy)NSString *lives;

-(instancetype)initWithDic:(NSDictionary *)subdic;

+(instancetype)modelWithDic:(NSDictionary *)subdic;






@end
