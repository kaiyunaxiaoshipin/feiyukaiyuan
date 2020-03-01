#import "chatController.h"
#import "chatmessageModel.h"
#import "chatmessageCell.h"
#import "ZFModalTransitionAnimator.h"
#import "LivePlay.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
@interface chatController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIView *mview;
    int setvischat;
    UIButton *emjoyBtn;
    UIButton *send;
    UIView *zhezhao;
    int sendok;//判断发送消息可以
    CGFloat barH;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic, strong) ZFModalTransitionAnimator *animator;
@end
@implementation chatController
-(NSArray *)models{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        chatmessageModel *model = [chatmessageModel messageWithDic:dic];
        [model setMessageFrame:[array lastObject]];
        [array addObject:model];
    }
    _models = array;
    return _models;
    
}
//接收消息
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    if (message != nil) {
        NSString *fromName =  minstr(message.fromName);
        fromName = [fromName stringByReplacingOccurrencesOfString:JmessageName withString:@""];
        if ([fromName isEqual:_chatID]) {

            //NSDictionary *extras = message.content.extras;
            NSString *avatar;//= [extras valueForKey:@"avatar"];
            NSString *text =  [message.content valueForKey:@"text"];
            NSString *time =  [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",message.timestamp]];
            NSString *type = [NSString stringWithFormat:@"%d",message.isReceived];
            if ([type isEqual:@"1"] ) {
                avatar = self.avatar;
            }
            else{
                avatar = [Config getavatar];
            }
            NSDictionary *subdic = @{@"avatar":avatar,@"text":text,@"time":time,@"type":type};
            [self.allArray addObject:subdic];
            [self.tableView reloadData];
            [self jumpLast];
        }
    }
}
-(void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    
    if (message != nil) {
        NSLog(@"发送的 Message:  %@",message);
        //NSDictionary *extras = message.content.extras;
        NSString *avatar ;//= [extras valueForKey:@"avatar"];
        NSString *text =  [message.content valueForKey:@"text"];
        NSString *time =  [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",message.timestamp]];
        NSString *type = [NSString stringWithFormat:@"%d",message.isReceived];
        if ([type isEqual:@"1"] ) {
            avatar = self.avatar;
        }
        else{
            avatar = [Config getavatar];
        }
        NSDictionary *subdic = @{@"avatar":avatar,@"text":text,@"time":time,@"type":type};
        [self.allArray addObject:subdic];
        [self.tableView reloadData];
        [self jumpLast];
    }
    if (error != nil) {
        NSLog(@"Send response error - %@", error);
  
        return;
    }
}
//发送消息
-(void)pushMessage{
    if ([_fromWhere isEqualToString:@"user"]) {
        [MBProgressHUD showError:YZMsg(@"对方还未注册私信，无法发送")];
        return;
    }
     NSString *userBaseUrl = [NSString stringWithFormat:@"User.checkBlack&uid=%@&touid=%@",[Config getOwnID],self.chatID];
    
    [YBToolClass postNetworkWithUrl:userBaseUrl andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infos = [info firstObject];
            NSString *t2u = [NSString stringWithFormat:@"%@",[infos valueForKey:@"t2u"]];//对方是否拉黑我
            if ([t2u isEqual:@"0"]) {
                sendok = 0;
                NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
                NSString *trimedString = [_textField.text stringByTrimmingCharactersInSet:set];
                if ([trimedString length] == 0) {
                    return;
                }
                _textField.text = [_textField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
                JMSGMessage *message = nil;
                
                JMSGOptionalContent *option = [[JMSGOptionalContent alloc]init];
                option.noSaveNotification = YES;
                JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:_textField.text];
                //添加附加字段
                //  [textContent addStringExtra:[Config getavatar] forKey:@"avatar"];
                message = [self.msgConversation createMessageWithContent:textContent];
                [self.msgConversation sendMessage:message optionalContent:option];
                
                _textField.text = nil;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    send.userInteractionEnabled = YES;
                    sendok = 1;
                });
            }
            else{
                [MBProgressHUD showError:YZMsg(@"对方暂时拒绝接收您的消息")];
            }

        }
    } fail:^{
        
    }];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self navtion];
    [self.msgConversation clearUnreadCount];
}
- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   [self.msgConversation clearUnreadCount];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width,64 + statusbarHeight)];
    navtion.backgroundColor = RGB(256, 256, 256);
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *labell = [[UILabel alloc]initWithFrame:CGRectMake(0, + statusbarHeight, _window_width,84)];
    labell.backgroundColor = [UIColor clearColor];
    labell.textColor = navtionTitleColor;
    labell.text = self.chatname;
    labell.font = navtionTitleFont;
    labell.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:labell];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    [self.view addSubview:navtion];
}
//返回
-(void)doReturn{
    [self.msgConversation clearUnreadCount];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gengxinweidu" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.allArray = [NSMutableArray array];
    barH = 40;
    if ([[self iphoneType] isEqualToString:@"iPhone X"]) {
        barH = 60;
        NSLog(@"iPhone X");
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    sendok = 1;

   
    //创建会话
    self.navigationController.navigationBarHidden = YES;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-100-statusbarHeight) style:UITableViewStyleGrouped];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
    [self.tableView addGestureRecognizer:tapGesture];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentOffset = CGPointMake(0, _window_height);
    //去掉分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //禁止选中
    _tableView.allowsSelection = NO;
    mview = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height-barH,_window_width,44)];
    mview.backgroundColor = [UIColor clearColor];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10,5,mview.frame.size.width * 0.8-10, 30)];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.returnKeyType = UIReturnKeySend;

    send = [UIButton buttonWithType:UIButtonTypeSystem];
    [send setTitle:YZMsg(@"发送") forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    send.backgroundColor = normalColors;
    send.layer.masksToBounds = YES;
    send.layer.cornerRadius = 5;
    send.frame = CGRectMake(_window_width*0.8 +10,5,_window_width*0.2 - 20 ,30);
    [send addTarget:self action:@selector(pushMessage) forControlEvents:UIControlEventTouchUpInside];
    [mview addSubview:send];
    mview.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [mview addSubview:_textField];
    [self.view addSubview:self.tableView];
    [self.view addSubview:mview];
    self.view.backgroundColor = self.tableView.backgroundColor;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //获取消息记录
    [self.msgConversation allMessages:^(id resultObject, NSError *error) {
        
        self.allArray  = [resultObject mutableCopy];
        self.allArray=(NSMutableArray *)[[ self.allArray reverseObjectEnumerator] allObjects];
        //最多显示100条
        if (self.allArray.count > 100) {
           [self.allArray removeObjectsInRange:NSMakeRange(0,self.allArray.count - 100)];
        }
        NSMutableArray *array = [NSMutableArray array];
        //JMSGMessage 转成dic， 不然有性能问题
        for (int i=0; i<self.allArray.count; i++) {
            JMSGMessage *message = self.allArray[i];
            NSString *avatar = [NSString string];// = [extras valueForKey:@"avatar"];
            NSString *text =  [message.content valueForKey:@"text"];
            NSString *time =  [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%@",message.timestamp]];
            NSString *type = [NSString stringWithFormat:@"%d",message.isReceived];
            if ([type isEqual:@"1"] ) {
                 avatar = self.avatar;
            }
            else{
                avatar = [Config getavatar];
            }
            NSDictionary *subdic = @{@"avatar":avatar,@"text":text,@"time":time,@"type":type};
            [array addObject:subdic];
        }
        [self.allArray removeAllObjects];
        self.allArray = nil;
        self.allArray = [NSMutableArray array];
        self.allArray = [array mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
             [self jumpLast];
        });
    }];
}
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self pushMessage];
    return YES;
}
-(void)jumpLast
{
    NSUInteger sectionCount = [self.tableView numberOfSections];
    if (sectionCount) {
        NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
        if (rowCount) {
            NSUInteger ii[2] = {0, rowCount - 1};
            NSIndexPath* indexPath = [NSIndexPath indexPathWithIndexes:ii length:2];
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    chatmessageCell *cell = [chatmessageCell cellWithTableView:tableView];
    cell.model = self.models[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatmessageModel *model = self.models[indexPath.row];
    return model.rowH;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    int newHeight = _window_height - height;
    //遮罩
    zhezhao = [[UIView alloc] initWithFrame: CGRectMake(0,64, _window_width,_window_height - height)];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo)];
    [zhezhao setBackgroundColor:[UIColor clearColor]];
    [zhezhao addGestureRecognizer:tapGesture];
    [UIView animateWithDuration:0.3 animations:^{
        mview.frame = CGRectMake(0, height - barH, _window_width,44);
        self.tableView.frame = CGRectMake(0,64, _window_width,_window_height-newHeight-64);
        [self jumpLast];
    }];
}
-(void)Actiondo
{
    [zhezhao removeFromSuperview];
    [_textField resignFirstResponder];
    [self keyboardWillHide:nil];
}
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.1 animations:^{
        mview.frame = CGRectMake(0, _window_height-barH, _window_width, 44);
        self.tableView.frame = CGRectMake(0,64, _window_width, _window_height-100);
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self Actiondo];
}
@end
