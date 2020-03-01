//
//  common.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/18.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "liveCommon.h"
@interface common : NSObject
+ (void)saveProfile:(liveCommon *)common;
+ (void)clearProfile;
+(liveCommon *)myProfile;
+(NSString *)share_title;
+(NSString *)share_des;
+(NSString *)wx_siteurl;
+(NSString *)ipa_ver;
+(NSString *)app_ios;
+(NSString *)ios_shelves;
+(NSString *)name_coin;
+(NSString *)name_votes;
+(NSString *)enter_tip_level;


+(NSString *)maintain_switch; //维护开关
+(NSString *)maintain_tips;   //维护内容
+(NSString *)live_pri_switch; //私密房间开关
+(NSString *)live_cha_switch; //收费房间开关
+(NSString *)live_time_switch;//计时收费房间开关
+(NSArray  *)live_time_coin;  //收费阶梯
+(NSArray  *)live_type;       //房间类型
+(NSArray  *)share_type;  //分享类型
+(NSArray  *)liveclass;  //直播分类
+(void)saveagorakitid:(NSString *)agorakitid;//声网ID
+(NSString  *)agorakitid;

+(NSString *)sprout_key;
+(NSString *)sprout_white;
+(NSString *)sprout_skin;
+(NSString *)sprout_saturated;
+(NSString *)sprout_pink;
+(NSString *)sprout_eye;
+(NSString *)sprout_face;
+(NSString *)jpush_sys_roomid;

+(NSString *)qiniu_domain;
+(NSString *)video_share_title;
+(NSString *)video_share_des;
#pragma mark - 后台审核开关
+(NSString *)getAuditSwitch;
#pragma mark - 腾讯空间
+(NSString *)getTximgfolder;
+(NSString *)getTxvideofolder;
#pragma mark - 存储类型（七牛-腾讯）
+(NSString *)cloudtype;


/**
 获取用户等级信息
 
 @param level 等级
 @return 用户等级信息字典
 */
+(NSDictionary *)getUserLevelMessage:(NSString *)level;

/**
 获取主播等级信息

 @param level 等级
 @return 主播等级信息字典
 */
+(NSDictionary *)getAnchorLevelMessage:(NSString *)level;

//保存个人中心选项缓存
+(void)savepersoncontroller:(NSArray *)arrays;
+(NSArray *)getpersonc;

//腾讯appid
+(void)saveTXSDKAppID:(NSString *)save;
+(NSString *)getTXSDKAppID;

//梦颜参数
+(void)saveIsTXfiter:(NSString *)save;
+(NSString *)getIsTXfiter;

@end
