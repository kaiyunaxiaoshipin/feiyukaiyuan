//
//  MessageListVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageListVC.h"

#import "MessageHeaderV.h"
#import "MessageListCell.h"
#import "MessageListModel.h"
#import "JCHATConversationViewController.h"
#import "MessageFansVC.h"
#import "MsgTopPubVC.h"
#import "SelPeopleV.h"
#import "JCHATAlertViewWait.h"
#import "MsgSysVC.h"
//#import "CenterVC.h"
@interface MessageListVC ()<UITableViewDelegate,UITableViewDataSource,JMessageDelegate,JMSGConversationDelegate>
{
    YBNavi *_ybNavi;
    __block NSMutableArray *_conversationArr;
    NSInteger _unreadCount;
    
    SelPeopleV * _selV;

    JMSGConversation *conver_admin1;//官方通知
    JMSGConversation *conver_admin2;//系统通知
    UILabel *nothingLabel;
    NSDictionary *systemDic;
}
@property(nonatomic,assign)int paging;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)MessageHeaderV *headerV;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSMutableArray *userArray;

@end

@implementation MessageListVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    if (!appDelegate.isDBMigrating) {
        [self getConversationList];
//    } else {
//        NSLog(@"is DBMigrating don't get allconversations");
//        [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
//    }
    [self getUnreadCound];
}
- (void)bbbb:(NSNotification *)noti{
    [self requestSystemMsg];
}
- (void)requestSystemMsg{
    systemDic = @{
                  @"addtime":@"--",
                  @"content":YZMsg(@"暂无消息")
                  };
    [YBToolClass postNetworkWithUrl:@"Message.getList" andParameter:@{@"p":@"1"} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            if ([(NSArray*)info count]>0) {
                systemDic = [info firstObject];
            }
        }
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } fail:^{
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = Black_Cor;
    self.userArray = [NSMutableArray array];
    self.models = [NSArray array];
    _conversationArr = [NSMutableArray array];
    
    [self getview];
    //统一注册极光相关通知
    [self addNotifications];
    
//    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
//    if (!appDelegate.isDBMigrating) {
        [self addDelegate];
//    } else {
//        NSLog(@"is DBMigrating don't get allconversations");
//        [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
//    }
    [self.view addSubview:self.tableView];
    
    [self requestSystemMsg];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbbb:) name:@"system_notificationUpdate" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark - 数据更新
- (NSArray *)models {
    NSMutableArray *m_array = [NSMutableArray array];
    for (NSDictionary *dic in _userArray) {
        MessageListModel *model = [MessageListModel modelWithDic:dic];
        [m_array addObject:model];
    }
    _models = m_array;
    
    return _models;
}
//根据id获取用户的信息
-(void)getUserList:(NSString *)idStrs {
    
    //getMultiInfo  没有idStrs == 没有消息记录就不请求了
    if (idStrs.length<=0) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
//        [PublicView showTextNoData:_tableView text1:@"" text2:@"暂未收到任何消息"];
        return;
    }
//    [PublicView hiddenTextNoData:_tableView];
    NSString *url = [purl stringByAppendingFormat:@"?service=User.getUidsInfo&uid=%@&uids=%@",[Config getOwnID],idStrs];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            [_userArray removeAllObjects];
            _userArray = nil;
            _userArray = [NSMutableArray array];
            NSArray *info = [data valueForKey:@"info"];
            for (int i=0; i<info.count; i++) {
                NSMutableDictionary *m_dic = [NSMutableDictionary dictionaryWithDictionary:info[i]];
                [_userArray addObject:m_dic];
                for (JMSGConversation *conversation in _conversationArr) {
                    NSString *JIM_id = [NSString string];
                    if (conversation.conversationType == kJMSGConversationTypeSingle) {
                        JIM_id = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
                        JIM_id = [JIM_id stringByReplacingOccurrencesOfString:JmessageName withString:@""];
                    }
                    NSString *uid = [NSString stringWithFormat:@"%@",[m_dic valueForKey:@"id"]];
                    if ([JIM_id isEqual:uid]) {
                        [m_dic setObject:conversation forKey:@"conversation"];
                    }
                }
            }
            [_tableView reloadData];
        }else {
//            [MBProgressHUD showError:msg];
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
}

#pragma mark - 点击事件
-(void)goCenter:(NSString *)hostID{
    //    if ([[Config getOwnID] intValue]<=0) {
    //        [PublicObj warnLogin];
    //        return;
    //    }
    
    if ([hostID isEqual:@"dsp_admin_1"]||[hostID isEqual:@"dsp_admin_2"]) {
        return;
    }
    
//    CenterVC *center = [[CenterVC alloc]init];
//    if ([hostID isEqual:[Config getOwnID]]) {
//        center.otherUid =[Config getOwnID];
//    }else{
//        center.otherUid =hostID;
//    }
//    center.isPush = YES;
//    center.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:center animated:YES];
    
}
-(void)msgClickEvent:(NSString *)type {
   
    if ([type isEqual:@"粉丝"]) {
        MessageFansVC *fansVC = [[MessageFansVC alloc]init];
        fansVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fansVC animated:YES];
        NSLog(@"==粉丝==");
    }else {
        //赞、@我的、评论
        MsgTopPubVC *pubVC = [[MsgTopPubVC alloc]init];
        pubVC.type = type;
        pubVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pubVC animated:YES];
         NSLog(@"==赞==@我的==评论==");
    }
}
-(void)selPeopleFun {
    YBWeakSelf;
    if (!_selV) {
        _selV = [[SelPeopleV alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, _window_height) showType:@"1" selUser:^(NSString *state, MessageListModel *userModel) {
            [weakSelf selCallBack:state uModel:userModel];
        }];
        [self.view addSubview:_selV];
        
    }
    [UIView animateWithDuration:0.3 animations:^{
        _selV.frame = CGRectMake(0, 0, _window_width, _window_height);
        self.tabBarController.tabBar.hidden = YES;
    }];
   
}

-(void)selCallBack:(NSString *)state uModel:(MessageListModel *)model{
    if ([state isEqual:@"关闭"]) {
        [UIView animateWithDuration:0.3 animations:^{
            _selV.frame = CGRectMake(0, _window_height, _window_width, _window_height);
        } completion:^(BOOL finished) {
            self.tabBarController.tabBar.hidden = NO;
            [_selV removeFromSuperview];
            _selV = nil;
        }];
    }else {
        //单聊
        [UIView animateWithDuration:0.3 animations:^{
            _selV.frame = CGRectMake(0, _window_height, _window_width, _window_height);
        } completion:^(BOOL finished) {
            self.tabBarController.tabBar.hidden = NO;
            [_selV removeFromSuperview];
            _selV = nil;
            //去单聊页面
            NSLog(@"===去单聊页面===%@",model.uidStr);
            [[JCHATAlertViewWait ins] showInView];
            JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
            sendMessageCtl.hidesBottomBarWhenPushed = YES;
            __weak __typeof(self)weakSelf = self;
            [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uidStr] completionHandler:^(id resultObject, NSError *error) {
                 [[JCHATAlertViewWait ins] hidenAll];
                if (error == nil) {
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    sendMessageCtl.conversation = resultObject;
                    sendMessageCtl.userModel = model;
                    [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
                }else{
                    [MBProgressHUD showError:YZMsg(@"对方未注册私信")];
                }
            }];
        }];
        
    }
}
#pragma mark - UITableViewDelegate、UITableViewDataSource
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [MBProgressHUD showError:YZMsg(@"系统消息无法删除")];
        return;
    }

    //[self.tableView reloadData];
    MessageListModel *model = _models[indexPath.row];
    [JMSGConversation deleteSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uidStr]];
    [self getConversationList];

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return _window_width/4+5;
//    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        _headerV = [[[NSBundle mainBundle]loadNibNamed:@"MessageHeaderV" owner:nil options:nil]objectAtIndex:0];
//        _headerV.frame = CGRectMake(0, 0, _window_width, _window_width/4+5);
//        _headerV.backgroundColor = Black_Cor;
//        _headerV.headerBgV.backgroundColor = CellRow_Cor;
//        _headerV.fansBtn = [PublicObj setUpImgDownText:_headerV.fansBtn space:15];
//        _headerV.zanBtn = [PublicObj setUpImgDownText:_headerV.zanBtn space:15];
//        _headerV.aiTeBtn = [PublicObj setUpImgDownText:_headerV.aiTeBtn space:15];
//        _headerV.commentBtn = [PublicObj setUpImgDownText:_headerV.commentBtn space:15];
//        WeakSelf;
//        _headerV.msgEvent = ^(NSString *type) {
//            [weakSelf msgClickEvent:type];
//        };
//        return _headerV;
//    }
    return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListCell *cell = [MessageListCell cellWithTab:tableView andIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.nameL.text = YZMsg(@"系统消息");
        cell.detailL.text = minstr([systemDic valueForKey:@"content"]);
        cell.timeL.text = minstr([systemDic valueForKey:@"addtime"]);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notifacationOldTime"]) {
            NSString *oldTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"notifacationOldTime"];
            if ([[YBToolClass sharedInstance] compareDate:oldTime withDate:minstr([systemDic valueForKey:@"addtime"])] == 1) {
                cell.redPoint.hidden = NO;
            }else{
                cell.redPoint.hidden = YES;
            }
        }else{
            if ([minstr([systemDic valueForKey:@"addtime"]) isEqual:@"--"]) {
                cell.redPoint.hidden = YES;
            }else{
                cell.redPoint.hidden = NO;
            }
        }
        cell.iconIV.image = [PublicObj getAppIcon];
    }else{
        MessageListModel *model = _models[indexPath.row];;
        cell.model = model;
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
        YBWeakSelf;
        cell.iconEvent = ^(NSString *type) {
//            [weakSelf goCenter:model.uidStr];
        };
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MsgSysVC *sysVC = [[MsgSysVC alloc]init];
//        sysVC.listModel = model;
        sysVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sysVC animated:YES];

    }else{
        MessageListModel *model = _models[indexPath.row];
        JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
        if ([model.uidStr isEqual:@"dsp_admin_1"]||[model.uidStr isEqual:@"dsp_admin_2"]) {
        }else{
            JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
            sendMessageCtl.hidesBottomBarWhenPushed = YES;
            sendMessageCtl.conversation = conversation;
            sendMessageCtl.userModel = model;
            [self.navigationController pushViewController:sendMessageCtl animated:YES];
        }
        [conversation clearUnreadCount];
        NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
        [self saveBadge:badge];
    }
}
#pragma mark - 极光消息相关 start

- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}
- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJMSGNetworkDidCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJMSGNetworkDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJMSGNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnecting)
                                                 name:kJMSGNetworkIsConnectingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dBMigrateFinish)
                                                 name:kDBMigrateFinishNotification object:nil];
    
    
}

- (void)netWorkConnectClose {
    _ybNavi.midTitleL.text = @"未连接";
}

- (void)netWorkConnectSetup {
    _ybNavi.midTitleL.text = @"收取中...";
}

- (void)connectSucceed {
    _ybNavi.midTitleL.text = YZMsg(@"消息");
}

- (void)isConnecting {
    _ybNavi.midTitleL.text = @"连接中...";
}

- (void)dBMigrateFinish {
    NSLog(@"Migrate is finish  and get allconversation");
    JCHATMAINTHREAD(^{
        //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    [self addDelegate];
    [self getConversationList];
}
#pragma mark - 获取回话列表
- (void)getConversationList {
    
    NSLog(@"get allConversation -- start");
    [_userArray removeAllObjects];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
//        JCHATMAINTHREAD(^{
            if (error == nil) {
                
                _conversationArr = [self sortConversation:resultObject];
                _unreadCount = 0;
                NSString *idStrs = [NSString string];
                for (NSInteger i=0; i < [_conversationArr count]; i++) {
                    JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
                    if (conversation.conversationType == kJMSGConversationTypeSingle) {
                        _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
                        NSString *name = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
                        name = [name stringByReplacingOccurrencesOfString:JmessageName withString:@""];
                        idStrs = [idStrs stringByAppendingFormat:@"%@,",name];
                    }
                }
                if (idStrs.length > 1) {
                    //去掉最后一个逗号
                    idStrs = [idStrs substringToIndex:[idStrs length] - 1];
                }
                [self getUserList:idStrs];
                
                [self saveBadge:_unreadCount];
            } else {
                [_conversationArr removeAllObjects];
                _conversationArr = nil;
            }
        [_tableView reloadData];
        
//        });
    }];
}

NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [conversationArr sortedArrayUsingDescriptors:sortDescriptors];
    
    for (JMSGConversation *im_con in sortedArray) {
        if (im_con.conversationType == kJMSGConversationTypeSingle) {
            NSString *name = [NSString stringWithFormat:@"%@",[im_con.target valueForKey:@"username"]];
            name = [name stringByReplacingOccurrencesOfString:JmessageName withString:@""];
            if ([name isEqual:@"dsp_admin_2"]) {
                conver_admin2 = im_con;
            }
            if ([name isEqual:@"dsp_admin_1"]) {
                conver_admin1 = im_con;
            }
        }
    }
    NSMutableArray *m_array = [NSMutableArray arrayWithArray:sortedArray];
    if (conver_admin2) {
        [m_array removeObject:conver_admin2];
        [m_array insertObject:conver_admin2 atIndex:0];
    }
    if (conver_admin1) {
        [m_array removeObject:conver_admin1];
        [m_array insertObject:conver_admin1 atIndex:0];
    }
    conver_admin2 = nil;
    conver_admin1 = nil;
    return m_array;
    
    //NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    //return [NSMutableArray arrayWithArray:sortResultArr];
}

#pragma mark JMSGMessageDelegate
- (void)onReceiveChatRoomConversation:(JMSGConversation *)conversation
                             messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages{
    NSLog(@"123123233121233121231231231223123");
}

- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    DDLogDebug(@"Action -- onReceivemessage %@",message.serverMessageId);
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    DDLogDebug(@"Action -- onConversationChanged");
    
    [self onSyncReloadConversationListWithConversation:conversation];
}
-(void)onUnreadChanged:(NSUInteger)newCount{
    [self getUnreadCound];
}
-(void)getUnreadCound {
    /*
     * 服务端拉取群组测试，由于客户端这边只有单聊，所以获取未读的时候处理下群组消息
     * 如有群组需求，此处要重新处理
     */
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error == nil) {
            for (JMSGConversation *g_con in resultObject) {
                if (g_con.conversationType == kJMSGConversationTypeGroup) {
                    [g_con clearUnreadCount];
                }
            }
            //获取未读
            int unread = [([JMSGConversation getAllUnreadCount]) intValue];
            UITabBarItem *item = [self.tabBarController.tabBar.items objectAtIndex:2];
            if (unread>0) {
                item.badgeValue = [NSString stringWithFormat:@"%d",unread];
            }else{
                item.badgeValue = nil;
            }
        }
    }];
}
//离线消息
- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    DDLogDebug(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
    [self onSyncReloadConversationListWithConversation:conversation];
}
//消息漫游
- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    DDLogDebug(@"Action -- onSyncRoamingMessageConversation:");
    
    [self onSyncReloadConversationListWithConversation:conversation];
}

- (void)onSyncReloadConversationListWithConversation:(JMSGConversation *)conversation {
    if (!conversation) {
        return ;
    }
    BOOL isHave = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *newUser = (JMSGUser *)conversation.target;
        for (int i = 0; i < _conversationArr.count; i++) {
            JMSGConversation *oldConversation = _conversationArr[i];
            if (oldConversation.conversationType == kJMSGConversationTypeSingle) {
                JMSGUser *oldUser = (JMSGUser *)oldConversation.target;
                if ([newUser.username isEqualToString:oldUser.username] && [newUser.appKey isEqualToString:oldUser.appKey]) {
                    [_conversationArr replaceObjectAtIndex:i withObject:conversation];
                    isHave = YES;
                    break ;
                }
            }
        }
    }
    if (!isHave) {
        [_conversationArr insertObject:conversation atIndex:0];
    }
    _conversationArr = [self sortConversation:_conversationArr];
    
//    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
    _unreadCount = 0;
    NSString *idStrs = [NSString string];
    for (NSInteger i=0; i < [_conversationArr count]; i++) {
        JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
        if (conversation.conversationType == kJMSGConversationTypeSingle) {
            _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
            NSString *name = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
            name = [name stringByReplacingOccurrencesOfString:JmessageName withString:@""];
            idStrs = [idStrs stringByAppendingFormat:@"%@,",name];
        }
    }
    if (idStrs.length > 1) {
        //去掉最后一个逗号
        idStrs = [idStrs substringToIndex:[idStrs length] - 1];
    }
    [self getUserList:idStrs];
    
    [self saveBadge:_unreadCount];

}
- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 极光消息相关 end

#pragma mark - set/get
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height - 64-statusbarHeight)style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.editing = NO;
        YBWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            weakSelf.paging = 1;
            [weakSelf getConversationList];
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            weakSelf.paging +=1;
            [weakSelf getConversationList];
        }];
        
    }
    return _tableView;
}

#pragma mark - 导航
-(void)creatNavi {
    _ybNavi = [[YBNavi alloc]init];
    _ybNavi.leftHidden = YES;
    _ybNavi.rightHidden = NO;
    _ybNavi.haveImgR = YES;
    [_ybNavi ybNaviLeft:^(id btnBack) {
    } andRightName:@"msg_linkman" andRight:^(id btnBack) {
        NSLog(@"选择联系人");
        [self selPeopleFun];
        
    } andMidTitle:YZMsg(@"消息")];
    [self.view addSubview:_ybNavi];
}
-(void)getview{
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationItem.leftBarButtonItem = nil;
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = RGB(256, 256, 256);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-50, statusbarHeight+24, 100, 40)];
    label.text = YZMsg(@"消息");
    label.textAlignment = NSTextAlignmentCenter;
    label.font = navtionTitleFont;
    [navtion addSubview:label];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightBTN = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBTN setTitle:YZMsg(@"忽略未读") forState:UIControlStateNormal];
    rightBTN.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBTN addTarget:self action:@selector(weidu:) forControlEvents:UIControlEventTouchUpInside];
    [rightBTN setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBTN.frame = CGRectMake(_window_width - 80,24 + statusbarHeight, 80, 40);
    rightBTN.titleLabel.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:rightBTN];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64+ statusbarHeight);
    [navtion addSubview:btnttttt];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];
    [self.view addSubview:navtion];
    
    
    nothingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _window_height*0.3, _window_width, 20)];
    nothingLabel.textColor = RGB_COLOR(@"#969696", 1);
    nothingLabel.font = [UIFont systemFontOfSize:13];
    nothingLabel.text = YZMsg(@"你还没有收到任何消息");
    nothingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nothingLabel];
    nothingLabel.hidden = YES;
}
//返回
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//忽略未读
-(void)weidu:(UIButton *)sender{
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    [[NSUserDefaults standardUserDefaults] setObject:minstr([systemDic valueForKey:@"addtime"]) forKey:@"notifacationOldTime"];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    int unreadCount = 0;
    for (JMSGConversation *Conversation in _conversationArr) {
        unreadCount += [Conversation.unreadCount intValue];
        [Conversation clearUnreadCount];
    }
    if (_unreadCount>0) {
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:YZMsg(@"已经忽略未读消息") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        [alerts show];
        [self getConversationList];
    }
    else{
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:YZMsg(@"暂无未读消息") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        [alerts show];
    }
}

@end
