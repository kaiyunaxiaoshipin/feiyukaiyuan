//
//  guardListModel.h
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface guardListModel : NSObject
@property (nonatomic,strong)NSString *avatar_thumb;
@property (nonatomic,strong)NSString *level;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *user_nicename;
@property (nonatomic,strong)NSString *contribute;
@property (nonatomic,strong)NSString *uid;

-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
