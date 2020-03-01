//
//  viplogin.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/6.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "userLoginAnimation.h"
#import "YFRollingLabel.h"


typedef void (^xinBlock)();

@interface viplogin : UIView
@property(nonatomic,strong)YFRollingLabel *label;
@property(nonatomic,weak)id<useradimation>delegate;
@property(nonatomic,strong)UIImageView *userMoveImageV;//进入动画背景
@property(nonatomic,assign)int  isUserMove;// 限制用户进入动画
@property(nonatomic,strong)NSMutableArray *userLogin;//用户进入数组，存放动画

-(void)addUserMove:(NSDictionary *)dic;

-(instancetype)initWithFrame:(CGRect)frame andBlock:(xinBlock)blocks;

@property(nonatomic,copy)xinBlock blocks;

@end
