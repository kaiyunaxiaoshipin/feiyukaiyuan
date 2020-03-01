//
//  fansModel.m
//  yunbaolive
//
//  Created by cat on 16/4/1.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "fansModel.h"
@implementation fansModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        self.name = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
        self.level = [NSString stringWithFormat:@"%@",[dic valueForKey:@"level"]];
        self.sex = [NSString stringWithFormat:@"%@",[dic valueForKey:@"sex"]];
        self.signature = [NSString stringWithFormat:@"%@",[dic valueForKey:@"signature"]];
        self.icon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
        if ([dic valueForKey:@"id"]) {
            self.uid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        }else{
            self.uid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"uid"]];
        }
        self.isattention = [NSString stringWithFormat:@"%@",[dic valueForKey:@"isattention"]];
        self.level_anchor = [NSString stringWithFormat:@"%@",[dic valueForKey:@"level_anchor"]];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return  [[self alloc]initWithDic:dic];
}
@end
