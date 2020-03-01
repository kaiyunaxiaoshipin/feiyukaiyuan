#import "LivePlay.h"
#import "MessageListModel.h"

/*
tableview->->backscrollview 4
_danmuView->backscrollview 5
gamevc->backscrollview 6
userview->backscroll添加 7
haohualiwuv->backscrollview 8
liansongliwubottomview->backscrollview 8
 
 
 
UI层次（从低到高，防止覆盖问题）
tableview（聊天） 4
弹幕 5
game 5
私信 7
私信聊天 8
礼物（连送、豪华）9
弹窗 window add
*/

#import <ReplayKit/ReplayKit.h>

/***********************  腾讯SDK start ********************/
//腾讯
#import <TXLiteAVSDK_Professional/TXLivePlayListener.h>
#import <TXLiteAVSDK_Professional/TXLivePlayConfig.h>
#import <TXLiteAVSDK_Professional/TXLivePlayer.h>
#import <mach/mach.h>
/***********************  腾讯SDK end **********************/

//新礼物结束
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define upViewW     _window_width*0.8

@interface moviePlay ()<
UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,dianjishijian,UIScrollViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate ,catSwitchDelegate,UIAlertViewDelegate,socketDelegate,frontviewDelegate,sendGiftDelegate,upmessageKickAndShutUp,haohuadelegate,listDelegate,gameDelegate,WPFRotateViewDelegate,shangzhuangdelegate,js_play_linkmic,tx_play_linkmic,shouhuViewDelegate,guardShowDelegate,redListViewDelegate,anchorPKViewDelegate,TXLivePlayListener,JackpotViewDelegate >
@end
int d =1;
@implementation moviePlay
{
    NSMutableArray *msgList;
  
    UIAlertController  *Feedeductionalertc;//扣费alert
    UIAlertController *md5AlertController;
    BOOL isSuperAdmin;
    //发起连麦进行11S的倒计时
    NSTimer *startLinkTimer;
    int startLinkTime;
    
    /***********************  腾讯SDK start ********************/
    TXLivePlayer *       _txLivePlayer;
    TXLivePlayConfig*    _config;
    CWStatusBarNotification *_notification;
    BOOL _canChange;
    BOOL _isCancleLink;
    /***********************  腾讯SDK end **********************/

}
#pragma socketDelegate
//准备炸金花游戏
//*********************************************************************** 炸金花********************************//
-(void)stopGamendMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    
    
    
}
-(void)prepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:method andMsgtype:msgtype];
    gameVC.delagate = self;
    gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
    [self changeBtnFrame:_window_height - 260];
    [backScrollView insertSubview:gameVC atIndex:4];
    [backScrollView insertSubview:_liwuBTN atIndex:5];
    [self tableviewheight:_window_height - _window_height*0.2 -260];
    [self changecontinuegiftframe];
    //上庄
    if ([method isEqual:@"startCattleGame"]) {
        if (!zhuangVC) {
            zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:NO withstreame:[self.playDoc valueForKey:@"stream"]];
            zhuangVC.deleagte = self;
            [backScrollView insertSubview:zhuangVC atIndex:10];
            [backScrollView bringSubviewToFront:zhuangVC];
            [zhuangVC addtableview];
            [zhuangVC getbanksCoin:zhuangstartdic];
        }
    }
}
//**************************************************上庄操作***********************

-(void)changeBank:(NSDictionary *)bankdic{
       [gameVC changebankid:[bankdic valueForKey:@"id"]];
       [zhuangVC getNewZhuang:bankdic];
}
-(void)getzhuangjianewmessagedelegatem:(NSDictionary *)subdic{
    
    [zhuangVC getNewZhuang:subdic];
    
}
-(void)takePoker:(NSString *)gameid Method:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (!gameVC) {
        gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:method andMsgtype:msgtype];
        gameVC.delagate = self;
        gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
        [self changeBtnFrame:_window_height - 260];
        [backScrollView insertSubview:gameVC atIndex:4];
        [backScrollView insertSubview:_liwuBTN atIndex:5];
    }
    //上庄
    if ([method isEqual:@"startCattleGame"]) {
        if (!zhuangVC) {
            zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:NO withstreame:[self.playDoc valueForKey:@"stream"]];
            zhuangVC.deleagte = self;
            [backScrollView insertSubview:zhuangVC atIndex:10];
            [zhuangVC getbanksCoin:zhuangstartdic];
            [zhuangVC addtableview];
        }
        [zhuangVC addPoker];
    }
    [self tableviewheight:_window_height - _window_height*0.2 -260 - www ];
    //wangminxinliwu
    [self changecontinuegiftframe];
    [gameVC createUI];
}
-(void)startGame:(NSString *)time andGameID:(NSString *)gameid{
    [self removeAllGames];
    [gameVC movieplayStartCut:time andGameid:gameid];
}
- (void)removeAllGames{
//    if (zhuangVC) {
//        [zhuangVC dismissroom];
//        [zhuangVC removeall];
//        [zhuangVC remopokers];
//        [zhuangVC removeFromSuperview];
//        zhuangVC = nil;
//    }
//    if (shell) {
//        [shell stopGame];
//        [shell releaseAll];
//        [shell removeFromSuperview];
//        shell = nil;
//    }
//    if (gameVC) {
//        [gameVC releaseAll];
//        [gameVC removeFromSuperview];
//        gameVC = nil;
//    }
//    if (rotationV) {
//        [rotationV stopRotatipnGameInt];
//        [rotationV stoplasttimer];
//        [rotationV removeFromSuperview];
//        [rotationV removeall];
//        rotationV = nil;
//    }
}
//得到游戏结果
-(void)getResult:(NSArray *)array{
    [gameVC getResult:array];
    if (zhuangVC) {
        [zhuangVC getresult:array];
    }
    
}
-(void)reloadcoinsdelegate{
    if (gameVC) {
        [gameVC reloadcoins];
    }
}
-(void)stopGame{
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    [gameVC removeFromSuperview];
    gameVC = nil;
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50 - ShowDiff];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
//用户投注
-(void)skate:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketDelegate stakePoke:type andMoney:money andMethod:method andMsgtype:msgtype];
}
-(void)getCoin:(NSString *)type andMoney:(NSString *)money{
    [gameVC getCoinType:type andMoney:money];
}

//*********************************************************************** 炸金花********************************//
//*********************************************************************** 二八贝********************************//
-(void)shellprepGameandMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [self removeAllGames];
    if (shell) {
        [shell gameOver];
        [shell removeFromSuperview];
        shell = nil;
    }
    shell = [[shellGame alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
    shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
    shell.delagate = self;
    [backScrollView insertSubview:shell atIndex:4];
    [backScrollView insertSubview:_liwuBTN atIndex:5];
    [self changeBtnFrame:_window_height - 45 - 215];
     [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
-(void)shelltakePoker:(NSString *)gameid Method:(NSString *)method andMsgtype:(NSString *)msgtype{
    if (!shell) {
        shell = [[shellGame alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
        shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
        shell.delagate = self;
        [backScrollView insertSubview:shell atIndex:4];
        [backScrollView insertSubview:_liwuBTN atIndex:5];
    }
    [self changeBtnFrame:_window_height - 45 - 215];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
    //wangminxinliwu
    [self changecontinuegiftframe];
    [shell createUI];
}
-(void)shellstopGame{
    [shell gameOver];
    [shell removeFromSuperview];
    [self changeBtnFrame:_window_height - 45];
    shell = nil;
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50 - ShowDiff];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
-(void)shellgetResult:(NSArray *)array{
    [shell getShellResult:array];
}
//开始倒数计时
-(void)shellstartGame:(NSString *)time andGameID:(NSString *)gameid{
    [shell movieplayStartCut:time andGameid:gameid];
}
-(void)shellgetCoin:(NSString *)type andMoney:(NSString *)money{
    [shell getShellCoin:type andMoney:money];
}
-(void)shellstakePoke:(NSString *)type andMoney:(NSString *)money andMethod:(NSString *)method andMsgtype:(NSString *)msgtype{
    [socketDelegate stakePoke:type andMoney:money andMethod:method andMsgtype:msgtype];
}
//**********************************************************************转盘游戏
//关闭游戏
-(void)stopRotationGame{
    [self setbtnframe];
     [rotationV stopRotatipnGameInt];
     [rotationV stoplasttimer];
    [rotationV removeFromSuperview];
    [rotationV removeall];
    rotationV = nil;
    [self changeBtnFrame:_window_height - 45];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50 - ShowDiff];
    //wangminxinliwu
    [self changecontinuegiftframe];
}
//出现游戏界面
-(void)prepRotationGame{
    [self removeAllGames];
    [self getRotation];
}
-(void)getRotation{
    if (zhuangVC) {
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (!rotationV) {
        isRotationGame = YES;
        rotationV = [WPFRotateView rotateView];
        [rotationV setlayoutview];
        rotationV.delegate = self;
        [rotationV isHost:NO andHostDic:[_playDoc valueForKey:@"stream"]];
        rotationV.frame = CGRectMake(_window_width, _window_height - _window_width/1.5, _window_width, _window_width);
        [backScrollView insertSubview:rotationV atIndex:6];
        [backScrollView insertSubview:_liwuBTN atIndex:7];
        [rotationV addtableview];
    }
    rotationV.frame = CGRectMake(_window_width, _window_height - _window_width/1.5, _window_width, _window_width);
    [self changeBtnFrame:_window_height - 45 - _window_width/1.5];
    
}
-(void)changeBtnFrame:(CGFloat)hhh{
    hhh = hhh - ShowDiff;
    if (rotationV) {
        [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - _window_width+_window_width/5];
        [self changecontinuegiftframe];
    }
    CGFloat  wwwssss = 30;
    keyBTN.frame = CGRectMake(_window_width + 15,hhh, www, www);
    _returnCancle.frame = CGRectMake(_window_width*2-wwwssss-10,hhh,wwwssss,wwwssss);
    _fenxiangBTN.frame = CGRectMake(_window_width*2 - wwwssss*2-20,hhh,wwwssss,wwwssss);
    _messageBTN.frame = CGRectMake(_window_width*2 - wwwssss*3-30,hhh, wwwssss, wwwssss);
    sendBagBtn.frame = CGRectMake(_window_width*2 - wwwssss*4-40,hhh, wwwssss,wwwssss);
    _liwuBTN.frame = CGRectMake(_window_width*2 - wwwssss*5-50,hhh, wwwssss,wwwssss);
    _connectVideo.frame = CGRectMake(_window_width*2 - wwwssss*1.5-10,hhh-10-wwwssss*1.5,wwwssss*1.5,wwwssss*1.5);
    NSArray *shareplatforms = [common share_type];
    
    if (shareplatforms.count == 0) {
        _fenxiangBTN.hidden = YES;
        _messageBTN.frame = CGRectMake(_window_width*2 - wwwssss*2-20,hhh,wwwssss,wwwssss);
        sendBagBtn.frame = CGRectMake(_window_width*2 - wwwssss*3-30,hhh, wwwssss, wwwssss);
        _liwuBTN.frame = CGRectMake(_window_width*2 - wwwssss*4-40,hhh, wwwssss, wwwssss);
    }

}
//开始倒计时
-(void)startRotationGame:(NSString *)time andGameID:(NSString *)gameid{
    [self getRotation];
    [rotationV movieplayStartCut:time andGameid:gameid];
}
//获取游戏结果
-(void)getRotationResult:(NSArray *)array{
    [rotationV getRotationResult:array];
}
//用户押注
-(void)skateRotaton:(NSString *)type andMoney:(NSString *)money{
    [socketDelegate stakeRotationPoke:type andMoney:money];
}
//更新押注数量
-(void)getRotationCoin:(NSString *)type andMoney:(NSString *)money{
    [rotationV getRotationCoinType:type andMoney:money];
}
//*****************************************************************************
-(void)superAdmin:(NSString *)state{
    [socketDelegate superStopRoom];
    haohualiwuV.expensiveGiftCount = nil;
    [self releaseObservers];
    [self lastView];
}
-(void)roomCloseByAdmin{
    [self lastView];
}
-(void)addZombieByArray:(NSArray *)array{
    if (!listView) {
        listView = [[ListCollection alloc]initWithListArray:_listArray andID:[self.playDoc valueForKey:@"uid"]andStream:[NSString stringWithFormat:@"%@",[self.playDoc valueForKey:@"stream"]]];
        listView.delegate = self;
        listView.frame = CGRectMake(_window_width+110, 20 + statusbarHeight, _window_width-130, 40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
        [backScrollView addSubview:listView];
    }
    [listView listarrayAddArray:array];
    userCount += array.count;
//    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
}
-(void)light:(NSDictionary *)chats{
    [msgList addObject:chats];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)messageListen:(NSDictionary *)chats{
        [msgList addObject:chats];
        titleColor = @"0";
        if(msgList.count>30)
        {
            [msgList removeObjectAtIndex:0];
        }
        [self.tableView reloadData];
        [self jumpLast];
}
-(void)UserLeave:(NSDictionary *)msg{
    userCount -= 1;
//    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (listView) {
        [listView userLive:msg];
    }
}
//********************************用户进入动画********************************************//
-(void)UserAccess:(NSDictionary *)msg{
    //用户进入
    userCount += 1;
    if (listView) {
        [listView userAccess:msg];
    }
//    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    NSString *vipType = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"vip_type"]];
    NSString *guard_type = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"guard_type"]];

    if ([vipType isEqual:@"1"] || [guard_type isEqual:@"1"] || [guard_type isEqual:@"2"]) {
        [useraimation addUserMove:msg];
        useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
    }
    //进场动画级别限制
//    NSString *levelLimit = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"level"]];
//    int levelLimits = [levelLimit intValue];
//    int levelLimitsLocal = [[common enter_tip_level] intValue];
//    if (levelLimitsLocal >levelLimits) {
//
//
//    }else{
//
//        [useraimation addUserMove:msg];
//        useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
//
//    }
    NSString *car_id = minstr([[msg valueForKey:@"ct"] valueForKey:@"car_id"]);
    if (![car_id isEqual:@"0"]) {
        if (!vipanimation) {
            vipanimation = [[viplogin alloc]initWithFrame:CGRectMake(_window_width,80,_window_width,_window_width*0.8) andBlock:^(id arrays) {
                [vipanimation removeFromSuperview];
                vipanimation = nil;
            }];
            vipanimation.frame =CGRectMake(_window_width,80,_window_width,_window_width*0.8);
            [backScrollView insertSubview:vipanimation atIndex:10];
            UITapGestureRecognizer  *tapvip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
            [vipanimation addGestureRecognizer:tapvip];
      }
        [vipanimation addUserMove:msg];
        
    }
    [self userLoginSendMSG:msg];
}
//用户进入直播间发送XXX进入了直播间
-(void)userLoginSendMSG:(NSDictionary *)dic {
    titleColor = @"userLogin";
    NSString *uname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"user_nicename"]];
    NSString *levell = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"level"]];
    NSString *ID = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"id"]];
    NSString *vip_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"vip_type"]];
    NSString *liangname = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"liangname"]];
    NSString *usertype = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"usertype"]];
    NSString *guard_type = [NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"guard_type"]];

    NSString *conttt = YZMsg(@" 进入了直播间");
    NSString *isadminn;
    if ([[NSString stringWithFormat:@"%@",[[dic valueForKey:@"ct"] valueForKey:@"usertype"]] isEqual:@"40"]) {
        isadminn = @"1";
    }else{
        isadminn = @"0";
    }
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",conttt,@"contentChat",levell,@"levelI",ID,@"id",titleColor,@"titleColor",vip_type,@"vip_type",liangname,@"liangname",usertype,@"usertype",guard_type,@"guard_type",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
////////////////////////////////////////////////////
-(void)LiveOff{
    [self lastView];
}
-(void)sendLight{
   [self staredMove];
}
-(void)setSystemNot:(NSDictionary *)msg{
    titleColor = @"firstlogin";
    NSString *ct = [msg valueForKey:@"ct"];
    NSString *uname = YZMsg(@"直播间消息");
    NSString *ID = @"";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",ID,@"id",titleColor,@"titleColor",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}

-(void)setAdmin:(NSDictionary *)msg{
    NSString *touid = [NSString stringWithFormat:@"%@",[msg valueForKey:@"touid"]];

    if ([touid isEqual:[Config getOwnID]]) {
        if ([minstr([msg valueForKey:@"action"]) isEqual:@"0"]) {
            usertype = @"0";
        }else{
            usertype = @"40";
        }
    }
    titleColor = @"firstlogin";
    NSString *ct = [msg valueForKey:@"ct"];
    NSString *uname = YZMsg(@"直播间消息");
    NSString *ID = @"";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",ct,@"contentChat",ID,@"id",titleColor,@"titleColor",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)sendGift:(NSDictionary *)chats andLiansong:(NSString *)liansong andTotalCoin:(NSString *)votestotal andGiftInfo:(NSDictionary *)giftInfo{
//          [msgList addObject:chats];
//      [self addCoin:totalcoin];//添加映票
    votesTatal = votestotal;
    [setFrontV changeState:votestotal andID:nil];

//      NSNumber *number = [giftInfo valueForKey:@"giftid"];
//      NSString *giftid = [NSString stringWithFormat:@"%@",number];
    NSString *type = minstr([giftInfo valueForKey:@"type"]);

    if (!continueGifts) {
        continueGifts = [[continueGift alloc]init];
        [liansongliwubottomview addSubview:continueGifts];
        //初始化礼物空位
        [continueGifts initGift];
    }
    if ([type isEqual:@"1"]) {
        [self expensiveGift:giftInfo];
    }
    else{
        [continueGifts GiftPopView:giftInfo andLianSong:haohualiwu];
    }
//    titleColor = @"0";
//    if(msgList.count>30)
//    {
//        [msgList removeObjectAtIndex:0];
//    }
//    [self.tableView reloadData];
//    [self jumpLast];
}
-(void)SendBarrage:(NSDictionary *)msg{
    NSString *text = [NSString stringWithFormat:@"%@",[[msg valueForKey:@"ct"] valueForKey:@"content"]];
    NSString *name = [msg valueForKey:@"uname"];
    NSString *icon = [msg valueForKey:@"uhead"];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithObjectsAndKeys:text,@"title",name,@"name",icon,@"icon",nil];
    [_danmuView setModel:userinfo];
    long totalcoin = [self.danmuprice intValue];
    [self addCoin:totalcoin];
}
-(void)StartEndLive{
    [self lastView];
}
-(void)UserDisconnect:(NSDictionary *)msg{
    userCount -= 1;
//    setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
    if (listView) {
        [listView userLive:msg];
    }
    if (_js_playrtmp) {
        if ([[msg valueForKey:@"uid"] integerValue] == _js_playrtmp.tag-1500) {
            [self releasePlayLinkView];
        }
    }
}
-(void)KickUser:(NSDictionary *)chats{
    [msgList addObject:chats];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
}
-(void)kickOK{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"你已被踢出房间") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
    [alert show];
    [self dissmissVC];
}
#pragma frontview 信息页面
-(void)gongxianbang{
    //跳往魅力值界面
    webH5 *jumpC = [[webH5 alloc]init];
    jumpC.urls = [NSString stringWithFormat:@"%@/index.php?g=Appapi&m=contribute&a=index&uid=%@",h5url,minstr([self.playDoc valueForKey:@"uid"])];
//    personList *jumpC = [[personList alloc] init];
//    jumpC.userID =[self.playDoc valueForKey:@"uid"];
//    [self presentViewController:jumpC animated:YES completion:nil];
    [self.navigationController pushViewController:jumpC animated:YES];
}
//加载信息页面
-(void)zhubomessage{
    if (userView) {
        [userView removeFromSuperview];
        userView = nil;
    }
    if (!userView) {
         userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height+20,upViewW,upViewW*4/3) andPlayer:@"movieplay"];
        //添加用户列表弹窗
        userView.upmessageDelegate = self;
        userView.backgroundColor = [UIColor whiteColor];
        userView.layer.cornerRadius = 10;
        UIWindow *mainwindows = [UIApplication sharedApplication].delegate.window;
        [mainwindows addSubview:userView];
        
    }
    self.tanChuangID = [self.playDoc valueForKey:@"uid"];
    NSDictionary *subdic = @{@"id":[self.playDoc valueForKey:@"uid"]};
    [self GetInformessage:subdic];
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,(_window_height-upViewW*4/3)/2,upViewW,upViewW*4/3);
    }];
}
//改变tableview高度
-(void)tableviewheight:(CGFloat)h{
    self.tableView.frame = CGRectMake(_window_width + 10,h,tableWidth,_window_height*0.2);
    useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
}
//点击礼物ye消失
-(void)zhezhaoBTNdelegate{
    if (giftview && giftview.giftCountView && giftview.giftCountView.hidden == NO) {
        [giftview hideGiftCountView];
        return;
    }

    giftViewShow = NO;
    if (gameVC || shell || rotationV) {
        [self.liwuBTN setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];//@"花猫直播－游戏图标"
        giftview.push.enabled = NO;
            if (gameVC) {
                gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                 [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 265];
            }
            if (shell) {
                shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 265];
            }
            if (rotationV) {
                rotationV.frame = CGRectMake(_window_width, _window_height - _window_width/1.5, _window_width, _window_width);
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - _window_width+_window_width/5];
            }
        setFrontV.ZheZhaoBTN.hidden = YES;
        giftview.continuBTN.hidden = YES;
        fenxiangV.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            [self changeGiftViewFrameY:_window_height *3];
            self.tableView.hidden = NO;
        }];
        //wangminxinliwu
        [self changecontinuegiftframe];
    }
    else{
        giftViewShow = NO;
        giftview.push.enabled = NO;
        setFrontV.ZheZhaoBTN.hidden = YES;
        giftview.continuBTN.hidden = YES;
        fenxiangV.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
           [self changeGiftViewFrameY:_window_height *3];
            [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50 - ShowDiff];
        }];
        keyBTN.hidden = NO;
        //wangminxinliwu
        [self changecontinuegiftframe];
    }
    
    [self showBTN];
    if (huanxinviews) {
        if (sysView || chatsmall) {
            return;
        }
        [huanxinviews.view removeFromSuperview];
        huanxinviews = nil;
        huanxinviews.view = nil;
    }
}
//页面退出
-(void)returnCancless{
  [self dissmissVC];
}

-(void)doFenxiang:(UIButton *)sender{
    if (!fenxiangV) {
        //分享弹窗
        fenxiangV = [[fenXiangView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
        [fenxiangV GetDIc:self.playDoc];
        [self.view addSubview:fenxiangV];
    }else{
        [fenxiangV show];
    }
    
}
-(void)changeGiftViewFrameY:(CGFloat)Y{
    giftview.frame = CGRectMake(0,Y, _window_width, _window_width/2+100+ShowDiff);
    if (Y >= _window_height) {
        liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top-150,300,140);
    }
//    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
//        giftview.frame = CGRectMake(0,Y-10, _window_width, (_window_width-20)/2+120+ShowDiff);
//        [giftview setBottomAdd];
//    }

}
//礼物按钮
-(void)doLiwu{
    if (gameVC || rotationV || shell) {
        if (giftViewShow == NO) {
            giftViewShow = YES;
            if (gameVC) {
                [self changeBtnFrame:_window_height - 260];
                [UIView animateWithDuration:0.5 animations:^{
                    gameVC.frame = CGRectMake(_window_width, _window_height+60, _window_width,260);
                }];
            }
            if (rotationV) {
                [self changeBtnFrame:_window_height - 45 - _window_width/1.5];
                [UIView animateWithDuration:0.5 animations:^{
                    rotationV.frame = CGRectMake(_window_width, _window_height+60, _window_width, _window_width);
                }];
            }
            if (shell) {
                [self changeBtnFrame:_window_height - 45 - 215];
                [UIView animateWithDuration:0.5 animations:^{
                    shell.frame = CGRectMake(_window_width, _window_height +60, _window_width,260);
                }];
            }
            if (!giftview) {
                //礼物弹窗
                giftview = [[liwuview alloc]initWithDic:self.playDoc andMyDic:nil];
                giftview.giftDelegate = self;
                [self changeGiftViewFrameY:_window_height*3];
                [self.view addSubview:giftview];
            }
            giftview.guradType = minstr([guardInfo valueForKey:@"type"]);
            [self.view bringSubviewToFront:giftview];

            backScrollView.userInteractionEnabled = YES;
            setFrontV.ZheZhaoBTN.hidden = NO;
            setFrontV.backgroundColor = [UIColor clearColor];
            LiveUser *user = [Config myProfile];
            [giftview chongzhiV:user.coin];
            [UIView animateWithDuration:0.5 animations:^{
                [self changeGiftViewFrameY:_window_height-(_window_width/2+100+ShowDiff)];
            }];
            [self.liwuBTN setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];//@"花猫直播－游戏图标"
            [self changecontinuegiftframe];
            [self hideBTN];
        }
        else{
            [self zhezhaoBTNdelegate];
        }
    }
    else{
        if (giftViewShow == NO) {
            giftViewShow = YES;
            if (!giftview) {
                //礼物弹窗
                giftview = [[liwuview alloc]initWithDic:self.playDoc andMyDic:nil];
                giftview.giftDelegate = self;
                 [self changeGiftViewFrameY:_window_height*3];
                [self.view addSubview:giftview];
            }
            giftview.guradType = minstr([guardInfo valueForKey:@"type"]);

            [self.view bringSubviewToFront:giftview];

            backScrollView.userInteractionEnabled = YES;
            setFrontV.ZheZhaoBTN.hidden = NO;
            setFrontV.backgroundColor = [UIColor clearColor];
            LiveUser *user = [Config myProfile];
            [giftview chongzhiV:user.coin];
            [UIView animateWithDuration:0.1 animations:^{
                [self changeGiftViewFrameY:_window_height - (_window_width/2+100+ShowDiff)];
            }];
            [self changecontinuegiftframeIndoliwu];
            [self showBTN];
        }
    }
    [giftview reloadPushState];
}
#pragma gift delegate
//发送礼物
-(void)sendGift:(NSDictionary *)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa{
    haohualiwu = lianfa;
    NSString *info = [[datas firstObject] valueForKey:@"gifttoken"];
    level = [[datas firstObject] valueForKey:@"level"];
    LiveUser *users = [Config myProfile];
    users.level = level;
    [Config updateProfile:users];
    [socketDelegate sendGift:level andINfo:info andlianfa:lianfa];
}
-(NSMutableArray *)chatModels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in msgList) {
        chatModel *model = [chatModel modelWithDic:dic];
        [model setChatFrame:[_chatModels lastObject]];
        [array addObject:model];
    }
    _chatModels = array;
    return _chatModels;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    self.unRead = 0;
    [self labeiHid];
}

//手指拖拽弹窗移动
-(void)musicPan:(UIPanGestureRecognizer *)sender{
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = sender.view.center;
    center.x += point.x;
    center.y += point.y;
    userView.center = center;
    //清空
    [sender setTranslation:CGPointZero inView:sender.view];
}

-(void)shajincheng{
    
  
}
-(void)initArray{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];

    haslianmai = NO;//本人是否连麦
    _canScrollToBottom  = YES;

    haohualiwuV.expensiveGiftCount = [NSMutableArray array];
    msgList = [[NSMutableArray alloc] init];
    level = (NSString *)[Config getLevel];
    self.content = [NSString stringWithFormat:@" "];
    _chatModels = [NSMutableArray array];
    userCount = 0;
    starisok = 0;
    heartNum = @1;
    
    firstStar = 0;//点亮
    titleColor = @"0";    
    isRotationGame = NO;
    isZhajinhuaGame = NO;
    //屏幕一直亮
//   self.navigationController.navigationBarHidden =YES;
}

//更新最新配置
-(void)buildUpdate{
    // 在这里加载后台配置文件
    [YBToolClass postNetworkWithUrl:@"Home.getConfig" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            NSDictionary *subdic = [info firstObject];
            if (![subdic isEqual:[NSNull null]]) {
                liveCommon *commons = [[liveCommon alloc]initWithDic:subdic];
                [common saveProfile:commons];
            }
        }

    } fail:^{
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUpdate];
    _canChange = NO;
    ksynotconnected = NO;
    ksyclosed = NO;
    isshow = 0;
    giftViewShow = NO;
    isSuperAdmin = NO;
    [self initArray];
    self.automaticallyAdjustsScrollViewInsets = NO;
    myUser = [Config myProfile];
    _listArray = [NSMutableArray array];
    [self playerPlayVideo];//播放视频
    [self setView];//加载信息页面
    [self Registnsnotifition];
    [self getNodeJSInfo];//初始化nodejs信息

//    //计时扣费
    if ([_livetype isEqual:@"3"]) {
        if (!timecoast) {
            timecoast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timecoastmoney) userInfo:nil repeats:YES];
        }
    }
    
    coasttime = 60;
    //显示进场标题
    [self showTitle];
}
//显示进场标题
- (void)showTitle{
    if (minstr([self.playDoc valueForKey:@"title"]).length > 0) {
        CGFloat titleWidth = [[YBToolClass sharedInstance] widthOfString:minstr([self.playDoc valueForKey:@"title"]) andFont:[UIFont systemFontOfSize:14] andHeight:30];
        UIImageView *titleBackImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width, 110, 35+titleWidth+20, 30)];
        titleBackImgView.image = [UIImage imageNamed:@"moviePlay_title"];
        titleBackImgView.alpha = 0.5;
        titleBackImgView.layer.cornerRadius = 15;
        titleBackImgView.layer.masksToBounds = YES;
        [self.view addSubview:titleBackImgView];
        UIImageView *laba = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 15, 15)];
        laba.image = [UIImage imageNamed:@"moviePlay_laba"];
        [titleBackImgView addSubview:laba];
        UILabel *titL = [[UILabel alloc]initWithFrame:CGRectMake(laba.right+10, 0, titleWidth+20, 30)];
        titL.text = minstr([self.playDoc valueForKey:@"title"]);
        titL.textColor = [UIColor whiteColor];
        titL.font = [UIFont systemFontOfSize:14];
        [titleBackImgView addSubview:titL];
        [UIView animateWithDuration:3 animations:^{
            titleBackImgView.alpha = 1;
            titleBackImgView.x = 10;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2 animations:^{
                titleBackImgView.alpha = 0;
                titleBackImgView.x = -_window_width;
            } completion:^(BOOL finished) {
                [titleBackImgView removeFromSuperview];
            }];

        });
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == keyField) {
        [self pushMessage:nil];
    }
    return YES;
}
//加载底部滑动scrollview
-(void)backscroll{

    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,_window_height, _window_width, _window_height)];
    backScrollView.delegate = self;
    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    backScrollView.pagingEnabled = YES;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.bounces = NO;
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
      fangKeng = !fangKeng;//全部加载完毕了再释放滑动
}
-(void)socketShutUp:(NSString *)name andID:(NSString *)ID andType:(NSString *)type{
    [socketDelegate shutUp:name andID:ID andType:type];
}
-(void)socketkickuser:(NSString *)name andID:(NSString *)ID{
    [socketDelegate kickuser:name andID:ID];
}
-(void)GetInformessage:(NSDictionary *)subdic{
    if (userView) {
        [userView removeFromSuperview];
        userView = nil;
    }

    if (!userView) {
        //添加用户列表弹窗
        userView = [[upmessageInfo alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height,upViewW,upViewW*4/3) andPlayer:@"movieplay"];
        userView.upmessageDelegate = self;
        userView.backgroundColor = [UIColor whiteColor];
        userView.layer.cornerRadius = 10;
        UIWindow *mainwindows = [UIApplication sharedApplication].delegate.window;
        [mainwindows addSubview:userView];
    }
    //用户弹窗
    self.tanChuangID = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];
    [userView getUpmessgeinfo:subdic andzhuboDic:self.playDoc];
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake(_window_width*0.1,_window_height*0.2,upViewW,upViewW*4/3);
    }];
    
    
    /*
     _danmuView->backscrollview 5
     gamevc->backscrollview 6
     userview->backscroll添加 7
     haohualiwuv->backscrollview 8
     liansongliwubottomview->backscrollview 8
     */
}
//几秒后隐藏消失
-(void)doAlpha{
    [UIView animateWithDuration:3.0 animations:^{
        starImage.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [starImage removeFromSuperview];
        });
    }];
}
//点亮星星
-(void)starok{
    if (gameVC) {
    }
    else if (rotationV){
    }
    else if (shell) {
        [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
    }

    //wangminxinliwu
    [self changecontinuegiftframe];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
    [keyField resignFirstResponder];
    [self showBTN];
    keyBTN.hidden = NO;
    [self staredMove];
    //♥点亮
    if (firstStar == 0) {
        firstStar = 1;
        [socketDelegate starlight:level :heartNum andUsertype:usertype andGuardType:minstr([guardInfo valueForKey:@"type"])];
        titleColor = @"0";
    }
    [self getweidulabel];
    [self zhezhaoBTNdelegate];
}
-(void)staredMove{
    
    CGFloat starX;
    CGFloat starY;
    starX = _returnCancle.frame.origin.x - 10;
    starY = _liwuBTN.frame.origin.y - 20;
    NSInteger random = arc4random()%5;
    starImage = [[UIImageView alloc]initWithFrame:CGRectMake(starX+random,starY-random,30,30)];
    
    starImage.alpha = 0;
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"plane_heart_cyan.png",@"plane_heart_pink.png",@"plane_heart_red.png",@"plane_heart_yellow.png",@"plane_heart_heart.png", nil];
    
    srand((unsigned)time(0));
    
    starImage.image = [UIImage imageNamed:[array objectAtIndex:random]];
    
    heartNum = [NSNumber numberWithInteger:random];
    
    [UIView animateWithDuration:0.2 animations:^{
            starImage.alpha = 1.0;
            starImage.frame = CGRectMake(starX+random - 10, starY-random - 30, 30, 30);
            CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
            starImage.transform = CGAffineTransformScale(transfrom, 1, 1);
        }];
    [backScrollView insertSubview:starImage atIndex:10];
    
    CGFloat finishX = _window_width*2 - round(arc4random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 200;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(arc4random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(arc4random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(starImage)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    //  设置imageView的结束frame
    starImage.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        starImage.alpha = 0;
    }];
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    if (starisok == 0) {
        starisok = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            starisok = 0;
        });
//    [socketDelegate starlight];
        
    }
}
/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageViewsss = (__bridge UIImageView *)(context);
    [imageViewsss removeFromSuperview];
    imageViewsss = nil;
}
/*==================  以上是点亮  ================*/
-(void)setView{
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height)];
    backScrollView.delegate = self;
    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
    [backScrollView setContentOffset:CGPointMake(_window_width,0) animated:YES];
    backScrollView.pagingEnabled = YES;
    backScrollView.backgroundColor = [UIColor clearColor];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.bounces = NO;
    backScrollView.userInteractionEnabled = YES;
    [self.view addSubview:backScrollView];
    
    
    //加载背景模糊图
    buttomimageviews = [[UIImageView alloc]init];
    [buttomimageviews sd_setImageWithURL:[NSURL URLWithString:[self.playDoc valueForKey:@"avatar"]]];
    buttomimageviews.frame = CGRectMake(0,0, _window_width, _window_height);
    buttomimageviews.userInteractionEnabled = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [buttomimageviews addSubview:effectview];
    [backScrollView addSubview:buttomimageviews];

    
    setFrontV = [[setViewM alloc] initWithDic:self.playDoc];
    setFrontV.frame = CGRectMake(_window_width,0,_window_width,_window_height);
    setFrontV.frontviewDelegate = self;
    setFrontV.clipsToBounds = YES;
    [backScrollView addSubview:setFrontV];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(_window_width + 10,setFrontV.frame.size.height - _window_height*0.25 - 50 - ShowDiff,tableWidth,_window_height*0.2) style:UITableViewStylePlain];
    [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50 - ShowDiff];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.estimatedRowHeight = 80.0;
    [backScrollView insertSubview:self.tableView atIndex:4];
    self.tableView.clipsToBounds = YES;
    
    useraimation = [[userLoginAnimation alloc]init];
    useraimation.frame = CGRectMake(_window_width + 10,self.tableView.top - 40,_window_width,20);
    [backScrollView insertSubview:useraimation atIndex:4];
    
    _danmuView = [[GrounderSuperView alloc] initWithFrame:CGRectMake(_window_width, 100, self.view.frame.size.width, 140)];
    [backScrollView insertSubview:_danmuView atIndex:5];//添加弹幕
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    [_danmuView addGestureRecognizer:tap];
    cs = [[catSwitch alloc] initWithFrame:CGRectMake(6,11,44,22)];
    cs.delegate = self;
    //输入框
    keyField = [[UITextField alloc]initWithFrame:CGRectMake(70,7,_window_width-90 - 50, 30)];
    keyField.returnKeyType = UIReturnKeySend;
    keyField.delegate = self;
    keyField.textColor = [UIColor blackColor];
    keyField.borderStyle = UITextBorderStyleNone;
    keyField.placeholder = YZMsg(@"和大家说些什么");
    keyField.backgroundColor = [UIColor whiteColor];
    keyField.layer.cornerRadius = 15.0;
    keyField.layer.masksToBounds = YES;
    UIView *fieldLeft = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 30)];
    fieldLeft.backgroundColor = [UIColor whiteColor];
    keyField.leftView = fieldLeft;
    keyField.leftViewMode = UITextFieldViewModeAlways;
    keyField.font = [UIFont systemFontOfSize:15];
    #pragma mark -- 绑定键盘
    www = 30;
    //点击弹出键盘
    keyBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [keyBTN setBackgroundImage:[UIImage imageNamed:@"live_聊天"] forState:UIControlStateNormal];
    [keyBTN addTarget:self action:@selector(showkeyboard:) forControlEvents:UIControlEventTouchUpInside];
    keyBTN.frame = CGRectMake(_window_width + 15,_window_height - 45 - ShowDiff, www, www);
    
    //发送按钮
    pushBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pushBTN setTitle:YZMsg(@"发送") forState:UIControlStateNormal];
    [pushBTN setImage:[UIImage imageNamed:@"chat_send_gray"] forState:UIControlStateNormal];
    [pushBTN setImage:[UIImage imageNamed:@"chat_send_yellow"] forState:UIControlStateSelected];
    pushBTN.imageView.contentMode = UIViewContentModeScaleAspectFit;
    pushBTN.layer.masksToBounds = YES;
    pushBTN.layer.cornerRadius = 5;
//    [pushBTN setTitleColor:RGB(255, 204, 0) forState:0];
    pushBTN.selected = NO;
//    pushBTN.backgroundColor = normalColors;
    [pushBTN addTarget:self action:@selector(pushMessage:) forControlEvents:UIControlEventTouchUpInside];
    pushBTN.frame = CGRectMake(_window_width-55,7,50,30);
    
    //tool绑定键盘
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height+10, _window_width, 44)];
    toolBar.backgroundColor = [UIColor clearColor];
    UIView *tooBgv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 44)];
    tooBgv.backgroundColor = [UIColor whiteColor];
    tooBgv.alpha = 0.7;
    [toolBar addSubview:tooBgv];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toolbarClick:)];
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(cs.right+9, cs.top, 1, 20)];
    line1.backgroundColor = RGB(176, 176, 176);
    line1.alpha = 0.5;
    [toolBar addSubview:line1];
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(keyField.right+7, line1.top, 1, 20)];
    line2.backgroundColor = line1.backgroundColor;
    line2.alpha = line1.alpha;
    [toolBar addSubview:line2];
//    [toolBar addGestureRecognizer:tapGesture];
    
    [toolBar addSubview:pushBTN];
    [toolBar addSubview:keyField];
    [toolBar addSubview:cs];
    
    [self.view addSubview:toolBar];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangePushBtnState) name:UITextFieldTextDidChangeNotification object:nil];

    starTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    starTap.delegate = (id<UIGestureRecognizerDelegate>)self;
    starTap.numberOfTapsRequired = 1;
    starTap.numberOfTouchesRequired = 1;
    [setFrontV addGestureRecognizer:starTap];
    
    liansongliwubottomview = [[UIView alloc]init];
    [backScrollView insertSubview:liansongliwubottomview atIndex:8];
    liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top-150,300,140);

    
    
    UITapGestureRecognizer *gifttaps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starok)];
    [liansongliwubottomview addGestureRecognizer:gifttaps];
    
    //添加底部按钮
    _returnCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnCancle.tintColor = [UIColor whiteColor];
    [_returnCancle setImage:[UIImage imageNamed:@"live_关闭"] forState:UIControlStateNormal];//直播间观众—关闭
    _returnCancle.backgroundColor = [UIColor clearColor];
    [_returnCancle addTarget:self action:@selector(returnCancless) forControlEvents:UIControlEventTouchUpInside];
    //消息按钮
    _messageBTN =[UIButton buttonWithType:UIButtonTypeCustom];
     self.unReadLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, -5, 16, 16)];
     self.unReadLabel.hidden = YES;
     self.unReadLabel.textAlignment = NSTextAlignmentCenter;
     self.unReadLabel.textColor = [UIColor whiteColor];
     self.unReadLabel.layer.masksToBounds = YES;
     self.unReadLabel.layer.cornerRadius = 8;
     self.unReadLabel.font = [UIFont systemFontOfSize:9];
     self.unReadLabel.backgroundColor = [UIColor redColor];
    [_messageBTN addSubview: self.unReadLabel];
    [_messageBTN setImage:[UIImage imageNamed:@"live_私信"] forState:UIControlStateNormal];//直播间观众—私信
    _messageBTN.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_messageBTN addTarget:self action:@selector(doMessage) forControlEvents:UIControlEventTouchUpInside];
    //分享按钮
    _fenxiangBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _fenxiangBTN.enabled = YES;
    _fenxiangBTN.tintColor = [UIColor whiteColor];
    [_fenxiangBTN setBackgroundImage:[UIImage imageNamed:@"live_分享"] forState:UIControlStateNormal];
    [_fenxiangBTN addTarget:self action:@selector(doFenxiang:) forControlEvents:UIControlEventTouchUpInside];
    //礼物
    _liwuBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    _liwuBTN.tintColor = [UIColor whiteColor];
    [_liwuBTN setBackgroundImage:[UIImage imageNamed:@"live_礼物"] forState:UIControlStateNormal];
    [_liwuBTN addTarget:self action:@selector(doLiwu) forControlEvents:UIControlEventTouchUpInside];
    /*==================  连麦  ================*/
    //连麦按钮
    _connectVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"]forState:UIControlStateNormal];
    [_connectVideo addTarget:self action:@selector(connectVideos) forControlEvents:UIControlEventTouchUpInside];
    _connectVideo.selected = NO;
    
    //红包按钮
    sendBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBagBtn setImage:[UIImage imageNamed:@"live_红包"]forState:UIControlStateNormal];
    [sendBagBtn addTarget:self action:@selector(showRedView) forControlEvents:UIControlEventTouchUpInside];

    [self setbtnframe];
    
    [backScrollView insertSubview:keyBTN atIndex:5];
    [backScrollView insertSubview:_returnCancle atIndex:5];
    
    NSArray *shareplatforms = [common share_type];
    if (shareplatforms.count != 0) {
        [backScrollView insertSubview:_fenxiangBTN atIndex:5];
     }
  
    [backScrollView insertSubview:_messageBTN atIndex:5];
    [backScrollView insertSubview:_liwuBTN atIndex:5];
    [backScrollView insertSubview:_connectVideo atIndex:5];
    [backScrollView insertSubview:sendBagBtn atIndex:5];
    [backScrollView insertSubview:_connectVideo aboveSubview:_danmuView];
}
-(void)setbtnframe{
    
    CGFloat  wwwwww = 30;
    CGFloat hhh = _window_height - wwwwww - 15 - ShowDiff;
    _returnCancle.frame = CGRectMake(_window_width*2-wwwwww-10,hhh,wwwwww,wwwwww);
    _fenxiangBTN.frame = CGRectMake(_window_width*2 - wwwwww*2-20,hhh,wwwwww,wwwwww);
    _messageBTN.frame = CGRectMake(_window_width*2 - wwwwww*3-30,hhh, wwwwww, wwwwww);
    sendBagBtn.frame = CGRectMake(_window_width*2 - wwwwww*4-40,hhh, wwwwww,wwwwww);
    _liwuBTN.frame = CGRectMake(_window_width*2 - wwwwww*5-50,hhh, wwwwww,wwwwww);

    _connectVideo.frame = CGRectMake(_window_width*2 - wwwwww*1.5-10,hhh-10-wwwwww*1.5,wwwwww*1.5,wwwwww*1.5);

    NSArray *shareplatforms = [common share_type];
    
    if (shareplatforms.count == 0) {
        _fenxiangBTN.hidden = YES;
        _messageBTN.frame = CGRectMake(_window_width*2 - wwwwww*2-20,hhh,wwwwww,wwwwww);
        sendBagBtn.frame = CGRectMake(_window_width*2 - wwwwww*3-30,hhh, wwwwww, wwwwww);
        _liwuBTN.frame = CGRectMake(_window_width*2 - wwwwww*4-40,hhh, wwwwww, wwwwww);
    }
    
}
-(void)toolbarHidden
{
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
    [UIView animateWithDuration:0.5 animations:^{
        chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (chatsmall) {
            [chatsmall.view removeFromSuperview];
            chatsmall.view = nil;
            chatsmall = nil;
        }
    });
}
-(void)toolbarClick:(id)sender
{
    [keyField resignFirstResponder];
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
}
-(void)guanzhuZhuBo{
    [UIView animateWithDuration:0.5 animations:^{
        setFrontV.leftView.frame = CGRectMake(10, 25+statusbarHeight, 95, leftW);
        listcollectionviewx = _window_width+105;
        listView.frame = CGRectMake(listcollectionviewx, 20+statusbarHeight, _window_width-105,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-105, 40);
    }];
    setFrontV.newattention.hidden = YES;
    [socketDelegate attentionLive:level];
}
- (void) addObservers {
    //播放器播放完成
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handlePlayerNotify:)
                                                name:(MPMoviePlayerPlaybackDidFinishNotification)
                                              object:nil];
    
}
#pragma mark - 连麦鉴权信息
-(void)reloadChongzhi:(NSString *)coin{
    if (giftview) {    
    [giftview chongzhiV:coin];
    }
}
#pragma mark ---- 私信方法
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    //显示消息数量
    [self labeiHid];
}
-(void)labeiHid{
    dispatch_queue_t queue = dispatch_queue_create("GetIMMessage", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        self.unRead = [minstr([JMSGConversation getAllUnreadCount]) intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.unReadLabel.text = [NSString stringWithFormat:@"%d",self.unRead];
            if ([self.unReadLabel.text isEqual:@"0"] || self.unRead == 0) {
                self.unReadLabel.hidden =YES;
            }else {
                self.unReadLabel.hidden = NO;
            }
        });
    });
}
-(void)Registnsnotifition{
    //点击用户聊天
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changePlayRoom:) name:@"changePlayRoom" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(forsixin:) name:@"sixinok" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getweidulabel) name:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shajincheng) name:@"shajincheng" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadLiveplayAttion:) name:@"reloadLiveplayAttion" object:nil];

}
-(void)getweidulabel{
    [self labeiHid];
}
//跳往消息列表
-(void)doMessage{
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    [huanxinviews.view removeFromSuperview];
    huanxinviews = nil;
    huanxinviews.view = nil;
    if (!huanxinviews) {
        huanxinviews = [[huanxinsixinview alloc]init];
        huanxinviews.zhuboID = minstr([_playDoc valueForKey:@"uid"]);
        [huanxinviews forMessage];
        huanxinviews.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
        [self.view insertSubview:huanxinviews.view atIndex:9];
        if (liansongliwubottomview) {
            [self.view insertSubview:liansongliwubottomview atIndex:8];
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        huanxinviews.view.frame = CGRectMake(0, _window_height - _window_height*0.4,_window_width, _window_height*0.4);
    }];
}
//点击用户聊天
-(void)forsixin:(NSNotification *)ns{
    NSMutableDictionary *dic = [[ns userInfo] mutableCopy];
    if (sysView.view) {
        [sysView.view removeFromSuperview];
        sysView = nil;
        sysView.view = nil;

    }
    __weak moviePlay *wSelf = self;

    if ([[dic valueForKey:@"id"] isEqual:@"1"]) {
        sysView = [[MsgSysVC alloc]init];
        sysView.view.frame = CGRectMake(_window_width, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
        sysView.block = ^(int type) {
            if (type == 0) {
                [wSelf hideSysTemView];
            }
        };
        [sysView reloadSystemView];
        
        [self.view insertSubview:sysView.view atIndex:10];
        if (liansongliwubottomview) {
            [self.view insertSubview:liansongliwubottomview atIndex:8];
        }
        [UIView animateWithDuration:0.5 animations:^{
            sysView.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
        }];
        return;
    }
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    if (!chatsmall) {
        chatsmall = [[JCHATConversationViewController alloc]init];
        [dic setObject:minstr([dic valueForKey:@"name"]) forKey:@"user_nicename"];
        MessageListModel *model = [[MessageListModel alloc]initWithDic:dic];
        chatsmall.userModel = model;
        chatsmall.conversation = [dic valueForKey:@"conversation"];
        chatsmall.view.frame = CGRectMake(_window_width, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
        chatsmall.block = ^(int type) {
            if (type == 0) {
                [wSelf hideChatMall];
            }
            if (type == 1) {
                [wSelf doUpMessageGuanZhu];
            }

        };
        [chatsmall reloadSamllChtaView:@"0"];

        [self.view insertSubview:chatsmall.view atIndex:10];
        if (liansongliwubottomview) {
            [self.view insertSubview:liansongliwubottomview atIndex:8];
        }
    }
    chatsmall.view.hidden = NO;

    [UIView animateWithDuration:0.5 animations:^{
        chatsmall.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
    }];
    
//    chatsmall.icon = [dic valueForKey:@"avatar"];
//    chatsmall.chatID = [dic valueForKey:@"id"];
//    chatsmall.chatname = [dic valueForKey:@"name"];
//    chatsmall.msgConversation = [dic valueForKey:@"Conversation"];
//    [chatsmall changename];
//    [chatsmall formessage];
}
- (void)hideSysTemView{
    [sysView.view removeFromSuperview];
    sysView = nil;
    sysView.view = nil;

}
-(void)siXin:(NSString *)icon andName:(NSString *)name andID:(NSString *)ID andIsatt:(NSString *)isatt{
    [chatsmall.view removeFromSuperview];
    chatsmall = nil;
    chatsmall.view = nil;
    [huanxinviews.view removeFromSuperview];
    huanxinviews = nil;
    huanxinviews.view = nil;
    __weak moviePlay *wSelf = self;
    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,ID] completionHandler:^(id resultObject, NSError *error) {
        [self doCancle];
        if (!error) {
            if (!chatsmall) {
                chatsmall = [[JCHATConversationViewController alloc]init];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:minstr(icon) forKey:@"avatar"];
                [dic setObject:minstr(ID) forKey:@"id"];
                [dic setObject:minstr(name) forKey:@"user_nicename"];
                [dic setObject:minstr(name) forKey:@"name"];
                [dic setObject:resultObject forKey:@"conversation"];
                [dic setObject:isatt forKey:@"utot"];
                MessageListModel *model = [[MessageListModel alloc]initWithDic:dic];
                chatsmall.userModel = model;
                chatsmall.conversation = resultObject;
                chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
                chatsmall.block = ^(int type) {
                    if (type == 0) {
                        [wSelf hideChatMall];
                    }
                    if (type == 1) {
                        [wSelf doUpMessageGuanZhu];
                    }

                };
                [self.view insertSubview:chatsmall.view atIndex:10];
                [chatsmall reloadSamllChtaView:@"0"];
                if (liansongliwubottomview) {
                    [self.view insertSubview:liansongliwubottomview atIndex:8];
                }
            }
            chatsmall.view.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                chatsmall.view.frame = CGRectMake(0, _window_height-_window_height*0.4, _window_width, _window_height*0.4);
            }];

        }else{
            [MBProgressHUD showError:error.localizedDescription];
        }
//        if (error == nil) {
//
//            chatsmall.msgConversation = resultObject;
//            chatsmall.icon = icon;
//            chatsmall.chatID = ID;
//            chatsmall.chatname = name;
//            [chatsmall changename];
//            [chatsmall formessage];
//        }
//            else{
////                chatsmall.msgConversation = resultObject;
//                chatsmall.icon = icon;
//                chatsmall.chatID = ID;
//                chatsmall.chatname = name;
//                chatsmall.fromWhere = @"user";
//                [chatsmall changename];
//                [chatsmall formessage];
////                 [MBProgressHUD showError:error.localizedDescription];
//            }
        }];
}
- (void)hideChatMall{
    if (huanxinviews) {
        [huanxinviews forMessage];
        CATransition *transition = [CATransition animation];    //创建动画效果类
        transition.duration = 0.3; //设置动画时长
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
        transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};设置动画类型，移入，推出等
        //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
        transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
        [chatsmall.view.layer addAnimation:transition forKey:nil];       //在图层增加动画效果
        [chatsmall.view removeFromSuperview];
        chatsmall.view = nil;
        chatsmall = nil;

    }else{
        [UIView animateWithDuration:0.3 animations:^{
            chatsmall.view.frame = CGRectMake(0, _window_height, _window_width, _window_height*0.4);
        } completion:^(BOOL finished) {
            [chatsmall.view removeFromSuperview];
            chatsmall.view = nil;
            chatsmall = nil;
        }];
    }
}
-(void)doUpMessageGuanZhu{
    if ([userView.forceBtn.titleLabel.text isEqual:YZMsg(@"已关注")]) {
        [userView.forceBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:normalColors forState:UIControlStateNormal];
        setFrontV.leftView.frame = CGRectMake(10,25+statusbarHeight,140,leftW);
        listcollectionviewx = _window_width+150;
        setFrontV.newattention.hidden = NO;
       listView.frame = CGRectMake(listcollectionviewx, 20+statusbarHeight, _window_width-150,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-150, 40);
        [userView.forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else{
        setFrontV.leftView.frame = CGRectMake(10,25+statusbarHeight,95,leftW);
        listcollectionviewx = _window_width+105;
        setFrontV.newattention.hidden = YES;
        listView.frame = CGRectMake(listcollectionviewx, 20+statusbarHeight, _window_width-105,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-105, 40);
        //EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.tanChuangID];
       // NSLog(@"%@",error.errorDescription);
        [userView.forceBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
        [userView.forceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if(self.tanChuangID == [self.playDoc valueForKey:@"uid"])
        {
            [socketDelegate attentionLive:level];
        }
        userView.forceBtn.enabled = NO;
    }
}
-(void)pushZhuYe:(NSString *)IDS{
     [self doCancle];
     otherUserMsgVC  *person = [[otherUserMsgVC alloc]init];
     person.userID = IDS;
     [self.navigationController pushViewController:person animated:YES];
}
-(void)doupCancle{
    [self doCancle];
}
#pragma mark -- 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if (redBview) {
        return;
    }
    if ([md5AlertController.textFields.firstObject becomeFirstResponder]) {
        return;
    }
    if (chatsmall) {
        return;
    }
    if (gameVC) {
        gameVC.hidden = YES;
    }
    if (shell) {
        shell.hidden = YES;
    }
    if (rotationV) {
        rotationV.hidden = YES;
    }
    [self doCancle];
    [self hideBTN];
    
    keyBTN.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    CGFloat heightw = keyboardRect.size.height;
    int newHeight = _window_height - height -44;
    [UIView animateWithDuration:0.3 animations:^{
        [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 40 - heightw];
        toolBar.frame = CGRectMake(0,height-44,_window_width,44);
        listView.frame = CGRectMake(listcollectionviewx,-height,_window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
        setFrontV.frame = CGRectMake(_window_width,-newHeight,_window_width,_window_height);
        [self changeGiftViewFrameY:_window_height*10];
        //wangminxinliwu
        [self changecontinuegiftframe];
        if (zhuangVC) {
            zhuangVC.frame =  CGRectMake(_window_width + 10,20, _window_width/4, _window_width/4 + 20 + _window_width/8);
        }
    }];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{

    if (gameVC) {
        gameVC.hidden = NO;
    }
    if (shell) {
        shell.hidden = NO;
    }
    if (rotationV) {
        rotationV.hidden = NO;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        setFrontV.frame = CGRectMake(_window_width,0,_window_width,_window_height);
        listView.frame = CGRectMake(listcollectionviewx, 20+statusbarHeight, _window_width-130,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-130, 40);
            if (giftViewShow) {
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
            }
            if (gameVC) {
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
                
            }
            else if (rotationV){
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - _window_width + _window_width/5];
            }
            else if (shell) {
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
            }
            else{
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2 - 50 - ShowDiff];
            }
            
            //wangminxinliwu
            [self changecontinuegiftframe];
        toolBar.frame = CGRectMake(0,_window_height + 10,_window_width,44);
        [self changeGiftViewFrameY:_window_height*3];
    }];
    if (zhuangVC) {
        zhuangVC.frame =  CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8);
    }
    [self showBTN];
    keyBTN.hidden = NO;
}
-(void)hideBTN{
    _returnCancle.hidden = YES;
    _liwuBTN.hidden = YES;
    _fenxiangBTN.hidden = YES;
    _messageBTN.hidden = YES;
    keyBTN.hidden = YES;
    redBagBtn.hidden = YES;
}
//按钮出现
-(void)showBTN{
    _returnCancle.hidden = NO;
    _liwuBTN.hidden = NO;
    _fenxiangBTN.hidden = NO;
    _messageBTN.hidden = NO;
    keyBTN.hidden = NO;
    redBagBtn.hidden = NO;
}
//列表信息退出
-(void)doCancle{
    userView.forceBtn.enabled = YES;
    [UIView animateWithDuration:0.2 animations:^{
        userView.frame = CGRectMake( _window_width*0.1,_window_height*2, upViewW,upViewW);
    }];
    self.tableView.userInteractionEnabled = YES;
}
//发送消息
-(void)sendBarrage
{
    [socketDelegate sendBarrageID:[self.playDoc valueForKey:@"uid"] andTEst:keyField.text andDic:self.playDoc and:^(id arrays) {
        NSArray *data = [arrays valueForKey:@"data"];
        NSNumber *code = [data valueForKey:@"code"];
        if([code isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            level = [[[data valueForKey:@"info"] firstObject] valueForKey:@"level"];
            [socketDelegate sendBarrage:level andmessage:[[[data valueForKey:@"info"] firstObject] valueForKey:@"barragetoken"]];
            //刷新本地魅力值
            LiveUser *liveUser = [Config myProfile];
            keyField.text = @"";
            liveUser.coin = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"coin"]];
            liveUser.level = level;
            [Config updateProfile:liveUser];
            
            
            if (gameVC) {
                [gameVC reloadcoins];
            }
            if (shell) {
                [shell reloadcoins];
            }
            if (rotationV) {
                [rotationV reloadcoins];
            }
            
            if (giftview) {
                [giftview chongzhiV:[NSString stringWithFormat:@"%@",liveUser.coin]];
            }
        }
        else
        {
            [MBProgressHUD showError:[data valueForKey:@"msg"]];
            giftview.continuBTN.hidden = YES;
        }
    }];
}
-(void)pushMessage:(UITextField *)sender{
    if (keyField.text.length >50) {
        [MBProgressHUD showError:YZMsg(@"字数最多50字")];
        return;
    }
    pushBTN.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pushBTN.enabled = YES;
    });
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimedString = [keyField.text stringByTrimmingCharactersInSet:set];
    if ([trimedString length] == 0) {
        return ;
    }
    NSString *userLevel = [Config getLevel];
    if(cs.state == YES)//发送
    {
        if (keyField.text.length <=0) {
            return;
        }
        if ([userLevel intValue] < [barrage_limit intValue]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"发送弹幕,需要到达%@级",barrage_limit]];
            return;
        }
        [self sendBarrage];
        keyField.text =nil;
        pushBTN.selected = NO;
        return;
    }
    else{
        if ([userLevel intValue] < [speak_limit intValue]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"发言,需要到达%@级",barrage_limit]];
            return;
        }

        titleColor = @"0";
        self.content = keyField.text;
        [socketDelegate sendmessage:self.content andLevel:level andUsertype:usertype andGuardType:minstr([guardInfo valueForKey:@"type"])];
        keyField.text =nil;
        pushBTN.selected = NO;
    }
}
//聊天输入框
-(void)showkeyboard:(UIButton *)sender{
    if (chatsmall) {
        chatsmall.view.hidden = YES;
        [chatsmall.view removeFromSuperview];
        chatsmall.view = nil;
        chatsmall = nil;
    }
    [keyField becomeFirstResponder];
}
// 以下是 tableview的方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.chatModels.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    chatMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatMsgCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"chatMsgCell" owner:nil options:nil] lastObject];
    }
    cell.model = self.chatModels[indexPath.section];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    chatModel *model = self.chatModels[indexPath.section];
    [keyField resignFirstResponder];
    NSString *IsUser = [NSString stringWithFormat:@"%@",model.userID];
    if (IsUser.length > 1) {
    NSDictionary *subdic = @{@"id":model.userID};
        [self GetInformessage:subdic];
    }
    toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _canScrollToBottom = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  _canScrollToBottom = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == backScrollView) {
        if (backScrollView.contentOffset.x == 0) {
            _danmuView.hidden = YES;
        }
        else{
            _danmuView.hidden = NO;
        }
        [keyField resignFirstResponder];
        toolBar.frame = CGRectMake(0, _window_height+10, _window_width, 44);
        [self showBTN];
        keyBTN.hidden = NO;
    }
}
/*************   以上socket.io 监听  *********/
//直播结束跳到此页面
-(void)lastView{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPlaying"];

    [timecoast invalidate];
    timecoast = nil;
    [Feedeductionalertc dismissViewControllerAnimated:YES completion:nil];
    [self removetimer];

    [userView removeFromSuperview];
    userView = nil;
    [self releaseall];
    if (haslianmai) {
        if ([_sdkType isEqual:@"1"]) {
            [self txStopLinkMic];
        }else{
            [socketDelegate closeConnect];
        }
    }
    [haohualiwuV stopHaoHUaLiwu];
    [self onStopVideo];
    haohualiwuV.expensiveGiftCount = nil;
    [continueGifts stopTimerAndArray];
    continueGifts = nil;
    [haohualiwuV removeFromSuperview];
    [chatsmall.view removeFromSuperview];
    [huanxinviews.view removeFromSuperview];
    [setFrontV removeFromSuperview];
    [listView removeFromSuperview];
    listView = nil;
    
    [self requestLiveAllTimeandVotes];
//    lastv = [[lastview alloc]initWithFrame:self.view.bounds block:^(NSString *nulls) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    } andavatar:[NSString stringWithFormat:@"%@",[self.playDoc valueForKey:@"avatar"]]];
//    [self.view addSubview:lastv];
}
#pragma mark ================ 直播结束 ===============
- (void)requestLiveAllTimeandVotes{
    NSString *url = [NSString stringWithFormat:@"Live.stopInfo&stream=%@",minstr([_playDoc valueForKey:@"stream"])];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subdic = [info firstObject];
            [self lastview:subdic];
        }else{
            [self lastview:nil];
        }
    } fail:^{
        [self lastview:nil];
    }];
    
}
-(void)lastview:(NSDictionary *)dic{
    //无数据都显示0
    if (!dic) {
        dic = @{@"votes":@"0",@"nums":@"0",@"length":@"0"};
    }
    UIImageView *lastView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    lastView.userInteractionEnabled = YES;
    [lastView sd_setImageWithURL:[NSURL URLWithString:[Config getavatar]]];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
    [lastView addSubview:effectview];
    
    
    UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,24+statusbarHeight, _window_width, _window_height*0.17)];
    labell.textColor = RGB_COLOR(@"#cacbcc", 1);
    labell.text = YZMsg(@"直播已结束");
    labell.textAlignment = NSTextAlignmentCenter;
    labell.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [lastView addSubview:labell];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.1, labell.bottom+50, _window_width*0.8, _window_width*0.8*8/13)];
    backView.backgroundColor = RGB_COLOR(@"#000000", 0.2);
    backView.layer.cornerRadius = 5.0;
    backView.layer.masksToBounds = YES;
    [lastView addSubview:backView];
    
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width/2-50, labell.bottom, 100, 100)];
    [headerImgView sd_setImageWithURL:[NSURL URLWithString:minstr([_playDoc valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    headerImgView.layer.masksToBounds = YES;
    headerImgView.layer.cornerRadius = 50;
    [lastView addSubview:headerImgView];
    
    
    UILabel *nameL= [[UILabel alloc]initWithFrame:CGRectMake(0,50, backView.width, backView.height*0.55-50)];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = minstr([_playDoc valueForKey:@"user_nicename"]);
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [backView addSubview:nameL];
    
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(10, nameL.bottom, backView.width-20, 1) andColor:RGB_COLOR(@"#585452", 1) andView:backView];
    
    NSArray *labelArray = @[YZMsg(@"直播时长"),[NSString stringWithFormat:@"收获%@",[common name_votes]],@"观看人数"];
    for (int i = 0; i < labelArray.count; i++) {
        UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*backView.width/3, nameL.bottom, backView.width/3, backView.height/4)];
        topLabel.font = [UIFont boldSystemFontOfSize:18];
        topLabel.textColor = normalColors;
        topLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            topLabel.text = minstr([dic valueForKey:@"length"]);
        }
        if (i == 1) {
            topLabel.text = minstr([dic valueForKey:@"votes"]);
        }
        if (i == 2) {
            topLabel.text = minstr([dic valueForKey:@"nums"]);
        }
        [backView addSubview:topLabel];
        UILabel *footLabel = [[UILabel alloc]initWithFrame:CGRectMake(topLabel.left, topLabel.bottom, topLabel.width, 14)];
        footLabel.font = [UIFont systemFontOfSize:13];
        footLabel.textColor = RGB_COLOR(@"#cacbcc", 1);
        footLabel.textAlignment = NSTextAlignmentCenter;
        footLabel.text = labelArray[i];
        [backView addSubview:footLabel];
    }
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_window_width*0.1,_window_height *0.75, _window_width*0.8,50);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(docancle) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:normalColors];
    [button setTitle:YZMsg(@"返回首页") forState:0];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds  =YES;
    [lastView addSubview:button];
    [self.view addSubview:lastView];
    
    
    
}
- (void)docancle{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//注销计时器
-(void)removetimer{
    
    [starMove invalidate];
    starMove = nil;
    [listTimer invalidate];
    listTimer = nil;
    [lianmaitimer invalidate];
    lianmaitimer = nil;
    [timecoast invalidate];
    timecoast = nil;
    if (startLinkTimer) {
        [startLinkTimer invalidate];
        startLinkTimer = nil;
    }

    
}
-(void)releaseall{
    [Feedeductionalertc dismissViewControllerAnimated:YES completion:nil];
    [self removetimer];
    if (gifhour) {
        [gifhour removeall];
        [gifhour removeFromSuperview];
        gifhour = nil;
    }
    if (zhuangVC) {
        [zhuangVC dismissroom];
        [zhuangVC removeall];
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (haslianmai == YES) {
        if ([_sdkType isEqual:@"1"]) {
            [self txStopLinkMic];
        }else{
            [socketDelegate closeConnect];
        }
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    haohualiwuV.expensiveGiftCount = nil;
    if (continueGifts) {
        [continueGifts stopTimerAndArray];
        continueGifts = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
         [rotationV stoplasttimer];
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
    }
    [self onStopVideo];
    [self releaseObservers];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [socketDelegate socketStop];
        socketDelegate = nil;
    });
}
//直播结束时退出房间
-(void)dissmissVC{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPlaying"];

    [self removetimer];
    [userView removeFromSuperview];
    userView = nil;
    self.tableView.hidden = YES;
    [self releaseall];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_isJpush isEqual:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//获取进入直播间所需要的所有信息全都在这个enterroom这个接口返回
-(void)getNodeJSInfo
{
    socketDelegate = [[socketMovieplay alloc]init];
    socketDelegate.socketDelegate = self;
    [socketDelegate setnodejszhuboDic:self.playDoc Handler:^(id arrays) {
        
        NSMutableArray *info = [[arrays valueForKey:@"info"] firstObject];
        guardInfo = [info valueForKey:@"guard"];
        speak_limit = minstr([info valueForKey:@"speak_limit"]);
        barrage_limit = minstr([info valueForKey:@"barrage_limit"]);
        jackpot_level = minstr([info valueForKey:@"jackpot_level"]);
        if (![jackpot_level isEqual:@"-1"]) {
            [self JackpotLevelUp:@{@"uplevel":jackpot_level}];
        }
        [common saveagorakitid:minstr([info valueForKey:@"agorakitid"])];//保存声网ID
        if ([minstr([info valueForKey:@"issuper"]) isEqual:@"1"]) {
            isSuperAdmin = YES;
        }else{
            isSuperAdmin = NO;
        }
        usertype = minstr([info valueForKey:@"usertype"]);
        //保存靓号和vip信息
        NSDictionary *liang = [info valueForKey:@"liang"];
        NSString *liangnum = minstr([liang valueForKey:@"name"]);
        NSDictionary *vip = [info valueForKey:@"vip"];
        NSString *type = minstr([vip valueForKey:@"type"]);
        
        
        NSDictionary *subdic = [NSDictionary dictionaryWithObjects:@[type,liangnum] forKeys:@[@"vip_type",@"liang"]];
        [Config saveVipandliang:subdic];
        
        
        self.danmuprice = [info valueForKey:@"barrage_fee"];
        _listArray = [info valueForKey:@"userlists"];
        LiveUser *users = [Config myProfile];
        users.coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"coin"]];
        [Config updateProfile:users];
        
        
        NSString *isattention = [NSString stringWithFormat:@"%@",[info valueForKey:@"isattention"]];
        userCount = [[info valueForKey:@"nums"] intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            votesTatal = minstr([info valueForKey:@"votestotal"]);
           [setFrontV changeState:votesTatal andID:nil];
            if (![minstr([info valueForKey:@"guard_nums"]) isEqual:@"0"]) {
                [setFrontV changeGuardButtonFrame:minstr([info valueForKey:@"guard_nums"])];
            }

//           setFrontV.onlineLabel.text = [NSString stringWithFormat:@"%lld",userCount];
           //userlist_time 间隔时间
               //获取用户列表
           listView = [[ListCollection alloc]initWithListArray:[info valueForKey:@"userlists"] andID:[self.playDoc valueForKey:@"uid"] andStream:[NSString stringWithFormat:@"%@",[self.playDoc valueForKey:@"stream"]]];
           listView.delegate = self;
               userlist_time = [[info valueForKey:@"userlist_time"] intValue];
               if (!listTimer) {
                   listTimer = [NSTimer scheduledTimerWithTimeInterval:userlist_time target:self selector:@selector(reloadUserList) userInfo:nil repeats:YES];
               }
           [backScrollView addSubview:listView];
           [self isAttentionLive:isattention];
       });
        //游戏******************************************
        //获取庄家信息
        NSString *coin = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_coin"]];
        
        NSString *game_banker_limit = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_limit"]];
        NSString *uname = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_name"]];
        NSString *uhead = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_banker_avatar"]];
        NSString *uid = [NSString stringWithFormat:@"%@",[info valueForKey:@"game_bankerid"]];
        NSDictionary *zhuangdic = @{
                                    @"coin":coin,
                                    @"game_banker_limit":game_banker_limit,
                                    @"uname":uname,
                                    @"uhead":uhead,
                                    @"id":uid
                                    };
        [gameState savezhuanglimit:game_banker_limit];//缓存上庄钱数限制
        zhuangstartdic = zhuangdic;
        NSString *gametime = [NSString stringWithFormat:@"%@",[info valueForKey:@"gametime"]];
        NSString *gameaction = [NSString stringWithFormat:@"%@",[info valueForKey:@"gameaction"]];
        if (!gametime || [gametime isEqual:[NSNull null]] || [gametime isEqual:@"<null>"] || [gametime isEqual:@"null"] || [gametime isEqual:@"0"]) {
            //没有游戏
            
        }
        else{
            //有游戏 1炸金花  2海盗  3转盘  4牛牛  5二八贝
            if ([gameaction isEqual:@"1"] || [gameaction isEqual:@"4"] || [gameaction isEqual:@"2"]) {

                if ([gameaction isEqual:@"2"]) {
                    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startLodumaniGame" andMsgtype:@"18"];
                }
                if ([gameaction isEqual:@"1"]) {
                    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startGame" andMsgtype:@"15"];
                }
                else if ([gameaction isEqual:@"4"]){
                    gameVC = [[gameBottomVC alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startCattleGame" andMsgtype:@"17"];
                }
                gameVC.delagate = self;
                gameVC.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                [self changeBtnFrame:_window_height - 260];
                [backScrollView insertSubview:gameVC atIndex:4];
                [backScrollView insertSubview:_liwuBTN atIndex:5];
                [self tableviewheight:_window_height - _window_height*0.2 - 260];
                [gameVC continueUI];
                [gameVC movieplayStartCut:gametime andGameid:[info valueForKey:@"gameid"]];
                NSArray *arrays = [info valueForKey:@"game"];
                if (arrays) {
                    [gameVC getNewCOins:[info valueForKey:@"game"]];
                }
                NSArray *arraysbet = [info valueForKey:@"gamebet"];
                if (arraysbet) {
                    [gameVC getmyCOIns:[info valueForKey:@"gamebet"]];
                }
                //上庄
                if ([gameaction isEqual:@"4"]) {
                    if (!zhuangVC) {
                        zhuangVC = [[shangzhuang alloc]initWithFrame:CGRectMake(_window_width + 10,90, _window_width/4, _window_width/4 + 20 + _window_width/8) ishost:NO withstreame:[self.playDoc valueForKey:@"stream"]];
                        zhuangVC.deleagte = self;
                        [backScrollView insertSubview:zhuangVC atIndex:10];
                        [backScrollView bringSubviewToFront:zhuangVC];
                        [zhuangVC getbanksCoin:zhuangstartdic];
                        [zhuangVC setpoker];
                        [zhuangVC addtableview];
                    }
                }
            }
            //转盘
            else if ([gameaction isEqual:@"3"]){
                [self getRotation];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [rotationV continueGame:gametime andgameId:[info valueForKey:@"gameid"] andMoney:[info valueForKey:@"game"] andmycoin:[info valueForKey:@"gamebet"]];
                });
            }
            else if ([gameaction isEqual:@"5"]){
                shell = [[shellGame alloc]initWIthDic:_playDoc andIsHost:NO andMethod:@"startShellGame" andMsgtype:@"19" andandBanklist:nil];
                shell.frame = CGRectMake(_window_width, _window_height - 260, _window_width,260);
                shell.delagate = self;
                [backScrollView insertSubview:shell atIndex:4];
                [backScrollView insertSubview:_liwuBTN atIndex:5];
                [shell movieplayStartCut:gametime andGameid:[info valueForKey:@"gameid"]];
                NSArray *arrays = [info valueForKey:@"game"];
                if (arrays) {
                    [shell getNewCOins:[info valueForKey:@"game"]];
                }
                NSArray *arraysbet = [info valueForKey:@"gamebet"];
                if (arraysbet) {
                    [shell getmyCOIns:[info valueForKey:@"gamebet"]];
                }
                [self changeBtnFrame:_window_height - 45 - 215];
                [self tableviewheight:setFrontV.frame.size.height - _window_height*0.2- 265];
            }
        }
        [self changecontinuegiftframe];
    
        //进入房间的时候checklive返回的收费金额
        if ([_livetype isEqual:@"3"] || [_livetype isEqual:@"2"]) {
            //此处用于计时收费
            //刷新所有人的影票
            [self addCoin:[_type_val longLongValue]];
            [socketDelegate addvotesenterroom:minstr(_type_val)];
        }
        if (![minstr([info valueForKey:@"linkmic_uid"]) isEqual:@"0"] && ![_sdkType isEqual:@"1"]) {
            //金山连麦(用户--主播)
            [self playLinkUserUrl:minstr([info valueForKey:@"linkmic_pull"]) andUid:minstr([info valueForKey:@"linkmic_uid"])];
        }
        
        if ([minstr([info valueForKey:@"isred"]) isEqual:@"1"]) {
            if (!redBagBtn) {
                //PK按钮
                redBagBtn = [UIButton buttonWithType:0];
                [redBagBtn setBackgroundImage:[UIImage imageNamed:@"红包-右上角"] forState:UIControlStateNormal];
                [redBagBtn addTarget:self action:@selector(redBagBtnClick) forControlEvents:UIControlEventTouchUpInside];
                redBagBtn.frame = CGRectMake(_window_width*2-50, 130+statusbarHeight, 40, 50);
                [backScrollView addSubview:redBagBtn];
            }
        }
        NSDictionary *pkinfo = [info valueForKey:@"pkinfo"];
        if (![minstr([pkinfo valueForKey:@"pkuid"]) isEqual:@"0"]) {
            [self anchor_agreeLink:pkinfo];
            if ([minstr([pkinfo valueForKey:@"ifpk"]) isEqual:@"1"]) {
                [self showPKView:pkinfo];
                NSMutableDictionary *pkDic = [NSMutableDictionary dictionary];
                [pkDic setObject:minstr([_playDoc valueForKey:@"uid"]) forKey:@"pkuid1"];
                [pkDic setObject:minstr([pkinfo valueForKey:@"pk_gift_liveuid"]) forKey:@"pktotal1"];
                [pkDic setObject:minstr([pkinfo valueForKey:@"pk_gift_pkuid"]) forKey:@"pktotal2"];
                [self changePkProgressViewValue:pkDic];
            }
        }
        
    }andlivetype:_livetype];
}
//改变连送礼物的frame
-(void)changecontinuegiftframe{
    
    liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top - 150,300,140);
    if (zhuangVC) {
        liansongliwubottomview.frame = CGRectMake(_window_width, self.tableView.top,_window_width/2,140);
    }
}
//改变连送礼物的frame
-(void)changecontinuegiftframeIndoliwu{
    
    liansongliwubottomview.frame = CGRectMake(_window_width, _window_height - (_window_width/2+100+ShowDiff)-140,_window_width/2,140);
}

-(void)reloadUserList{
    [listView listReloadNoew];
}
- (void)reloadLiveplayAttion:(NSNotification *)not{
    NSDictionary *dic = [not object];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        [self isAttentionLive:minstr([dic valueForKey:@"isattent"])];
    }
}
-(void)isAttentionLive:(NSString *)isattention{
    if ([isattention isEqual:@"0"]) {
        //未关注
        setFrontV.newattention.hidden = NO;
        setFrontV.leftView.frame = CGRectMake(10,25+statusbarHeight,140,leftW);
        listcollectionviewx = _window_width+150;
        listView.frame = CGRectMake(listcollectionviewx, 20+statusbarHeight, _window_width-150,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-150, 40);
    }
    else{
        //关注
        setFrontV.newattention.hidden = YES;
        setFrontV.leftView.frame = CGRectMake(10,25+statusbarHeight,95,leftW);
        listcollectionviewx = _window_width+105;
        listView.frame = CGRectMake(listcollectionviewx, 20+statusbarHeight, _window_width-105,40);
        listView.listCollectionview.frame = CGRectMake(0, 0, _window_width-105, 40);
        [socketDelegate attentionLive:level];
    }
}
/*************** 以下视频播放 ***************/
-(void)playerPlayVideo {

    _videoPlayView = [[UIView alloc] init];
    _videoPlayView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_videoPlayView];
    [self.view sendSubviewToBack:_videoPlayView];
    UIImageView *pkBackImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,_window_width,_window_height)];
    pkBackImgView.image = [UIImage imageNamed:@"pk背景"];
    pkBackImgView.userInteractionEnabled = YES;
    [self.view addSubview:pkBackImgView];
    [self.view sendSubviewToBack:pkBackImgView];
    _videoPlayView.frame = CGRectMake(0,0, _window_width, _window_height);
    _url = [NSURL URLWithString:[minstr([self.playDoc valueForKey:@"pull"]) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]
]];
    [self setupObservers];
    NSLog(@"======播流地址%@",_url);
    [self onPlayVideo];
}
-(void)handlePlayerNotify:(NSNotification*)notify {
    if (!_js_player) {
        return;
    }
    if (MPMediaPlaybackIsPreparedToPlayDidChangeNotification ==  notify.name) {
        NSLog(@"KSYPlayerVC: %@ -- ip:%@", _url, [_js_player serverAddress]);
        if ([minstr([self.playDoc valueForKey:@"isvideo"]) isEqual:@"1"]) {
            if (_js_player.naturalSize.width > _js_player.naturalSize.height) {
                _js_player.scalingMode = MPMovieScalingModeAspectFit;
            }else{
                _js_player.scalingMode = MPMovieScalingModeAspectFill;
            }
        }
        //移除开场加载动画
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    setFrontV.bigAvatarImageView.hidden = YES;
                    [buttomimageviews removeFromSuperview];
                    backScrollView.userInteractionEnabled = YES;
                    backScrollView.contentSize = CGSizeMake(_window_width*2,0);
                });
    }
    if (MPMoviePlayerPlaybackDidFinishNotification ==  notify.name) {
       
            [_js_player reload:_url flush:NO];
    }
}
- (void)setupObservers {
    
    if (![_sdkType isEqual:@"1"]) {
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMediaPlaybackIsPreparedToPlayDidChangeNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerPlaybackStateDidChangeNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerPlaybackDidFinishNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerLoadStateDidChangeNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMovieNaturalSizeAvailableNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerFirstVideoFrameRenderedNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerFirstAudioFrameRenderedNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerSuggestReloadNotification)
                                                  object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handlePlayerNotify:)
                                                    name:(MPMoviePlayerPlaybackStatusNotification)
                                                  object:nil];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toolbarHidden) name:@"toolbarHidden" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(qiehuanfangjian:) name:@"qiehuanfangjian" object:nil];

}
- (void)releaseObservers {
    if (![_sdkType isEqual:@"1"]) {
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerPlaybackDidFinishNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerLoadStateDidChangeNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMovieNaturalSizeAvailableNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerFirstVideoFrameRenderedNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerFirstAudioFrameRenderedNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerSuggestReloadNotification
                                                     object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:MPMoviePlayerPlaybackStatusNotification
                                                     object:nil];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"toolbarHidden" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"sixinok" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"qiehuanfangjian" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changePlayRoom" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"reloadLiveplayAttion" object:nil];

}
- (void)onPlayVideo {
    if ([_sdkType isEqual:@"1"]) {
        [self txPlayer];
    }else{
        [self jsPlayer];
    }
}
#pragma mark - 金山播放器
-(void)jsPlayer {
    if (_js_player) {
        [_js_player play];
        return;
    }
    _js_player =  [[KSYMoviePlayerController alloc] initWithContentURL: _url];
    _js_player.view.backgroundColor = [UIColor clearColor];
    [_js_player.view setFrame: _videoPlayView.bounds];  // player's frame must match parent's
    [_videoPlayView addSubview: _js_player.view];
    _js_player.shouldAutoplay = TRUE;
    _js_player.bInterruptOtherAudio = NO;
    _js_player.shouldEnableKSYStatModule = TRUE;
    if ([minstr([self.playDoc valueForKey:@"anyway"]) isEqual:@"1"]) {
        _js_player.scalingMode = MPMovieScalingModeAspectFit;
    }else{
        if ([minstr([self.playDoc valueForKey:@"isvideo"]) isEqual:@"1"]) {
            _js_player.scalingMode = MPMovieScalingModeAspectFit;
        }else{
            _js_player.scalingMode = MPMovieScalingModeAspectFill;
        }
    }
    
    [_js_player prepareToPlay];
    [_js_player setVolume:2.0 rigthVolume:2.0];
    _js_player.videoDecoderMode = MPMovieVideoDecoderMode_Software;
}
-(void)txPlayer {
    _config = [[TXLivePlayConfig alloc] init];
    //_config.enableAEC = YES;
    //自动模式
    _config.bAutoAdjustCacheTime   = YES;
    _config.minAutoAdjustCacheTime = 1;
    _config.maxAutoAdjustCacheTime = 5;
    _txLivePlayer =[[TXLivePlayer alloc] init];
    if (ios8) {
        _txLivePlayer.enableHWAcceleration = false;
        
    }else{
        _txLivePlayer.enableHWAcceleration = YES;
    }
    [_txLivePlayer setupVideoWidget:_videoPlayView.bounds containView:_videoPlayView insertIndex:0];
    [_txLivePlayer setRenderRotation:HOME_ORIENTATION_DOWN];
    [_txLivePlayer setConfig:_config];
    
    if ([minstr([self.playDoc valueForKey:@"anyway"]) isEqual:@"1"]) {
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
    if ([minstr([self.playDoc valueForKey:@"isvideo"]) isEqual:@"1"]) {
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
    
    if ([_livetype isEqual:@"5"]) {
        [_txLivePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
    }
    
    if(_txLivePlayer != nil)
    {
        _txLivePlayer.delegate = self;
        NSString *playUrl = [self.playDoc valueForKey:@"pull"];
        NSInteger _playType = 0;
        if ([playUrl hasPrefix:@"rtmp:"]) {
            _playType = PLAY_TYPE_LIVE_RTMP;
        } else if (([playUrl hasPrefix:@"https:"] || [playUrl hasPrefix:@"http:"]) && [playUrl rangeOfString:@".flv"].length > 0) {
            _playType = PLAY_TYPE_LIVE_FLV;
        }
        else{
            
        }
        if ([playUrl rangeOfString:@".mp4"].length > 0) {
            _playType = PLAY_TYPE_VOD_MP4;
        }
        int result = [_txLivePlayer startPlay:playUrl type:_playType];
        NSLog(@"wangminxin%d",result);
        if (result == -1)
        {
            
        }
        if( result != 0)
        {
            [_notification displayNotificationWithMessage:@"视频流播放失败" forDuration:5];
            [self lastView];
        }
        if( result == 0){
            NSLog(@"播放视频");
        }
        if ([_livetype isEqual:@"6"]) {
            [_txLivePlayer setMute:YES];//一开始 进行1v1 设置静音
        }
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void)onStopVideo{
    if (_js_player) {
        [_js_player stop];
        [_js_player.view removeFromSuperview];
        _js_player = nil;
    }
    //tx
    if(_txLivePlayer != nil) {
        _txLivePlayer.delegate = nil;
        [_txLivePlayer stopPlay];
        [_txLivePlayer removeVideoWidget];
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    for (TXPlayLinkMic *playv in self.view.subviews) {
        if ([playv isKindOfClass:[TXPlayLinkMic class]]) {
            [playv stopConnect];
            [playv stopPush];
            [playv removeFromSuperview];
        }
    }
}
/*************** 以上视频播放 ***************/
//礼物效果
/************ 礼物弹出及队列显示开始 *************/
-(void)expensiveGiftdelegate:(NSDictionary *)giftData{
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
        [backScrollView addSubview:haohualiwuV];
        [backScrollView insertSubview:haohualiwuV atIndex:8];
        CGAffineTransform t = CGAffineTransformMakeTranslation(_window_width, 0);
        haohualiwuV.transform = t;
    }
    if (giftData == nil) {
        
        
    }
    else
    {
        [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive];
    }
}
-(void)expensiveGift:(NSDictionary *)giftData{
    if (!haohualiwuV) {
        haohualiwuV = [[expensiveGiftV alloc]init];
        haohualiwuV.delegate = self;
//         [backScrollView insertSubview:haohualiwuV atIndex:8];
        [backScrollView addSubview:haohualiwuV];
        CGAffineTransform t = CGAffineTransformMakeTranslation(_window_width, 0);
        haohualiwuV.transform = t;
    }
    if (giftData == nil) {
        
        
        
    }
    else
    {
         [haohualiwuV addArrayCount:giftData];
    }
    if(haohualiwuV.haohuaCount == 0){
        [haohualiwuV enGiftEspensive];
    }
}
/*
 *添加魅力值数
 */
-(void)addCoin:(long)coin
{
    long long ordDate = [votesTatal longLongValue];
    votesTatal = [NSString stringWithFormat:@"%lld",ordDate + coin];
    [setFrontV changeState: votesTatal andID:nil];
}
-(void)addvotesdelegate:(NSString *)votes{
    [self addCoin:[votes longLongValue]];
}
/************  杨志刚 礼物弹出及队列显示结束 *************/
//跳转充值
-(void)pushCoinV{
      CoinVeiw *coin = [[CoinVeiw alloc] init];
//      [self presentViewController:coin animated:YES completion:nil];
      [self.navigationController pushViewController:coin animated:YES];
}
-(void)luckyBtnClickdelegate{
    webH5 *web = [[webH5 alloc]init];
    web.urls = [NSString stringWithFormat:@"%@/index.php?g=portal&m=page&a=index&id=26",h5url];
    [self.navigationController pushViewController:web animated:YES];
}

//聊天自动上滚
-(void)jumpLast
{
    if (_canScrollToBottom) {
    NSUInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {sectionCount-1, 0};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }  
    }
     }
}
//切换聊天和弹幕
-(void)switchState:(BOOL)state
{
    if(!state)
    {
        keyField.placeholder = YZMsg(@"和大家说些什么");
    }
    else
    {
        keyField.frame  = CGRectMake(70,7,_window_width-90 - 50, 30);//CGRectMake(50,5,_window_width-60 - 50 , 30);
        keyField.placeholder = [NSString stringWithFormat:@"%@，%@%@/%@",YZMsg(@"开启大喇叭"),self.danmuprice,[common name_coin],YZMsg(@"条")];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//执行扣费
-(void)timecoastmoney{
    coasttime -= 1;
    if (coasttime == 0) {
        [timecoast invalidate];
        timecoast = nil;
        coasttime = 60;
        [self docoast:@"Live.timeCharge"];
    }
}
//切换房间类型
-(void)changeLive:(NSString *)type_val{
    if (isSuperAdmin) {
        return;
    }
    _type_val = type_val;
    _videoPlayView.hidden = YES;
    self.js_player.shouldMute = YES;
    setFrontV.bigAvatarImageView.hidden = NO;
    if (timecoast) {
        [timecoast invalidate];
        timecoast = nil;
    }
    coasttime = 0;
    Feedeductionalertc = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前房间收费%@%@/分钟",type_val,[common name_coin]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
    UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (timecoast) {
            [timecoast invalidate];
            timecoast = nil;
        }
        [self dissmissVC];
    }];
    UIAlertAction *surelActionss = [UIAlertAction actionWithTitle:@"付费" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self docoast:@"Live.roomCharge"];
    }];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue < 9.0) {
        
    }
    else{
        [surelActionss setValue:normalColors forKey:@"_titleTextColor"];
        [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
    }
    [Feedeductionalertc addAction:cancelActionss];
    [Feedeductionalertc addAction:surelActionss];
    [self presentViewController:Feedeductionalertc animated:YES completion:nil];
    
}
-(void)docoast:(NSString *)type{
    NSString *url = [purl stringByAppendingFormat:@"?service=%@",type];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"liveuid":[self.playDoc valueForKey:@"uid"],
                             @"stream":[self.playDoc valueForKey:@"stream"]
                             };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                _videoPlayView.hidden = NO;
                self.js_player.shouldMute = NO;
                coasttime = 60;
                if (!timecoast) {
                    timecoast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timecoastmoney) userInfo:nil repeats:YES];
                }
                [socketDelegate addvotes:_type_val isfirst:@"0"];
                [self addCoin:[_type_val longLongValue]];
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                LiveUser *user = [Config myProfile];
                user.coin = minstr([info valueForKey:@"coin"]);
                [Config updateProfile:user];
                _videoPlayView.hidden = NO;
                self.js_player.shouldMute = NO;
                setFrontV.bigAvatarImageView.hidden = YES;
            }
            else{
                UIAlertController  *alertlianmaiVC = [UIAlertController alertControllerWithTitle:@"您当前余额不足无法观看" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
                UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self dissmissVC];
                }];
                if (timecoast) {
                    [timecoast invalidate];
                    timecoast = nil;
                }
                
                _videoPlayView.hidden = YES;
                self.js_player.shouldMute = YES;
                setFrontV.bigAvatarImageView.hidden = NO;
                
                NSString *version = [UIDevice currentDevice].systemVersion;
                if (version.doubleValue < 9.0) {
                    
                }
                else{
                    [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
                }
                [alertlianmaiVC addAction:cancelActionss];
                [self presentViewController:alertlianmaiVC animated:YES completion:nil];
  
                
            }
        }
        else{
            
            [MBProgressHUD showError:[responseObject valueForKey:@"msg"]];
            if (timecoast) {
                [timecoast invalidate];
                timecoast = nil;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dissmissVC];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (timecoast) {
            [timecoast invalidate];
            timecoast = nil;
        }
        [self dissmissVC];
    }];
}
//竞拍失败
-(void)jingpaifailed{
   [gifhour addjingpairesultview:3 anddic:nil];
}
-(void)jingpaisuccess:(NSDictionary *)dic{
    [gifhour addjingpairesultview:4 anddic:dic];
}
//有人竞拍获取新竞拍信息
-(void)getnewjingpaipersonmessage:(NSDictionary *)dic{
    [gifhour getnewmessage:dic];
}
//交了保证金后刷新钻石
-(void)jingpaizuanshi{
    
    if (gifhour) {
        [gifhour getcoins];
    }
    if (giftview) {
        [giftview chongzhiV:[Config getcoin]];
    }
}
//竞拍 //获取竞拍信息
-(void)getjingpaimessagedelegate:(NSDictionary *)dic{
        
    if (!gifhour) {
        
        gifhour  = [[Hourglass alloc]initWithDic:self.playDoc andFrame:CGRectMake(_window_width*2 - 60,_window_height*0.35,60,100) Block:^(NSString *task) {
            //点击竞拍压住
            [socketDelegate sendmyjingpaimessage:task];
            [self jingpaizuanshi];
            
        } andtask:^(NSString *task) {
            
            
        } andjingpaixiangqingblock:^(NSString *task) {
            //进入详情页面
            webH5 *VC = [[webH5 alloc]init];
            VC.isjingpai = @"isjingpai";
            VC.urls = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=Auction&a=detail&id=%@&uid=%@&token=%@",task,[Config getOwnID],[Config getOwnToken]];
            [self presentViewController:VC animated:YES completion:nil];
        } andchongzhi:^(NSString *task) {
            //跳往充值页面
            [self pushCoinV];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jingpaizuanshi) name:@"isjingpai" object:nil];
        [backScrollView addSubview:gifhour];
        [backScrollView insertSubview:gifhour atIndex:4];
        [gifhour addnowfirstpersonmessahevc];
    }
    if (gifhour) {
        [gifhour getjingpaimessage:dic];
    }
}
-(void)addvideoswipe{
    if (!videopan) {
        videopan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlepanss:)];
        [videopan setDelegate:self];
        [_videoPlayView addGestureRecognizer:videopan];
    }
    if (!videotap) {
        videotap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videotap)];
        [_videoPlayView addGestureRecognizer:videotap];
    }
}
-(void)videotap{
    [_videoPlayView removeGestureRecognizer:videopan];
    [_videoPlayView removeGestureRecognizer:videotap];
    videopan = nil;
    videotap = nil;
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _videoPlayView.frame = CGRectMake(0, 0, _window_width, _window_height);
        [_js_player.view setFrame: _videoPlayView.bounds];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.hidden = NO;
        setFrontV.hidden      = NO;
        _danmuView.hidden     = NO;
        listView.hidden       = NO;
        gifhour.hidden        = NO;
        backScrollView.hidden = NO;
    });
}
- (void) handlepanss: (UIPanGestureRecognizer *)rec{
    CGPoint point = [rec translationInView:_videoPlayView];
    NSLog(@"%f,%f",point.x,point.y);
    rec.view.center = CGPointMake(rec.view.center.x + point.x, rec.view.center.y + point.y);
    [rec setTranslation:CGPointMake(0, 0) inView:_videoPlayView];
}
/*
#pragma mark ================ 检查房间类型 ===============
-(void)checklive:(NSString *)stream andliveuid:(NSString *)liveuid{
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.checkLive"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 5.0;
    request.HTTPMethod = @"post";
    NSString *param = [NSString stringWithFormat:@"uid=%@&token=%@&liveuid=%@&stream=%@",[Config getOwnID],[Config getOwnToken],liveuid,stream];
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSError *error;
    NSData *backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        [MBProgressHUD showError:@"无网络"];
    }
    else{
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:backData options:NSJSONReadingMutableContainers error:nil];
        NSNumber *number = [dic valueForKey:@"ret"];
        
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [dic valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                NSDictionary *info = [[data valueForKey:@"info"] firstObject];
                NSString *type = [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                _type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                _livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                
                if ([type isEqual:@"0"]) {
                    [self onPlayVideo];
                }
                else if ([type isEqual:@"1"]){
                    NSString *_MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];

                    //密码
                    md5AlertController = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:YZMsg(@"该房间为密码房间") preferredStyle:UIAlertControllerStyleAlert];
                    //添加一个取消按钮
                    [md5AlertController addAction:[UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }]];

                    //在AlertView中添加一个输入框
                    [md5AlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        
                        textField.placeholder = @"请输入密码";
                    }];
                    
                    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
                    [md5AlertController addAction:[UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITextField *alertTextField = md5AlertController.textFields.firstObject;
//                        [self checkMD5WithText:envirnmentNameTextField.text andMD5:_MD5];
                        //输出 检查是否正确无误
                        NSLog(@"你输入的文本%@",alertTextField.text);
                        if ([_MD5 isEqualToString:[self stringToMD5:alertTextField.text]]) {
                            [self onPlayVideo];
                        }else{
                            alertTextField.text = @"";
                            [MBProgressHUD showError:YZMsg(@"密码错误")];
                            [self presentViewController:md5AlertController animated:true completion:nil];
                            return ;
                        }
                        
                    }]];
                    
                    
                    //present出AlertView
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self presentViewController:md5AlertController animated:true completion:nil];
                    });
                    
                    
//                    secretAlert = [[UIAlertView alloc]initWithTitle:@"请填写密码" message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
//                    secretAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
//                    UITextField *field = [secretAlert textFieldAtIndex:0];
//                    field.keyboardType = UIKeyboardTypeNumberPad;
//                    [secretAlert show];
//                    _MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                }
                else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    //收费
                    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:minstr([info valueForKey:@"type_msg"]) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];

                    }];
                    [alertContro addAction:cancleAction];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self doCoastRoomCharge];
                    }];
                    [alertContro addAction:sureAction];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self presentViewController:alertContro animated:YES completion:nil];
                    });
                    
                    
//                    NSString *type_msg = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
//                    coastAlert = [[UIAlertView alloc]initWithTitle:type_msg message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
//                    [coastAlert show];
                }
                
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }
        
    }
    
}
 */
//- (NSString *)stringToMD5:(NSString *)str
//{
//
//    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
//    const char *fooData = [str UTF8String];
//
//    //2.然后创建一个字符串数组,接收MD5的值
//    unsigned char result[CC_MD5_DIGEST_LENGTH];
//
//    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
//    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
//    /**
//     第一个参数:要加密的字符串
//     第二个参数: 获取要加密字符串的长度
//     第三个参数: 接收结果的数组
//     */
//
//    //4.创建一个字符串保存加密结果
//    NSMutableString *saveResult = [NSMutableString string];
//
//    //5.从result 数组中获取加密结果并放到 saveResult中
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
//        [saveResult appendFormat:@"%02x", result[i]];
//    }
//    /*
//     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
//     NSLog("%02X", 0x888);  //888
//     NSLog("%02X", 0x4); //04
//     */
//    return saveResult;
//}
/*
//执行扣费
-(void)doCoastRoomCharge{
    
    NSString *url = [purl stringByAppendingFormat:@"?service=Live.roomCharge"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken],
                             @"liveuid":minstr([self.playDoc valueForKey:@"uid"]),
                             @"stream":minstr([self.playDoc valueForKey:@"stream"])
                             };
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *number = [responseObject valueForKey:@"ret"];
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                [self onPlayVideo];
                //计时扣费
                if ([_livetype isEqual:@"3"]) {
                    if (!timecoast) {
                        timecoast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timecoastmoney) userInfo:nil repeats:YES];
                    }
                }

            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
                [self.navigationController popViewControllerAnimated:YES];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:@"无网络"];
    }];
}
#pragma mark ================ 切换房间通知 ===============
- (void)qiehuanfangjian:(NSNotification *)not{
    self.playDoc = [not object];
    [self changeRoom:self.playDoc];
}
 */
- (void)changeRoom:(NSDictionary *)info{
    _isJpush = @"1";
    [socketDelegate socketStop];
    socketDelegate = nil;
    [self initArray];
    //    [UIView animateWithDuration:0.5 animations:^{
    //        giftview.frame = CGRectMake(0,_window_height*10, _window_width, _window_height/3);
    //    }];
    
    
    [continueGifts stopTimerAndArray];
    [continueGifts initGift];
    [continueGifts removeFromSuperview];
    continueGifts = nil;
    haohualiwuV.expensiveGiftCount = nil;
    haohualiwuV.expensiveGiftCount = [NSMutableArray array];
    [haohualiwuV stopHaoHUaLiwu];
    [self onStopVideo];
    //    [self releaseObservers];
    self.chatModels = nil;
    self.chatModels = [NSMutableArray array];
    msgList = nil;
    msgList = [NSMutableArray array];
    [self.tableView reloadData];
    
    [setFrontV.bigAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[self.playDoc valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_bg.png"]];
    setFrontV.bigAvatarImageView.hidden = NO;
    
    NSString *path = [self.playDoc valueForKey:@"avatar"];
    NSURL *url = [NSURL URLWithString:path];
    [setFrontV.IconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    [setFrontV.levelimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"host_%@",minstr([self.playDoc valueForKey:@"level_anchor"])]]];
    
    userCount = 0;
    [listView initArray];
    listView = nil;
    [listView removeFromSuperview];
    [fenxiangV removeFromSuperview];
    fenxiangV = nil;
    socketDelegate = nil;
    [self removetimer];
    if (gifhour) {
        [gifhour removeall];
        [gifhour removeFromSuperview];
        gifhour = nil;
    }
    if (zhuangVC) {
        [zhuangVC dismissroom];
        [zhuangVC removeall];
        [zhuangVC remopokers];
        [zhuangVC removeFromSuperview];
        zhuangVC = nil;
    }
    if (haslianmai == YES) {
        if ([_sdkType isEqual:@"1"]) {
            [self txStopLinkMic];
        }else{
            [socketDelegate closeConnect];
        }
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    haohualiwuV.expensiveGiftCount = nil;
    if (continueGifts) {
        [continueGifts stopTimerAndArray];
        continueGifts = nil;
    }
    if (shell) {
        [shell stopGame];
        [shell releaseAll];
        [shell removeFromSuperview];
        shell = nil;
    }
    if (gameVC) {
        [gameVC releaseAll];
        [gameVC removeFromSuperview];
        gameVC = nil;
    }
    if (rotationV) {
        [rotationV stopRotatipnGameInt];
        [rotationV stoplasttimer];
        [rotationV removeFromSuperview];
        [rotationV removeall];
        rotationV = nil;
    }
    if (giftview) {
        [giftview removeFromSuperview];
        giftview = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playerPlayVideo];
        [huanxinviews.view removeFromSuperview];
        huanxinviews = nil;
        [chatsmall.view removeFromSuperview];
        chatsmall = nil;
        //        huanxinviews = [[huanxinsixinview alloc]init];
        //        huanxinviews.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
        //        [self.view insertSubview:huanxinviews.view atIndex:7];
        //        chatsmall = [[chatsmallview alloc]init];
        //        chatsmall.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
        //        [self.view insertSubview:chatsmall.view atIndex:8];
        //        chatsmall.view.hidden =YES;
    });
    
    
    [self showBTN];
    [self getNodeJSInfo]; //初始化nodejs信息
    //检查房间类型
    
    if ([_livetype isEqual:@"3"]) {
        if (!timecoast) {
            timecoast = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timecoastmoney) userInfo:nil repeats:YES];
        }

    }
    coasttime = 60;
    
}

- (void)qiehuanfangjian:(NSNotification *)not{
    NSDictionary *dic = [not object];
    _isJpush = @"1";
    [self dissmissVC];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"jinruzhibojiantongzhi" object:dic];
}
#pragma mark ================ 切换房间 ===============
- (void)changePlayRoom:(NSNotification *)not{
    NSDictionary *dic = [not userInfo];
    _livetype = minstr([dic valueForKey:@"livetype"]);
    _type_val = minstr([dic valueForKey:@"type_val"]);
    self.playDoc = [dic valueForKey:@"dic"];
    [self changeRoom:self.playDoc];
}

#pragma mark ================ 连麦 ===============
- (void)playLinkUserUrl:(NSString *)playurl andUid:(NSString *)userid{
    [self releasePlayLinkView];
    if ([_sdkType isEqual:@"1"]) {
        _tx_playrtmp = [[TXPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":playurl,@"pushurl":@"0"} andFrame:CGRectMake(_window_width - 100, _window_height - 110 -statusbarHeight - 150 -ShowDiff, 100, 150) andisHOST:NO];
        _tx_playrtmp.delegate = self;
        _tx_playrtmp.tag = 1500 + [userid intValue];
        [self.view addSubview:_tx_playrtmp];
        [self.view insertSubview:_tx_playrtmp aboveSubview:self.tableView];
    }else{
        _js_playrtmp = [[JSPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":playurl,@"pushurl":@"0"} andFrame:CGRectMake(_window_width - 100, _window_height - 110 -statusbarHeight - 150 -ShowDiff, 100, 150) andisHOST:NO];
        _js_playrtmp.delegate = self;
        _js_playrtmp.tag = 1500 + [userid intValue];
        [self.view addSubview:_js_playrtmp];
        [self.view insertSubview:_js_playrtmp aboveSubview:self.tableView];
    }
}
//连麦
-(void)connectVideos{
//    if([[Config getLevel] intValue] < [lianmaiLevel intValue]){
//        [MBProgressHUD showError:[NSString stringWithFormat:@"用户等级达到%@级才可与主播连麦哦～",lianmaiLevel]];
//        return;
//    }
//    [self faqilaimai];
#warning ===== user link
    if (haslianmai) {
        [self faqilaimai];
    }else{
        [YBToolClass postNetworkWithUrl:@"Linkmic.isMic" andParameter:@{@"liveuid":minstr([_playDoc valueForKey:@"uid"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                [self faqilaimai];
            }else{
                [MBProgressHUD showError:msg];
            }
            
        } fail:^{
            
        }];
    }
}
- (void)faqilaimai{
    if (zhuangVC || shell || gameVC || rotationV) {
        [MBProgressHUD showError:@"游戏状态下不能进行连麦哦～"];
        return;
    }
    if (!haslianmai) {
        if (_js_playrtmp) {
            [MBProgressHUD showError:YZMsg(@"主播连麦中，请等会儿再试哦～")];
            return;
        }
    }
    if (haslianmai == NO) {
        haslianmai = YES;
        //发送连麦socket
        [MBProgressHUD showError:YZMsg(@"连麦请求已发送")];
        [socketDelegate connectvideoToHost];
        if (!startLinkTimer) {
            startLinkTime = 11;
            startLinkTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLinkTimeDaoJiShi) userInfo:nil repeats:YES];
        }
        
    }
    else{
        if (startLinkTimer) {
            [MBProgressHUD showError:YZMsg(@"您已申请，请稍等")];
            return;
        }
        UIAlertController  *alertlianmaiVC = [UIAlertController alertControllerWithTitle:YZMsg(@"是否断开连麦") message:@"" preferredStyle:UIAlertControllerStyleAlert];
        //修改按钮的颜色，同上可以使用同样的方法修改内容，样式
        UIAlertAction *defaultActionss = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //关闭连麦
            haslianmai = NO;
            NSLog(@"关闭连麦");
            [self closeconnect];
            [socketDelegate closeConnect];
        }];
        UIAlertAction *cancelActionss = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        NSString *version = [UIDevice currentDevice].systemVersion;
        if (version.doubleValue < 9.0) {
            
        }
        else{
            [defaultActionss setValue:normalColors forKey:@"_titleTextColor"];
            [cancelActionss setValue:normalColors forKey:@"_titleTextColor"];
        }
        [alertlianmaiVC addAction:defaultActionss];
        [alertlianmaiVC addAction:cancelActionss];
        [self presentViewController:alertlianmaiVC animated:YES completion:nil];
    }

}
- (void)startLinkTimeDaoJiShi{
    startLinkTime -- ;
    if (startLinkTime <= 0) {
        [startLinkTimer invalidate];
        startLinkTimer = nil;
    }
}
-(void)closeconnect{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self releasePlayLinkView];
        [MBProgressHUD hideHUD];
        [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
        haslianmai = NO;
        _connectVideo.userInteractionEnabled = YES;
    });
}
//得到主播同意开始连麦
-(void)startConnectvideo{
    if (startLinkTimer) {
        [startLinkTimer invalidate];
        startLinkTimer = nil;
    }
    [YBToolClass postNetworkWithUrl:@"Linkmic.RequestLVBAddrForLinkMic" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            NSDictionary *infoDic = [info firstObject];
            _myplayurl = [infoDic valueForKey:@"playurl"];
            NSString *_mypushurl = [infoDic valueForKey:@"pushurl"];
            NSDictionary *subdic = @{
                                     @"userid":[Config getOwnID],
                                     @"playurl":[NSString stringWithFormat:@"%@",_myplayurl],
                                     @"pushurl":[NSString stringWithFormat:@"%@",_mypushurl]
                                     };
            [self releasePlayLinkView];
            if ([_sdkType isEqual:@"1"]) {
                //腾讯
                _tx_playrtmp = [[TXPlayLinkMic alloc]initWithRTMPURL:subdic andFrame:CGRectMake(_window_width - 100, _window_height - 110 - ShowDiff - 150 , 100, 150) andisHOST:NO];
                _tx_playrtmp.delegate = self;
                _tx_playrtmp.tag = 1500 + [[Config getOwnID] intValue];
                [self.view addSubview:_tx_playrtmp];
                [self.view insertSubview:_tx_playrtmp aboveSubview:self.tableView];
            }else{
                //金山
                _js_playrtmp = [[JSPlayLinkMic alloc]initWithRTMPURL:subdic andFrame:CGRectMake(_window_width - 100, _window_height - 110 - ShowDiff - 150 , 100, 150) andisHOST:NO];
                _js_playrtmp.delegate = self;
                _js_playrtmp.tag = 1500 + [[Config getOwnID] intValue];
                [self.view addSubview:_js_playrtmp];
                [self.view insertSubview:_js_playrtmp aboveSubview:self.tableView];
            }
            
        }
        else{
            [MBProgressHUD showError:msg];
            _connectVideo.userInteractionEnabled = YES;
            
        }

    } fail:^{
        _connectVideo.userInteractionEnabled = YES;
    }];
    
}
#pragma mark -  腾讯连麦start
//停止从CDN拉流，开始推流
-(void)tx_startConnectRtmpForLink_mic{
    //1.结束从CDN拉流
    [_txLivePlayer stopPlay];
    //2.拉取主播的低时延流
    [self gethostlowurl];
    //3.通知主播和其他小主播拉取自己的流
    [socketDelegate sendSmallURL:_myplayurl andID:[Config getOwnID]];
    [_connectVideo setImage:[UIImage imageNamed:@"live_断"] forState:0];
    _connectVideo.userInteractionEnabled = YES;
}
//1.拉取主播的低时延流
-(void)gethostlowurl{
    NSString *url = [purl stringByAppendingFormat:@"?service=Linkmic.RequestPlayUrlWithSignForLinkMic&uid=%@&originStreamUrl=%@",[Config getOwnID],[self.playDoc valueForKey:@"pull"]];
    NSString *newUrlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YBNetworking postWithUrl:newUrlStr Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            NSDictionary *info = [[data valueForKey:@"info"] firstObject];
            NSString *streamUrlWithSignature = [info valueForKey:@"streamUrlWithSignature"];
            [_txLivePlayer startPlay:streamUrlWithSignature type:PLAY_TYPE_LIVE_RTMP_ACC];//加速直播
        }else{
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
}
-(void)tx_stoppushlink{
    [self txStopLinkMic];
}

-(void)tx_closeUserbyVideo:(NSDictionary *)subdic{
    [MBProgressHUD showError:@"播放失败"];
}
-(void)txStopLinkMic{
    
    _connectVideo.userInteractionEnabled = YES;
    [socketDelegate closeConnect];//关闭连麦通知
    //清除其他连麦信息
    for (TXPlayLinkMic *playv in self.view.subviews) {
        if ([playv isKindOfClass:[TXPlayLinkMic class]]) {
            [playv stopConnect];
            [playv stopPush];
            [playv removeFromSuperview];
        }
    }
    [_txLivePlayer stopPlay];

}
#pragma mark -  腾讯连麦end
//开始连麦推流
-(void)js_startConnectRtmpForLink_mic{
    [socketDelegate sendSmallURL:_myplayurl andID:[Config getOwnID]];
    [_connectVideo setImage:[UIImage imageNamed:@"live_断"] forState:0];
    _connectVideo.userInteractionEnabled = YES;

}
- (void)js_stoppushlink{
    [MBProgressHUD showError:YZMsg(@"推流失败")];
    [socketDelegate closeConnect];
    _connectVideo.userInteractionEnabled = YES;

}
- (void)hostout{
    if (startLinkTimer) {
        [startLinkTimer invalidate];
        startLinkTimer = nil;
    }
    _connectVideo.userInteractionEnabled = YES;
    [self releasePlayLinkView];
    [self enabledlianmaibtn];
}
- (void)releasePlayLinkView{
    if (_js_playrtmp) {
        [_js_playrtmp stopConnect];
        [_js_playrtmp stopPush];
        [_js_playrtmp removeFromSuperview];
        _js_playrtmp = nil;
    }
    if (startLinkTimer) {
        [startLinkTimer invalidate];
        startLinkTimer = nil;
    }
    if (_tx_playrtmp) {
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }

}
- (void)enabledlianmaibtn{

    [_connectVideo setImage:[UIImage imageNamed:@"live_连麦"] forState:UIControlStateNormal];
    haslianmai = NO;
    _connectVideo.userInteractionEnabled = YES;
}
#pragma mark ================ s添加印象 ===============
- (void)setLabel:(NSString *)touid{
    impressVC *vc = [[impressVC alloc]init];
    vc.isAdd = YES;
    vc.touid = touid;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark ================ 改变发送按钮图片 ===============
- (void)ChangePushBtnState{
    if (keyField.text.length > 0) {
        pushBTN.selected = YES;
    }else{
        pushBTN.selected = NO;
    }
}
#pragma mark ================ 守护功能 ===============
-(void)showGuardView{
    if (giftview) {
        [self changeGiftViewFrameY:_window_height*10];
    }
    gShowView = [[guardShowView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) andUserGuardMsg:guardInfo andLiveUid:minstr([_playDoc valueForKey:@"uid"])];
    gShowView.delegate = self;
    [self.view addSubview:gShowView];
    [gShowView show];
}
- (void)buyOrRenewGuard{
    [self removeShouhuView];
    if (!guardView) {
        guardView = [[shouhuView alloc]init];
        guardView.liveUid = minstr([_playDoc valueForKey:@"uid"]);
        guardView.stream = minstr([_playDoc valueForKey:@"stream"]);
        guardView.delegate = self;
        guardView.guardType = minstr([guardInfo valueForKey:@"type"]);
        [self.view addSubview:guardView];
    }
    [guardView show];
}
- (void)removeShouhuView{
    if (guardView) {
        [guardView removeFromSuperview];
        guardView = nil;
    }
    if (gShowView) {
        [gShowView removeFromSuperview];
        gShowView = nil;
    }
    if (redList) {
        [redList removeFromSuperview];
        redList = nil;
    }
}
- (void)buyShouhuSuccess:(NSDictionary *)dic{
    guardInfo = dic;
    [socketDelegate buyGuardSuccess:dic];
}
- (void)updateGuardMsg:(NSDictionary *)dic{
    [setFrontV changeState:minstr([dic valueForKey:@"votestotal"]) andID:nil];
    [setFrontV changeGuardButtonFrame:minstr([dic valueForKey:@"guard_nums"])];
    if (listView) {
        [listView listReloadNoew];
    }
    
}
#pragma mark ================ 红包 ===============
- (void)showRedView{
    redBview = [[redBagView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
    __weak moviePlay *wSelf = self;
    redBview.block = ^(NSString *type) {
        [wSelf sendRedBagSuccess:type];
    };
    redBview.zhuboDic = _playDoc;
    [self.view addSubview:redBview];
}
- (void)sendRedBagSuccess:(NSString *)type{
    [redBview removeFromSuperview];
    redBview = nil;
    if ([type isEqual:@"909"]) {
        return;
    }
    [socketDelegate fahongbaola];
}
- (void)showRedbag:(NSDictionary *)dic{
    if (!redBagBtn) {
        //PK按钮
        redBagBtn = [UIButton buttonWithType:0];
        [redBagBtn setBackgroundImage:[UIImage imageNamed:@"红包-右上角"] forState:UIControlStateNormal];
        [redBagBtn addTarget:self action:@selector(redBagBtnClick) forControlEvents:UIControlEventTouchUpInside];
        redBagBtn.frame = CGRectMake(_window_width*2-50, 130+statusbarHeight, 40, 50);
        [backScrollView addSubview:redBagBtn];
    }
    NSString *uname;
    if ([minstr([dic valueForKey:@"uid"]) isEqual:minstr([_playDoc valueForKey:@"uid"])]) {
        uname = YZMsg(@"主播");
    }else{
        uname = minstr([dic valueForKey:@"uname"]);
    }
    NSString *levell = @" ";
    NSString *ID = @" ";
    NSString *vip_type = @"0";
    NSString *liangname = @"0";
    NSDictionary *chat = [NSDictionary dictionaryWithObjectsAndKeys:uname,@"userName",minstr([dic valueForKey:@"ct"]),@"contentChat",levell,@"levelI",ID,@"id",@"redbag",@"titleColor",vip_type,@"vip_type",liangname,@"liangname",nil];
    [msgList addObject:chat];
    titleColor = @"0";
    if(msgList.count>30)
    {
        [msgList removeObjectAtIndex:0];
    }
    [self.tableView reloadData];
    [self jumpLast];
    
}
- (void)redBagBtnClick{
    redList = [[redListView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height) withZHuboMsg:_playDoc];
    redList.delegate =self;
    [self.view addSubview:redList];
}
#pragma mark ================ 主播连麦 ===============
- (void)anchor_agreeLink:(NSDictionary *)dic{
    if (![_sdkType isEqual:@"1"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _js_player.view.frame = CGRectMake(0, 130+statusbarHeight, _window_width/2, _window_width*2/3);
        }];
        if (_js_playrtmp) {
            [_js_playrtmp stopConnect];
            [_js_playrtmp stopPush];
            [_js_playrtmp removeFromSuperview];
            _js_playrtmp = nil;
        }
        _js_playrtmp = [[JSPlayLinkMic alloc]initWithRTMPURL:@{@"playurl":minstr([dic valueForKey:@"pkpull"]),@"pushurl":@"0",@"userid":minstr([dic valueForKey:@"pkuid"])} andFrame:CGRectMake(_window_width/2, 130+statusbarHeight , _window_width/2, _window_width*2/3) andisHOST:NO];
        _js_playrtmp.delegate = self;
        _js_playrtmp.tag = 1500 + [minstr([dic valueForKey:@"pkuid"]) intValue];
        [_videoPlayView addSubview:_js_playrtmp];
    }else{
        /*
        _canChange = YES;
        _isCancleLink = NO;
//        [UIView animateWithDuration:0.3 animations:^{
//            _videoPlayView.frame = CGRectMake(0, 130+statusbarHeight, _window_width, _window_width*2/3);
//            [_txLivePlayer setupVideoWidget:_videoPlayView.bounds containView:_videoPlayView insertIndex:0];
//        }];
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _videoPlayView.frame = CGRectMake(0, 130+statusbarHeight, _window_width, _window_width*2/3);
                [_txLivePlayer setupVideoWidget:_videoPlayView.bounds containView:_videoPlayView insertIndex:0];
            }];
        });
        
    }
}
- (void)anchor_stopLink:(NSDictionary *)dic{
    if (pkView) {
        [pkView removeFromSuperview];
        pkView = nil;
    }
    if (_js_playrtmp) {
        [_js_playrtmp stopConnect];
        [_js_playrtmp stopPush];
        [_js_playrtmp removeFromSuperview];
        _js_playrtmp = nil;
    }
    if (_tx_playrtmp) {
        [_tx_playrtmp stopConnect];
        [_tx_playrtmp stopPush];
        [_tx_playrtmp removeFromSuperview];
        _tx_playrtmp = nil;
    }
    if ([_sdkType isEqual:@"1"]) {
        /*
         _canChange = YES;
         _isCancleLink = YES;
         //_videoPlayView.frame = CGRectMake(0, 0, _window_width, _window_height);
         //[_txLivePlayer setupVideoWidget:_videoPlayView.bounds containView:_videoPlayView insertIndex:0];
         */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _videoPlayView.frame = CGRectMake(0, 0, _window_width, _window_height);
                [_txLivePlayer setupVideoWidget:_videoPlayView.bounds containView:_videoPlayView insertIndex:0];
            }];
        });
        
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            _js_player.view.frame = CGRectMake(0, 0, _window_width, _window_height);
        }];
    }
   
}
#pragma mark ================ PK ===============
-(void)removePKView{
    if (pkView) {
        [pkView removeFromSuperview];
        pkView = nil;
    }
}
- (void)showPKView:(NSDictionary *)dic{
    if (pkView) {
        [pkView removeFromSuperview];
        pkView = nil;
    }
    NSString *time;
    if (dic) {
        time = minstr([dic valueForKey:@"pk_time"]);
    }else{
        time = @"300";
    }
    CGFloat startY = 130+statusbarHeight;
    if ([_sdkType isEqual:@"1"]) {
        startY = 0;
    }
    pkView = [[anchorPKView alloc]initWithFrame:CGRectMake(0, startY, _window_width, _window_width*2/3+20) andTime:time];
    pkView.delegate = self;
    [_videoPlayView addSubview:pkView];
}
- (void)showPKResult:(NSDictionary *)dic{
    int win;
    if ([minstr([dic valueForKey:@"win_uid"]) isEqual:@"0"]) {
        win = 0;
    }else if ([minstr([dic valueForKey:@"win_uid"]) isEqual:minstr([_playDoc valueForKey:@"uid"])]) {
        win = 1;
    }else{
        win = 2;
    }
    
    [pkView showPkResult:dic andWin:win];
}
- (void)changePkProgressViewValue:(NSDictionary *)dic{
    NSString *blueNum;
    NSString *redNum;
    CGFloat progress = 0.0;
    if ([minstr([dic valueForKey:@"pkuid1"]) isEqual:minstr([_playDoc valueForKey:@"uid"])]) {
        blueNum = minstr([dic valueForKey:@"pktotal1"]);
        redNum = minstr([dic valueForKey:@"pktotal2"]);
    }else{
        redNum = minstr([dic valueForKey:@"pktotal1"]);
        blueNum = minstr([dic valueForKey:@"pktotal2"]);
    }
    if ([blueNum isEqual:@"0"] && [redNum isEqual:@"0"]) {
        progress = 0.5;
    }else{
        if ([blueNum isEqual:@"0"]) {
            progress = 0.2;
        }else if ([redNum isEqual:@"0"]) {
            progress = 0.8;
        }else{
            CGFloat ppp = [blueNum floatValue]/([blueNum floatValue] + [redNum floatValue]);
            if (ppp < 0.2) {
                progress = 0.2;
            }else if (ppp > 0.8){
                progress = 0.8;
            }else{
                progress = ppp;
            }
        }
    }
    
    [pkView updateProgress:progress withBlueNum:blueNum withRedNum:redNum];
}
#pragma mark ============举报=============

-(void)doReportAnchor:(NSString *)touid{
    [self doCancle];

    jubaoVC *vc = [[jubaoVC alloc]init];
    vc.dongtaiId = touid;
    vc.isLive = YES;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark ===========================   腾讯播放start   =======================================

//播放监听事件
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
    NSLog(@"eventID:%d===%@",EvtID,param);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_CONNECT_SUCC) {
            NSLog(@"moviplay不连麦已经连接服务器");
        }
        else if (EvtID == PLAY_EVT_RTMP_STREAM_BEGIN){
            NSLog(@"moviplay不连麦已经连接服务器，开始拉流");
        }
        else if (EvtID == PLAY_EVT_PLAY_BEGIN){
            NSLog(@"moviplay不连麦视频播放开始");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                setFrontV.bigAvatarImageView.hidden = YES;
                [buttomimageviews removeFromSuperview];
                backScrollView.userInteractionEnabled = YES;
                backScrollView.contentSize = CGSizeMake(_window_width*2,0);
            });
        }
        else if (EvtID== PLAY_WARNING_VIDEO_PLAY_LAG){
            NSLog(@"moviplay不连麦当前视频播放出现卡顿（用户直观感受）");
        }
        else if (EvtID == PLAY_EVT_PLAY_END){
            NSLog(@"moviplay不连麦视频播放结束");
            [_txLivePlayer resume];
        }
        else if (EvtID == PLAY_ERR_NET_DISCONNECT) {
            //视频播放结束
            NSLog(@"moviplay不连麦网络断连,且经多次重连抢救无效,可以放弃治疗,更多重试请自行重启播放");
        }else if (EvtID == PLAY_EVT_CHANGE_RESOLUTION) {
            NSLog(@"主播连麦分辨率改变");
            /*
            if (_canChange) {
                _canChange = NO;
                if (_isCancleLink) {
                     _videoPlayView.frame = CGRectMake(0, 0, _window_width, _window_height);
                }else{
                    _videoPlayView.frame = CGRectMake(0, 130+statusbarHeight, _window_width, _window_width*2/3);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        [_txLivePlayer setupVideoWidget:_videoPlayView.bounds containView:_videoPlayView insertIndex:0];
                    }];
                });
            }
            */
        }
    });
}
-(void)onNetStatus:(NSDictionary *)param{
    
    
}

#pragma mark ===========================   腾讯播放end   =======================================

#pragma mark ============奖池View=============
- (void)JackpotLevelUp:(NSDictionary *)dic{
    if (!JackpotBtn) {
        JackpotBtn = [[JackpotButton alloc]init];
        JackpotBtn.frame = CGRectMake(_window_width + 10, statusbarHeight + 135, 60, 30);
        [JackpotBtn setBackgroundImage:[UIImage imageNamed:@"Jackpot_btnBack"]];
        [JackpotBtn addTarget:self action:@selector(showJackpotView) forControlEvents:UIControlEventTouchUpInside];
        [backScrollView addSubview:JackpotBtn];
    }
    [JackpotBtn showLightAnimationWithLevel:minstr([dic valueForKey:@"uplevel"])];
    
}
- (void)WinningPrize:(NSDictionary *)dic{
    if (winningView) {
        [winningView removeFromSuperview];
        winningView = nil;
    }
    winningView = [[WinningPrizeView alloc]initWithFrame:CGRectMake(0, 130+statusbarHeight, _window_width, _window_width) andMsg:dic];
    [self.view addSubview:winningView];
    [self.view bringSubviewToFront:winningView];

}
- (void)showJackpotView{
    if (jackV) {
        [jackV removeFromSuperview];
        jackV = nil;
    }
    [YBToolClass postNetworkWithUrl:@"Jackpot.getJackpot" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infoDic = [info firstObject];
            jackV = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([JackpotView class]) owner:nil options:nil] lastObject];
            jackV.delegate = self;
            jackV.levelL.text = [NSString stringWithFormat:@"Lv.%@",minstr([infoDic valueForKey:@"level"])];
            jackV.coinL.text = minstr([infoDic valueForKey:@"total"]);
            jackV.frame = CGRectMake(_window_width*0.2, 135+statusbarHeight, _window_width*0.6+20, _window_width*0.6);
            [self.view addSubview:jackV];
        }else{
            [MBProgressHUD  showError:msg];
        }
    } fail:^{
        
    }];
}
-(void)jackpotViewClose{
    [jackV removeFromSuperview];
    jackV = nil;
}
#pragma mark ============幸运礼物全站效果=============
- (void)showAllLuckygift:(NSDictionary *)dic{
    [setFrontV.luckyGift addLuckyGiftMove:dic];
}

@end
