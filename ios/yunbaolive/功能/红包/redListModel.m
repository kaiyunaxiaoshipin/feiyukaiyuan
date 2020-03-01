//
//  redListModel.m
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "redListModel.h"

@implementation redListModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _time = minstr([dic valueForKey:@"second"]);
        _type = minstr([dic valueForKey:@"type_grant"]);
        _user_nicename = minstr([dic valueForKey:@"user_nicename"]);
        _avatar_thumb = minstr([dic valueForKey:@"avatar"]);
        _uid = minstr([dic valueForKey:@"uid"]);
        _redid = minstr([dic valueForKey:@"id"]);
        _des = minstr([dic valueForKey:@"des"]);
        _isrob = minstr([dic valueForKey:@"isrob"]);
    }
    return self;
}

@end
