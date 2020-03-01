//
//  RankModel.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "RankModel.h"

@implementation RankModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        _totalCoinStr = YBValue(dic, @"totalcoin");
        _uidStr = YBValue(dic, @"uid");
        _unameStr = YBValue(dic, @"user_nicename");
        _iconStr = YBValue(dic, @"avatar_thumb");
        if (![dic valueForKey:@"level"]) {
            _levelStr = YBValue(dic, @"levelAnchor");
        }else {
            _levelStr = YBValue(dic, @"level");
        }
        _isAttentionStr = YBValue(dic, @"isAttention");
        _sex = YBValue(dic, @"sex");

    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic {
     return [[self alloc]initWithDic:dic];
}
@end
