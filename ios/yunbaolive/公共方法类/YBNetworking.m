//
//  YBNetworking.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "YBNetworking.h"
#import "AFNetworking.h"
#import "sys/utsname.h"

@implementation YBNetworking

+(void)getQCloudWithUrl:(NSString *)url Suc:(YBPullSuccessBlock)sucBack Fail:(PullFailBlock)failBack {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        NSDictionary *data = [responseObject valueForKey:@"data"];
        NSString *msg = [NSString stringWithFormat:@"%@-%@",[responseObject objectForKey:@"message"],[responseObject objectForKey:@"codeDesc"]];
        //回调
        sucBack(data,code,msg);
        
    }failure:^(NSURLSessionDataTask *task, NSError *error)     {
        [MBProgressHUD showError:YZMsg(@"网络错误")];
        //必须判断failback是否存在
        if (failBack) {
            failBack(error);
        }
    }];
}
+(void)postWithUrl:(NSString *)url Dic:(NSDictionary *)dic Suc:(YBPullSuccessBlock)sucBack Fail:(PullFailBlock)failBack {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //NSString *pullUrl = [purl stringByAppendingFormat:@"?service=%@",url];//index.php
    [session POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]]) {
            NSDictionary *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
            //回调
            if ([code isEqual:@"700"]) {
                [[YBToolClass sharedInstance] quitLogin];
                [MBProgressHUD showError:msg];

                return ;
            }
            sucBack(data,code,msg);
        }else{
            NSString *erro_fun = [self getFunName:url];
            sucBack(@{},@"9999",[NSString stringWithFormat:@"接口错误:%@-%@\n%@",number,erro_fun,[responseObject valueForKey:@"msg"]]);
        }
    }failure:^(NSURLSessionDataTask *task, NSError *error)     {
        [MBProgressHUD showError:YZMsg(@"网络错误")];
        //必须判断failback是否存在
        if (failBack) {
            failBack(error);
        }
    }];
}
/**
 * 获得接口名称
 * @param url 全地址(eg:xxx/api/public/?service=Video.getRecommendVideos&uid=12470&type=0&p=1)
 * @return 返回的接口名(eg:Video.getRecommendVideos)
 */
+(NSString *)getFunName:(NSString *)url{
    if (![url containsString:@"&"]) {
        url = [url stringByAppendingFormat:@"&"];
    }
    NSRange startRange = [url rangeOfString:@"="];
    NSRange endRange = [url rangeOfString:@"&"];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [url substringWithRange:range];
    return result;
}

+ (NSString *)getNetworkType
{
    if (@available(iOS 13.0, *)) {
        return @"";
    }
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = [app valueForKeyPath:@"statusBar"];
    NSString *network = @"";
    if (iPhoneX) {
        //        iPhone X
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                network = @"WIFI";
            }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                network = [subview valueForKeyPath:@"originalText"];
            }
        }
    }else {
        //        非 iPhone X
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [foregroundView subviews];
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"2G";
                        break;
                    case 2:
                        network = @"3G";
                        break;
                    case 3:
                        network = @"4G";
                        break;
                    case 5:
                        network = @"WIFI";
                        break;
                    default:
                        break;
                }
            }
        }
    }
    if ([network isEqualToString:@""]) {
        network = @"NO DISPLAY";
    }
    return network;
}

+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([phoneType  isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([phoneType  isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([phoneType  isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([phoneType  isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([phoneType  isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([phoneType  isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([phoneType  isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([phoneType  isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([phoneType  isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([phoneType  isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([phoneType  isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([phoneType  isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([phoneType  isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([phoneType  isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([phoneType  isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([phoneType  isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([phoneType  isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([phoneType  isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([phoneType  isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
    
    if([phoneType  isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
    
    if([phoneType  isEqualToString:@"iPhone11,4"]) return@"iPhone XS Max";
    
    if([phoneType  isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
    
    return @"";
}

@end
