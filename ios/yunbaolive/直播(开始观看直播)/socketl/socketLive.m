//
//  socketLive.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/24.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "socketLive.h"
@implementation socketLive
{
    int lianmaitime;//连麦的请求时间10s
    NSTimer *lianmaitimer;//连麦计时10s
    UIAlertView *connectAlert;
    NSString *connectID;
    BOOL isLianMai;
    NSString *connectUserName;
    BOOL isPK;
}
-(void)zhaJinHua:(NSString *)gameid andTime:(NSString *)time andJinhuatoken:(NSString *)Jinhuatoken ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": method,
                                        @"action": @"4",
                                        @"msgtype": msgtype,
                                        @"liveuid":[Config getOwnID],
                                        @"gameid":gameid,
                                        @"time":time,
                                        @"token":Jinhuatoken
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//主播发送通知用户开始游戏 展示游戏界面
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":method,
                                        @"action": @"1",
                                        @"msgtype":msgtype,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//开始发牌
-(void)takePoker:(NSString *)gameid ndMethod:(NSString *)method andMsgtype:(NSString *)msgtype andBanklist:(NSDictionary *)banklist{
    if (banklist != nil) {
        NSArray *msgData =@[
                            @{
                                @"msg": @[
                                        @{
                                            @"_method_": method,
                                            @"action": @"2",
                                            @"msgtype":msgtype,
                                            @"gameid":gameid,
                                            @"bankerlist":banklist
                                            }
                                        ],
                                @"retcode": @"000000",
                                @"retmsg": @"OK"
                                }
                            ];
        [ChatSocket emit:@"broadcast" with:msgData];
    }
    else{
        NSArray *msgData =@[
                            @{
                                @"msg": @[
                                        @{
                                            @"_method_": method,
                                            @"action": @"2",
                                            @"msgtype":msgtype,
                                            @"gameid":gameid,
                                            }
                                        ],
                                @"retcode": @"000000",
                                @"retmsg": @"OK"
                                }
                            ];
        [ChatSocket emit:@"broadcast" with:msgData];
    }
}
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": method,
                                        @"action": @"3",
                                        @"msgtype":msgtype,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//出现界面
-(void)prepRotationGame{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"1",
                                        @"msgtype":@"16",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//停止游戏
-(void)stopRotationGame{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"3",
                                        @"msgtype":@"16",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//开始倒计时
-(void)RotatuonGame:(NSString *)gameid andTime:(NSString *)time androtationtoken:(NSString *)rotationtoken{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"4",
                                        @"msgtype": @"16",
                                        @"liveuid":[Config getOwnID],
                                        @"gameid":gameid,
                                        @"time":time,
                                        @"token":rotationtoken
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//开奖
-(void)sendMessage:(NSString *)text{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"0",
                                        @"ct":text,
                                        @"msgtype": @"2",
                                        @"timestamp": @"",
                                        @"touid": @"0",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"uhead":user.avatar,
                                        @"level":[Config getLevel],
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang],
                                        @"isAnchor":@"1",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

    
}
-(void)sendBarrage:(NSString *)info{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendBarrage",
                                        @"action": @"7",
                                        @"ct":info ,
                                        @"msgtype": @"1",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"touname": @"",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [Config getOwnID],
                                        @"level":[Config getLevel],
                                        @"usign":@"",
                                        @"uhead":user.avatar,
                                        @"sex":@"",
                                        @"city":@"",
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)shutUp:(NSString *)ID andName:(NSString *)name andType:(NSString *)type{
    NSString *msg ;
    if ([type isEqual:@"0"]) {
        msg = [NSString stringWithFormat:@"%@被永久禁言",name];
    }else{
        msg = [NSString stringWithFormat:@"%@被本场禁言",name];
    }
    
    NSArray* jinyanArray = @[
                             @{
                                 @"msg":
                                     @[@{
                                           @"_method_":@"ShutUpUser",
                                           @"action":@"1",
                                           @"ct":msg,
                                           @"uid":[Config getOwnID],
                                           @"touid":ID,
                                           @"showid":[Config getOwnID],
                                           @"uname":@"",
                                           @"msgtype":@"4",
                                           @"timestamp":@"",
                                           @"tougood":@"",
                                           @"touid":@"",
                                           @"touname":@"",
                                           @"ugood":@"",
                                           @"type":type
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    [ChatSocket emit:@"broadcast" with:jinyanArray];
}
-(void)kickuser:(NSString *)ID andName:(NSString *)name{
    
    NSArray* jinyanArray = @[
                             @{
                                 @"msg":
                                     @[@{
                                           @"_method_":@"KickUser",
                                           @"action":@"2",
                                           @"ct":[NSString stringWithFormat:@"%@被踢出房间",name],
                                           @"uid":[Config getOwnID],
                                           @"touid":ID,
                                           @"showid":[Config getOwnID],
                                           @"uname":@"",
                                           @"msgtype":@"4",
                                           @"timestamp":@"",
                                           @"tougood":@"",
                                           @"touid":@"",
                                           @"touname":@"",
                                           @"ugood":@""
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    [MBProgressHUD showError:YZMsg(@"踢人成功")];
    [ChatSocket emit:@"broadcast" with:jinyanArray];
    
}
-(void)setAdminID:(NSString *)ID andName:(NSString *)name andCt:(NSString *)ct{
    NSString *cts;
    if ([ct isEqual:@"0"]) {
        //不是管理员
         cts = @"被取消管理员";
        [MBProgressHUD showError:YZMsg(@"取消管理员成功")];
    }else{
        //是管理员
          cts = @"被设为管理员";
        [MBProgressHUD showError:YZMsg(@"设置管理员成功")];
    }

    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"setAdmin",
                                            @"action":ct,
                                            @"ct":[NSString stringWithFormat:@"%@%@",name,cts],
                                            @"msgtype":@"1",
                                            @"uid":[Config getOwnID],
                                            @"uname":YZMsg(@"直播间消息"),
                                            @"touid":ID,
                                            @"touname":name
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
}
-(void)getZombie{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"requestFans",
                                        @"timestamp":@"",
                                        @"msgtype": @"0",
                                        @"action":@"3"
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)phoneCall:(NSString *)message{
    NSLog(@"lalala");
    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"SystemNot",
                                            @"action":@"13",
                                            @"ct":message,
                                            @"msgtype":@"4",
                                            @"uid":@"",
                                            @"uname":YZMsg(@"直播间消息"),
                                            @"touid":@"",
                                            @"touname":@""
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
}
-(void)closeRoom{
    NSArray *msgData1 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_": @"StartEndLive",
                                         @"action": @"18",
                                         @"ct":@"直播关闭",
                                         @"msgtype": @"1",
                                         @"timestamp": @"",
                                         @"tougood": @"",
                                         @"touid": @"",
                                         @"touname": @"",
                                         @"ugood": @"",
                                         @"uid": [Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         @"equipment": @"app",
                                         @"roomnum": [Config getOwnID]
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData1];
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"18",
                                        @"ct":@"直播关闭",
                                        @"msgtype": @"1",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"",
                                        @"touname": @"",
                                        @"ugood":@"",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [Config getOwnID]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)colseSocket{
    [ChatSocket disconnect];
    [ChatSocket off:@""];
    [ChatSocket leaveNamespace];
    ChatSocket = nil;
}
-(void)getshut_time:(NSString *)shut_time{
    
//    _shut_time = [NSString stringWithFormat:@"%@",shut_time];
}
-(void)addNodeListen:(NSString *)socketUrl andTimeString:(NSString *)timestring{
    
    __weak socketLive *weakself = self;
    lianmaitime = 10;
    isbusy = NO;
    user = [Config myProfile];
    NSURL* url = [[NSURL alloc] initWithString:socketUrl];//@"http://live.yunbaozhibo.com:19965"
//    ChatSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES,@"reconnectWait":@1}];
    SocketManager *mange =  [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES}];
    ChatSocket = [[SocketIOClient alloc] initWithManager:mange nsp:nil];
    NSArray *cur = @[@{@"username":[Config getOwnNicename],
                       @"uid":[Config getOwnID],
                       @"token":[Config getOwnToken],
                       @"roomnum":[Config getOwnID],
                       @"stream":timestring
                       }];
    [ChatSocket connect];
    [ChatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {        
        [ChatSocket emit:@"conn" with:cur];
        NSLog(@"socket链接");
    }];
    [ChatSocket on:@"conn" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"进入房间");
        [weakself getZombie];
    }];
    
    [ChatSocket on:@"broadcastingListen" callback:^(NSArray* data, SocketAckEmitter* ack) {

            if([[data[0] firstObject] isEqual:@"stopplay"])
            {
            NSLog(@"%@",[data[0] firstObject]);
            [self.delegate superStopRoom:@""];
            UIAlertView  *alertsLimit = [[UIAlertView alloc]initWithTitle:YZMsg(@"涉嫌违规，被下播") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
            [alertsLimit show];
            return ;
          }
        
            for (NSString *path in data[0]) {
            NSDictionary *jsonArray = [path JSONValue];
            NSDictionary *msg = [[jsonArray valueForKey:@"msg"] firstObject];
            NSString *retcode = [NSString stringWithFormat:@"%@",[jsonArray valueForKey:@"retcode"]];
                
            if ([retcode isEqual:@"409002"]) {
                [MBProgressHUD showError:YZMsg(@"你已被禁言")];
                return;
            }
            NSString *method = [msg valueForKey:@"_method_"];
            [weakself getmessage:msg andMethod:method];
        }
       
        
    }];
}
-(void)getmessage:(NSDictionary *)msg andMethod:(NSString *)method{
    
    if ([method isEqual:@"requestFans"]) {
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"0"]){
            NSString *action = [msg valueForKey:@"action"];
            //僵尸粉
            if ([action isEqual:@"3"]) {
                NSArray *ct = [msg valueForKey:@"ct"];
                NSArray *data = [ct valueForKey:@"data"];
                if ([[data valueForKey:@"code"]isEqualToNumber:@0]) {
                    NSArray *info = [data valueForKey:@"info"];
                    NSArray *list = [info valueForKey:@"list"];
                    [self.delegate getZombieList:list];
                }
            }
        }
    }
    else if ([method isEqual:@"updateVotes"]){
        
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if ([msgtype isEqual:@"26"])
        {
            [self.delegate addvotesdelegate:[msg valueForKey:@"votes"]];
        }
    }
    else if ([method isEqual:@"SendMsg"]) {
        
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"2"])
        {
            NSString* ct;
            NSDictionary *heartDic = [[NSArray arrayWithObject:msg] firstObject];
            NSArray *sub_heart = [heartDic allKeys];
            
            if ([sub_heart containsObject:@"heart"]) {
                NSString *lightColor = [heartDic valueForKey:@"heart"];
                NSString *light = @"light";
                _titleColor = [light stringByAppendingFormat:@"%@",lightColor];
                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                NSString* uname = [msg valueForKey:@"uname"];
                NSString *levell = [msg valueForKey:@"level"];
                NSString *ID = [msg valueForKey:@"uid"];
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSString *usertype =minstr([msg valueForKey:@"usertype"]);
                NSString *guardType =minstr([msg valueForKey:@"guard_type"]);

                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",_titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",guardType,@"guard_type",nil];
                [self.delegate sendMessage:chat];
                [self.delegate socketLight];

            }
            else {
                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                _titleColor = @"0";
                NSString* uname = [msg valueForKey:@"uname"];
                NSString *levell = [msg valueForKey:@"level"];
                NSString *ID = [msg valueForKey:@"uid"];
                
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSString *usertype =minstr([msg valueForKey:@"usertype"]);
                NSString *isAnchor = minstr([msg valueForKey:@"isAnchor"]);
                NSString *guardType =minstr([msg valueForKey:@"guard_type"]);
                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",_titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",isAnchor,@"isAnchor",guardType,@"guard_type",nil];
                
                [self.delegate sendMessage:chat];
                
                
            }
        }
        if([msgtype isEqual:@"0"])
        {
            NSString *action = [msg valueForKey:@"action"];
            //用户离开
            if ([action isEqual:@"1"]) {
                NSString *ID = [[msg valueForKey:@"ct"] valueForKey:@"id"];
                [self.delegate socketUserLive:ID and:msg];
            }
            //用户进入
            if ([action isEqual:@"0"]) {
                NSDictionary *dic = [msg valueForKey:@"ct"];
                NSString *ID = [dic valueForKey:@"id"];
                [self.delegate socketUserLogin:ID andDic:msg];
            }
        }

    }
    else if ([method isEqual:@"stopLive"])//stopLiveStartEndLive
    {
        [self.delegate superStopRoom:@""];
    }
    else if([method isEqual:@"StartEndLive"])
    {
        NSString *action = [msg valueForKey:@"action"];
        if ([action isEqual:@"19"]) {
            [self.delegate loginOnOtherDevice];
        }
    }
    else if ([method isEqual:@"light"]){
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"0"]){
            NSString *action = [msg valueForKey:@"action"];
            //点亮
            if ([action isEqual:@"2"]) {
                [self.delegate socketLight];
                NSLog(@"收到点亮消息");
            }
        }
    }
    else if([method isEqual:@"SendGift"])
    {
        if ([minstr([msg valueForKey:@"ifpk"]) isEqual:@"1"]) {
            if ([minstr([msg valueForKey:@"roomnum"]) isEqual:[Config getOwnID]]) {
                [self.delegate sendGift:msg];
            }
            [self.delegate changePkProgressViewValue:msg];
        }else{
            [self.delegate sendGift:msg];
        }
    } //幸运礼物
    else if([method isEqual:@"luckWin"])
    {
        [self.delegate showAllLuckygift:msg];
        NSLog(@"幸运礼物%@",msg);
    }
    //奖池中奖
    else if([method isEqual:@"jackpotWin"])
    {
        [self.delegate WinningPrize:msg];
        NSLog(@"奖池中奖%@",msg);
    }
    //奖池升级
    else if([method isEqual:@"jackpotUp"])
    {
        [self.delegate JackpotLevelUp:msg];
        NSLog(@"奖池升级%@",msg);
    }

    else if([method isEqual:@"SendBarrage"])
    {
        [self.delegate sendDanMu:msg];
    }
    else if ([method isEqual:@"SystemNot"] || [method isEqual:@"ShutUpUser"] || [method isEqual:@"KickUser"]){
        NSString *ct = [NSString stringWithFormat:@"%@",[msg valueForKey:@"ct"]];
        if (ct) {
            [self.delegate socketSystem:ct];
        }
    }
    else if ([method isEqual:@"setAdmin"]){
        NSString *ct = [NSString stringWithFormat:@"%@",[msg valueForKey:@"ct"]];
        if (ct) {
            [self.delegate socketSystem:ct];
        }
    }

    else if([method isEqual:@"disconnect"])
    {
        NSString *action = [msg valueForKey:@"action"];
        //用户离开
        if ([action isEqual:@"1"]) {
            NSString *ID = [[msg valueForKey:@"ct"] valueForKey:@"id"];
            if ([ID isEqual:connectID]) {
                isLianMai = NO;
                [self.delegate changeLivebroadcastLinkState:NO];
            }
            [self.delegate socketUserLive:ID and:msg];
        }
        
        /**************************  礼物结束  ***************************/
        
    }
    //炸金花游戏结果
    //游戏
    else if ([method isEqual:@"startGame"] || [method isEqual:@"startCattleGame"] || [method isEqual:@"startLodumaniGame"] ){
        
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"2"]) {
            
                        
        }
        if ([action isEqual:@"6"]) {
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.delegate getResult:ct];
        }
        else if ([action isEqual:@"5"]){
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.delegate getCoin:type andMoney:money];
        }
    }
    else if ([method isEqual:@"startRotationGame"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"6"]) {
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.delegate getRotationResult:ct];
        }
        else if ([action isEqual:@"5"]){
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.delegate getRotationCoin:type andMoney:money];
        }
    }
    else if ([method isEqual:@"startShellGame"] ){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"6"]) {
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.delegate getShellResult:ct];
        }
        else if ([action isEqual:@"5"]){
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.delegate getShellCoin:type andMoney:money];
        }
    }
    //上庄
    /*
     action 1上庄
     */
    else if ([method isEqual:@"shangzhuang"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            NSDictionary *subdic = @{
                                     @"uid":[msg valueForKey:@"uid"],
                                     @"uhead":[msg valueForKey:@"uhead"],
                                     @"uname":[msg valueForKey:@"uname"],
                                     @"coin":[msg valueForKey:@"coin"]
                                     };
            [self.delegate getzhuangjianewmessagedelegate:subdic];
        }
    }
#pragma 连麦
    //连麦
    /*
     1 有人发送连麦请求
     2 主播接受连麦
     3 主播拒绝连麦
     4 用户推流，发送自己的播流地址
     5 用户断开连麦
     6 主播断开连麦
     7 主播正忙碌
     8 主播无响应
    */
    else if ([method isEqual:@"ConnectVideo"]){//andAudienceID 连麦申请者ID
#pragma mark 连麦暂时隐藏
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            //连麦数量限制
            if (lianmaitime != 10) {
                //主播正忙碌
                [self hostisbusy:[NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]]];
                return;
                
            }
            if (isLianMai) {
                //主播正忙碌

                [self hostisbusy:[NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]]];
                return;

            }
            isAnchorLink = NO;
            isPK = NO;
            connectID = [NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]];
            if (lianmaitimer) {
                [lianmaitimer invalidate];
                lianmaitimer = nil;
            }
            if (!lianmaitimer) {
                lianmaitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lianmaidaojishi) userInfo:nil repeats:YES];
            }
            connectUserName = minstr([msg valueForKey:@"uname"]);
            [self showLinkAlert:msg];
//            NSString *name = [NSString stringWithFormat:@"%@向你发起连麦",[msg valueForKey:@"uname"]];
//            connectAlert = [[UIAlertView alloc]initWithTitle:YZMsg(@"提示") message:name delegate:self cancelButtonTitle:YZMsg(@"拒绝") otherButtonTitles:YZMsg(@"接受"), nil];
//            [connectAlert show];
        }
        else if ([action isEqual:@"4"]){
            if ([connectID isEqual:[msg valueForKey:@"uid"]]) {
                [self.delegate getSmallRTMP_URL:[msg valueForKey:@"playurl"] andUserID:[msg valueForKey:@"uid"]];
            }
        }
        else if ([action isEqual:@"5"]){
            //有人下麦
            NSString *userid;
            if ([action isEqual:@"5"]) {
                userid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]];
            }else{
                userid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
            }
            isLianMai = NO;
            [self.delegate usercloseConnect:userid];
            [self.delegate changeLivebroadcastLinkState:NO];
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"uname"]),YZMsg(@"已下麦")]];

        }
        else if ([action isEqual:@"9"]){
            [connectAlert dismissWithClickedButtonIndex:0 animated:YES];
        }

    }  else if ([method isEqual:@"BuyGuard"]){
        [self.delegate updateGuardMsg:msg];
        [self.delegate socketSystem:[NSString stringWithFormat:@"%@ %@",minstr([msg valueForKey:@"uname"]),YZMsg(@"守护了主播")]];
    }  else if ([method isEqual:@"LiveConnect"]){
         //1：发起连麦；2；接受连麦；3:拒绝连麦；4：连麦成功通知；5.手动断开连麦;7:对方正忙碌 8:对方无响应 9.游戏状态
        int action = [minstr([msg valueForKey:@"action"]) intValue];
        switch (action) {
            case 1:
                if (lianmaitime != 10) {
                    //主播正忙碌
                    [self zhubolianmaizhengmanglu:[NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]]];
                    return;
                    
                }

                if (isLianMai) {
                    [self zhubolianmaizhengmanglu:[NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]]];
                    return;
                }
                
                isPK = NO;
                isAnchorLink = YES;
                connectID = [NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]];
                //告诉对方 我是 游戏状态，
                if ([self.delegate checkGameState]) {
                    if (lianmaitimer) {
                        [lianmaitimer invalidate];
                        lianmaitimer = nil;
                        lianmaitime = 10;
                    }
                    [self anchor_operationAndAction:@"9"];
                    return;
                }
                if (lianmaitimer) {
                    [lianmaitimer invalidate];
                    lianmaitimer = nil;
                }
                if (!lianmaitimer) {
                    lianmaitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lianmaidaojishi) userInfo:nil repeats:YES];
                }
                connectUserName = minstr([msg valueForKey:@"uname"]);
                [self showLinkAlert:msg];

                break;
            case 3:
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",YZMsg(@"对方拒绝了你的连麦申请")]];
                isLianMai = NO;
                break;
            case 4:
                [self.delegate anchor_agreeLink:msg];
                
                break;
            case 5:
                isLianMai = NO;
                [MBProgressHUD showError:YZMsg(@"连麦已断开")];
                [self.delegate anchor_stopLink:msg];
                break;

            case 7:
                [MBProgressHUD showError:YZMsg(@"对方正忙碌")];
                isLianMai = NO;
                break;
            case 8:
                [MBProgressHUD showError:YZMsg(@"对方无响应")];
                isLianMai = NO;

                break;
            case 9:
                [MBProgressHUD showError:@"游戏状态下不能进行连麦哦～"];
                isLianMai = NO;
                
                break;
            default:
                break;
        }
    }
     //发红包
    else if([method isEqual:@"SendRed"])
    {
        NSString *action = [msg valueForKey:@"action"];
        //
        if ([action isEqual:@"0"]) {
            [self.delegate showRedbag:msg];
        }
    }else if ([method isEqual:@"LivePK"]){
        //1：发起PK；2；接受PK；3:拒绝PK；4：PK成功通知；5.;7:对方正忙碌 8:对方无响应 9:PK结果
        int action = [minstr([msg valueForKey:@"action"]) intValue];
        switch (action) {
                case 1:
                isPK = YES;
                if (lianmaitimer) {
                    [lianmaitimer invalidate];
                    lianmaitimer = nil;
                }
                if (!lianmaitimer) {
                    lianmaitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lianmaidaojishi) userInfo:nil repeats:YES];
                }
                connectUserName = minstr([msg valueForKey:@"uname"]);
                [self showPKAlert:msg];
                
                break;
                case 3:
                [MBProgressHUD showError:[NSString stringWithFormat:YZMsg(@"对方拒绝了你的PK申请")]];
                [self.delegate showPKButton];
                break;
                case 4:
                [self.delegate showPKView];
                
                break;
                
                case 7:
                [MBProgressHUD showError:YZMsg(@"对方正忙碌")];
                [self.delegate showPKButton];

                break;
                case 8:
                [MBProgressHUD showError:YZMsg(@"对方无响应")];
                [self.delegate showPKButton];
                break;
                case 9:
                [self.delegate showPKResult:msg];
                break;

            default:
                break;
        }
    }

    
}
//上庄
-(void)getzhuangjianewmessagem:(NSDictionary *)subdic{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"shangzhuang",
                                        @"action":@"1",
                                        @"msgtype":@"25",
                                        @"uid":[subdic valueForKey:@"uid"],
                                        @"uhead":[subdic valueForKey:@"uhead"],
                                        @"uname":[subdic valueForKey:@"uname"],
                                        @"coin":[subdic valueForKey:@"coin"]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)changeLiveType:(NSString *)type_val{
    NSArray *guanliArray =@[
                            @{
                                @"msg":@[
                                        @{
                                            @"_method_":@"changeLive",
                                            @"action":@"1",
                                            @"msgtype":@"27",
                                            @"type_val":type_val,
                                            }
                                        ],
                                @"retcode":@"000000",
                                @"retmsg":@"ok"
                                }
                            ];
    [ChatSocket emit:@"broadcast" with:guanliArray];
}
//游戏押注
-(void)stakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": method,
                                        @"action": @"5",
                                        @"msgtype":msgtype,
                                        @"type":type,
                                        @"money":money,
                                        @"uid":[Config getOwnID]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
#pragma mark ================ 连麦 ===============
//收到连麦请求倒计时10s，未接受则主动发消息，未响应
-(void)lianmaidaojishi{
    lianmaitime -= 1;
    if (isPK) {
//        linkAlert.timeL.text = [NSString stringWithFormat:@"发起PK请求(%ds)...",lianmaitime];
    }else{
        linkAlert.timeL.text = [NSString stringWithFormat:@"%@(%ds)...",YZMsg(@"发起连麦请求"),lianmaitime];
    }

    if (lianmaitime == 0) {
        lianmaitime = 10;
        [lianmaitimer invalidate];
        lianmaitimer = nil;
//        [connectAlert dismissWithClickedButtonIndex:0 animated:YES];
        [linkAlert removeFromSuperview];
        linkAlert = nil;
        if (isPK) {
            
        }else{
            if (isAnchorLink) {
                [self anchor_operationAndAction:@"8"];
            }else{
                [self hostout:connectID];
            }
        }
    }
}
//主播未响应
-(void)hostout:(NSString *)touid{
    
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"8",
                                         @"msgtype": @"10",
                                         @"touid":touid
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData2];
}
//主播正忙碌
-(void)hostisbusy:(NSString *)touid{
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"7",
                                         @"msgtype": @"10",
                                         @"touid":touid
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [ChatSocket emit:@"broadcast" with:msgData2];
}

//拒绝连麦请求
-(void)refuseConnect{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"ConnectVideo",
                                        @"action":@"3",
                                        @"msgtype": @"10",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"touid":connectID
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
//同意连麦请求
-(void)agreeMick{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"ConnectVideo",
                                        @"action":@"2",
                                        @"msgtype": @"10",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"touid":connectID,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    if (alertView == connectAlert) {
//        if (buttonIndex == 0) {
//            //拒绝
//            [self refuseConnect];
//            [self.delegate changeLivebroadcastLinkState:NO];
//            [lianmaitimer invalidate];
//            lianmaitimer = nil;
//            lianmaitime = 10;
//            isLianMai = NO;
//            return;
//        }
//        else if (buttonIndex == 1){
//            //接受
//            [self agreeMick];
//            [self.delegate changeLivebroadcastLinkState:YES];
//            [lianmaitimer invalidate];
//            lianmaitimer = nil;
//            lianmaitime = 10;
//            isLianMai = YES;
//        }
//    }
}
-(void)closeconnectuser:(NSString *)uid{
    isLianMai = NO;
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"ConnectVideo",
                                        @"action":@"6",
                                        @"msgtype": @"10",
                                        @"touid":uid,
                                        @"uname":connectUserName
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
}
- (void)showLinkAlert:(NSDictionary *)dic{
    if (linkAlert) {
        [linkAlert removeFromSuperview];
        linkAlert = nil;
    }
    linkAlert = [[linkAlertView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andUserMsg:dic];
    if (isPK) {
        linkAlert.timeL.text = [NSString stringWithFormat:@"%@(%ds)...",YZMsg(@"发起PK请求"),lianmaitime];
    }else{
        linkAlert.timeL.text = [NSString stringWithFormat:@"%@(10s)...",YZMsg(@"发起连麦请求")];
    }
    [[UIApplication sharedApplication].delegate.window addSubview:linkAlert];
    [linkAlert show];
    __weak socketLive *weakSelf = self;
    __block BOOL weakIsPK = isPK;
    linkAlert.block = ^(BOOL isAgree) {
        if (isAgree) {
            if (weakIsPK) {
                [weakSelf pk_operationAndAction:@"2"];

            }else{
                if ([dic valueForKey:@"pkuid"]) {
                    [weakSelf checkLinkLive:dic];
                }else{
                    [weakSelf agreeMick];
                    [lianmaitimer invalidate];
                    lianmaitimer = nil;
                    lianmaitime = 10;
                    isLianMai = YES;
                    [weakSelf.delegate changeLivebroadcastLinkState:YES];
                }
            }

        }else{
            if (isPK) {
                [weakSelf pk_operationAndAction:@"3"];
            }else{
                if ([dic valueForKey:@"pkuid"]) {
                    [weakSelf anchor_operationAndAction:@"3"];
                }else{
                    [weakSelf refuseConnect];
                }
                [weakSelf.delegate changeLivebroadcastLinkState:NO];
            }
            [lianmaitimer invalidate];
            lianmaitimer = nil;
            lianmaitime = 10;
            isLianMai = NO;
        }
    };
}
- (void)checkLinkLive:(NSDictionary *)dic{
    [YBToolClass postNetworkWithUrl:[NSString stringWithFormat:@"Livepk.CheckLive&stream=%@&uid_stream=%@",minstr([dic valueForKey:@"stream"]),minstr([_zhuboDic valueForKey:@"stream"])] andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [lianmaitimer invalidate];
        lianmaitimer = nil;
        lianmaitime = 10;
        NSString *myNewPull = minstr([[info firstObject] valueForKey:@"pull"]);
        if (code == 0) {
            [self anchor_Agree:@{@"pull":myNewPull}];
            isLianMai = YES;
            [self.delegate changeLivebroadcastLinkState:YES];

        }else{
            isLianMai = NO;
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        [lianmaitimer invalidate];
        lianmaitimer = nil;
        lianmaitime = 10;
        isLianMai = NO;

    }];
}
#pragma mark ================ 主播与主播连麦 ===============

/**
 主播连麦
 @param dic 对方主播信息
 @param myInfo 自己的信息(自己最新的 pull 防止鉴权过期)
 */
- (void)anchor_startLink:(NSDictionary *)dic andMyInfo:(NSDictionary *)myInfo{
    isLianMai = YES;
    connectID = minstr([dic valueForKey:@"uid"]);

    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"LiveConnect",
                                        @"action":@"1",
                                        @"msgtype": @"0",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"level":[Config getLevel],
                                        @"sex":[Config getSex],
                                        @"pkuid":minstr([dic valueForKey:@"uid"]),
                                        //@"pkpull":minstr([_zhuboDic valueForKey:@"pull"]),
                                        @"pkpull":minstr([myInfo valueForKey:@"pull"]),
                                        @"stream":minstr([_zhuboDic valueForKey:@"stream"]),
                                        @"level_anchor":[Config level_anchor],
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}
- (void)anchor_operationAndAction:(NSString *)action{
    //1：发起连麦；2；接受连麦；3:拒绝连麦；4：连麦成功通知；5.手动断开连麦;7:对方正忙碌 8:对方无响应 9.游戏状态
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"LiveConnect",
                                        @"action":action,
                                        @"msgtype": @"0",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"pkuid":connectID,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
    
}
- (void)zhubolianmaizhengmanglu:(NSString *)action{
    //1：发起连麦；2；接受连麦；3:拒绝连麦；4：连麦成功通知；5.手动断开连麦;7:对方正忙碌 8:对方无响应
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"LiveConnect",
                                        @"action":@"7",
                                        @"msgtype": @"0",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"pkuid":action,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
    
}

- (void)anchor_Agree:(NSDictionary *)dic{
    //1：发起连麦；2；接受连麦；3:拒绝连麦；4：连麦成功通知；5.手动断开连麦;7:对方正忙碌 8:对方无响应
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"LiveConnect",
                                        @"action":@"2",
                                        @"msgtype": @"0",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"pkuid":connectID,
                                        //@"pkpull":minstr([_zhuboDic valueForKey:@"pull"]),
                                        @"pkpull":minstr([dic valueForKey:@"pull"]),//防止鉴权过期，这里是获取的最新pull
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
    
}
- (void)anchor_DuankaiLink
{
    isLianMai = NO;
    [self anchor_operationAndAction:@"5"];
}
#pragma mark ================ PK ===============
- (void)launchPK{
    if (!connectID) {
        [MBProgressHUD showError:YZMsg(@"不能发起PK")];
        return;
    }
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"LivePK",
                                        @"action":@"1",
                                        @"msgtype": @"0",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"level":[Config getLevel],
                                        @"sex":[Config getSex],
                                        @"pkuid":connectID,
                                        @"level_anchor":[Config level_anchor],
                                        @"stream":minstr([_zhuboDic valueForKey:@"stream"]),
                                        @"ct":@""
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}
- (void)pk_operationAndAction:(NSString *)action{
    //1：发起连麦；2；接受连麦；3:拒绝连麦；4：连麦成功通知；5.手动断开连麦;7:对方正忙碌 8:对方无响应
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"LivePK",
                                        @"action":action,
                                        @"msgtype": @"0",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"pkuid":connectID,
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];
    
}

#pragma mark ================ 红包 ===============
- (void)fahongbaola{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendRed",
                                        @"action": @"0",
                                        @"ct":@"在直播间发红包啦！快去抢哦～",
                                        @"msgtype": @"0",
                                        @"timestamp": @"",
                                        @"touid": @"0",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"uhead":user.avatar,
                                        @"level":[Config getLevel],
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang],
                                        @"isAnchor":@"1",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [ChatSocket emit:@"broadcast" with:msgData];

}
#pragma mark ================ pk弹窗 ===============
- (void)showPKAlert:(NSDictionary *)dic{
    if (pkAlertView) {
        [pkAlertView removeFromSuperview];
        pkAlertView = nil;
    }
    pkAlertView = [[anchorPKAlert alloc]initWithFrame:CGRectMake(_window_width*0.15, _window_height/2-(_window_width*0.7/52*34)/2, _window_width*0.7, _window_width*0.7/52*34) andIsStart:NO];
    pkAlertView.delegate = self;
    [[UIApplication sharedApplication].delegate.window addSubview:pkAlertView];
}
- (void)agreePKClick{
    [self pk_operationAndAction:@"2"];
    [self removePKAlert];
}
-(void)notAgreeClick{
    [self pk_operationAndAction:@"3"];
    [self removePKAlert];
}
-(void)removeShouhuView{
    [self pk_operationAndAction:@"8"];
    [self removePKAlert];
}
- (void)removePKAlert{
    if (lianmaitimer) {
        [lianmaitimer invalidate];
        lianmaitimer = nil;
        lianmaitime = 10;
    }
    [pkAlertView removeFromSuperview];
    pkAlertView = nil;
}
@end
