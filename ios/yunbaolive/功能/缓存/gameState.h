//
//  gameState.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/13.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface gameState : NSObject
+ (void)saveProfile:(NSString *)isGameOver;
+ (void)updateProfile:(NSString *)isGameOver;
+(NSString *)getGameState;

+ (void)savezhuanglimit:(NSString *)zhuanglimit;//上庄限制
+(NSString *)getzhuanglimit;
@end
