//
//  Hourglass.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/5/16.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^xinblock)();

typedef void (^taskblocks)(NSString *task);

@interface Hourglass : UIView

@property (nonatomic, copy) taskblocks blocks;

@property (nonatomic, copy) taskblocks taskblock;

@property (nonatomic, copy) taskblocks jingpaiblock;

@property (nonatomic, copy) taskblocks chongzhiblock;


@property(nonatomic,assign)int configwatch;//总的时间
@property(nonatomic,strong)NSString *stream;//流名

@property(nonatomic,copy)NSString *price_bond;//保证金

-(instancetype)initWithDic:(NSDictionary *)hostdic andFrame:(CGRect)frame Block:(taskblocks)block andtask:(taskblocks)taskblock andjingpaixiangqingblock:(taskblocks)jingpaiblock andchongzhi:(taskblocks)chongzhiblock;

-(void)addtimeL;
-(void)addjingpairesultview:(int)a anddic:(NSDictionary *)dic;//添加竞拍结果
-(void)getjingpaimessage:(NSDictionary *)subdic;
//添加显示目前竞拍价格最高的那一个人
-(void)addnowfirstpersonmessahevc;
-(void)getcoins;
-(void)getnewmessage:(NSDictionary *)dic;
-(void)removeall;
@end
