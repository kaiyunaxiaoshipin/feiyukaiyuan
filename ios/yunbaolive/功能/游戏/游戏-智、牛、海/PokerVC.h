//
//  PokerVC.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol startGame <NSObject>
-(void)startGame;//开始倒数计时
-(void)gameOver;
@end
@interface PokerVC : UIView
-(instancetype)initWithFrame:(CGRect)frame continue:(BOOL)isContinue andIsHost:(BOOL)isHost andBackimage:(NSString *)imagename andPokernums:(int)pokernums andIshaidao:(BOOL)ishaidao andISSANZHANF:(BOOL)issanzhang;
@property(nonatomic,assign)int pokernums;//扑克牌的张数
@property(nonatomic,assign)int pokerGroups;//扑克牌每组的数量
@property(nonatomic,assign)int groups;//扑克牌分组数
@property(nonatomic,weak)id<startGame>delegate;
@property(nonatomic,strong)NSArray *ct;//返回的扑克牌数组
@property(nonatomic,assign)CGFloat  moveX1;
@property(nonatomic,assign)CGFloat  moveX2;
@property(nonatomic,assign)CGFloat  moveX3;
@property(nonatomic,assign)CGFloat  moveX;
@property(nonatomic,assign)BOOL  isHaidao;
@property(nonatomic,assign)BOOL  isshangzhuang;//有没有上庄

//发牌
@property(nonatomic,assign)int isThirdTimes;
//翻牌
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,assign)int isThirdTimesOK1;//外层
@property(nonatomic,assign)int isThirdTimesOK2;//内层
-(void)result:(NSArray *)array;
-(void)releaseMusic;
-(void)reallocAll;
@end
