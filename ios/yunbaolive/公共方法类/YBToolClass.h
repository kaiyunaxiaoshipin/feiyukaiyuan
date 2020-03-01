//
//  YBToolClass.h
//  yunbaolive
//
//  Created by Boom on 2018/9/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^networkSuccessBlock)(int code,id info,NSString *msg);
typedef void (^networkFailBlock)();
@interface YBToolClass : NSObject
/**
 单例类方法
 
 @return 返回一个共享对象
 */
+ (instancetype)sharedInstance;

/**
 网络请求成功的回调
 */
@property(nonatomic,copy)networkSuccessBlock successB;
/**
 网络请求失败的回调
 */
@property(nonatomic,copy)networkFailBlock failB;

/**
 网络请求

 @param url 请求的接口名：例：home.gethot
 @param parameter 参数的字典
 @param successBlock 成功的回调
 @param failBlock 失败的回调
 */
+ (void)postNetworkWithUrl:(NSString *)url andParameter:(nullable id)parameter success:(networkSuccessBlock)successBlock fail:(networkFailBlock)failBlock;

/**
 计算字符串宽度

 @param str 字符串
 @param font 字体
 @param height 高度
 @return 宽度
 */
- (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;
+ (CGFloat)widthOfString:(NSString *)str andFont:(UIFont *)font andHeight:(CGFloat)height;

/**
 计算字符串的高度

 @param str 字符串
 @param font 字体
 @param width 宽度
 @return 高度
 */
- (CGFloat)heightOfString:(NSString *)str andFont:(UIFont *)font andWidth:(CGFloat)width;
/**
 画一条线
 
 @param frame 线frame
 @param color 线的颜色
 @param view 父View
 */
- (void)lineViewWithFrame:(CGRect)frame andColor:(UIColor *)color andView:(UIView *)view;

/**
 MD5加密

 @param input 要加密的字符串
 @return 加密好的字符串
 */
- (NSString *) md5:(NSString *) input;

/**
 比较两个时间的大小

 @param date01 老的时间
 @param date02 新的时间
 @return 返回 1 -1 0
 */
-(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

/**
 创建emoji正则表达式

 @param pattern 正则规则
 @param str 字符串
 @return 数组
 */
- (NSArray <NSTextCheckingResult *> *)machesWithPattern:(NSString *)pattern  andStr:(NSString *)str;

- (UIImage *)getLaunchImage;

-(void)quitLogin;
@end

NS_ASSUME_NONNULL_END
