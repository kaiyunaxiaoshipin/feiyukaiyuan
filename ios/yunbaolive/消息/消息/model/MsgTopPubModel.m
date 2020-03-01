//
//  MsgTopPubModel.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MsgTopPubModel.h"

@implementation MsgTopPubModel

- (instancetype)initWithDic:(NSDictionary *)dic vcType:(NSString *)vcType{
    self = [super init];
    if (self) {
        _pageVC = vcType;
        
        _uidStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
        _unameStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
        _iconStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
        _timeStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"addtime"]];
        _videoidStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"videoid"]];
        _videouidStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"videouid"]];
        _coverStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"video_thumb"]];
        
        //赞
        if ([_pageVC isEqual:@"赞"]) {
            _typeStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"type"]];
            _commentid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"obj_id"]];
        }else if ([_pageVC isEqual:@"@我的"]){
            _videoTitleStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"video_title"]];
        }else{
            //评论
            _touidStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"touid"]];
            _commentConStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"content"]];
        }
        
    }
    return self;
}

+(instancetype)modelWithDic:(NSDictionary *)dic vcType:(NSString *)vcType{
    return [[self alloc]initWithDic:dic vcType:vcType];
}
@end
