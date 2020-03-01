//
//  shangzhuang.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/9.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol shangzhuangdelegate <NSObject>
@optional;
-(void)applyforzhuang;//申请上庄
-(void)downzhuang;
@end
@interface shangzhuang : UIView
{
    UIAlertView *downalert;//下庄
}
@property(nonatomic,weak)id<shangzhuangdelegate>deleagte;
@property(nonatomic,strong)NSString *banker_coin;//庄家用户余额
@property(nonatomic,strong)NSString *stream;
@property(nonatomic,strong)NSDictionary *zhuangdic;//庄家dic//不为空则为有人
-(void)addPoker;//添加扑克牌
-(void)getresult:(NSArray *)ct;//结果
-(void)remopokers;
-(instancetype)initWithFrame:(CGRect)frame ishost:(BOOL)ishost withstreame:(NSString *)stream;
-(void)setpoker;//中途进入
-(void)getbanksCoin:(NSDictionary *)zhuangdic;//一开始获取庄家信息
-(void)getNewZhuang:(NSDictionary *)dic;//获取新的庄家信息
//如果在庄上，退出直播间下庄
-(void)dismissroom;
-(void)addtableview;
-(void)removeall;
@end
