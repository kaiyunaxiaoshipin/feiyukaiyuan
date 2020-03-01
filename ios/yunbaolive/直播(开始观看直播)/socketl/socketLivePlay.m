#import "socketLivePlay.h"

@implementation socketMovieplay
//发送弹幕
-(void)sendBarrageID:(NSString *)ID andTEst:(NSString *)content andDic:(NSDictionary *)zhubodic and:(getResults)handler{
    /*******发送弹幕开始 **********/
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.sendBarrage"];
    NSDictionary *barrage = @{
                              @"uid":[Config getOwnID],
                              @"token":[Config getOwnToken],
                              @"liveuid":ID,
                              @"stream":[zhubodic valueForKey:@"stream"],
                              @"giftid":@"1",
                              @"giftcount":@"1",
                              @"content":content
                              };
    [session POST:url parameters:barrage progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            handler(responseObject);
        }
        else{
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
//建立socket
- (void)setnodejszhuboDic:(NSDictionary *)zhubodic Handler:(getResults)handler andlivetype:(NSString *)livetypes{
    
    _livetype = livetypes;
    __weak socketMovieplay *weakself = self;
//    _shut_time = @"0";
    self.playDoc = zhubodic;
     justonce = 0;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.enterRoom&uid=%@&token=%@&liveuid=%@&city=%@&stream=%@",[Config getOwnID],[Config getOwnToken],[zhubodic valueForKey:@"uid"],[cityDefault getMyCity],[zhubodic valueForKey:@"stream"]];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *enter = @{
//                            @"uid":[Config getOwnID],
//                            @"token":,
//                            @"liveuid":[zhubodic valueForKey:@"uid"],
//                            @"city":[cityDefault getMyCity],
//                            @"stream":[zhubodic valueForKey:@"stream"]
//                            };
    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                handler(data);
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
//                _shut_time = [NSString stringWithFormat:@"%@",[info valueForKey:@"shut_time"]];//禁言时间
                _chatserver = [info valueForKey:@"chatserver"];
                [weakself addNodeListen:zhubodic];
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
-(void)addNodeListen:(NSDictionary *)dic
{
     __weak socketMovieplay *weakself = self;
    users = [Config myProfile];
    isReConSocket = YES;
    NSURL* url = [[NSURL alloc] initWithString:_chatserver];
//   _ChatSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES}];
    SocketManager *mange =  [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @NO,@"forcePolling":@YES}];
    _ChatSocket = [[SocketIOClient alloc] initWithManager:mange nsp:nil];
    [_ChatSocket connect];
    NSArray *cur = @[@{@"username":[Config getOwnNicename],
                       @"uid":[Config getOwnID],
                       @"token":[Config getOwnToken],
                       @"roomnum":[dic valueForKey:@"uid"],
                       @"stream":[dic valueForKey:@"stream"],
                       }];
    [_ChatSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
    NSLog(@"socket connected");
        [_ChatSocket emit:@"conn" with:cur];
    }];
    [_ChatSocket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket.io disconnect---%@",data);
    }];
    [_ChatSocket on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"socket.io error -- %@",data);
    }];
    [_ChatSocket on:@"conn" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"进入房间");
         [weakself getZombie];
        
        //第一次进入 扣费 ，广播其他人增加映票
        if ([_livetype isEqual:@"3"] || [_livetype isEqual:@"2"]) {
            //第一次进入 扣费 ，广播其他人增加映票
            if (justonce == 0) {
                [self addvotes:type_val isfirst:@"1"];
            }
        }
        
    }];
    [_ChatSocket on:@"broadcastingListen" callback:^(NSArray* data, SocketAckEmitter* ack) {
        justonce= 1;
        if ([[data[0] firstObject] isEqual:@"stopplay"]) {
            [weakself.socketDelegate roomCloseByAdmin];
            return ;
        }
        for (NSString *path in data[0]) {
            NSDictionary *jsonArray = [path JSONValue];
            NSDictionary *msg = [[jsonArray valueForKey:@"msg"] firstObject];
            NSString *retcode = [NSString stringWithFormat:@"%@",[jsonArray valueForKey:@"retcode"]];
            NSString *method = [msg valueForKey:@"_method_"];
            if ([retcode isEqual:@"409002"]) {
                [MBProgressHUD showError:YZMsg(@"你已被禁言")];
                return;
            }
            [weakself getmessage:msg andMethod:method];
        }
    }];
}
-(void)getmessage:(NSDictionary *)msg andMethod:(NSString *)method{
    //僵尸粉
    if ([method isEqual:@"requestFans"]) {
        
        NSArray *ct = [msg valueForKey:@"ct"];
        NSArray *data = [ct valueForKey:@"data"];
        if ([[data valueForKey:@"code"]isEqualToNumber:@0]) {
            NSArray *info = [data valueForKey:@"info"];
            NSArray *list = [[info valueForKey:@"list"] firstObject];
            [self.socketDelegate addZombieByArray:list];
        }
    }
    //会话消息
    if ([method isEqual:@"SendMsg"]) {
        //SendMsg   msgtype  26  votes
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"2"])
        {
            NSString* ct;
            NSDictionary *heartDic = [[NSArray arrayWithObject:msg] firstObject];
            NSArray *sub_heart = [heartDic allKeys];
            //点亮
            if ([sub_heart containsObject:@"heart"]) {
                NSString *lightColor = [heartDic valueForKey:@"heart"];
                NSString *light = @"light";
                NSString *titleColor = [light stringByAppendingFormat:@"%@",lightColor];
                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                NSString* uname = minstr([msg valueForKey:@"uname"]);
                NSString *levell = minstr([msg valueForKey:@"level"]);
                NSString *ID = minstr([msg valueForKey:@"uid"]);
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSString *usertype =minstr([msg valueForKey:@"usertype"]);
                NSString *guardType =minstr([msg valueForKey:@"guard_type"]);

                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",guardType,@"guard_type",nil];
                [self.socketDelegate light:chat];
            }
            else{
                NSString *titleColor = @"0";
                ct = [NSString stringWithFormat:@"%@", [msg valueForKey:@"ct"]];
                NSString* uname = minstr([msg valueForKey:@"uname"]);
                NSString *levell = minstr([msg valueForKey:@"level"]);
                NSString *ID = minstr([msg valueForKey:@"uid"]);
                NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
                NSString *liangname =minstr([msg valueForKey:@"liangname"]);
                NSString *usertype =minstr([msg valueForKey:@"usertype"]);
                NSString *isAnchor = minstr([msg valueForKey:@"isAnchor"]);
                NSString *guardType =minstr([msg valueForKey:@"guard_type"]);
                NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",isAnchor,@"isAnchor",guardType,@"guard_type",nil];
                [self.socketDelegate messageListen:chat];
            }
        }
        //用户离开进入
        if([msgtype isEqual:@"0"])
        {
            NSString *action = [msg valueForKey:@"action"];
            //用户离开
            if ([action isEqual:@"1"]) {
                NSLog(@"用户离开，%@",msg);
                [self.socketDelegate UserLeave:msg];
            }
            //用户进入
            if ([action isEqual:@"0"]) {
                [self.socketDelegate UserAccess:msg];
            }
        }
        //直播关闭
        if ([msgtype isEqual:@"1"]) {
            NSString *action = [msg valueForKey:@"action"];
            if ([action isEqual:@"18"]) {
                NSLog(@"直播关闭");
                [self.socketDelegate LiveOff];
            }
        }
        if ([msgtype isEqual:@"26"]) {
            
            
            
        }
        //发红包
        if([msgtype isEqual:@"255"])
        {
            NSString *action = [msg valueForKey:@"action"];
            //
            if ([action isEqual:@"0"]) {
                [self.socketDelegate showRedbag:msg];
            }
        }

    }
    //增加映票
    else if ([method isEqual:@"updateVotes"]){
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if ([msgtype isEqual:@"26"])
        {
            //限制进房间的时候自己不增加
            NSString *uid = minstr([msg valueForKey:@"uid"]);
            if (![uid isEqual:[Config getOwnID]]) {
                [self.socketDelegate addvotesdelegate:[msg valueForKey:@"votes"]];
            }
        }
    }
    //房间类型切换
    else if ([method isEqual:@"changeLive"])
    {
        [self.socketDelegate changeLive:[NSString stringWithFormat:@"%@",[msg valueForKey:@"type_val"]]];
    }
    //点亮
    else if ([method isEqual:@"light"]){
        NSString *msgtype = [msg valueForKey:@"msgtype"];
        if([msgtype isEqual:@"0"]){
            NSString *action = [msg valueForKey:@"action"];
            //点亮
            if ([action isEqual:@"2"]) {
                [self.socketDelegate sendLight];
            }
        }
    }
    //设置管理员
    else if ([method isEqual:@"SystemNot" ] || [method isEqual:@"ShutUpUser"]){
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
        if([msgtype isEqual:@"4"] && [action isEqual:@"13"]) {
            //设置取消管理员
            if ([touid isEqual:[Config getOwnID]]) {
                [self alertShowMsg:minstr([msg valueForKey:@"ct"]) andTitle:YZMsg(@"提示")];
            }
        }
        else if ([msgtype isEqual:@"4"] && [action isEqual:@"1"]) {
            //禁言
            if ([touid isEqual:[Config getOwnID]]) {
                [self alertShowMsg:minstr([msg valueForKey:@"ct"]) andTitle:YZMsg(@"提示")];

            }
        }
        [self.socketDelegate setSystemNot:msg];
    }    else if ([method isEqual:@"setAdmin"]){
        NSString *ct = [NSString stringWithFormat:@"%@",[msg valueForKey:@"ct"]];
        if (ct) {
            [self.socketDelegate setAdmin:msg];
        }
    }

    //送礼物
    else if([method isEqual:@"SendGift"])
    {
//        NSString *titleColor = @"2";
        if ([minstr([msg valueForKey:@"ifpk"]) isEqual:@"1"]) {
            [self.socketDelegate changePkProgressViewValue:msg];
            if (![minstr([msg valueForKey:@"roomnum"]) isEqual:minstr([_playDoc valueForKey:@"uid"])]) {
                return;
            }
        }

        NSString *haohualiwu =  [NSString stringWithFormat:@"%@",[msg valueForKey:@"evensend"]];
        NSDictionary *ct = [msg valueForKey:@"ct"];
        
        NSDictionary *GiftInfo = @{@"uid":[msg valueForKey:@"uid"],
                                   @"nicename":[msg valueForKey:@"uname"],
                                   @"giftname":[ct valueForKey:@"giftname"],
                                   @"gifticon":[ct valueForKey:@"gifticon"],
                                   @"giftcount":[ct valueForKey:@"giftcount"],
                                   @"giftid":[ct valueForKey:@"giftid"],
                                   @"level":[msg valueForKey:@"level"],
                                   @"avatar":[msg valueForKey:@"uhead"],
                                   @"type":[ct valueForKey:@"type"],
                                   @"swf":minstr([ct valueForKey:@"swf"]),
                                   @"swftime":minstr([ct valueForKey:@"swftime"]),
                                   @"swftype":minstr([ct valueForKey:@"swftype"]),
                                   @"isluck":minstr([ct valueForKey:@"isluck"]),
                                   @"lucktimes":minstr([ct valueForKey:@"lucktimes"]),
                                   @"mark":minstr([ct valueForKey:@"mark"])
                                   };
//        NSString *ctt = [NSString stringWithFormat:@"送了一个%@",[ct valueForKey:@"giftname"]];
//        titleColor = @"2";
//        NSString* uname = minstr([msg valueForKey:@"uname"]);
//        NSString *levell = minstr([msg valueForKey:@"level"]);
//        NSString *ID = minstr([msg valueForKey:@"uid"]);
//        NSString *avatar = minstr([msg valueForKey:@"uhead"]);
//        NSString *vip_type =minstr([msg valueForKey:@"vip_type"]);
//        NSString *liangname =minstr([msg valueForKey:@"liangname"]);
//        NSDictionary *chat6 = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ctt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",avatar,@"avatar",vip_type,@"vip_type",liangname,@"liangname",nil];
        [self.socketDelegate sendGift:nil andLiansong:haohualiwu andTotalCoin:minstr([ct valueForKey:@"votestotal"]) andGiftInfo:GiftInfo];
        
    }    //幸运礼物
    else if([method isEqual:@"luckWin"])
    {
        [self.socketDelegate showAllLuckygift:msg];
        NSLog(@"幸运礼物%@",msg);
    }
    //奖池中奖
    else if([method isEqual:@"jackpotWin"])
    {
        [self.socketDelegate WinningPrize:msg];
        NSLog(@"奖池中奖%@",msg);
    }
    //奖池升级
    else if([method isEqual:@"jackpotUp"])
    {
        [self.socketDelegate JackpotLevelUp:msg];
        NSLog(@"奖池升级%@",msg);
    }

    //弹幕
    else if([method isEqual:@"SendBarrage"])
    {
        [self.socketDelegate SendBarrage:msg];
        NSLog(@"弹幕接受成功%@",msg);
    }
    //结束直播
    else if([method isEqual:@"StartEndLive"])
    {
        [self.socketDelegate StartEndLive];
    }
    //断开链接
    else if([method isEqual:@"disconnect"])
    {
        [self.socketDelegate UserDisconnect:msg];
    }
    //踢人消息
    else if([method isEqual:@"KickUser"])
    {
        NSString* unamessss = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
        if([unamessss isEqual:[Config getOwnID]] ){
            [self.socketDelegate kickOK];
        }
        NSString *titleColor = @"firstlogin";
        NSString *ct = [msg valueForKey:@"ct"];
        NSString *uname = YZMsg(@"直播间消息");
        NSString *levell = @" ";
        NSString *ID = @" ";
        NSString *icon = @" ";
        NSString *vip_type = @"0";
        NSString *liangname = @"0";
        NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",icon,@"avatar",vip_type,@"vip_type",liangname,@"liangname",nil];
        [self.socketDelegate KickUser:chat];
    }
    //炸金花//收到主播广播准备开始游戏
    ////收到主播广播准备开始游戏
    else if ([method isEqual:@"startGame"] || [method isEqual:@"startLodumaniGame"] || [method isEqual:@"startCattleGame"] ){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        if ([action isEqual:@"1"]) {
            //出现游戏界面
            [self.socketDelegate prepGameandMethod:method andMsgtype:msgtype];
        }
        else if ([action isEqual:@"2"]){
            if ([method isEqual:@"startCattleGame"]) {
                NSDictionary *bankdic = [msg valueForKey:@"bankerlist"];
                [self.socketDelegate changeBank:bankdic];
            }
            //开始发牌
            [self.socketDelegate takePoker:[msg valueForKey:@"gameid"] Method:method andMsgtype:msgtype];
            
        }
        else if ([action isEqual:@"3"]){
            //主播关闭游戏
            [self.socketDelegate stopGame];
        }
        else if ([action isEqual:@"4"]){
            //游戏开始 倒数计时
            NSString *time = [NSString stringWithFormat:@"%@",[msg valueForKey:@"time"]];//游戏时间
            [self.socketDelegate startGame:time andGameID:[msg valueForKey:@"gameid"]];
        }
        else if ([action isEqual:@"5"]){
            //用户投注
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.socketDelegate getCoin:type andMoney:money];
        }else if ([action isEqual:@"6"]){
            //开奖
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate getResult:ct];
        }
    }
    else if ([method isEqual:@"startRotationGame"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            //出现游戏界面
            [self.socketDelegate prepRotationGame];
        }
        else if ([action isEqual:@"2"]){
            
            
        }
        else if ([action isEqual:@"3"]){
            //主播关闭游戏
            [self.socketDelegate stopRotationGame];
            
        }
        else if ([action isEqual:@"4"]){
            //游戏开始 倒数计时
            NSString *time = [NSString stringWithFormat:@"%@",[msg valueForKey:@"time"]];//游戏时间
            [self.socketDelegate startRotationGame:time andGameID:[msg valueForKey:@"gameid"]];
        }
        else if ([action isEqual:@"5"]){
            //用户投注
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.socketDelegate getRotationCoin:type andMoney:money];
        }else if ([action isEqual:@"6"]){
            //开奖
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate getRotationResult:ct];
        }
    }
    //二八贝
    else if ([method isEqual:@"startShellGame"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        NSString *msgtype = [NSString stringWithFormat:@"%@",[msg valueForKey:@"msgtype"]];
        if ([action isEqual:@"1"]) {
            //出现游戏界面
            [self.socketDelegate shellprepGameandMethod:method andMsgtype:msgtype];
        }
        else if ([action isEqual:@"2"]){
            //开始发牌
            [self.socketDelegate shelltakePoker:[msg valueForKey:@"gameid"] Method:method andMsgtype:msgtype];
        }
        else if ([action isEqual:@"3"]){
            //主播关闭游戏
            [self.socketDelegate shellstopGame];
        }
        else if ([action isEqual:@"4"]){
            //游戏开始 倒数计时
            NSString *time = [NSString stringWithFormat:@"%@",[msg valueForKey:@"time"]];//游戏时间
            [self.socketDelegate shellstartGame:time andGameID:[msg valueForKey:@"gameid"]];
        }
        else if ([action isEqual:@"5"]){
            //用户投注
            NSString *money = [NSString stringWithFormat:@"%@",[msg valueForKey:@"money"]];
            NSString *type = [NSString stringWithFormat:@"%@",[msg valueForKey:@"type"]];
            [self.socketDelegate shellgetCoin:type andMoney:money];
        }else if ([action isEqual:@"6"]){
            //开奖
            NSArray *ct = [msg valueForKey:@"ct"];
            [self.socketDelegate shellgetResult:ct];
        }
    }
    else if ([method isEqual:@"shangzhuang"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        //有人上庄
        if ([action isEqual:@"1"]) {
            NSDictionary *subdic = @{
                                     @"uid":[msg valueForKey:@"uid"],
                                     @"uhead":[msg valueForKey:@"uhead"],
                                     @"uname":[msg valueForKey:@"uname"],
                                     @"coin":[msg valueForKey:@"coin"]
                                     };
            [self.socketDelegate getzhuangjianewmessagedelegatem:subdic];
        }
    }
    
#pragma mark 连麦
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
    else if ([method isEqual:@"ConnectVideo"]){
        NSString *action = [NSString stringWithFormat:@"%@",[msg valueForKey:@"action"]];
        if ([action isEqual:@"1"]) {
            return;
        }
        if ([action isEqual:@"4"]) {
            NSString *uid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"uid"]];
            if (![uid isEqual:[Config getOwnID]]) {
                //不是连麦用户的其他用户播放连麦用户的流
                [self.socketDelegate playLinkUserUrl:minstr([msg valueForKey:@"playurl"]) andUid:minstr([msg valueForKey:@"uid"])];
            }
        }
        if ([action isEqual:@"5"]){
            [self.socketDelegate hostout];
            if (![minstr([msg valueForKey:@"uid"]) isEqual:[Config getOwnID]]) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"uname"]),YZMsg(@"已下麦")]];
            }
        }
        if ([action isEqual:@"6"]) {
            [self.socketDelegate hostout];
            if ([minstr([msg valueForKey:@"touid"]) isEqual:[Config getOwnID]]) {
                [MBProgressHUD showError:YZMsg(@"主播已把你下麦")];
            }else{
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@%@",minstr([msg valueForKey:@"uname"]),YZMsg(@"已下麦")]];
            }
        }
        NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];
        if ([touid isEqual:[Config getOwnID]]) {
            if ([action isEqual:@"2"]) {
                //同意连麦
                [self.socketDelegate startConnectvideo];
            }
            else if ([action isEqual:@"3"]){
                //拒绝连麦
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:YZMsg(@"主播拒绝了连麦请求")];
                [self.socketDelegate enabledlianmaibtn];
            }
            
            //主播正忙碌
            if ([action isEqual:@"7"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:YZMsg(@"主播正忙碌")];
                [self.socketDelegate enabledlianmaibtn];
            }
            //主播未响应
            if ([action isEqual:@"8"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:YZMsg(@"当前主播暂时无法接通")];
                [self.socketDelegate enabledlianmaibtn];
            }
            //主播未响应
            if ([action isEqual:@"10"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:YZMsg(@"主播未开启连麦功能哦～")];
                [self.socketDelegate enabledlianmaibtn];
            }

        }
        
    }
    //购买守护
    else if ([method isEqual:@"BuyGuard"]){
        [self.socketDelegate updateGuardMsg:msg];
        NSDictionary *dic = @{@"ct":[NSString stringWithFormat:@"%@ %@",minstr([msg valueForKey:@"uname"]),YZMsg(@"守护了主播")]};
        [self.socketDelegate setSystemNot:dic];
    }
    //发红包
    else if([method isEqual:@"SendRed"])
    {
        NSString *action = [msg valueForKey:@"action"];
        //
        if ([action isEqual:@"0"]) {
            [self.socketDelegate showRedbag:msg];
        }
    } else if ([method isEqual:@"LiveConnect"]){
        //1：发起连麦；2；接受连麦；3:拒绝连麦；4：连麦成功通知；5.手动断开连麦;7:对方正忙碌 8:对方无响应
        int action = [minstr([msg valueForKey:@"action"]) intValue];
        switch (action) {
                case 4:
                    [self.socketDelegate anchor_agreeLink:msg];
                break;
                case 5:
//                    [MBProgressHUD showError:YZMsg(@"连麦已断开")];
                    [self.socketDelegate anchor_stopLink:msg];
                break;
            default:
                break;
        }
    }else if ([method isEqual:@"LivePK"]){
        //1：发起PK；2；接受PK；3:拒绝PK；4：PK成功通知；5.;7:对方正忙碌 8:对方无响应 9:PK结果
        int action = [minstr([msg valueForKey:@"action"]) intValue];
        switch (action) {
                case 4:
                [self.socketDelegate showPKView:nil];
                break;
                case 9:
                    [self.socketDelegate showPKResult:msg];
                break;
                
            default:
                break;
        }
    }


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
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//转盘押注
-(void)stakeRotationPoke:(NSString *)type andMoney:(NSString *)money{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"startRotationGame",
                                        @"action": @"5",
                                        @"msgtype":@"16",
                                        @"type":type,
                                        @"money":money,
                                        @"uid":[Config getOwnID]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//发送竞拍消息
-(void)sendmyjingpaimessage:(NSString *)money{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"auction",
                                        @"action": @"2",
                                        @"msgtype":@"55",
                                        @"money":money,
                                        @"uname":[Config getOwnNicename],
                                        @"uid":[Config getOwnID],
                                        @"uhead":[Config getavatar]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//注销socket
-(void)socketStop{
    [_ChatSocket disconnect];
    [_ChatSocket off:@""];
    [_ChatSocket leaveNamespace];
    _ChatSocket = nil;
}
#pragma mark ----- 发送socket
//红包
-(void)sendRed:(NSString *)money andNodejsInfo:(NSMutableArray *)nodejsInfo{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=User.sendRed&uid=%@&touid=%@&money=%@&token=%@",[Config getOwnID],[self.playDoc valueForKey:@"uid"],money,[Config getOwnToken]];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            NSString *msg = [data valueForKey:@"msg"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSArray *info = [data valueForKey:@"info"];
                NSString *coin = [info valueForKey:@"coin"];
                NSString *level = [[data valueForKey:@"info"] valueForKey:@"level"];
                //刷新本地魅力值
                users.coin = [NSString stringWithFormat:@"%@",coin];
                [Config updateProfile:users];
                [self.socketDelegate reloadChongzhi:coin];
                NSArray *msgData =@[
                                    @{
                                        @"msg": @[
                                                @{
                                                    @"_method_": @"SendRed",
                                                    @"action": @"0",
                                                    @"ct":[info valueForKey:@"gifttoken"],
                                                    @"msgtype": @"1",
                                                    @"timestamp": @"",
                                                    @"tougood": @"",
                                                    @"touid": @"0",
                                                    @"touname": @"",
                                                    @"ugood":@"",
                                                    @"uid": [Config getOwnID],
                                                    @"uname": [Config getOwnNicename],
                                                    @"equipment": @"app",
                                                    @"roomnum": [self.playDoc valueForKey: @"uid"],
                                                    @"level":level,
                                                    @"city":@"",
                                                    @"evensend":@"n",
                                                    @"usign":@"",
                                                    @"uhead":@"",
                                                    @"sex":@"",
                                                    @"vip_type":[Config getVip_type],
                                                    @"liangname":[Config getliang]
                                                    }
                                                ],
                                        @"retcode": @"000000",
                                        @"retmsg": @"OK"
                                        }
                                    ];
                
                [_ChatSocket emit:@"broadcast" with:msgData];
                
            }
            else{
                [MBProgressHUD showError:msg];
            }
        }
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
//点亮
-(void)starlight:(NSString *)level :(NSNumber *)num andUsertype:(NSString *)usertype andGuardType:(NSString *)guardType{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendMsg",
                                        @"action": @"0",
                                        @"ct": @"我点亮了",
                                        @"msgtype": @"2",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey: @"uid"],
                                        @"level":level,
                                        @"heart":num,
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang],
                                        @"usertype":usertype,
                                        @"guard_type":guardType
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//关注主播
-(void)attentionLive:(NSString *)level{
    NSString *content = [NSString stringWithFormat:@"%@关注了主播",[Config getOwnNicename]];
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SystemNot",
                                        @"action": @"13",
                                        @"ct":content,
                                        @"msgtype": @"4",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"city":@"",
                                        @"touname": @"",
                                        @"ugood": @"",
                                        @"uid": [Config getOwnID],
                                        @"uname": YZMsg(@"直播间消息"),
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey: @"uid"],
                                        @"usign":@"",
                                        @"uhead":@"",
                                        @"level":level,
                                        @"sex":@""
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//房间关闭
-(void)superStopRoom{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"stopLive",
                                        @"action": @"19",
                                        @"ct":@"",
                                        @"msgtype": @"1",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touid": @"0",
                                        @"touname": @"",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum":[self.playDoc valueForKey: @"uid"],
                                        @"usign":@"",
                                        @"uhead":users.avatar,
                                        @"level":[Config getLevel],
                                        @"city":@"",
                                        @"sex":@""
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];}
//发送消息
-(void)sendmessage:(NSString *)text andLevel:(NSString *)level andUsertype:(NSString *)usertype andGuardType:(NSString *)guardType{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_":@"SendMsg",
                                        @"action":@"0",
                                        @"ct":text,
                                        @"msgtype":@"2",
                                        @"timestamp":@"",
                                        @"tougood":@"",
                                        @"touid":@"0",
                                        @"city":@"",
                                        @"touname":@"",
                                        @"ugood":@"",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"equipment":@"app",
                                        @"roomnum":[self.playDoc valueForKey: @"uid"],
                                        @"usign":@"",
                                        @"uhead":@"",
                                        @"level":level,
                                        @"sex":@"",
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang],
                                        @"isAnchor":@"0",
                                        @"usertype":usertype,
                                        @"guard_type":guardType
                                        }
                                    ],
                            @"retcode":@"000000",
                            @"retmsg":@"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//送礼物
-(void)sendGift:(NSString *)level andINfo:(NSString *)info andlianfa:(NSString *)lianfa{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendGift",
                                        @"action": @"0",
                                        @"ct":info ,
                                        @"msgtype": @"1",
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey: @"uid"],
                                        @"level":level,
                                        @"evensend":lianfa,
                                        @"uhead":users.avatar,
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//禁言
-(void)shutUp:(NSString *)name andID:(NSString *)ID andType:(NSString *)type{
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
                                           @"touname":@"",
                                           @"ugood":@""
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    
    [MBProgressHUD showError:YZMsg(@"禁言成功")];
    [_ChatSocket emit:@"broadcast" with:jinyanArray];
}
//踢人
-(void)kickuser:(NSString *)name andID:(NSString *)ID{
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
                                           @"touname":@"",
                                           @"ugood":@""
                                           }],
                                 @"retcode":@"000000",
                                 @"retmsg":@"OK"}];
    [MBProgressHUD showError:YZMsg(@"踢人成功")];
    [_ChatSocket emit:@"broadcast" with:jinyanArray];
}
//弹幕
-(void)sendBarrage:(NSString *)level andmessage:(NSString *)test{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"SendBarrage",
                                        @"action": @"7",
                                        @"ct":test ,
                                        @"msgtype": @"1",
                                        @"ugood": [Config getOwnID],
                                        @"uid": [Config getOwnID],
                                        @"uname": [Config getOwnNicename],
                                        @"equipment": @"app",
                                        @"roomnum": [self.playDoc valueForKey:@"uid"],
                                        @"level":[Config getLevel],
                                        @"uhead":users.avatar,
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//点亮
-(void)starlight{
    //NSLog(@"发送了点亮消息");
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"light",
                                        @"action": @"2",
                                        @"msgtype": @"0",
                                        @"timestamp": @"",
                                        @"tougood": @"",
                                        @"touname": @"",
                                        @"ugood": @"",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
//僵尸粉
-(void)getZombie{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"requestFans",
                                        @"timestamp":@"",
                                        @"msgtype": @"0",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
#pragma mark 连麦+声网
//连麦socket
-(void)sendlianmaicoin{
    NSArray *msgData2 =@[
                         @{
                             @"msg": @[
                                     @{
                                         @"_method_":@"ConnectVideo",
                                         @"action": @"5",
                                         @"msgtype": @"10",
                                         @"uid":[Config getOwnID],
                                         @"uname": [Config getOwnNicename],
                                         }
                                     ],
                             @"retcode": @"000000",
                             @"retmsg": @"OK"
                             }
                         ];
    [_ChatSocket emit:@"broadcast" with:msgData2];
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
    [_ChatSocket emit:@"broadcast" with:msgData];
}

//第一次进入 扣费 ，广播其他人增加映票
-(void)addvotesenterroom:(NSString *)votes{
    type_val = votes;
    
}

//增加映票
-(void)addvotes:(NSString *)votes isfirst:(NSString *)isfirst{
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"updateVotes",
                                        @"action":@"1",
                                        @"votes":votes,
                                        @"msgtype": @"26",
                                        @"uid":[Config getOwnID],
                                        @"isfirst":isfirst
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
#pragma mark ================ 连麦 ===============
-(void)sendSmallURL:(NSString *)playUrl andID:(NSString *)userID{
    
    
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"ConnectVideo",
                                        @"action":@"4",
                                        @"msgtype": @"10",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"playurl":playUrl
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
    
    
}
-(void)closeConnect{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"ConnectVideo",
                                        @"action":@"5",
                                        @"msgtype": @"10",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
}
-(void)connectvideoToHost{
    LiveUser *cuser = [Config myProfile];

    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"ConnectVideo",
                                        @"action":@"1",
                                        @"msgtype": @"10",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"level":cuser.level,
                                        @"sex":[Config getSex]
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];

}
- (void)alertShowMsg:(NSString *)msg andTitle:(NSString *)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark ================ 守护 ===============
- (void)buyGuardSuccess:(NSDictionary *)dic{
    NSArray *msgData =@[
                        @{
                            @"msg": @[
                                    @{
                                        @"_method_": @"BuyGuard",
                                        @"action":@"0",
                                        @"msgtype": @"0",
                                        @"ct":@"守护了主播",
                                        @"uid":[Config getOwnID],
                                        @"uname":[Config getOwnNicename],
                                        @"uhead":[Config getavatarThumb],
                                        @"votestotal":minstr([dic valueForKey:@"votestotal"]),
                                        @"guard_nums":minstr([dic valueForKey:@"guard_nums"])
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];

}
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
                                        @"uhead":users.avatar,
                                        @"level":[Config getLevel],
                                        @"vip_type":[Config getVip_type],
                                        @"liangname":[Config getliang],
                                        @"isAnchor":@"0",
                                        }
                                    ],
                            @"retcode": @"000000",
                            @"retmsg": @"OK"
                            }
                        ];
    [_ChatSocket emit:@"broadcast" with:msgData];
    
}

@end
