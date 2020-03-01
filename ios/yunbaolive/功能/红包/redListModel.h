//
//  redListModel.h
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface redListModel : NSObject
@property (nonatomic,strong)NSString *avatar_thumb;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *user_nicename;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString *redid;
@property (nonatomic,strong)NSString *des;
@property (nonatomic,strong)NSString *isrob;
-(instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
