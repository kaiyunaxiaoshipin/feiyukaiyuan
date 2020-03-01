//
//  MessageFansModel.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageFansModel.h"

@implementation MessageFansModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        _uidStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
        NSDictionary *info_dic = [dic valueForKey:@"userinfo"];
        if ([info_dic isKindOfClass:[NSDictionary class]]) {
            _unameStr = [NSString stringWithFormat:@"%@",[info_dic valueForKey:@"user_nicename"]];
            _iconStr = [NSString stringWithFormat:@"%@",[info_dic valueForKey:@"avatar"]];
        }
        _timeStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"addtime"]];
        _isAttentStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"isattention"]];
        
    }
    return self;
}

+(instancetype)modelWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}

@end
