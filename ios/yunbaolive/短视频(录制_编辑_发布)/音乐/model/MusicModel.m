//
//  MusicModel.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        _songID = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
        _musicNameStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
        _singerStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"author"]];
        _bgStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"img_url"]];
        _timeStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"length"]];
        _urlStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"file_url"]];
        _useNumsStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"use_nums"]];
        _isCollectStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"iscollect"]];
    }
    return self;
}

+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}


@end
