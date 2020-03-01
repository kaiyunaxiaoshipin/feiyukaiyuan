//
//  liveCommon.h
//  
//
//  Created by 王敏欣 on 2017/1/18.
//
//

#import <Foundation/Foundation.h>

@interface liveCommon : NSObject

@property(nonatomic,  strong)NSString *share_title;//分享话语
@property(nonatomic,  strong)NSString *share_des;//分享话语
@property(nonatomic,  strong)NSString *wx_siteurl;//分享微信观看页面
@property(nonatomic,  strong)NSString *ipa_ver;//ios版本号
@property(nonatomic,  strong)NSString *app_ios;//分享ios下载链接
@property(nonatomic,  strong)NSString *ios_shelves;//用于上架隐藏  1代表正常。其他为隐藏
@property(nonatomic,  strong)NSString *name_coin;//显示钻石文字
@property(nonatomic,  strong)NSString *name_votes;//显示魅力值文字
@property(nonatomic,  strong)NSString *enter_tip_level;//金光一闪等级

@property(nonatomic,  strong)NSString *maintain_switch;  //维护开关
@property(nonatomic,  strong)NSString *maintain_tips;    //维护信息
@property(nonatomic,  strong)NSString *live_pri_switch;  //私密房间开关
@property(nonatomic,  strong)NSString *live_cha_switch;  //收费房间开关
@property(nonatomic,  strong)NSString *live_time_switch;  //计时收费房间开关
@property(nonatomic,  strong)NSArray  *live_time_coin;    //收费阶梯
@property(nonatomic,  strong)NSArray  *live_type;         //房间类型
@property(nonatomic,  strong)NSArray  *share_type;        //分享类型
@property(nonatomic,  strong)NSArray  *liveclass;        //直播分类

@property(nonatomic,  strong)NSArray  *userLevel;        //用户等级信息
@property(nonatomic,  strong)NSArray  *anchorLevel;      //主播等级信息

@property(nonatomic,  strong)NSString *sprout_key;  //萌颜授权key
@property(nonatomic,  strong)NSString *sprout_white;  //美白
@property(nonatomic,  strong)NSString *sprout_skin;  //磨皮
@property(nonatomic,  strong)NSString *sprout_saturated;  //饱和
@property(nonatomic,  strong)NSString *sprout_pink;  //粉嫩
@property(nonatomic,  strong)NSString *sprout_eye;  //f大眼
@property(nonatomic,  strong)NSString *sprout_face;  //瘦脸

@property(nonatomic,  strong)NSString *jpush_sys_roomid;  //IM聊天室

@property(nonatomic,  strong)NSString *video_share_title;//分享话语
@property(nonatomic,  strong)NSString *video_share_des;//分享话语
@property(nonatomic,  strong)NSString *qiniu_domain;  //七牛链接

@property(nonatomic,  strong)NSString *tximgfolder;  //腾讯上传图片的文件夹的名字

@property(nonatomic,  strong)NSString *txvideofolder;//腾讯上传视频的文件夹的名字
@property(nonatomic,  strong)NSString *cloudtype;//分享话语
@property(nonatomic,  strong)NSString *video_audit_switch;  //七牛链接

-(instancetype)initWithDic:(NSDictionary *) dic;
+(instancetype)modelWithDic:(NSDictionary *) dic;

@end
