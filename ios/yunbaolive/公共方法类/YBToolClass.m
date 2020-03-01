//
//  YBToolClass.m
//  yunbaolive
//
//  Created by Boom on 2018/9/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "YBToolClass.h"
#import<CommonCrypto/CommonDigest.h>
#import "PhoneLoginVC.h"
#import "AppDelegate.h"


@implementation YBToolClass
static YBToolClass* kSingleObject = nil;

/** 单例类方法 */
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSingleObject = [[super allocWithZone:NULL] init];
    });
    
    return kSingleObject;
}

// 重写创建对象空间的方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    // 直接调用单例的创建方法
    return [self sharedInstance];
}
/**
 网络请求
 
 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)postNetworkWithUrl:(NSString *)url andParameter:(id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *requestUrl = [purl stringByAppendingFormat:@"/?service=%@",url];
//    NSString *requestUrl = [purl stringByAppendingFormat:@"/?service=%@&language=",url,[Config canshu]];

    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *pDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:minstr([Config getOwnID]),@"uid",minstr([Config getOwnToken]),@"token", nil];
    [pDic addEntriesFromDictionary:parameter];
    
    
    [session POST:requestUrl parameters:pDic
         progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
             NSNumber *number = [responseObject valueForKey:@"ret"] ;
             if([number isEqualToNumber:[NSNumber numberWithInt:200]])
             {
                 NSArray *data = [responseObject valueForKey:@"data"];
                 int code = [minstr([data valueForKey:@"code"]) intValue];
                 id info = [data valueForKey:@"info"];
                 successBlock(code, info,minstr([data valueForKey:@"msg"]));
                 if (code == 700) {
                     [[YBToolClass sharedInstance] quitLogin];
                     [MBProgressHUD showError:minstr([data valueForKey:@"msg"])];

                 }
             }else{
                 [MBProgressHUD showError:minstr([responseObject valueForKey:@"msg"])];
             }
             
         }
          failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         /*
         UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"接口错误" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
         UIViewController *currentVC = [UIApplication sharedApplication].delegate.window.rootViewController;
         [alertC addAction:cancelA];
         [currentVC presentViewController:alertC animated:YES completion:nil];
         */
         failBlock();
         [MBProgressHUD hideHUD];
         [MBProgressHUD showError:@"网络请求失败"];

     }];
}

/**
 计算字符串宽度
 
 @param str 字符串
 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}

+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height{
    return [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width;
}
/**
 计算字符串的高度
 
 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)heightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width{
    return [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height;
}

/**
 画一条线

 @param frame 线frame
 @param color 线的颜色
 @param view 父View
 */
- (void)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andView:(UIView *)view{
    UIView *lineView = [[UIView alloc]initWithFrame:frame];
    lineView.backgroundColor = color;
    [view addSubview:lineView];
}
/**
 MD5加密
 
 @param input 要加密的字符串
 @return 加密好的字符串
 */

- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr,strlen(cStr),digest); // This is the md5 call
    
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
    [output appendFormat:@"%02x", digest[i]];
    
    
    return output;
    
}

-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    
    int ci;

    NSDateFormatter *df = [[NSDateFormatter alloc]init];

    [df setDateFormat:@"yyyy-MM-dd HH:mm"];

    NSDate *dt1 = [[NSDate alloc]init];

    NSDate *dt2 = [[NSDate alloc]init];

    dt1 = [df dateFromString:date01];

    dt2 = [df dateFromString:date02];

    NSComparisonResult result = [dt1 compare:dt2];

    switch (result)

    {

        //date02比date01大
        case NSOrderedAscending:
            ci = 1;
            break;
        //date02比date01小
        case NSOrderedDescending:
            ci = -1;
            break;
        //date02=date01
        case NSOrderedSame:
            ci = 0;
            break;
        default:
            NSLog(@"erorr dates %@, %@", dt2, dt1);
            break;
     }

    return ci;

}

- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str
{
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error)
    {
        NSLog(@"正则表达式创建失败");
        return nil;
    }
    return [expression matchesInString:str options:0 range:NSMakeRange(0, str.length)];
}
- (UIImage *)getLaunchImage{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    
    //横屏请设置成 @"Landscape"
    
    NSString *viewOrientation = @"Portrait";
    
    NSString *launchImageName = nil;
    
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary* dict in imagesDict)
        
    {
            
    CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
            
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
                
        {
                    
            launchImageName = dict[@"UILaunchImageName"];
                    
        }
            
    }
    
    UIImage * launchImage = [UIImage imageNamed:launchImageName];
    
    return launchImage;
}
//退出登录函数
-(void)quitLogin
{
    NSString *aliasStr = [NSString stringWithFormat:@"youke"];
    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [Config clearProfile];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (!error) {
            //退出登录成功
        } else {
            //退出登录失败
        }
    }];
    UIApplication *app =[UIApplication sharedApplication];
    AppDelegate *app2 = (AppDelegate *)app.delegate;
    PhoneLoginVC *login = [[PhoneLoginVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    app2.window.rootViewController = nav;
}


@end
