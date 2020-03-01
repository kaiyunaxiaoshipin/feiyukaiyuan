#import <UIKit/UIKit.h>
#import "huanxinsixinview.h"
#import "chatsmallview.h"
#import "chatModel.h"
#import "NSString+StringSize.h"
#import "listModel.h"
#import "UIImageView+Util.h"
#import "listCell.h"
#import "UIImageView+WebCache.h"
#import <CommonCrypto/CommonDigest.h>
#import "fenXiangView.h"
#import "ZFModalTransitionAnimator.h"
#import "otherUserMsgVC.h"
#import "chatController.h"
#import "messageC.h"
#import "CoinVeiw.h"
#import "setViewM.h"

//连麦推流
#import <GPUImage/GPUImage.h>
#import <libksygpulive/libksygpulive.h>

#import "catSwitch.h"
#import "GrounderSuperView.h"
//新礼物
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"
#import "socketLivePlay.h"
#import "liwuview.h"
#import "continueGift.h"
#import "upmessageInfo.h"
#import "expensiveGiftV.h"//礼物
#import "ListCollection.h"//用户列表

#import "userLoginAnimation.h"//进场动画
#import "personList.h"
#import "lastview.h"

#import "WPFRotateView.h"
#import "gameBottomVC.h"
#import "shellGame.h"
#import "shangzhuang.h"//上下庄
#import "Hourglass.h"
#import "webH5.h"
#import "viplogin.h"//用户进场动画
#import "JMListen.h"
#import "JSPlayLinkMic.h"
#import "TXPlayLinkMic.h"
#import "impressVC.h"
#import "chatMsgCell.h"
#import "shouhuView.h"
#import "guardShowView.h"
#import "JCHATConversationViewController.h"
#import "redBagView.h"
#import "redListView.h"
#import "anchorOnline.h"
#import "anchorPKView.h"
#import "MsgSysVC.h"
#import "jubaoVC.h"
#import "WinningPrizeView.h"
#import "JackpotButton.h"
#import "JackpotView.h"

@protocol dianjishijian <NSObject>
@optional
-(void)duihaoHidden;
@end
@interface moviePlay : JMListen
{
    viplogin *vipanimation;//坐骑进场动画
    userLoginAnimation *useraimation;//进场动画(横条飘进)
    UIImageView *buttomimageviews;//背景模糊(一开始进入直播间未加载到视频的时候显示)
    ListCollection *listView;//用户列表
    expensiveGiftV *haohualiwuV;//豪华礼物
    fenXiangView *fenxiangV;//分享view
    continueGift *continueGifts;//连送礼物
    huanxinsixinview *huanxinviews;//私信列表
//    chatsmallview *chatsmall;//聊天
    JCHATConversationViewController *chatsmall;//聊天

    UIView *chatsmallzhezhao;
    setViewM *setFrontV;//页面UI
    upmessageInfo *userView;//用户列表弹窗
    liwuview *giftview;//礼物界面
    UIView *_videoPlayView;//视频播放view
    ////////////////////////////////////////////////////////////////////////////
    UIScrollView *backScrollView;//
    UIScrollView *buttomscrollview;//上下滑屏切换
    UIView *buttomviews;//用来左右滑动;
    UIImageView *buttomimageview;//滑动显示下一个或上一个图片
    BOOL fangKeng;//防坑 ，第一次进房间不滑动
    int scrollvieweight;//判断滑动距离是否够切换
    ////////////////////////////////////////////////////////////////////////////
    socketMovieplay *socketDelegate;//socket监听
    ////////////////////////////////////////////////////////////////////////////
    UIImageView *starImage; //点亮图片
    NSNumber *heartNum;
    int starisok;
    UITapGestureRecognizer *starTap;
    BOOL firstStar;// 第一次点亮
    ////////////////////////////////////////////////////////////////////////////
    UIButton *pushBTN;
    UITextField *keyField;//聊天输入框
    UIView *toolBar;
    catSwitch *cs;//弹幕按钮
    UIButton *keyBTN;//点击弹出键盘
    ////////////////////////////////////////////////////////////////////////////
    LiveUser *myUser;//缓存个人信息
    CGFloat listcollectionviewx;//用户列表的x
    NSString *haohualiwu;//判断豪华礼物
    long long userCount;//用户数量
    CGFloat www;
    NSString *titleColor;//判断 回复颜色
    NSString *level;
    
    BOOL    _canScrollToBottom;//判断tableview可不可以滑动
    UIPanGestureRecognizer *panGestureRecognizer;
    UIView* _winRtcView;
    int userlist_time;//定时刷新用户列表时间
    BOOL isRegistLianMai;//判断连麦注册成功
    BOOL isRotationGame;//判断游戏
    BOOL isZhajinhuaGame;
    UIView *liansongliwubottomview;
    BOOL haslianmai;//是不是可以连麦
    GPUImageOutput<GPUImageInput>* _curFilter;
    
    lastview *lastv;
    
    int coasttime;//扣费计时
    gameBottomVC *gameVC;//炸金花
    WPFRotateView *rotationV;//转盘
    shellGame *shell;//二八贝
    shangzhuang *zhuangVC;//上装VC
    NSDictionary *zhuangstartdic;//庄家初始化信息
    BOOL giftViewShow;//是否显示礼物view
    UIPanGestureRecognizer *videopan;//视频拖拽手势
    UITapGestureRecognizer *videotap;
    Hourglass *gifhour;//竞拍
    
    int isshow;//连麦相关
    BOOL ksynotconnected;
    BOOL ksyclosed;
    
    NSString *speak_limit;
    NSString *barrage_limit;
    NSString *jackpot_level;
    
    NSTimer *starMove;//点亮计时器
    NSTimer *listTimer;//定时刷新用户列表
    NSTimer *lianmaitimer;//主播同意连麦后超时响应时间
    NSTimer *timecoast;//计时扣费
    
    JSPlayLinkMic *_js_playrtmp;//连麦小窗口
    TXPlayLinkMic *_tx_playrtmp;
    NSString *_myplayurl;
    NSString *usertype;
    NSString *votesTatal;
    shouhuView *guardView;
    guardShowView *gShowView;
    NSDictionary *guardInfo;
    redBagView *redBview;
    UIButton *redBagBtn;
    redListView *redList;
    UIButton *sendBagBtn;
    anchorOnline *anchorView;
    anchorPKView *pkView;
    MsgSysVC *sysView;
//    NSString *lianmaiLevel;

    WinningPrizeView *winningView;
    JackpotButton *JackpotBtn;
    JackpotView *jackV;
}
@property(nonatomic,strong)NSString *livetype;
@property(nonatomic,strong)NSString *type_val;
@property GPUImageFilter     * filter;
@property(nonatomic,strong)GrounderSuperView *danmuView;//弹幕
@property(nonatomic,copy)NSString *tanChuangID;//弹窗用户的id
@property(nonatomic,strong)NSString *danmuprice;//弹幕价格
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)NSMutableArray *chatModels;//模型数组
@property(nonatomic,copy)NSString *content;//聊天内容
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) KSYMoviePlayerController *js_player;
@property(nonatomic,strong)NSArray *models;

@property(nonatomic,strong)UIButton *returnCancle;//退出
@property(nonatomic,strong)UIButton *messageBTN;//消息
@property(nonatomic,strong)UIButton *fenxiangBTN;//分享
@property(nonatomic,strong)UIButton *liwuBTN;//礼物
@property(nonatomic,strong)UIButton *connectVideo;//连麦

/*
 *
 **总的主播数组
 */
@property(nonatomic,strong)NSArray *scrollarray;
/*
 *
 **获取第几个主播
 */
@property(nonatomic,assign)int scrollindex;
@property(nonatomic,strong)NSString *isJpush;
@property(nonatomic,strong)NSDictionary *playDoc;
@property(nonatomic,assign)int hiddenN;
@property(nonatomic,assign)id<dianjishijian>liwuDelegate;

@property(nonatomic,strong)NSString *sdkType;//0-金山   1-腾讯

@end
