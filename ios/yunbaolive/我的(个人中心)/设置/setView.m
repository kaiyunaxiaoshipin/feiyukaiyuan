

#import "setView.h"
#import "InfoEdit2TableViewCell.h"
#import "ZFModalTransitionAnimator.h"
#import "userItemCell5.h"
#import "getpasswangViewController.h"
#import "PhoneLoginVC.h"
#import "AppDelegate.h"
#import "webH5.h"
#import <SDWebImage/SDImageCache.h>

@interface setView ()<UITableViewDataSource,UITableViewDelegate>
{
    int setvissssaaasas;
    int isNewBuid;//判断是不是最新版本
    NSArray *infoArray;
    float MBCache;
}
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@end
@implementation setView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = RGB(246, 246, 246);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.frame = CGRectMake(0, 64+statusbarHeight, _window_width, _window_height - 64 - statusbarHeight);
    
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    
    //换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    MBCache = bytesCache/1000/1000;
    
    [self requestData];
}
- (void)requestData{
    [YBToolClass postNetworkWithUrl:@"User.getPerSetting" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            infoArray = info;
            [self.tableView reloadData];
        }
    } fail:^{
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvissssaaasas = 0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    setvissssaaasas = 1;
    self.navigationController.navigationBarHidden = YES;

    [self navtion];
//    [self.tableView reloadData];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = [UIColor whiteColor];
    UILabel *labels = [[UILabel alloc]init];
    labels.text = _titleStr;
    [labels setFont:navtionTitleFont];
    labels.textColor = navtionTitleColor;
    labels.frame = CGRectMake(0,statusbarHeight,_window_width,84);
    labels.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:labels];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];

    [self.view addSubview:navtion];
}
-(void)doReturn{    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIFont *font = [UIFont fontWithName:@"Heiti SC" size:15];
    if (indexPath.section == 0) {
        NSDictionary *subDic = infoArray[indexPath.row];

        NSString *itemID = minstr([subDic valueForKey:@"id"]);
        if ([itemID intValue] == 16) {
            InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
            cell.labContrName.text = minstr([subDic valueForKey:@"name"]);
            cell.labContrName.font = font;
            NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];//本地的版本号
            cell.labDetail.text = build;
//            NSString *hisBuild = [common ipa_ver];//远程存储的版本号
//            NSNumber *local = (NSNumber *)build;
//            NSNumber *internet = (NSNumber *)hisBuild;
//            NSComparisonResult r = [local compare:internet];
//            if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
//                NSMutableAttributedString *attributeall = [[NSMutableAttributedString alloc]init];
//                NSString *string = [NSString stringWithFormat:@"%@",local];
//                NSMutableAttributedString *version = [[NSMutableAttributedString alloc]initWithString:string];
//                [attributeall appendAttributedString:version];
//                NSMutableAttributedString *now = [[NSMutableAttributedString alloc]initWithString:@"(当前版本可更新)"];
//                [attributeall appendAttributedString:now];
//                [attributeall addAttribute:NSForegroundColorAttributeName value:normalColors range:NSMakeRange(0, version.length)];
//                cell.labDetail.attributedText = attributeall;
//                isNewBuid = 1;
//            }
//            else{
//                isNewBuid = 0;
//                //(当前已是最新版本)
//                NSMutableAttributedString *attributeall = [[NSMutableAttributedString alloc]init];
//                NSString *string = [NSString stringWithFormat:@"%@",local];
//                NSMutableAttributedString *version = [[NSMutableAttributedString alloc]initWithString:string];
//                [attributeall appendAttributedString:version];
//                NSMutableAttributedString *now = [[NSMutableAttributedString alloc]initWithString:@"(当前已是最新版本)"];
//                [attributeall appendAttributedString:now];
//                [attributeall addAttribute:NSForegroundColorAttributeName value:normalColors range:NSMakeRange(0, version.length)];
//                cell.labDetail.attributedText = attributeall;
//            }
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            //ios_shelves 为上架版本号，与本地一致则为上架版本,需要隐藏一些东西
            NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地 build
            NSString *buildsss = [NSString stringWithFormat:@"%@",app_build];
            if (![[common ios_shelves] isEqual:buildsss]) {
                cell.hidden = NO;
                
            }else
            {
                cell.hidden = YES;
            }
            return cell;

        }else{
            NSDictionary *subDic = infoArray[indexPath.row];
            InfoEdit2TableViewCell *cell = [InfoEdit2TableViewCell cellWithTableView:tableView];
            cell.labContrName.text = minstr([subDic valueForKey:@"name"]);
            cell.labContrName.font = font;
            if ([itemID intValue] == 18) {
                cell.labDetail.text = [NSString stringWithFormat:@"%.2fMB",MBCache];
            }else{
                cell.labDetail.text = @"";
            }
            return cell;

        }
        }
    else
    {
        userItemCell5 *cell = [[NSBundle mainBundle]loadNibNamed:@"userItemCell5" owner:self options:nil].lastObject;
        
            return cell;
    
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //判断当前分区返回分区行数
    if (section == 0 ) {
        return infoArray.count;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //返回分区数
    return 2;
}
- ( CGFloat )tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 6;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger) section
{
    return 1;
}
//点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSDictionary *subDic = infoArray[indexPath.row];
        int idd = [minstr([subDic valueForKey:@"id"]) intValue];
        switch (idd) {
            case 0:
            {
                webH5 *web = [[webH5 alloc]init];
                web.urls = [NSString stringWithFormat:@"%@&uid=%@&token=%@",minstr([subDic valueForKey:@"href"]),[Config getOwnID],[Config getOwnToken]];
                [self.navigationController pushViewController:web animated:YES];
            }
                break;
            case 15:
            {
                //修改密码
                getpasswangViewController *tuisong = [[getpasswangViewController alloc]init];
                [self.navigationController pushViewController:tuisong animated:YES];
            }
                break;
            case 16:
            {
                //版本更新
                /*[self getbanben];
            }
                break;
            case 17:
            {
                NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
                NSLog(@"手机系统版本: %@", phoneVersion);
                //手机型号
                NSString* phoneModel = [[UIDevice currentDevice] model];
                NSLog(@"手机型号：%@",phoneModel);
                webH5 *web = [[webH5 alloc]init];
                web.urls = [NSString stringWithFormat:@"%@&uid=%@&token=%@&version=%@&model=%@",minstr([subDic valueForKey:@"href"]),[Config getOwnID],[Config getOwnToken],phoneVersion,phoneModel];
                [self.navigationController pushViewController:web animated:YES];
            }
                break;
            case 18:
            {*/
                //清除缓存
                [self clearCrash];
            }

                break;

        }    }
    else if (indexPath.section == 1){
        [self quitLogin];
    }
    
}
-(void)getbanben{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSNumber *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];//本地
    NSNumber *build = (NSNumber *)[common ipa_ver];//远程
    NSComparisonResult r = [app_build compare:build];
if (r == NSOrderedAscending || r == NSOrderedDescending) {//可改为if(r == -1L)
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[common app_ios]]];
            [MBProgressHUD hideHUD];
    }else if(r == NSOrderedSame) {//可改为if(r == 0L)
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:YZMsg(@"当前已是最新版本") message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                    [alert show];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)clearTmpPics
{
//    [[SDImageCache sharedImageCache] clearDisk];
 
}
//MARK:-设置tableivew分割线
-(void)setTableViewSeparator
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPa
{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//退出登录函数
-(void)quitLogin
{
//    NSString *aliasStr = [NSString stringWithFormat:@"youke"];
//    [JPUSHService setAlias:aliasStr callbackSelector:nil object:nil];
    [YBToolClass postNetworkWithUrl:@"Login.logout" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [JMSGUser logout:^(id resultObject, NSError *error) {
                if (!error) {
                    NSLog(@"极光IM退出登录成功");
                } else {
                    NSLog(@"极光IM退出登录失败");
                }
            }];
            
            [Config clearProfile];
            UIApplication *app =[UIApplication sharedApplication];
            AppDelegate *app2 = (AppDelegate*)app.delegate;
            PhoneLoginVC *login = [[PhoneLoginVC alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            app2.window.rootViewController = nav;

        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
- (void)clearCrash{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    [_tableView reloadData];
    MBCache = 0;
    [MBProgressHUD showError:YZMsg(@"缓存已清除")];
}
@end
