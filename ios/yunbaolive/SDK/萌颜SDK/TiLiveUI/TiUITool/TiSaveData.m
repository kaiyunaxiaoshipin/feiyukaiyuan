//
//  TiSaveData.m
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import "TiSaveData.h"

@implementation TiSaveData

+ (void)setFloat:(float)f forKey:(NSString *)key {
    if (key.length == 0) return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:f forKey:key];
    [defaults synchronize];

}

+ (float)floatForKey:(NSString *)key {
    if (key.length == 0) return 0;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults floatForKey:key];

}

+ (void)setBool:(BOOL)b forKey:(NSString *)key {
    if (key.length == 0) return;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:b forKey:key];
    [defaults synchronize];

}

+ (BOOL)boolForKey:(NSString *)key {
    if (key.length == 0) return nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    if (key.length == 0) return;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];

}

+ (id)valueForKey:(NSString *)key {
    if (key.length == 0) return nil;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key];

}
+ (void)releaseAllCache{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@""];
    [defaults removeObjectForKey:@""];
    [defaults removeObjectForKey:@""];
    [defaults removeObjectForKey:@""];
    [defaults synchronize];
}

@end
