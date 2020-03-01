//
//  gameBottomVC.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "gameBottomVC.h"
typedef void (^playSuccess)(id arrays);
@interface shellGame : UIView
//socket
@property(nonatomic,copy)NSString *method;
@property(nonatomic,copy)NSString *msgtype;
@property(nonatomic,weak)id<gameDelegate>delagate;
@property(nonatomic,assign)BOOL isHost;
@property(nonatomic,strong)NSDictionary *zhuboDic;//直播dic
@property(nonatomic,strong)NSDictionary *info;//
-(instancetype)initWIthDic:(NSDictionary *)dic andIsHost:(BOOL)ok andMethod:(NSString *)method andMsgtype:(NSString *)msgtype andandBanklist:(NSDictionary *)dic;
-(void)startGame:(playSuccess)ok;//开始游戏
-(void)getShellResult:(NSArray *)array;//游戏结果
-(void)getShellCoin:(NSString *)type andMoney:(NSString *)money;//更新押注
-(void)gameOver;
-(void)createUI;//开始执行动画(moveiplay)
-(void)movieplayStartCut:(NSString *)time andGameid:(NSString *)gameid;//开始倒计时(moveiplay)
-(void)getmyCOIns:(NSArray *)arrays;
-(void)stopGame;
-(void)getNewCOins:(NSArray *)array;//中途加入的获取分数
-(void)releaseAll;
//二八贝
-(void)reloadcoins;
@end
