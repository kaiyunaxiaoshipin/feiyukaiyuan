//
//  JCHATSendMessageViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "JCHATFileManager.h"
#import "JCHATShowTimeCell.h"

#import "AppDelegate.h"
#import "UIImage+ResizeMagick.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <JMessage/JMSGConversation.h>
#import "JCHATStringUtils.h"

#import <UIKit/UIPrintInfo.h>
#import "JCHATLoadMessageTableViewCell.h"
#import "JCHATSendMsgManager.h"

#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/Photos.h>

#import "TencentLocationVC.h"

#import "twEmojiView.h"
#import "ASRView.h"
#import "webH5.h"
#import "otherUserMsgVC.h"
@interface JCHATConversationViewController ()<twEmojiViewDelegate,TouchMsgTabDelegate> {
  
@private
    BOOL isNoOtherMessage;
    NSInteger messageOffset;
    NSMutableArray *_imgDataArr;
//    JMSGConversation *_conversation;
    NSMutableDictionary *_allMessageDic;    //缓存所有的message model
    NSMutableArray *_allmessageIdArr;       //按序缓存后有的messageId， 于allMessage 一起使用
    NSMutableArray *_userArr;
    UIButton *_rightBtn;
    NSMutableDictionary *_refreshAvatarUsersDic;
    
     YBNavi *_ybNavi;
    twEmojiView *_emojiV;
    ASRView *_asrView;
    BOOL _asrMoveUp;
    UIView *followView;
}

@end

@implementation JCHATConversationViewController


- (void)viewWillAppear:(BOOL)animated {
    DDLogDebug(@"Event - viewWillAppear");
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    
    kWEAKSELF
    [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        DDLogDebug(@"refresh nav right button");
        kSTRONGSELF
//        [strongSelf.navigationController setNavigationBarHidden:NO];
        // 禁用 iOS7 返回手势
        if ([strongSelf.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            strongSelf.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
        if (strongSelf.conversation.conversationType == kJMSGConversationTypeGroup) {
//            [strongSelf updateGroupConversationTittle:nil];
        } else {
            strongSelf.title = [resultObject title];
        }
        [_messageTableView reloadData];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    DDLogDebug(@"Event - viewWillDisappear");
    [super viewWillDisappear:animated];
    
//    [IQKeyboardManager sharedManager].enable = YES;
    
    [_conversation clearUnreadCount];
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _asrMoveUp = NO;
    _refreshAvatarUsersDic = [NSMutableDictionary dictionary];
    _allMessageDic = [NSMutableDictionary dictionary];
    _allmessageIdArr = [NSMutableArray array];
    _imgDataArr = [NSMutableArray array];
    DDLogDebug(@"Action - viewDidLoad");
    
    [self creatNavi];
    self.messageTabTop.constant = 64+statusbarHeight;
    self.messageTableView.touchDelegate = self;
    if (@available(iOS 11.0,*)) {
        self.messageTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _ybNavi.midTitleL.text = _userModel.unameStr;

    [self setupView];
    [self addNotification];
    [self addDelegate];
    [self getGroupMemberListWithGetMessageFlag:YES];
    
    if (![_userModel.isAtt isEqual:@"1"]) {
        [self creatFollowView];
    }
}
- (void)creatFollowView{
    followView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 40)];
    followView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:followView];
    UIButton *fCloseBtn = [UIButton buttonWithType:0];
    fCloseBtn.frame = CGRectMake(5, 5, 30, 30);
    [fCloseBtn setImage:[UIImage imageNamed:@"提示关闭"] forState:0];
    fCloseBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [fCloseBtn addTarget:self action:@selector(removeFollowView) forControlEvents:UIControlEventTouchUpInside];
    [followView addSubview:fCloseBtn];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(fCloseBtn.right, 0, _window_width/2, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.text = YZMsg(@"点击关注，可及时看到对方动态");
    label.textColor = RGB_COLOR(@"#959697", 1);
    [followView addSubview:label];
    UIButton *followBtn = [UIButton buttonWithType:0];
    followBtn.frame = CGRectMake(_window_width-54, 10, 44, 20);
    [followBtn setImage:[UIImage imageNamed:@"fans_关注"] forState:0];
    [followBtn addTarget:self action:@selector(doFollow) forControlEvents:UIControlEventTouchUpInside];
    [followView addSubview:followBtn];
}
- (void)removeFollowView{
    [followView removeFromSuperview];
    followView = nil;
}
- (void)doFollow{
    NSString *postUrl = @"User.setAttent";
    NSDictionary *postDic = @{
                              @"touid":_userModel.uidStr
                              };
    [YBToolClass postNetworkWithUrl:postUrl andParameter:postDic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [MBProgressHUD showError:YZMsg(@"关注对方成功")];
            if (self.block) {
                self.block(1);
            }
            [self removeFollowView];
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
  JMSGGroup *group;
  if (newGroup == nil) {
    group = self.conversation.target;
  } else {
    group = newGroup;
  }
  
  if ([group.name isEqualToString:@""]) {
    self.title = @"群聊";
  } else {
    self.title = group.name;
  }
  self.title = [NSString stringWithFormat:@"%@(%lu)",self.title,(unsigned long)[group.memberArray count]];
  [self getGroupMemberListWithGetMessageFlag:NO];
  if (self.isConversationChange) {
    [self cleanMessageCache];
    [self getPageMessage];
    self.isConversationChange = NO;
  }
}

- (void)viewDidLayoutSubviews {
  DDLogDebug(@"Event - viewDidLayoutSubviews");
  [self scrollToBottomAnimated:NO];
}


#pragma mark --释放内存
- (void)dealloc {
    DDLogDebug(@"Action -- dealloc");
    //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
    //remove delegate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [JMessage removeDelegate:self withConversation:_conversation];
}

- (void)addtoolbar {
  self.toolBarContainer.toolbar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
  [self.toolBarContainer addSubview:self.toolBarContainer.toolbar];
}
#pragma mark - 子控件
- (void)setupView {
    
    [_conversation clearUnreadCount];
    
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapClick:)];
    //[self.view addGestureRecognizer:gesture];
  [self.view setBackgroundColor:RGB_COLOR(@"#201c36", 1)];
    _toolBarToBottomConstrait.constant = 0+ShowDiff;
  _toolBarContainer.toolbar.delegate = self;
  [_toolBarContainer.toolbar setUserInteractionEnabled:YES];
  self.toolBarContainer.toolbar.textView.text = [[JCHATSendMsgManager ins] draftStringWithConversation:_conversation];
  _messageTableView.userInteractionEnabled = YES;
  _messageTableView.showsVerticalScrollIndicator = NO;
  _messageTableView.delegate = self;
  _messageTableView.dataSource = self;
  _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageTableView.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
  
  _moreViewContainer.moreView.delegate = self;
  _moreViewContainer.moreView.backgroundColor = Black_Cor;
    
    //表情
    _emojiV = [[twEmojiView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff)];
    _emojiV.delegate = self;
    [self.view addSubview:_emojiV];
}



- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
  if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
    JMSGGroup *group = nil;
    group = self.conversation.target;
    _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
    [self isContantMeWithUserArr:_userArr];
    if (getMesageFlag) {
      [self getPageMessage];
    }
  } else {
    if (getMesageFlag) {
      [self getPageMessage];
    }
    [self hidenDetailBtn:NO];
  }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
  BOOL hideFlag = YES;
  for (NSInteger i =0; i< [userArr count]; i++) {
    JMSGUser *user = [userArr objectAtIndex:i];
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      hideFlag = NO;
      break;
    }
  }
    if (!hideFlag) {
        [self reloadAllCellAvatarImage];
    }
  [self hidenDetailBtn:hideFlag];
}

- (void)hidenDetailBtn:(BOOL)flag {
    [_rightBtn setHidden:flag];
}

- (void)setTitleWithUser:(JMSGUser *)user {
  self.title = _conversation.title;
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
  DDLogDebug(@"Event - sendMessageResponse");
    
  if (message != nil) {
    NSLog(@"发送的 Message:  %@",message);
  }
    [self relayoutTableCellWithMessage:message];
  
  if (error != nil) {
    DDLogDebug(@"Send response error - %@", error);
    [_conversation clearUnreadCount];
    NSString *alert = [JCHATStringUtils errorAlert:error];
    if (alert == nil) {
      alert = [error description];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //[MBProgressHUD showMessage:alert view:self.view];
      [MBProgressHUD showMessage:alert toView:self.view];
    return;
  }
    
  JCHATChatModel *model = _allMessageDic[message.msgId];
  if (!model) {
    return;
  }
}

#pragma mark --收到消息
- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    
    if (message != nil) {
    }
    if (error != nil) {
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setErrorMessageChatModelWithError:error];
        [self addMessage:model];
        return;
    }

    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }

    if (message.contentType == kJMSGContentTypeCustom) {
        return;
    }
    DDLogDebug(@"Event - receiveMessageNotification");
    
    kWEAKSELF
    JCHATMAINTHREAD((^{
        kSTRONGSELF
        if (!message) {
          DDLogWarn(@"get the nil message .");
          return;
        }

//        if (_allMessageDic[message.msgId] != nil) {
//          DDLogDebug(@"该条消息已加载");
//          return;
//        }

        if (message.contentType == kJMSGContentTypeEventNotification) {
          if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
              && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
//            [strongSelf setupNavigation];
          }
        }

        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
        }
        
        JCHATChatModel *model = [_allMessageDic objectForKey:message.msgId];
        if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
            model.message = message;
            [strongSelf refreshCellMessageMediaWithChatModel:model];
        }else{
            
            NSString *firstMsgId = [_allmessageIdArr firstObject];
            JCHATChatModel *firstModel = [_allMessageDic objectForKey:firstMsgId];
            if (message.timestamp < firstModel.message.timestamp) {
                // 比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载
                return ;
            }
            
            model = [[JCHATChatModel alloc] init];
            [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
            if (message.contentType == kJMSGContentTypeImage) {
                [_imgDataArr addObject:model];
            }
            model.photoIndex = [_imgDataArr count] -1;
            [strongSelf addmessageShowTimeData:message.timestamp];
            [strongSelf addMessage:model];
            
            BOOL isHaveCache = NO;
            NSString *key = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
            NSMutableArray *messages = _refreshAvatarUsersDic[key];
            if (messages) {
                isHaveCache = YES;
                [messages addObject:message];
            }else{
                messages = [NSMutableArray array];
                [messages addObject:message];
            }
            if (messages.count > 10) {
                [messages removeObjectAtIndex:0];
            }
            [_refreshAvatarUsersDic setObject:messages forKey:key];
            
            [strongSelf chcekReceiveMessageAvatarWithReceiveNewMessage:message];
//            if (!isHaveCache) {
//                [strongSelf performSelector:@selector(chcekReceiveMessageAvatarWithReceiveNewMessage:) withObject:message afterDelay:1.5];
//            }
        }
  }));
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
  if (![self.conversation isMessageForThisConversation:message]) {
    return;
  }
  
  DDLogDebug(@"Event - receiveMessageNotification");
  JCHATMAINTHREAD((^{
      if (!message) {
          DDLogWarn(@"get the nil message .");
          return;
      }
      
      if (_conversation.conversationType == kJMSGConversationTypeSingle) {
      } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
          return;
      }
    
      JCHATChatModel *model = [_allMessageDic objectForKey:message.msgId];
      if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
          model.message = message;
          [self refreshCellMessageMediaWithChatModel:model];
      }else{
          model = [[JCHATChatModel alloc] init];
          [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
          if (message.contentType == kJMSGContentTypeImage) {
              [_imgDataArr addObject:model];
          }
          model.photoIndex = [_imgDataArr count] -1;
          [self addmessageShowTimeData:message.timestamp];
          [self addMessage:model];
      }
    
  }));
}
//同步离线消息
- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
                         offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages {
    DDLogDebug(@"Action -- onSyncOfflineMessageConversation:offlineMessages:");
    
    if (conversation.conversationType != self.conversation.conversationType) {
        return ;
    }
    BOOL isThisConversation = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user1 = (JMSGUser *)conversation.target;
        JMSGUser *user2 = (JMSGUser *)self.conversation.target;
        if ([user1.username isEqualToString:user2.username] &&
            [user1.appKey isEqualToString:user2.appKey]) {
            isThisConversation = YES;
        }
    }else{
        JMSGGroup *group1 = (JMSGGroup *)conversation.target;
        JMSGGroup *group2 = (JMSGGroup *)conversation.target;
        if ([group1.gid isEqualToString:group2.gid]) {
            isThisConversation = YES;
        }
    }
    
    if (!isThisConversation) {
        return ;
    }
    
    NSMutableArray *pathsArray = [NSMutableArray array];
    NSMutableArray *allSyncMessages = [NSMutableArray arrayWithArray:offlineMessages];
    for (int i = 0; i< allSyncMessages.count; i++) {
        JMSGMessage *message = allSyncMessages[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr addObject:model.message.msgId];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
        [pathsArray addObject:path];
    }
    if (pathsArray.count) {
        [_messageTableView beginUpdates];
        [_messageTableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationNone];
        [_messageTableView endUpdates];
        [self scrollToEnd];
    }
}
//同步漫游消息
- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation {
    DDLogDebug(@"Action -- onSyncRoamingMessageConversation:");
    
    if (conversation.conversationType != self.conversation.conversationType) {
        return ;
    }
    BOOL isThisConversation = NO;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user1 = (JMSGUser *)conversation.target;
        JMSGUser *user2 = (JMSGUser *)self.conversation.target;
        if ([user1.username isEqualToString:user2.username] &&
            [user1.appKey isEqualToString:user2.appKey]) {
            isThisConversation = YES;
        }
    }
    if (!isThisConversation) {
        return ;
    }
    isNoOtherMessage = NO;
    messageOffset = 0;
    [_imgDataArr removeAllObjects];
    [_userArr removeAllObjects];
    
    [_allMessageDic removeAllObjects];
    [_allmessageIdArr removeAllObjects];
    [_imgDataArr removeAllObjects];
    
    [self getGroupMemberListWithGetMessageFlag:YES];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
//  [self updateGroupConversationTittle:group];
}

- (void)relayoutTableCellWithMessage:(JMSGMessage *) message{
    DDLogDebug(@"relayoutTableCellWithMessage: msgid:%@",message.msgId);
    if ([message.msgId isEqualToString:@""]) {
        return;
    }
    
    JCHATChatModel *model = _allMessageDic[message.msgId];
    if (model) {
        model.message = message;
        [_allMessageDic setObject:model forKey:message.msgId];
    }
    
    NSInteger index = [_allmessageIdArr indexOfObject:message.msgId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JCHATMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
    tableviewcell.model = model;
    [tableviewcell layoutAllView];
    
//    [_messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark --获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
  for (NSInteger i=0; i< [_allmessageIdArr count]; i++) {
    NSString *getMessageID = _allmessageIdArr[i];
    if ([getMessageID isEqualToString:messageID]) {
      return i;
    }
  }
  return 0;
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  DDLogDebug(@"deviceType = %@", deviceType);
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
  [_allMessageDic removeAllObjects];
  [_allmessageIdArr removeAllObjects];
  [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allmessageIdArr addObject:model.timeId];
    [self addCellToTabel];
    return;
  }
  [_allMessageDic setObject:model forKey:model.message.msgId];
  [_allmessageIdArr addObject:model.message.msgId];
  [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
  JMSGMessage *message1 = (JMSGMessage *)object1;
  JMSGMessage *message2 = (JMSGMessage *)object2;
  if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
    return NSOrderedDescending;
  } else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
    return NSOrderedAscending;
  }
  return NSOrderedSame;
}

- (void)AlertToSendImage:(NSNotification *)notification {
  UIImage *img = notification.object;
  [self prepareImageMessage:img];
}

- (void)deleteMessage:(NSNotification *)notification {
  JMSGMessage *message = notification.object;
  [_conversation deleteMessageWithMessageId:message.msgId];
  [_allMessageDic removeObjectForKey:message.msgId];
  [_allmessageIdArr removeObject:message.msgId];
  [_messageTableView loadMoreMessage];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
  NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
  return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)getPageMessage {
  DDLogDebug(@"Action - getAllMessage");
  [self cleanMessageCache];
  NSMutableArray * arrList = [[NSMutableArray alloc] init];
  [_allmessageIdArr addObject:[[NSObject alloc] init]];
  
  messageOffset = messagefristPageNumber;
  [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
  if ([arrList count] < messagefristPageNumber) {
    isNoOtherMessage = YES;
    [_allmessageIdArr removeObjectAtIndex:0];
  }
  
  for (NSInteger i=0; i< [arrList count]; i++) {
    JMSGMessage *message = [arrList objectAtIndex:i];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
    if (message.contentType == kJMSGContentTypeImage) {
      [_imgDataArr addObject:model];
      model.photoIndex = [_imgDataArr count] - 1;
    }
    
    [self dataMessageShowTime:message.timestamp];
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
  }
  [_messageTableView reloadData];
  [self scrollToBottomAnimated:NO];
}

- (void)flashToLoadMessage {
    NSMutableArray * arrList = @[].mutableCopy;
    NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(messagePageNumber)];
    [arrList addObjectsFromArray:newMessageArr];
    if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
        isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
    }
    
    messageOffset += messagePageNumber;
    for (NSInteger i = 0; i < [arrList count]; i++) {
        JMSGMessage *message = arrList[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
        
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr insertObject:model atIndex:0];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr insertObject:model.message.msgId atIndex: isNoOtherMessage?0:1];
        [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
    }
    
    [_messageTableView loadMoreMessage];
}

- (JMSGUser *)getAvatarWithTargetId:(NSString *)targetId {
    
  for (NSInteger i=0; i<[_userArr count]; i++) {
    JMSGUser *user = [_userArr objectAtIndex:i];
    if ([user.username isEqualToString:targetId]) {
      return user;
    }
  }
  return nil;
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
  if (!_voiceRecordHelper) {
    WEAKSELF
    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
      DDLogDebug(@"已经达到最大限制时间了，进入下一步的提示");
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf finishRecorded];
    };
    
    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
    };
    
    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
  }
  return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
  if (!_voiceRecordHUD) {
    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
  }
  return _voiceRecordHUD;
}

- (void)backClick {
  if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  _toolBarHeightConstrait.constant = 45;
  [self dropToolBar];
}

- (void)switchToTextInputMode {
  UITextView *inputview = self.toolBarContainer.toolbar.textView;
  [inputview becomeFirstResponder];
  [self layoutAndAnimateMessageInputTextView:inputview];
}

#pragma mark -调用相册
- (void)photoClick {
    
  ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
  [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    JCHATPhotoPickerViewController *photoPickerVC = [[JCHATPhotoPickerViewController alloc] init];
    photoPickerVC.photoDelegate = self;
    [self presentViewController:photoPickerVC animated:YES completion:NULL];
  } failureBlock:^(NSError *error) {
   
      UIAlertController *alertC = [UIAlertController alertControllerWithTitle:YZMsg(@"没有相册权限") message:YZMsg(@"请到设置页面获取相册权限") preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *cancelA = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleCancel handler:nil];
      [alertC addAction:cancelA];
      [self presentViewController:alertC animated:YES completion:nil];
  }];
}

#pragma mark --调用相机
- (void)cameraClick {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  
  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
    [picker setMediaTypes:arrMediaTypes];
    picker.showsCameraControls = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    picker.editing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  }
}

#pragma mark - 语音输入
-(void)voiceInputClick {
    NSLog(@"语音输入");
    YBWeakSelf;
    if (!_asrView) {
        _asrView = [[ASRView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, _window_height) callBack:^(NSString *type, NSString *content) {
            if ([type isEqual:@"返回"]) {
                NSLog(@"返回");
                [weakSelf asrBack];
            }else if ([type isEqual:YZMsg(@"发送")]){
                NSLog(@"发送");
                [weakSelf asrSend:content];
            }
        }];
        [self.view addSubview:_asrView];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _asrView.frame = CGRectMake(0, 0, _window_width, _window_height);
        _moreViewHeight.constant = ASRHeight-_toolBarHeightConstrait.constant;
        [self scrollToEnd];
    }];
    
}
-(void)asrBack {
    [_asrView.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        _asrView.frame = CGRectMake(0, _window_height, _window_width, _window_height);
        _moreViewHeight.constant = kMoreHeight+ShowDiff;
        [self scrollToEnd];
    }];
}
-(void)asrSend:(NSString *)content {
    [self sendText:content];
}

#pragma mark - 位置信息
-(void)locationClick {
    TencentLocationVC *locationVC = [[TencentLocationVC alloc]init];
    YBWeakSelf;
    locationVC.locationEvent = ^(NSDictionary *locDic) {
        [weakSelf prepareLocation:locDic];
    };
    [self.navigationController pushViewController:locationVC animated:YES];
}
-(void)prepareLocation:(NSDictionary *)dic{
    
    NSNumber *latitude = @([[NSString stringWithFormat:@"%@",[dic valueForKey:@"latitude"]] doubleValue]);
    NSNumber *longitude = @([[NSString stringWithFormat:@"%@",[dic valueForKey:@"longitude"]] doubleValue]);
    NSString *address = [dic valueForKey:@"address"];
    
    
    JMSGLocationContent *locationContent = [[JMSGLocationContent alloc]initWithLatitude:latitude longitude:longitude scale:@(1) address:address];

     [self checkBlack:locationContent voice:@""];
    
//    JMSGMessage *message = nil;
//    message = [_conversation createMessageWithContent:locationContent];
//    [_conversation sendMessage:message];
//    [self addmessageShowTimeData:message.timestamp];
//    [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
//    [self addMessage:model];
    
}


#pragma mark - HMPhotoPickerViewController Delegate
- (void)JCHATPhotoPickerViewController:(JCHATPhotoSelectViewController *)PhotoPickerVC selectedPhotoArray:(NSArray *)selected_photo_array {
  for (UIImage *image in selected_photo_array) {
    [self prepareImageMessage:image];
  }
  [self dropToolBarNoAnimate];
}
#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  if ([mediaType isEqualToString:@"public.movie"]) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showMessage:YZMsg(@"不支持视频发送") toView:self.view];
    return;
  }
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self prepareImageMessage:image];
  [self dropToolBarNoAnimate];
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
  DDLogDebug(@"Action - prepareImageMessage");
  img = [img resizedImageByWidth:upLoadImgWidth];
  
  JMSGMessage* message = nil;
  JCHATChatModel *model = [[JCHATChatModel alloc] init];
  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
  if (imageContent) {
    message = [_conversation createMessageWithContent:imageContent];
    [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
    [_imgDataArr addObject:model];
    model.photoIndex = [_imgDataArr count] - 1;
    [model setupImageSize];
    [self addMessage:model];
  }
}

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --add Delegate
- (void)addDelegate {
  [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark --加载通知
- (void)addNotification{
  //给键盘注册通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cleanMessageCache)
                                               name:kDeleteAllMessage
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(AlertToSendImage:)
                                               name:kAlertToSendImage
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deleteMessage:)
                                               name:kDeleteMessage
                                             object:nil];

  [self.toolBarContainer.toolbar.textView addObserver:self
                                           forKeyPath:@"contentSize"
                                              options:NSKeyValueObservingOptionNew
                                              context:nil];
  self.toolBarContainer.toolbar.textView.delegate = self;
}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
  [self prepareTextMessage:text];
}

- (void)perform {
  _moreViewHeight.constant = 0;
  _toolBarToBottomConstrait.constant = 0+ShowDiff;
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
    if (_ybNavi.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, _window_height - _window_height*0.4, _window_width, _window_height*0.4);
            _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight);
        }];
        return;
    }

  _barBottomFlag =YES;
  _previousTextViewContentHeight = 36;
  _toolBarContainer.toolbar.addButton.selected = NO;
  _toolBarContainer.toolbar.faceBtn.selected = NO;
//  [_messageTableView reloadData];
  [UIView animateWithDuration:0.3 animations:^{
    _toolBarToBottomConstrait.constant = 0+ShowDiff;
      _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff);
    _moreViewHeight.constant = 0;
  }];
    
}

- (void)dropToolBarNoAnimate {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 36;
  _toolBarContainer.toolbar.addButton.selected = NO;
    _toolBarContainer.toolbar.faceBtn.selected = NO;
//  [_messageTableView reloadData];
  _toolBarToBottomConstrait.constant = 0+ShowDiff;
    _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff);
  _moreViewHeight.constant = 0;
}
#pragma mark - 键盘
- (void)inputKeyboardWillShow:(NSNotification *)notification{
    //获取键盘的高
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.origin.y;
    CGFloat newHeight = _window_height - height;

    if (_ybNavi.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0,_window_height*0.2, _window_width, _window_height*0.8 - newHeight);
        }];
        //        mview.frame = CGRectMake(0,self.view.frame.size.height-barH, _window_width*0.2-20, 44);
        return;
    }

    _toolBarContainer.toolbar.addButton.selected = NO;
    _toolBarContainer.toolbar.faceBtn.selected = NO;
    _barBottomFlag=NO;
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (_asrView.textView.isFirstResponder == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            _asrMoveUp = YES;
            _asrView.frame = CGRectMake(0, -keyBoardFrame.size.height, _window_width, _window_height);
            _moreViewHeight.constant = keyBoardFrame.size.height-_toolBarHeightConstrait.constant;
        }];
    }else{
        [UIView animateWithDuration:animationTime animations:^{
            _moreViewHeight.constant = keyBoardFrame.size.height;
            _toolBarToBottomConstrait.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    [self scrollToEnd];//!
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    kWEAKSELF
    if (_asrMoveUp == YES) {
        [UIView animateWithDuration:0.25 animations:^{
            _asrMoveUp = NO;
            _asrView.frame = CGRectMake(0, 0, _window_width, _window_height);
            _moreViewHeight.constant = ASRHeight-_toolBarHeightConstrait.constant;
        }];
    }else{
        [UIView animateWithDuration:animationTime animations:^{
            _moreViewHeight.constant = 0;
            _toolBarToBottomConstrait.constant = 0+ShowDiff;
            [weakSelf.view layoutIfNeeded];
        }];
    }
    if (_ybNavi.hidden) {
        [UIView animateWithDuration:0.1 animations:^{
            self.view.frame = CGRectMake(0, _window_height - _window_height*0.4, _window_width, _window_height*0.4);
        }];
    }
    [self scrollToBottomAnimated:NO];
}
#pragma mark -- 更多
- (void)pressMoreBtnClick:(UIButton *)btn {
  _barBottomFlag=NO;
  [_toolBarContainer.toolbar.textView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        _toolBarToBottomConstrait.constant = 0;
        _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight+ShowDiff);
        _moreViewHeight.constant = kMoreHeight+ShowDiff;
        [_messageTableView layoutIfNeeded];
        [_toolBarContainer layoutIfNeeded];
        [_moreViewContainer layoutIfNeeded];
    }];
    [_toolBarContainer.toolbar switchToolbarToTextMode];
   
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
    [self dropToolBar];
//    _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight);
  [_toolBarContainer.toolbar.textView becomeFirstResponder];
}
#pragma mark - 表情弹起、落下
-(void)pressFaceBtnClick:(UIButton *)btn {
    [_toolBarContainer.toolbar.textView resignFirstResponder];

    if (_ybNavi.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0,_window_height*0.2, _window_width, _window_height*0.8 - EmojiHeight);
            _emojiV.frame = CGRectMake(0, _window_height-EmojiHeight, _window_width, EmojiHeight);

        }];
        return ;
    }

    _barBottomFlag=NO;
    [UIView animateWithDuration:0.3 animations:^{
        _toolBarToBottomConstrait.constant = EmojiHeight+ShowDiff;
        _moreViewHeight.constant = 0;
        _emojiV.frame = CGRectMake(0, _window_height-EmojiHeight-ShowDiff, _window_width, EmojiHeight+ShowDiff);
        [_messageTableView layoutIfNeeded];
        [_toolBarContainer layoutIfNeeded];
        [_moreViewContainer layoutIfNeeded];
    }];
    [_toolBarContainer.toolbar switchToolbarToTextMode];
}
-(void)noPressFaceBtnClick:(UIButton *)btn {
//    _toolBarToBottomConstrait.constant = 0;
//    [_toolBarContainer layoutIfNeeded];
//    _emojiV.frame = CGRectMake(0, _window_height, _window_width, EmojiHeight);
     [self dropToolBar];
    [_toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark - Emoji 代理
-(void)sendimage:(NSString *)str {
    if ([str isEqual:@"msg_del"]) {
        [_toolBarContainer.toolbar.textView deleteBackward];
    }else {
        [_toolBarContainer.toolbar.textView insertText:str];
    }
}

-(void)clickSendEmojiBtn {
    
    [self prepareTextMessage:_toolBarContainer.toolbar.textView.text];
    _toolBarContainer.toolbar.textView.text = @"";
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    
    DDLogDebug(@"Action - prepareTextMessage");
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    
    [self checkBlack:textContent voice:@""];
    
//    JMSGMessage *message = nil;
//    message = [_conversation createMessageWithContent:textContent];//!
//    [_conversation sendMessage:message];
//    [self addmessageShowTimeData:message.timestamp];
//    [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
//    [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
  [_messageTableView beginUpdates];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageTableView endUpdates];
  [self scrollToEnd];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count] > 0 && lastModel.isTime == NO) {
      
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([_allmessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
    DDLogDebug(@"不用显示时间");
  }
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr addObject:timeModel.timeId];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr addObject:timeModel.timeId];
  } else {
    DDLogDebug(@"不用显示时间");
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr insertObject:timeModel.timeId atIndex: isNoOtherMessage?0:1];
  } else {
    DDLogDebug(@"不用显示时间");
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];//!
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}

#pragma mark - 屏幕触摸事件
//代理
-(void)msgTableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_barBottomFlag==NO) {
        if (_asrView.isFirstResponder == YES) {
            [UIView animateWithDuration:0.25 animations:^{
                _asrView.frame = CGRectMake(0, 0, _window_width, _window_height);
                _moreViewHeight.constant = ASRHeight-_toolBarHeightConstrait.constant;
            }];
        }
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint _touchPoint = [touch locationInView:self.view];
        if (YES == CGRectContainsPoint(_messageTableView.frame, _touchPoint)){
            [self.toolBarContainer.toolbar.textView resignFirstResponder];
            [self dropToolBar];
        }
    }
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    [self dropToolBar];
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([_allmessageIdArr count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}

#pragma mark - tableView datasoce
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (!isNoOtherMessage) {
    if (indexPath.row == 0) { //这个是第 0 行 用于刷新
      return 40;
    }
  }
    
    if (indexPath.row >= _allmessageIdArr.count) {
        DDLogDebug(@"1.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return 40;
    }
  NSString *messageId = _allmessageIdArr[indexPath.row];
  JCHATChatModel *model = _allMessageDic[messageId];
  if (model.isTime == YES) {
    return 31;
  }
  
  if (model.message.contentType == kJMSGContentTypeEventNotification) {
    return model.contentHeight + 17;
  }
  
  if (model.message.contentType == kJMSGContentTypeText) {
    return model.contentHeight + 17;
  } else if (model.message.contentType == kJMSGContentTypeImage ||
             model.message.contentType == kJMSGContentTypeFile ||
             model.message.contentType == kJMSGContentTypeLocation) {
    if (model.imageSize.height == 0) {
      [model setupImageSize];
    }
    return model.imageSize.height < 44?59:model.imageSize.height + 14;
    
  } else if (model.message.contentType == kJMSGContentTypeVoice) {
    return 69;
  }  else {
    return 49;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_allmessageIdArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isNoOtherMessage) {
        if (indexPath.row == 0) {
          static NSString *cellLoadIdentifier = @"loadCell"; //name
          JCHATLoadMessageTableViewCell *cell = (JCHATLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
          
          if (cell == nil) {
            cell = [[JCHATLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
          }
          [cell startLoading];
            [self flashToLoadMessage];
//          [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
          return cell;
        }
    }
    if (indexPath.row >= _allmessageIdArr.count) {
        DDLogDebug(@"2.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return nil;
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    if (!messageId) {
        DDLogDebug(@"messageId is nil%@",messageId);
        return nil;
    }

    JCHATChatModel *model = _allMessageDic[messageId];
    if (!model) {
        DDLogDebug(@"JCHATChatModel is nil%@", messageId);
        return nil;
    }
    
    if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
        //消息时间
        static NSString *cellIdentifier = @"timeCell";
        JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        if (cell == nil) {
          cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:nil options:nil] lastObject];
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        if (model.isErrorMessage) {
          cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
          return cell;
        }

        if (model.message.contentType == kJMSGContentTypeEventNotification) {
          cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
        } else {
          cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
        }
        return cell;

    } else {
        //消息内容
        static NSString *cellIdentifier2 = @"MessageCell";
        JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];

        if (cell == nil) {
          cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier2];
          cell.conversation = _conversation;
        }

        [cell setCellData:model delegate:self indexPath:indexPath];
        
        kWEAKSELF
        cell.messageTableViewCellRefreshMediaMessage = ^(JCHATChatModel *cellModel,BOOL isShouldRefresh){
            if (isShouldRefresh) {
                [weakSelf refreshCellMessageMediaWithChatModel:cellModel];
            }
        };
        
        return cell;
    }
    
}

#pragma mark - 检查并刷新消息图片图片
- (void)refreshCellMessageMediaWithChatModel:(JCHATChatModel *)model {
    DDLogDebug(@"Action - refreshCellMessageMediaWithChatModel:");
    
    if (!model) {
        return ;
    }
    if (!model.message || ![self.conversation isMessageForThisConversation:model.message]) {
        return ;
    }
    NSString *msgId = model.message.msgId;
    JMSGMessage *db_message = [self.conversation messageWithMessageId:msgId];
    if (!db_message || !db_message.msgId) {
        return ;
    }
    
    model.message = db_message;
    [_allMessageDic setObject:model forKey:model.message.msgId];
    //[_allmessageIdArr addObject:model.message.msgId];msgId 不会变化所以不用去修改
    
    // 1.method
//    [self.messageTableView reloadData];
    
    // 2.method
//    NSArray *cellArray = [_messageTableView visibleCells];
//    for (id temp in cellArray) {
//        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
//            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
//            if ([cell.model.message.msgId isEqualToString:msgId]) {
//                cell.model = model;
//                [cell layoutAllView];
//            }
//        }
//    }
    // 3.在cell 里面刷新
}
#pragma mark - 检查并刷新头像
- (void)chcekReceiveMessageAvatarWithReceiveNewMessage:(JMSGMessage *)message {
    DDLogDebug(@"chcekReceiveMessageAvatarWithReceiveNewMessage:%@",message.serverMessageId);
    if (!message || !message.fromUser) {
        return ;
    }
    
    JMSGMessage *lastMessage = message;
    JMSGUser *fromUser = lastMessage.fromUser;
    [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil && [objectId isEqualToString:fromUser.username]) {
            if (data != nil) {
                NSUInteger lenght = data.length;
                [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
            }
        }
    }];
//    NSString *key = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
//    NSMutableArray *messages = _refreshAvatarUsersDic[key];
//    if (messages.count > 0) {
//        JMSGMessage *lastMessage = [messages lastObject];
//        JMSGUser *fromUser = lastMessage.fromUser;
//        [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
//            if (error == nil && [objectId isEqualToString:fromUser.username]) {
//                if (data != nil) {
//                    NSUInteger lenght = data.length;
//                    [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
//                }
//            }
//            [_refreshAvatarUsersDic removeObjectForKey:key];
//        }];
//    }
}

- (void)refreshVisibleRowsAvatarWithNewMessage:(JMSGMessage *)message avatarDataLength:(NSUInteger)length {
    
    DDLogDebug(@"refreshVisibleRowsAvatarWithNewMessage::%@",message.serverMessageId);
    
    NSString *username_appkey = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
    NSString *msgId = message.msgId;
    
    NSArray *indexPaths = [[_messageTableView indexPathsForVisibleRows] mutableCopy];
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    for (int i = 0; i < indexPaths.count; i++) {
        NSIndexPath *indexPath = indexPaths[i];
        JCHATMessageTableViewCell *cell = [_messageTableView cellForRowAtIndexPath:indexPath];
        JCHATChatModel *cellModel = cell.model;
        JMSGUser *cellUser = cell.model.message.fromUser;
        NSString *key = [NSString stringWithFormat:@"%@_%@",cellUser.username,cellUser.appKey];
        
        if (![username_appkey isEqualToString:key]) {
            continue ;
        }
        if (cellModel.avatarDataLength != length) {
            JMSGMessage *dbMessage = [self.conversation messageWithMessageId:msgId];
            JCHATChatModel *model = [_allMessageDic objectForKey:msgId];
            model.message = dbMessage;
            [_allMessageDic setObject:model forKey:msgId];
            [reloadIndexPaths addObject:indexPath];
        }
    }
    
    if (reloadIndexPaths.count > 0) {
        [_messageTableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)reloadAllCellAvatarImage {
    DDLogDebug(@"Action -reloadAllCellAvatarImage");
    
    for (int i = 0; i < _allmessageIdArr.count; i++) {
        NSString *msgid = [_allmessageIdArr objectAtIndex:i];
        JCHATChatModel *model = [_allMessageDic objectForKey:msgid];
        if (model.message.isReceived && !model.message.fromUser.avatar) {
            JMSGMessage *message = [self.conversation messageWithMessageId:msgid];
            model.message = message;
            [_allMessageDic setObject:model forKey:msgid];
        }
    }
    
    NSArray *cellArray = [_messageTableView visibleCells];
    for (id temp in cellArray) {
        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
            if (cell.model.message.isReceived) {
                [cell reloadAvatarImage];
            }
        }
    }
}

#pragma mark -PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    
    if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
      JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
      [voiceCell playVoice];
    }
  }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
  [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
  [_allMessageDic setObject:*chatModel forKey:message.msgId];
  
  if ([_allmessageIdArr count] > index) {
    [_allmessageIdArr removeObjectAtIndex:index];
    [_allmessageIdArr insertObject:message.msgId atIndex:index];
  }
}

#pragma mark - 头像点击事件代理
- (void)selectHeadView:(JCHATChatModel *)model {
  if (!model.message.fromUser) {
    [MBProgressHUD showMessage:@"该用户为API用户" toView:self.view];
    return;
  }
    if ([model.uidStr isEqual:@"dsp_admin_1"]||[model.uidStr isEqual:@"dsp_admin_2"]) {
        return;
    }
//    CenterVC *center = [[CenterVC alloc]init];
//    if (![model.message isReceived]) {
//        //自己
//        center.otherUid =[Config getOwnID];
//    }else {
//        //别人
//        center.otherUid = model.uidStr;
//    }
//    center.isPush = YES;
//    center.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:center animated:YES];
}

#pragma mark -连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
      if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        tempCell.continuePlayer = YES;
      }else {
        tempCell.continuePlayer = NO;
      }
    }
  }
}

#pragma mark 预览图片 PictureDelegate
//PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
    
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
  NSInteger count = _imgDataArr.count;
  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
  for (int i = 0; i<count; i++) {
    JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.message = messageObject;
    photo.srcImageView = tapView; // 来源于哪个UIImageView
    [photos addObject:photo];
  }
  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
  browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
//  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
  browser.photos = photos; // 设置所有的图片
  browser.conversation =_conversation;
  [browser show];
}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
  NSMutableArray *urlArr =[NSMutableArray array];
  for (NSInteger i=0; i<[_allmessageIdArr count]; i++) {
    NSString *messageId = _allmessageIdArr[i];
    JCHATChatModel *model = _allMessageDic[messageId];
    if (model.message.contentType == kJMSGContentTypeImage) {
      [urlArr addObject:((JMSGImageContent *)model.message.content)];
    }
  }
  return urlArr;
}
#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
  DDLogVerbose(@"Action - didStartRecordingVoice");
  [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
  DDLogVerbose(@"Action - didCancelRecordingVoice");
  [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
  DDLogVerbose(@"Action - didFinishRecordingVoiceAction");
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  DDLogVerbose(@"Action - didDragOutsideAction");
  [self resumeRecord];
}

- (void)didDragInsideAction {
  DDLogVerbose(@"Action - didDragInsideAction");
  [self pauseRecord];
}

- (void)pauseRecord {
  [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
  [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
  WEAKSELF
  [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    
  }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
  DDLogDebug(@"Action - startRecord");
  [self.voiceRecordHUD startRecordingHUDAtView:self.view];
  [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
  }];
}

- (void)finishRecorded {
  DDLogDebug(@"Action - finishRecorded");
  WEAKSELF
  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                       voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
  }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
  DDLogDebug(@"Action - SendMessageWithVoice");
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
      DDLogDebug(@"录音时长小于 0.5s");
    } else {
      DDLogDebug(@"录音时长大于 60s");
    }
    return;
  }
  
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                 voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
    [self checkBlack:voiceContent voice:voicePath];
    
//    JMSGMessage *voiceMessage = nil;
//    voiceMessage = [_conversation createMessageWithContent:voiceContent];
//  [_conversation sendMessage:voiceMessage];
//  [self addmessageShowTimeData:voiceMessage.timestamp];
//  [model setChatModelWith:voiceMessage conversationType:_conversation userModel:_userModel];
//  [JCHATFileManager deleteFile:voicePath];
//  [self addMessage:model];
}

#pragma mark - 检查拉黑
-(void)checkBlack:(JMSGAbstractContent *)content voice:(NSString *)voicePath {
    if (voicePath.length>0) {
        [JCHATFileManager deleteFile:voicePath];
    }
    
    NSString *url = [purl stringByAppendingFormat:@"/?service=User.checkBlack&uid=%@&token=%@&touid=%@",[Config getOwnID],[Config getOwnToken],_userModel.uidStr];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            NSDictionary *infoDic = [[data valueForKey:@"info"] firstObject];
            NSString *isattent = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"isattent"]];
            NSString *t2u = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"t2u"]];
            NSString *p_switch;
            int p_nums;
//            NSString *p_switch = [NSString stringWithFormat:@"%@",[common private_letter_switch]];
//            int p_nums = [[NSString stringWithFormat:@"%@",[common private_letter_nums]] intValue];
            //我发送的条数
            NSMutableArray *frends_cont = [NSMutableArray array];
            for (int i = 0; i < _allmessageIdArr.count; i++) {
                NSString *msgid = [_allmessageIdArr objectAtIndex:i];
                JCHATChatModel *model = [_allMessageDic objectForKey:msgid];
                if ([model.uidStr isEqual:[Config getOwnID]]) {
                    [frends_cont addObject:model];
                }
            }
            
            if ([t2u isEqual:@"0"]) {
                if ([isattent isEqual:@"0"] && [p_switch isEqual:@"1"] && frends_cont.count >= p_nums) {
//                    [MBProgressHUD showError:[NSString stringWithFormat:@"对方未关注你,最多只能发送%d条信息",p_nums]];
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@%d%@",YZMsg(@"对方未关注你,最多只能发送"),p_nums,YZMsg(@"条信息")]];
                }else {
                    JMSGMessage *message = nil;
                    message = [_conversation createMessageWithContent:content];
                    JMSGOptionalContent *option;
                    option.noSaveNotification = YES;
                    [_conversation sendMessage:message optionalContent:option];
                    [self addmessageShowTimeData:message.timestamp];
                    JCHATChatModel *model =[[JCHATChatModel alloc] init];
                    [model setChatModelWith:message conversationType:_conversation userModel:_userModel];
                    [self addMessage:model];
                }
            }else {
//                [MBProgressHUD showError:YZMsg(@"对方暂时拒绝接收您的消息")];
                [MBProgressHUD showError:YZMsg(@"对方暂时拒绝接收您的消息")];
            }
        }else {
//            [MBProgressHUD showError:msg];
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (self.barBottomFlag) {
    return;
  }
  if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
    [self layoutAndAnimateMessageInputTextView:object];
  }
}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
  } else {
    return textView.contentSize.height;
  }
}

#pragma mark - Layout Message Input View Helper Method

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
  CGFloat maxHeight = [JCHATToolBar maxHeight];
  
  CGFloat contentH = [self getTextViewContentH:textView];
  
  BOOL isShrinking = contentH < _previousTextViewContentHeight;
  CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
  
  if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
    changeInHeight = 0;
  }
  else {
    changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
  }
  if (changeInHeight != 0.0f) {
      kWEAKSELF
    [UIView animateWithDuration:0.25f
                     animations:^{
                       [weakSelf setTableViewInsetsWithBottomValue:_messageTableView.contentInset.bottom + changeInHeight];
                       
                       [weakSelf scrollToBottomAnimated:NO];
                       
                       if (isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           _previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // if shrinking the view, animate text view frame BEFORE input view frame
                         [_toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                       
                       if (!isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           weakSelf.previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // growing the view, animate the text view frame AFTER input view frame
                         [weakSelf.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                     }
                     completion:^(BOOL finished) {
                     }];
    JCHATMessageTextView *textview =_toolBarContainer.toolbar.textView;
    CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:textview.text withWidthLimit:textView.frame.size.width withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
    CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
      _toolBarHeightConstrait.constant = (textHeight + 8)>=45?(textHeight + 8):45;//!
    self.previousTextViewContentHeight = MIN(contentH, maxHeight);
  }
  
  // Once we reached the max height, we have to consider the bottom offset for the text view.
  // To make visible the last line, again we have to set the content offset.
  if (self.previousTextViewContentHeight == maxHeight) {
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime,
                   dispatch_get_main_queue(),
                   ^(void) {
                     CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                     [textView setContentOffset:bottomOffset animated:YES];
                   });
  }
}

- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView {
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:messageInputTextView.text];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  if (![self shouldAllowScroll]) return;
  
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
  //      if (self.isUserScrolling) {
  //          if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
  //              && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
  //              return NO;
  //          }
  //      }
  
  return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
  //    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
  //    self.messageTableView.contentInset = insets;
  //    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    insets.top = 64;
  }
  insets.bottom = bottom;
  return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
#pragma mark - 拉黑
-(void)setBlack {
    NSString *url = [purl stringByAppendingFormat:@"/?service=User.setBlack&uid=%@&token=%@&touid=%@",[Config getOwnID],[Config getOwnToken],_userModel.uidStr];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            NSString *infoDic = [[data valueForKey:@"info"] firstObject];
            NSString *isBlakc = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"isblack"]];
            if ([isBlakc isEqual:@"1"]) {
//                [MBProgressHUD showError:YZMsg(@"拉黑成功")];
                [MBProgressHUD showError:YZMsg(@"拉黑成功")];
                
            }else {
//                [MBProgressHUD showError:YZMsg(@"取消拉黑成功")];
                [MBProgressHUD showError:YZMsg(@"取消拉黑成功")];
            }
        }else {
//            [MBProgressHUD showError:msg];
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
}
-(void)clickRightMore {
    otherUserMsgVC *person = [[otherUserMsgVC alloc]init];
    person.userID = _userModel.uidStr;
    person.block = ^{
        [self removeFollowView];
    };
    [self.navigationController pushViewController:person animated:YES];
//    NSString *url = [purl stringByAppendingFormat:@"/?service=User.checkBlack&uid=%@&token=%@&touid=%@",[Config getOwnID],[Config getOwnToken],_userModel.uidStr];
//    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
//        if ([code isEqual:@"0"]) {
//            NSDictionary *infoDic = [[data valueForKey:@"info"] firstObject];
//            NSString *u2t = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"u2t"]];
//            //u2t  0-未拉黑  1-已拉黑
//            NSString *blackTitle = YZMsg(@"拉黑");
//            if ([u2t isEqual:@"1"]) {
//                blackTitle = @"取消拉黑";
//            }
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction *reportA = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                webH5 *h5vc = [[webH5 alloc]init];
//                h5vc.urls =[h5url stringByAppendingString:[NSString stringWithFormat:@"/index.php?g=Appapi&m=Userreport&a=index&uid=%@&token=%@&touid=%@",[Config getOwnID],[Config getOwnToken],_userModel.uidStr]];
//                [self.navigationController pushViewController:h5vc animated:YES];
//
//            }];
//            UIAlertAction *blackA = [UIAlertAction actionWithTitle:blackTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                [self setBlack];
//            }];
//            UIAlertAction *cancleA = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleCancel handler:nil];
//            [alertC addAction:reportA];
//            [alertC addAction:blackA];
//            [alertC addAction:cancleA];
//            [self presentViewController:alertC animated:YES completion:nil];
//        }else {
////            [MBProgressHUD showError:msg];
//            [MBProgressHUD showError:msg];
//        }
//    } Fail:nil];
    
}
#pragma mark - 导航
-(void)creatNavi {
    _ybNavi = [[YBNavi alloc]init];
    _ybNavi.haveImgR = YES;
    _ybNavi.rightHidden = NO;
    [_ybNavi ybNaviLeft:^(id btnBack) {
        if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
            [[JCHATAudioPlayerHelper shareInstance] stopAudio];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } andRightName:@"极光个人主页" andRight:^(id btnBack) {
        [self clickRightMore];
    } andMidTitle:_userModel.unameStr];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, _ybNavi.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:_ybNavi];

    [self.view addSubview:_ybNavi];
}
//聊天小窗口
- (void)reloadSamllChtaView:(NSString *)isatt{
    _ybNavi.hidden = YES;
    UIView *smallNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 35)];
    smallNavi.backgroundColor = RGB_COLOR(@"#f9fafb", 1);
    [self.view addSubview:smallNavi];
    if ([isatt isEqual:@"1"]) {
        [followView removeFromSuperview];
        followView = nil;
    }else{
        if (followView) {
            followView.y = 35;
        }
    }
    [self.moreViewContainer.moreView removeFromSuperview];
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(0, 0, 35, 35);
    [btn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:0];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [btn addTarget:self action:@selector(hideSmallView) forControlEvents:UIControlEventTouchUpInside];
    [smallNavi addSubview:btn];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, _window_width-70, 35)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor= RGB_COLOR(@"#636464", 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _userModel.unameStr;
    [smallNavi addSubview:titleLabel];
    self.messageTabTop.constant = 35;
    _messageTableView.frame = CGRectMake(0, 0, _window_width, _window_height*0.4-80);
    [self getGroupMemberListWithGetMessageFlag:YES];
    self.toolBarContainer.toolbar.voideWidth.constant -= 30;
    self.toolBarContainer.toolbar.addBtnWidth.constant -= 30;
    [_emojiV removeFromSuperview];
    _emojiV = nil;
    _emojiV = [[twEmojiView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, EmojiHeight)];
    _emojiV.delegate = self;
    [[UIApplication sharedApplication].delegate.window addSubview:_emojiV];
}

- (void)hideSmallView{
    [_asrView.textView resignFirstResponder];
    //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
    //remove delegate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [JMessage removeDelegate:self withConversation:_conversation];
    [self dropToolBar];
    if (self.block) {
        self.block(0);
    }
}
@end
