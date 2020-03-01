//
//  NearbyVideoModel.m
//  iphoneLive
//
//  Created by YangBiao on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "NearbyVideoModel.h"

@implementation NearbyVideoModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        id userinfo = [dic valueForKey:@"userinfo"];
        self.videoImage = [NSString stringWithFormat:@"%@",[dic valueForKey:@"thumb"]];
        self.videoTitle = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
        self.videoID    = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        self.playUrlStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"href"]];
        self.distance   = [NSString stringWithFormat:@"%@",[dic valueForKey:@"distance"]];
        self.status   = [NSString stringWithFormat:@"%@",[dic valueForKey:@"status"]];
        self.views   = [NSString stringWithFormat:@"%@",[dic valueForKey:@"views"]];
        if ([userinfo isKindOfClass:[NSDictionary class]]) {
            self.userAvatar = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"userinfo"] valueForKey:@"avatar"]];
            self.userName   = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"userinfo"] valueForKey:@"user_nicename"]];
        }else{
            self.userAvatar = @"";
            self.userName   = @"";
        }
        self.userUid    = [NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
        self.time       = [NSString stringWithFormat:@"%@",[dic valueForKey:@"datetime"]];
        self.commentNum = [NSString stringWithFormat:@"%@",[dic valueForKey:@"comments"]];
        self.zanNum     = [NSString stringWithFormat:@"%@",[dic valueForKey:@"likes"]];
        if (minstr([dic valueForKey:@"city"])!=nil & minstr([dic valueForKey:@"city"])!=NULL &&minstr([dic valueForKey:@"city"]).length!=0) {
            self.city = [NSString stringWithFormat:@"%@",[dic valueForKey:@"city"]];

        }else{
            if ([userinfo isKindOfClass:[NSDictionary class]]) {
                self.city = [NSString stringWithFormat:@"%@",[userinfo valueForKey:@"city"]];
            }else{
                self.city = YZMsg(@"好像在火星");
            }
        }
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    
    NearbyVideoModel *model = [[NearbyVideoModel alloc]initWithDic:dic];
    return model;
}
@end
