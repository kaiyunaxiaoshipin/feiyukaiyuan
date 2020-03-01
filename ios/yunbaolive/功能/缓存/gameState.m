//
//  gameState.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/13.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "gameState.h"
//1 是庄家
NSString *const  zhuangjia = @"zhuangjia";
NSString *const  zhuanglimits = @"zhuanglimits";
//1 游戏进行中。 0 游戏未开始
NSString *const  gameover = @"gameover";

@implementation gameState

+(void)saveProfile:(NSString *)isGameOver{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isGameOver forKey:gameover];
    [userDefaults synchronize];
}
+ (void)updateProfile:(NSString *)isGameOver{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:isGameOver forKey:gameover];
}
+(NSString *)getGameState
{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *gameStates = [userDefults objectForKey:@"gameover"];
    return gameStates;
}
//获取上庄限制
+ (void)savezhuanglimit:(NSString *)zhuanglimit{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:zhuanglimit forKey:zhuanglimits];
    [userDefaults synchronize];
    
}
+(NSString *)getzhuanglimit{
    NSUserDefaults *userDefults = [NSUserDefaults standardUserDefaults];
    NSString *zhuanglimi = [userDefults objectForKey:@"zhuanglimits"];
    return zhuanglimi;
}
@end
