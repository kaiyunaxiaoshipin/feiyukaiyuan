#import "attentionViewC.h"
#import "hotModel.h"
#import "LivePlay.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HotCollectionViewCell.h"
#import "ZYTabBar.h"

@interface attentionViewC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    NSDictionary *selectedDic;
    UIView *nothingView;//直播无网络的时候显示
    UILabel *labelFirst;
    UILabel *labelSecond;

    UIAlertController *alertController;//邀请码填写
    UITextField *codetextfield;
    NSString *type_val;//
    NSString *livetype;//
    CGFloat oldOffset;
    int page;
    UIAlertController *md5AlertController;
    YBNoWordView *noNetwork;
    NSString *_sdkType;//0-金山  1-腾讯


}
@property(nonatomic,strong)NSMutableArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSMutableArray *infoArray;//获取到的主播列表信息
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;//加密密码
@end
@implementation attentionViewC
//懒加载
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self pullInternet];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    oldOffset = 0;
    type_val = @"0";
    livetype = @"0";
    page = 1;
    self.infoArray    =  [NSMutableArray array];
    self.zhuboModel    =  [NSMutableArray array];
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2-4.5, (_window_width/2-4.5));
    flow.minimumLineSpacing = 3;
    flow.minimumInteritemSpacing = 3;
    flow.sectionInset = UIEdgeInsetsMake(3, 3,3, 3);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) collectionViewLayout:flow];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotCollectionViewCELL"];
    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self pullInternet];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self pullInternet];
    }];
    _collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = UIEdgeInsetsMake(64+statusbarHeight, 0, 0, 0);
    [self createView];

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
-(void)createView{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    labelFirst = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    labelFirst.font = [UIFont systemFontOfSize:14];
//    labelFirst.text = YZMsg(@"附近没有主播开播");
    labelFirst.textAlignment = NSTextAlignmentCenter;
    labelFirst.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:labelFirst];
    labelSecond = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    labelSecond.font = [UIFont systemFontOfSize:13];
//    labelSecond.text = YZMsg(@"去首页看看其他主播的直播吧～");
    labelSecond.textAlignment = NSTextAlignmentCenter;
    labelSecond.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:labelSecond];
    
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self pullInternet];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];

}
-(void)pullInternet{
    [YBToolClass postNetworkWithUrl:@"Home.getFollow" andParameter:@{@"p":@(page)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        noNetwork.hidden = YES;
        if (code == 0) {
            if (page == 1) {
                [_infoArray removeAllObjects];
                [_zhuboModel removeAllObjects];
            }
            NSArray *infoList = [[info firstObject] valueForKey:@"list"];
            [_infoArray addObjectsFromArray:infoList];
            for (NSDictionary *dic in infoList) {
                hotModel *model = [[hotModel alloc]initWithDic:dic];
                [_zhuboModel addObject:model];
            }
            [_collectionView reloadData];
            if ([infoList count] <= 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }

            if (self.infoArray.count == 0) {
                labelFirst.text = minstr([[info firstObject] valueForKey:@"title"]);
                labelSecond.text = minstr([[info firstObject] valueForKey:@"des"]);
                nothingView.hidden = NO;
            }else{
                nothingView.hidden = YES;
            }

        }else{
            if (self.infoArray.count == 0) {
                nothingView.hidden = NO;
            }else{
                nothingView.hidden = YES;
            }
        }

    } fail:^{
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        nothingView.hidden = YES;
        if (_infoArray.count == 0) {
            noNetwork.hidden = NO;
        }
        [MBProgressHUD showError:@"网络请求失败"];
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _zhuboModel.count;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    selectedDic = _infoArray[indexPath.row];
    [self checklive:[selectedDic valueForKey:@"stream"] andliveuid:[selectedDic valueForKey:@"uid"]];
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotCollectionViewCell *cell = (HotCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HotCollectionViewCELL" forIndexPath:indexPath];
    cell.model = _zhuboModel[indexPath.row];
    
    return cell;
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
                            [self pushMovieVC];
                        }else{
                            alertTextField.text = @"";
                            [MBProgressHUD showError:YZMsg(@"密码错误")];
                            [self presentViewController:md5AlertController animated:true completion:nil];
                            return ;
                        }
                        
                    }]];
                    
                    [self presentViewController:md5AlertController animated:YES completion:nil];

                    //present出AlertView
                }else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
                    //收费
                    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"提示") message:minstr([info valueForKey:@"type_msg"]) preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [self dismissViewControllerAnimated:NO completion:nil];
                        
                    }];
                    [alertContro addAction:cancleAction];
                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self doCoast];
                    }];
                    [alertContro addAction:sureAction];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self presentViewController:alertContro animated:YES completion:nil];
                    });
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
    player.scrollarray = self.infoArray;
    player.playDoc = selectedDic;
       player.type_val = type_val;
      player.livetype = livetype;
    player.sdkType = _sdkType;
    [[MXBADelegate sharedAppDelegate] pushViewController:player animated:YES];
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
#pragma mark ================ socrollview代理 ===============
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    oldOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > oldOffset) {
        if (scrollView.contentOffset.y > 0) {
            _pageView.hidden = YES;
            [self hideTabBar];
        }
    }else{
        _pageView.hidden = NO;
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
