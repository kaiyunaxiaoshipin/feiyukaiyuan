//
//  YLYMusicLRC.h
//  OKLRCDemo
//
//  Created by 楊盧银Mac on 14-5-16.
//  Copyright (c) 2014年 com.yly16. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLYMusicLRC : NSObject

@property (strong , nonatomic)NSMutableArray *lrcList;
-(YLYMusicLRC*)initWithLRCFile:(NSString*)path;
@end
