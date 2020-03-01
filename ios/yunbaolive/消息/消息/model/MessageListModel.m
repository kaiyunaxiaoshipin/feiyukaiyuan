//
//  MessageListModel.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageListModel.h"
#import "JCHATStringUtils.h"


@implementation MessageListModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        _uidStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        _unameStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
        _iconStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
        _conversation = [dic valueForKey:@"conversation"];
        _sex = minstr([dic valueForKey:@"sex"]);
        _level = minstr([dic valueForKey:@"level"]);
        _isAtt = minstr([dic valueForKey:@"utot"]);

        _unReadStr = [NSString stringWithFormat:@"%@",_conversation.unreadCount];
        if (_conversation.latestMessage.timestamp != nil ) {
            double time = [_conversation.latestMessage.timestamp doubleValue];
            _timeStr = [JCHATStringUtils getFriendlyDateString:time forConversation:YES];
        } else {
            _timeStr = @"";
        }
        _contentStr = _conversation.latestMessageContentText;
        
    }
    return self;
}

+(instancetype)modelWithDic:(NSDictionary *)dic {
    return [[self alloc]initWithDic:dic];
}
@end
