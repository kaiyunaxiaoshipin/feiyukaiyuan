//
//  classVC.m
//  yunbaolive
//
//  Created by Boom on 2018/9/22.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "classVC.h"
#import "hotModel.h"
#import "LivePlay.h"
#import <CommonCrypto/CommonCrypto.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HotCollectionViewCell.h"

@interface classVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSDictionary *selectedDic;
    NSString *type_val;//
    NSString *livetype;//
    int page;
    UIView *collectionHeaderView;
    UIAlertController *md5AlertController;
    UIView *nothingView;
    YBNoWordView *noNetwork;
    NSString *_sdkType;//0-金山  1-腾讯

}
@property(nonatomic,strong)NSMutableArray *zhuboModel;//主播模型
@property(nonatomic,strong)NSMutableArray *infoArray;//获取到的主播列表信息
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *MD5;//加密密码

@end

@implementation classVC
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = _titleStr;
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArray = [NSMutableArray array];
    _zhuboModel = [NSMutableArray array];
    page = 1;
    [self navtion];
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width/2-4.5, (_window_width/2-4.5) );
    flow.minimumLineSpacing = 3;
    flow.minimumInteritemSpacing = 3;
    flow.sectionInset = UIEdgeInsetsMake(3, 3,3, 3);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height-64-statusbarHeight) collectionViewLayout:flow];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotCollectionViewCELL"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV"];
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
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
    [self pullInternet];

    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = YZMsg(@"暂时没有主播开播");
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = YZMsg(@"赶快去其他频道逛逛吧～");
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:label2];
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self pullInternet];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];
}
- (void)pullInternet{
    [YBToolClass postNetworkWithUrl:@"Home.getClassLive" andParameter:@{@"p":@(page),@"liveclassid":_classID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        noNetwork.hidden = YES;

        if (code == 0) {
            if (page == 1) {
                [_infoArray removeAllObjects];
                [_zhuboModel removeAllObjects];
            }
            [_infoArray addObjectsFromArray:info];
            for (NSDictionary *dic in info) {
                hotModel *model = [[hotModel alloc]initWithDic:dic];
                [_zhuboModel addObject:model];
            }
            [_collectionView reloadData];
            if ([info count] <= 0) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        if (_infoArray.count == 0) {
            nothingView.hidden = NO;
        }else{
            nothingView.hidden = YES;
        }
    } fail:^{
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
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
                
                type_val =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type_val"]];
                livetype =  [NSString stringWithFormat:@"%@",[info valueForKey:@"type"]];
                _sdkType = minstr([info valueForKey:@"live_sdk"]);

                if ([type isEqual:@"0"]) {
                    [self pushMovieVC];
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
                            [self pushMovieVC];
                        }else{
                            alertTextField.text = @"";
                            [MBProgressHUD showError:YZMsg(@"密码错误")];
                            [self presentViewController:md5AlertController animated:true completion:nil];
                            return ;
                        }
                        
                    }]];
                    
                    
                    //present出AlertView
                    [self presentViewController:md5AlertController animated:true completion:nil];
                }
                else if ([type isEqual:@"2"] || [type isEqual:@"3"]){
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
                    [self presentViewController:alertContro animated:YES completion:nil];
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
    player.scrollarray = _infoArray;
    player.scrollindex = 0;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
