//
//  NearbyVideoModel.h
//  iphoneLive
//
//  Created by YangBiao on 2017/9/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyVideoModel : NSObject
@property (nonatomic,copy) NSString *videoImage;  //视频封面图
@property (nonatomic,copy) NSString *videoTitle;  //视频标题
@property (nonatomic,copy) NSString *videoID;     //视频ID
@property (nonatomic,copy) NSString *playUrlStr;  //视频播放链接
@property (nonatomic,copy) NSString *distance;    //距离
@property (nonatomic,copy) NSString *time;        //时间
@property (nonatomic,copy) NSString *commentNum;  //评论数量
@property (nonatomic,strong)NSString *zanNum;      //点赞数
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *userAvatar;  //作者头像
@property (nonatomic,copy) NSString *userName;    //作者昵称
@property (nonatomic,copy) NSString *userUid;     //作者uid
@property (nonatomic,copy) NSString *status;     //状态0未审核1通过2拒绝
@property (nonatomic,copy) NSString *views;     //浏览次数

- (instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
