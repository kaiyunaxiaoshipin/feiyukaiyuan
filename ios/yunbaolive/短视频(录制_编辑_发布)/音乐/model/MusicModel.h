//
//  MusicModel.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicModel : NSObject

@property(nonatomic,strong)NSString *songID;             //歌曲ID
@property(nonatomic,strong)NSString *musicNameStr;       //歌曲名字
@property(nonatomic,strong)NSString *singerStr;          //歌手名字
@property(nonatomic,strong)NSString *bgStr;              //歌手/歌曲封面
@property(nonatomic,strong)NSString *timeStr;            //歌曲时长
@property(nonatomic,strong)NSString *urlStr;             //歌曲下载地址
@property(nonatomic,strong)NSString *useNumsStr;         //使用次数
@property(nonatomic,strong)NSString *isCollectStr;       //是否收藏


-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
