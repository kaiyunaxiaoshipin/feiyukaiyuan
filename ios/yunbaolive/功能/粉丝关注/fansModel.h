//
//  fansModel.h
//  yunbaolive
//
//  Created by cat on 16/4/1.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fansModel : NSObject



@property(nonatomic,copy)NSString *name;

@property(nonatomic,copy)NSString *level;

@property(nonatomic,copy)NSString *sex;

@property(nonatomic,copy)NSString *signature;

@property(nonatomic,copy)NSString *icon;

@property(nonatomic,copy)NSString *level_anchor;


@property(nonatomic,copy)NSString *btn;

@property(nonatomic,copy)NSString *isattention;
@property(nonatomic,copy)NSString *uid;

-(instancetype)initWithDic:(NSDictionary *)dic;


+(instancetype)modelWithDic:(NSDictionary *)dic;


@end
