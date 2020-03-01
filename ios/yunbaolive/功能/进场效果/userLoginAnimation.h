//
//  userLoginAnimation.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/2/21.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol useradimation <NSObject>

-(void)animationlogin;

@end

@interface userLoginAnimation : UIView
@property(nonatomic,strong)UIImageView *vipimage;
@property(nonatomic,weak)id<useradimation>delegate;
@property(nonatomic,strong)UIImageView *userMoveImageV;//进入动画背景
@property(nonatomic,strong)UIView *msgView;//显示用户信息

@property(nonatomic,assign)int  isUserMove;// 限制用户进入动画
@property(nonatomic,strong)NSMutableArray *userLogin;//用户进入数组，存放动画
-(void)addUserMove:(NSDictionary *)dic;

@end
