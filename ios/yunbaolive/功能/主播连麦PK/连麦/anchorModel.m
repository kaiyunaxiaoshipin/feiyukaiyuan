//
//  anchorModel.m
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "anchorModel.h"

@implementation anchorModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _sex = minstr([dic valueForKey:@"sex"]);
        _pkuid = minstr([dic valueForKey:@"pkuid"]);
        _user_nicename = minstr([dic valueForKey:@"user_nicename"]);
        _avatar_thumb = minstr([dic valueForKey:@"avatar"]);
        _level = minstr([dic valueForKey:@"level"]);
        _pull = minstr([dic valueForKey:@"pull"]);
        _stream = minstr([dic valueForKey:@"stream"]);
        _uid = minstr([dic valueForKey:@"uid"]);
    }
    return self;
}
+ (NSDictionary *)dicWithModel:(anchorModel *)model{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:model.sex forKey:@"sex"];
    [muDic setObject:model.pkuid forKey:@"pkuid"];
    [muDic setObject:model.user_nicename forKey:@"user_nicename"];
    [muDic setObject:model.avatar_thumb forKey:@"avatar"];
    [muDic setObject:model.level forKey:@"level"];
    [muDic setObject:model.pull forKey:@"pull"];
    [muDic setObject:model.uid forKey:@"uid"];
    [muDic setObject:model.stream forKey:@"stream"];
    return muDic;
}

@end
