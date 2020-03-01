//
//  MsgTopPubModel.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgTopPubModel : NSObject

@property(nonatomic,strong)NSString *pageVC;                //区分 赞、@我的、评论

//三个页面公共字段
@property(nonatomic,strong)NSString *uidStr;
@property(nonatomic,strong)NSString *unameStr;
@property(nonatomic,strong)NSString *iconStr;
@property(nonatomic,strong)NSString *timeStr;
@property(nonatomic,strong)NSString *videoidStr;
@property(nonatomic,strong)NSString *videouidStr;           //发视频的人对应的uid
@property(nonatomic,strong)NSString *coverStr;              //封面

//赞
@property(nonatomic,strong)NSString *typeStr;               //0-评论  1-视频
@property(nonatomic,strong)NSString *commentid;             //评论id

//@我的
@property(nonatomic,strong)NSString *videoTitleStr;         //视频标题
//评论
@property(nonatomic,strong)NSString *touidStr;              //被评论人的id（预留）
@property(nonatomic,strong)NSString *commentConStr;         //评论的内容

- (instancetype)initWithDic:(NSDictionary *)dic vcType:(NSString *)vcType;
+ (instancetype)modelWithDic:(NSDictionary *)dic vcType:(NSString *)vcType;

@end
