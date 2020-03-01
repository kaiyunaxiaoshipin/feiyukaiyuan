//
//  guardListModel.m
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "guardListModel.h"

@implementation guardListModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        _sex = minstr([dic valueForKey:@"sex"]);
        _type = minstr([dic valueForKey:@"type"]);
        _contribute = minstr([dic valueForKey:@"contribute"]);
        _user_nicename = minstr([dic valueForKey:@"user_nicename"]);
        _avatar_thumb = minstr([dic valueForKey:@"avatar_thumb"]);
        _level = minstr([dic valueForKey:@"level"]);
        _uid = minstr([dic valueForKey:@"id"]);
    }
    return self;
}

@end
