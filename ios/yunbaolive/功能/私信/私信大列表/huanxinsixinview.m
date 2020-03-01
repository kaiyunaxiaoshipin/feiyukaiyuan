#import "huanxinsixinview.h"
#import "MessageListModel.h"
#import "MessageListCell.h"
#import "ZFModalTransitionAnimator.h"
@implementation huanxinsixinview{
    UILabel *nothingLabel;
    NSDictionary *systemDic;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        idStrings=  [NSString string];
        _allArray = [NSMutableArray array];
        _JIMallArray = [NSMutableArray array];
        [self setview];
//        [self forMessage];
        [self requestSystemMsg];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bbbb:) name:@"system_notificationUpdate" object:nil];

        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
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

-(void)reloadMessageIM{
    [self forMessage];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"formessage" object:nil];
}
-(void)setview{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadMessageIM) name:@"reloadMessageIM" object:nil];
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width,40)];
    navtion.backgroundColor = RGB_COLOR(@"#f9fafb", 1);
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-50, 0, 100, 40)];
    label.text = YZMsg(@"消息");
    label.textColor = RGB_COLOR(@"#636465", 1);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = navtionTitleFont;
    [navtion addSubview:label];
    
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
//    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
    UIButton *hulueBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    hulueBTN.frame = CGRectMake(_window_width - 60, 0, 50, 40);
    hulueBTN.backgroundColor = [UIColor clearColor];
    [hulueBTN setTitle:YZMsg(@"忽略未读") forState:UIControlStateNormal];
    [hulueBTN setTitleColor:RGB_COLOR(@"#bfc0c1", 1) forState:UIControlStateNormal];
    hulueBTN.titleLabel.font = [UIFont systemFontOfSize:12];
    [hulueBTN addTarget:self action:@selector(weidu:) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:hulueBTN];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _window_width/2, 40)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
//    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,0,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"sixin_back"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
//    [navtion addSubview:returnBtn];
  
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, _window_width,_window_height*0.4 - 40) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    nothingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    nothingLabel.center = self.tableView.center;
    nothingLabel.textColor = RGB_COLOR(@"#969696", 1);
    nothingLabel.font = [UIFont systemFontOfSize:13];
    nothingLabel.text = YZMsg(@"你还没有收到任何消息");
    nothingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nothingLabel];
    nothingLabel.hidden = YES;

}
-(void)doReturn{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gengxinweidu" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toolbarHidden" object:nil];
    [UIView animateWithDuration:1.0 animations:^{
        self.view.frame = CGRectMake(0, _window_height*3, _window_width, _window_height*0.4);
    }];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    [self forMessage];
}
-(void)onConversationChanged:(JMSGConversation *)conversation{
    [self forMessage];
}
#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"latestMessage.timestamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [conversationArr sortedArrayUsingDescriptors:sortDescriptors];
    return [NSMutableArray arrayWithArray:sortedArray];
}
-(void)forMessage{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (error == nil) {
            self.JIMallArray = nil;
            self.JIMallArray = [NSMutableArray array];
            self.allArray = nil;
            self.allArray = [NSMutableArray array];
            self.JIMallArray = [self sortConversation:resultObject];
            [self.tableView reloadData];
            idStrings = nil;
            idStrings = [NSString string];
            idStrings = [NSString stringWithFormat:@"%@,",_zhuboID];
            for (int i=0; i < [self.JIMallArray count]; i++) {
                JMSGConversation *conversation = [resultObject objectAtIndex:i];
                NSString *name = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
                name = [name stringByReplacingOccurrencesOfString:JmessageName withString:@""];
                if (![name isEqual:_zhuboID]) {
                    idStrings = [idStrings stringByAppendingFormat:@"%@,",name];
                }
            }
            //获取列表所有人的id
            if (idStrings.length > 1) {
                //获取列表所有人的id
                idStrings = [idStrings substringToIndex:[idStrings length] - 1];
                [self getUserList:idStrings];
                nothingLabel.hidden = YES;
            }else{
                nothingLabel.hidden = NO;
            }
        }
        else{
            self.allArray = nil;
            [self.tableView reloadData];
        }
    }];
}
-(void)getUserList:(NSString *)touid{
    [self.allArray removeAllObjects];;
    NSString *url = [NSString stringWithFormat:@"User.getUidsInfo&uid=%@&uids=%@",[Config getOwnID],touid];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSArray *infos = info;
            for (int i=0; i<infos.count; i++) {
                NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:infos[i]];
                NSString *utot = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"utot"]];
                [self.allArray addObject:subdic];
                for (JMSGConversation *conversation in self.JIMallArray) {
                    NSString *conversationid = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
                    conversationid = [conversationid stringByReplacingOccurrencesOfString:JmessageName withString:@""];
                    NSString *touid = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"id"]];

                    if ([conversationid isEqual:touid]) {
                        [subdic setObject:conversation forKey:@"conversation"];
                    }
                    
                }
            }
            
            [self.tableView reloadData];

        }
    } fail:^{
        
    }];
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
    for (JMSGConversation *Conversation in self.JIMallArray) {
        unreadCount += [Conversation.unreadCount intValue];
        [Conversation clearUnreadCount];
    }
    if (unreadCount>0) {
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:YZMsg(@"已经忽略未读消息") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        [alerts show];
        [self forMessage];
    }
    else{
        UIAlertView *alerts = [[UIAlertView alloc]initWithTitle:YZMsg(@"暂无未读消息") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        [alerts show];
    }
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [MBProgressHUD showError:YZMsg(@"系统消息无法删除")];
        return;
    }
    MessageListModel *model = [[MessageListModel alloc] initWithDic:self.allArray[indexPath.row]];
    [JMSGConversation deleteSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uidStr]];
    [self forMessage];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.allArray.count;
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
        MessageListModel *model = [[MessageListModel alloc] initWithDic:self.allArray[indexPath.row]];
        cell.model = model;
        if ([model.uidStr isEqual:_zhuboID]) {
            cell.timeL.hidden = YES;
            cell.redPoint.hidden = YES;
            cell.siliaoL.hidden = NO;
            if (cell.detailL.text.length == 0) {
                cell.detailL.text = YZMsg(@"Hi～我是主播，快来和我聊天吧");
            }else{
                cell.detailL.text = model.contentStr;
                cell.timeL.hidden = NO;
                cell.siliaoL.hidden = YES;
                int num = [model.unReadStr intValue];
                if (num > 0) {
                    cell.redPoint.hidden = NO;
                }else{
                    cell.redPoint.hidden = YES;
                }
            }
        }else{
            cell.timeL.hidden = NO;
            cell.siliaoL.hidden = YES;
            int num = [model.unReadStr intValue];
            if (num > 0) {
                cell.redPoint.hidden = NO;
            }else{
                cell.redPoint.hidden = YES;
            }
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"1",@"1",@"1",@"1"] forKeys:@[@"name",@"id",@"conversation",@"avatar"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sixinok" object:nil userInfo:dic];

        return;
    }
    MessageListModel *model = [[MessageListModel alloc] initWithDic:self.allArray[indexPath.row]];
    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uidStr] completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%@",model.unameStr],[NSString stringWithFormat:@"%@",model.uidStr],resultObject,model.iconStr,model.isAtt] forKeys:@[@"name",@"id",@"conversation",@"avatar",@"utot"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sixinok" object:nil userInfo:dic];
        }else{
            [MBProgressHUD showError:error.localizedDescription];
        }
    }];
}
@end
