//
//  LiveNodeModel.m
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveNodeModel.h"

@implementation LiveNodeModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if([dic valueForKey:@"title"] == nil || [[dic valueForKey:@"title"] isEqual:[NSNull null]] || [[dic valueForKey:@"title"] isEqualToString:@""])
        {
            self.title = YZMsg(@"无标题");
        }
        else
        {
            self.title = [dic valueForKey:@"title"];
        }
        self.nums = [NSString stringWithFormat:@"%@",[dic valueForKey:@"nums"]];
        self.dateendtime = [NSString stringWithFormat:@"%@",[dic valueForKey:@"dateendtime"]];
        self.datestarttime = [NSString stringWithFormat:@"%@",[dic valueForKey:@"datestarttime"]];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end


