#import "messageC.h"
#import "chatController.h"
#import "messageModel.h"
#import "messageCellcell.h"
#import "ZFModalTransitionAnimator.h"
@interface messageC ()<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSString *lastMessage;//获取最后一条消息
    UILabel *label1;//获取会话所有的未读消息数 关注
    NSString *idStrings;//获取用户列表所有人的id
    UILabel *nothingLabel;
}
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
//@property(nonatomic,strong)NSArray *models;
//@property(nonatomic,strong)NSMutableArray *UNfollowArray;//未关注好友
//@property(nonatomic,strong)NSMutableArray *followArray;//关注好友
@property(nonatomic,strong)NSMutableArray *JIMallArray;//所有
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *allArray;//

@end
@implementation messageC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self forMessage];
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
            self.JIMallArray = [NSMutableArray array];
            self.allArray = [NSMutableArray array];
            self.JIMallArray = [self sortConversation:resultObject];
            [self.tableView reloadData];
            idStrings = nil;
            idStrings = [NSString string];
            for (int i=0; i < [self.JIMallArray count]; i++) {
                JMSGConversation *conversation = [resultObject objectAtIndex:i];
                NSString *name = [NSString stringWithFormat:@"%@",[conversation.target valueForKey:@"username"]];
                name = [name stringByReplacingOccurrencesOfString:JmessageName withString:@""];
                idStrings = [idStrings stringByAppendingFormat:@"%@,",name];
             }
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
            self.allArray = [NSMutableArray array];
            [self.tableView reloadData];
        }
    }];
}
-(void)getUserList:(NSString *)touid{
    NSString *url = [NSString stringWithFormat:@"User.getUidsInfo&uid=%@&uids=%@",[Config getOwnID],touid];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSArray *infos = info;
            for (int i=0; i<infos.count; i++) {
                NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:infos[i]];
//                NSString *utot = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"utot"]];
//                if ([utot isEqual:@"1"]) {
//                    [self.followArray addObject:subdic];
//                }else{
//                    [self.UNfollowArray addObject:subdic];
//                }
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

        }
        [self.tableView reloadData];

    } fail:^{
        
    }];
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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+ statusbarHeight, _window_width, _window_height-64 - statusbarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor  = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    nothingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _window_height*0.3, _window_width, 20)];
    nothingLabel.textColor = RGB_COLOR(@"#969696", 1);
    nothingLabel.font = [UIFont systemFontOfSize:13];
    nothingLabel.text = YZMsg(@"你还没有收到任何消息");
    nothingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nothingLabel];
    nothingLabel.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    idStrings = [NSString string];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor =  [UIColor groupTableViewBackgroundColor];
    self.allArray = [NSMutableArray array];
    [self getview];//初始化界面
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return self.allArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    messageCellcell *cell = [messageCellcell cellWithTableView:tableView];
    NSDictionary *subdic = self.allArray[indexPath.row];
    messageModel *model = [[messageModel alloc]initWithDic:subdic];
    cell.model = model;
    return cell;
}
-(void)edit{    
    self.tableView.editing = YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    chatController *chat = [[chatController alloc]init];
    NSDictionary *subdic = self.allArray[indexPath.row];
    messageModel *model = [[messageModel alloc]initWithDic:subdic];

    [JMSGConversation createSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uid] completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            chat.msgConversation = resultObject;
            chat.chatID = model.uid;
            chat.avatar = model.imageIcon;
            chat.chatname = model.userName;
            [chat.msgConversation clearUnreadCount];
            [[MXBADelegate sharedAppDelegate] pushViewController:chat animated:YES];
        }else{
           [MBProgressHUD showError:error.localizedDescription];
        }
    }];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    messageModel *model = [[messageModel alloc] initWithDic:self.allArray[indexPath.row]];
    [JMSGConversation deleteSingleConversationWithUsername:[NSString stringWithFormat:@"%@%@",JmessageName,model.uid]];
    [self forMessage];
}

@end
