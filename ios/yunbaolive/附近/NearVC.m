//
//  NearVC.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/1.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NearVC.h"

#import "LivePlay.h"
#import "AppDelegate.h"
#import "HotCollectionViewCell.h"
#import "searchVC.h"
#import "hotModel.h"
#import "ZYTabBar.h"
#import "MessageListVC.h"

@import CoreLocation;

@interface NearVC ()<UICollectionViewDataSource,UICollectionViewDelegate,CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout,JMessageDelegate>
{
    CLLocationManager   *_NearByManager;
    UIView *nothingView;
    NSDictionary *selectedDic;
    int selected;
    UIAlertView *coastAlert;
    UIAlertView *secretAlert;
    NSString *type_val;//
    NSString *livetype;//
    int page;
    UIView *navi;
    CGFloat oldOffset;
    YBNoWordView *noNetwork;
    NSString *_sdkType;//0-金山  1-腾讯

}
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;

@end

@implementation NearVC

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self pullInternetforNew];
    
    [self getUnreadCount];
}
-(void)getUnreadCount{
    [self labeiHid];
}
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    //显示消息数量
    [self labeiHid];
}
-(void)onUnreadChanged:(NSUInteger)newCount{
    [self labeiHid];
}
-(void)labeiHid{
    dispatch_queue_t queue = dispatch_queue_create("GetIMMessage", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        unRead = [minstr([JMSGConversation getAllUnreadCount]) intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [NSString stringWithFormat:@"%d",unRead];
            if ([label.text isEqual:@"0"]) {
                label.hidden =YES;
            }else{
                label.hidden = NO;
            }
        });
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBar.hidden = YES;
    oldOffset = 0;
    type_val = @"0";
    livetype = @"0";
    page = 1;
    self.allArray = [NSMutableArray array];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2-4.5, (_window_width/2-4.5) );
    flow.minimumLineSpacing = 3;
    flow.minimumInteritemSpacing = 3;
    flow.sectionInset = UIEdgeInsetsMake(3, 3,3, 3);

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) collectionViewLayout:flow];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotCollectionViewCELL"];
    self.collectionView.delegate =self;
    self.collectionView.dataSource = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self pullInternetforNew];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self pullInternetforNew];
    }];
    [self.view addSubview:self.collectionView];
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //获取所有未读消息
    [JMessage addDelegate:self withConversation:nil];
    [self getUnreadCount];
    _collectionView.contentInset = UIEdgeInsetsMake(64+statusbarHeight, 0, 0, 0);
    [self creatNavi];

}

-(void)createView{
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = YZMsg(@"附近没有主播开播");
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = YZMsg(@"去首页看看其他主播的直播吧～");
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:label2];
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self pullInternetforNew];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];

}
-(void)pullInternetforNew{
    [YBToolClass postNetworkWithUrl:@"Home.getNearby" andParameter:[NSDictionary dictionaryWithObjectsAndKeys:[cityDefault getMylng],@"lng",[cityDefault getMylat],@"lat",[cityDefault getMyCity],@"city",@(page),@"p", nil] success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        noNetwork.hidden = YES;
        if (code == 0) {
            NSArray *infos = info;
            if (page == 1) {
                [self.allArray removeAllObjects];
            }
            [self.allArray addObjectsFromArray:infos];
            if (self.allArray.count == 0) {
                nothingView.hidden = NO;
            }
            else{
                nothingView.hidden = YES;
            }
            //加载成功 停止刷新
            [self.collectionView reloadData];
            if (infos.count == 0) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }

    } fail:^{
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        nothingView.hidden = YES;
        if (_allArray.count == 0) {
            noNetwork.hidden = NO;
        }
    }];
}
#pragma mark - Table view data source
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HotCollectionViewCELL" forIndexPath:indexPath];
    NSDictionary *subdic = self.allArray[indexPath.row];
    cell.isNear = YES;
    cell.model = [[hotModel alloc]initWithDic:subdic];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selected = (int)indexPath.row;
    selectedDic = self.allArray[indexPath.row];
    [self checklive:[selectedDic valueForKey:@"stream"] andliveuid:[selectedDic valueForKey:@"uid"]];
}
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
                
                type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                _sdkType = minstr([info valueForKey:@"live_sdk"]);
                if ([type isEqual:@"0"]) {
                    [self pushMovieVC];
                }
                else if ([type isEqual:@"1"]){
                    //密码
                    secretAlert = [[UIAlertView alloc]initWithTitle:@"请填写密码" message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
                    secretAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
                    UITextField *field = [secretAlert textFieldAtIndex:0];
                    field.keyboardType = UIKeyboardTypeNumberPad;
                    [secretAlert show];
                    _MD5 = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                }else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    //收费
                    NSString *type_msg = [NSString stringWithFormat:@"%@",[info valueForKey:@"type_msg"]];
                    coastAlert = [[UIAlertView alloc]initWithTitle:type_msg message:nil delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
                    [coastAlert show];
                }
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]];
                [MBProgressHUD showError:msg];
            }
        }
        
        
        
    }
}
-(void)pushMovieVC{
    moviePlay *player = [[moviePlay alloc]init];
    player.scrollarray = self.allArray;
    player.scrollindex = selected;
    player.playDoc = selectedDic;
    player.type_val = type_val;
    player.livetype = livetype;
    player.sdkType = _sdkType;
    [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == coastAlert) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            [self doCoast];
        }
    }else    if (alertView == secretAlert) {
        if (buttonIndex == 0) {
            return;
        }else if (buttonIndex == 1){
            UITextField *field = [alertView textFieldAtIndex:0];
            
            NSString *MD5s = [self stringToMD5:field.text];
            if ([MD5s isEqual:_MD5]) {
                
                [self pushMovieVC];
            }else{
                [MBProgressHUD showError:YZMsg(@"密码错误")];
            }
            
        }
    }
}
- (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
//执行扣费
-(void)doCoast{
    [YBToolClass postNetworkWithUrl:@"Live.roomCharge" andParameter:@{@"liveuid":minstr([selectedDic valueForKey:@"uid"]),@"stream":minstr([selectedDic valueForKey:@"stream"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            [self pushMovieVC];
            //计时扣费
            
        }
        
    } fail:^{
        [self.collectionView.mj_header endRefreshing];
    }];

}
#pragma mark -
#pragma mark - navi
-(void)creatNavi {
    
    navi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navi];
    
    //标题
    UILabel *midLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22+statusbarHeight, 60, 42)];
    midLabel.backgroundColor = [UIColor clearColor];
    midLabel.font = navtionTitleFont;
    midLabel.text = YZMsg(@"附近");
    midLabel.textAlignment = NSTextAlignmentCenter;
    [navi addSubview:midLabel];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(20, 36, 20, 3) andColor:normalColors andView:midLabel];

    
    //私信
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    messageBtn.frame = CGRectMake(_window_width-40,24 +statusbarHeight,40,40);
    messageBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [messageBtn setImage:[UIImage imageNamed:@"home_message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    messageBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [navi addSubview:messageBtn];
    label = [[UILabel alloc]initWithFrame:CGRectMake(20,5 , 16, 16)];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    label.hidden = YES;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.text = [NSString stringWithFormat:@"%d",unRead];
    label.textAlignment = NSTextAlignmentCenter;
    [messageBtn addSubview:label];

    
    UIButton *searchBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBTN setImage:[UIImage imageNamed:@"home_search"] forState:UIControlStateNormal];
    searchBTN.frame = CGRectMake(messageBtn.left-40,24 +statusbarHeight,40,40);
    searchBTN.contentMode = UIViewContentModeScaleAspectFit;
    [searchBTN addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    searchBTN.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [navi addSubview:searchBTN];
    
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 63+statusbarHeight, _window_width, 1) andColor:RGB(244, 245, 246) andView:navi];
    
}

-(void)messageBtnClick{
    MessageListVC *MC = [[MessageListVC alloc]init];
    [[MXBADelegate sharedAppDelegate]pushViewController:MC animated:YES];
}
-(void)search{
    searchVC *search = [[searchVC alloc]init];
    UINavigationController *naviSearch = [[UINavigationController alloc]initWithRootViewController:search];
//    [self presentViewController:naviSearch animated:YES completion:nil];
    [[MXBADelegate sharedAppDelegate]pushViewController:search animated:YES];

}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    oldOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > oldOffset) {
        if (scrollView.contentOffset.y > 0) {
            navi.hidden = YES;
            [self hideTabBar];
        }
    }else{
        navi.hidden = NO;
        [self showTabBar];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"%f",oldOffset);
}
#pragma mark ================ 隐藏和显示tabbar ===============
- (void)hideTabBar {
    
    if (self.tabBarController.tabBar.hidden == YES) {
        return;
    }
    self.tabBarController.tabBar.hidden = YES;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = YES;
}
- (void)showTabBar

{
    if (self.tabBarController.tabBar.hidden == NO)
    {
        return;
    }
    self.tabBarController.tabBar.hidden = NO;
    ZYTabBar *tabbar = (ZYTabBar *)self.tabBarController.tabBar;
    tabbar.plusBtn.hidden = NO;
    
}

@end
