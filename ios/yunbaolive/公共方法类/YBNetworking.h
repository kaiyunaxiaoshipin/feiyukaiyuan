//
//  YBNetworking.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YBPullSuccessBlock)(NSDictionary *data,NSString *code,NSString *msg);
typedef void (^PullFailBlock)(id fail);

@interface YBNetworking : NSObject

/**
 * 腾讯云上传
 */
+(void)getQCloudWithUrl:(NSString *)url Suc:(YBPullSuccessBlock)sucBack Fail:(PullFailBlock)failBack;
/**
 网络封装
 @param url 接口名称
 @param dic 接口参数dic
 @param sucBack 成功回调
 @param failBack 失败回调
 */
+(void)postWithUrl:(NSString *)url Dic:(NSDictionary *)dic Suc:(YBPullSuccessBlock)sucBack Fail:(PullFailBlock)failBack;

+ (NSString *)getNetworkType;
+ (NSString *)iphoneType;
@end
