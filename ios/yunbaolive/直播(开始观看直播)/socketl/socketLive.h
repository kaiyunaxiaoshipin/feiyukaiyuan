//
//  socketLive.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/24.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <SocketIO/SocketIO-Swift.h>
#import "linkAlertView.h"
#import "anchorPKAlert.h"

@protocol socketLiveDelegate <NSObject>

@optional
-(void)socketCloseShow;
-(void)getZombieList:(NSArray *)list;
-(void)sendMessage:(NSDictionary *)dic;
-(void)sendDanMu:(NSDictionary *)dic;
-(void)socketUserLive:(NSString *)ID and:(NSDictionary *)msg;
-(void)socketUserLogin:(NSString *)ID andDic:(NSDictionary *)dic;
-(void)socketLight;
-(void)sendGift:(NSDictionary *)msg;
-(void)socketSystem:(NSString *)ct;
-(void)sendBarrage:(NSDictionary *)msg;

-(void)getResult:(NSArray *)array;//炸金花开奖结果
-(void)getCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//转盘
-(void)getRotationResult:(NSArray *)array;//转盘开奖结果
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money;//更新投注金额
//二八贝
-(void)getShellResult:(NSArray *)array;//二八贝开奖结果
-(void)getShellCoin:(NSString *)type andMoney:(NSString *)money;//二八贝更新投注金额
-(void)getzhuangjianewmessagedelegate:(NSDictionary *)subdic;

//超管禁用直播
-(void)superStopRoom:(NSString *)state;

-(void)addvotesdelegate:(NSString *)votes;
////连麦**************************************************************
//-(void)getConnectvideo:(NSString *)AudienceName andAudienceID:(NSString *)Audience;
//-(void)xiamai:(NSString *)uname andID:(NSString *)uid;
//
//-(void)getjingpaimessagedelegate:(NSDictionary *)dic;//竞拍
//
//-(void)getnewmessage:(NSDictionary *)dic;//有人竞拍更新信息
//
//-(void)jingpaioverdelegate:(NSDictionary *)dic;//竞拍结束

-(void)loginOnOtherDevice;
#pragma mark ================ 连麦 ===============
/**
 连麦成功，拉取连麦用户的流
 
 @param playurl 流地址
 @param userid 用户ID
 */
-(void)getSmallRTMP_URL:(NSString *)playurl andUserID:(NSString *)userid;
/**
 有人下麦
 
 @param uid UID
 */
-(void)usercloseConnect:(NSString *)uid;

/**
 更改Livebroadcast中的连麦状态

 @param islianmai 是否在连麦
 */
- (void)changeLivebroadcastLinkState:(BOOL)islianmai;

#pragma mark ================ 守护 ===============
- (void)updateGuardMsg:(NSDictionary *)dic;
#pragma mark ================ 主播与主播连麦 ===============
- (void)anchor_agreeLink:(NSDictionary *)dic;
- (void)anchor_stopLink:(NSDictionary *)dic;
#pragma mark ================ PK ===============
- (void)showPKView;
- (void)showPKButton;
- (void)showPKResult:(NSDictionary *)dic;
- (void)changePkProgressViewValue:(NSDictionary *)dic;
- (void)duifangjujuePK;
#pragma mark ================ 发红包 ===============
- (void)showRedbag:(NSDictionary *)dic;

#pragma mark - 检查游戏状态
-(BOOL)checkGameState;


- (void)showAllLuckygift:(NSDictionary *)dic;
- (void)JackpotLevelUp:(NSDictionary *)dic;
- (void)WinningPrize:(NSDictionary *)dic;

@end
@interface socketLive : NSObject<UIAlertViewDelegate,anchorPKAlertDelegate>
{
    SocketIOClient *ChatSocket;
    LiveUser *user;
    BOOL isbusy;
    linkAlertView *linkAlert;
    BOOL isAnchorLink;
    anchorPKAlert *pkAlertView;

}

@property(nonatomic,assign)id<socketLiveDelegate>delegate;
@property(nonatomic,strong)NSString *titleColor;
@property(nonatomic,strong)NSString *lianmaiID;//连麦人的ID
@property(nonatomic,strong)NSString *shut_time;//禁言时间
@property(nonatomic,strong)NSDictionary *zhuboDic;

-(void)getshut_time:(NSString *)shut_time;//获取禁言时间（createroom获取）
-(void)addNodeListen:(NSString *)socketUrl andTimeString:(NSString *)timestring;//添加cosket监听
-(void)colseSocket;
-(void)closeRoom;
-(void)phoneCall:(NSString *)message;
-(void)getZombie;
-(void)setAdminID:(NSString *)ID andName:(NSString *)name andCt:(NSString *)ct;
-(void)shutUp:(NSString *)ID andName:(NSString *)name andType:(NSString *)type;
-(void)kickuser:(NSString *)ID andName:(NSString *)name;
-(void)sendBarrage:(NSString *)info;
-(void)sendMessage:(NSString *)text;

//炸金花游戏
-(void)zhaJinHua:(NSString *)gameid andTime:(NSString *)time andJinhuatoken:(NSString *)Jinhuatoken ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
//主播发送通知用户开始游戏
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
-(void)takePoker:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist;//开始发牌
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype;//主播关闭游戏
//转盘游戏
-(void)RotatuonGame:(NSString *)gameid andTime:(NSString *)time androtationtoken:(NSString *)rotationtoken;
-(void)stopRotationGame;
-(void)prepRotationGame;
//压住
-(void)stakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype;
//改变房间类型
-(void)changeLiveType:(NSString *)type_val;
//连麦回复
-(void)replyConnectvideo:(NSString *)action andAudienceID:(NSString *)uid;
-(void)closevideo:(NSString *)ID;
-(void)hostisbusy:(NSString *)touid;//主播正忙碌（连麦）
-(void)hostout:(NSString *)touid;//主播未响应（连麦）
-(void)sendjiangpaimessage:(NSString *)type;//竞拍消息

-(void)getzhuangjianewmessagem:(NSDictionary *)subdic;

-(void)closeconnectuser:(NSString *)uid;
#pragma mark ================ 主播与主播连麦 ===============
- (void)anchor_startLink:(NSDictionary *)dic andMyInfo:(NSDictionary *)myInfo;
- (void)anchor_DuankaiLink;
#pragma mark ================ PK ===============
- (void)launchPK;
#pragma mark ================ 红包 ===============
- (void)fahongbaola;

@end
