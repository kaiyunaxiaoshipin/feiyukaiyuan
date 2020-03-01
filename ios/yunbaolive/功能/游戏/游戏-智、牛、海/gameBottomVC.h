//
//  gameBottomVC.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void (^playSuccess)(id arrays);
@protocol gameDelegate <NSObject>
@optional;
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)startGameSocketToken:(NSString *)token andGameID:(NSString *)ID andTime:(NSString *)time ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)prepGame:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist;//主播发送通知用户开始游戏
-(void)skate:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype;//用户投注
-(void)playSuccess;
-(void)pushCoinV;
-(void)reloadcoinsdelegate;

-(void)changebank:(NSDictionary *)subdic;//更换庄家
@end
@interface gameBottomVC : UIView

@property(nonatomic,copy)NSString *bankerid;//庄家ID 无庄家为0
@property(nonatomic,copy)NSString *isFirst;//判断是不是第一次点击游戏
//socket
@property(nonatomic,copy)NSString *method;
@property(nonatomic,copy)NSString *msgtype;
@property(nonatomic,weak)id<gameDelegate>delagate;
@property(nonatomic,assign)BOOL isHost;
@property(nonatomic,strong)NSDictionary *zhuboDic;//直播dic
@property(nonatomic,strong)NSDictionary *info;//
-(instancetype)initWIthDic:(NSDictionary *)dic andIsHost:(BOOL)ok andMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)startGame:(playSuccess)ok;//开始游戏
-(void)getResult:(NSArray *)array;//游戏结果
-(void)createUI;//开始执行动画(moveiplay)
-(void)continueUI;//中途加入的
-(void)movieplayStartCut:(NSString *)time andGameid:(NSString *)gameid;//开始倒计时(moveiplay)
-(void)getCoinType:(NSString *)type andMoney:(NSString *)money;//更新押注
-(void)stopGame;
-(void)getNewCOins:(NSArray *)array;//中途加入的获取分数
-(void)getmyCOIns:(NSArray *)arrays;
-(void)releaseAll;
-(void)reloadcoins;
-(void)changebankid:(NSString *)bankid;
@end
