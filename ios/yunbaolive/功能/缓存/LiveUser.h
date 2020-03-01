//
//  LiveUser.h
//  yunbaolive
//
//  Created by cat on 16/3/9.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveUser : NSObject
@property (nonatomic, strong)NSString *avatar;
@property (nonatomic, strong)NSString *birthday;
@property (nonatomic, strong)NSString *coin;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *user_nicename;
@property (nonatomic, strong)NSString *signature;
@property (nonatomic, strong)NSString *city;
@property (nonatomic, strong)NSString *level;
@property (nonatomic, strong)NSString *level_anchor;
@property (nonatomic, strong)NSString *avatar_thumb;
@property (nonatomic, strong)NSString *login_type;

//vip_type

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
