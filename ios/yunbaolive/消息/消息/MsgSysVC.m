//
//  MsgSysVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/8/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MsgSysVC.h"
#import "MsgSysModel.h"
#import "MsgSysCell.h"
#import "webH5.h"

@interface MsgSysVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int _paging;
    YBNavi *navi;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSArray *sysModels;

@end

@implementation MsgSysVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pullData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    self.sysModels = [NSArray array];
    _paging = 1;
    [self creatNavi];
    [self.view addSubview:self.tableView];
}

#pragma mark -
- (NSArray *)sysModels {
    
    NSMutableArray *m_array = [NSMutableArray array];
    for (NSDictionary *dic in _dataArray) {
        MsgSysModel *model = [MsgSysModel modelWithDic:dic lisModel:_listModel];
        [m_array addObject:model];
    }
    _sysModels = m_array;
    return _sysModels;
}

-(void)pullData {
//    NSString *url;
//    if ([_listModel.uidStr isEqual:@"dsp_admin_1"]) {
//        //官方
//        url = [purl stringByAppendingFormat:@"index.php?service=Message.officialLists&p=%d",_paging];
//    }else{
//        //系统
//        url = [purl stringByAppendingFormat:@"index.php?service=Message.systemnotifyLists&uid=%@&p=%d",[Config getOwnID],_paging];
//    }
    NSString *url = [purl stringByAppendingFormat:@"index.php?service=Message.getList&uid=%@&p=%d&token=%@",[Config getOwnID],_paging,[Config getOwnToken]];

    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging == 1) {
                [_dataArray removeAllObjects];
            }
            if (infoA.count <=0 ) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_dataArray addObjectsFromArray:infoA];
            }
            if (_dataArray.count <=0) {
                [PublicView showTextNoData:_tableView text1:@"" text2:YZMsg(@"暂无收到消息")];
            }else{
                [PublicView hiddenTextNoData:_tableView];
            }
            if (_dataArray.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:minstr([[_dataArray firstObject] valueForKey:@"addtime"]) forKey:@"notifacationOldTime"];
            }
            [_tableView reloadData];
        }else{
//            [MBProgressHUD showError:msg];
            [MBProgressHUD showError:msg];
        }
    } Fail:^(id fail) {
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    }];

}
-(void)refreshFooter {
    _paging +=1;
    [self pullData];
}
#pragma mark - UITableViewDelegate、UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 80;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.sysModels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgSysCell *cell = [MsgSysCell cellWithTab:tableView andIndexPath:indexPath];
    cell.model = _sysModels[indexPath.row];
    cell.iconIV.image = [PublicObj getAppIcon];

//    cell.backgroundColor = CellRow_Cor;
//    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MsgSysModel *model = _sysModels[indexPath.row];
    if ([model.uidStr isEqual:@"dsp_admin_1"]) {
        webH5 *h5 = [[webH5 alloc]init];
        h5.urls = model.urlStr;
        [self.navigationController pushViewController:h5 animated:YES];
    }
    
}

#pragma mark - set/get
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height - 64-statusbarHeight-ShowDiff)style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = Black_Cor;
        
        //先设置预估行高
        _tableView.estimatedRowHeight = 200;
        //再设置自动计算行高
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        YBWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _paging = 1;
            [weakSelf pullData];
        }];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
        _tableView.mj_footer = footer;
        [footer setTitle:YZMsg(@"数据加载中...") forState:MJRefreshStateRefreshing];
        [footer setTitle:YZMsg(@"没有更多了哦~") forState:MJRefreshStateIdle];
        [footer setTitle:YZMsg(@"没有更多了哦~") forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
        footer.automaticallyHidden = YES;
        
    }
    return _tableView;
}

#pragma mark - 导航
-(void)creatNavi {
    navi = [[YBNavi alloc]init];
    navi.leftHidden = NO;
    navi.rightHidden = YES;
    [navi ybNaviLeft:^(id btnBack) {
        if (_dataArray.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:minstr([[_dataArray firstObject] valueForKey:@"addtime"]) forKey:@"notifacationOldTime"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } andRightName:@"" andRight:^(id btnBack) {
        
    } andMidTitle:YZMsg(@"系统消息")];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navi.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navi];
    [self.view addSubview:navi];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)reloadSystemView{
    UIView *smallNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 35)];
    smallNavi.backgroundColor = RGB_COLOR(@"#f9fafb", 1);
    [self.view addSubview:smallNavi];
    
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
    titleLabel.text = YZMsg(@"系统消息");
    [smallNavi addSubview:titleLabel];
    _tableView.frame = CGRectMake(0, 35, _window_width, _window_height*0.4-35);
}
- (void)hideSmallView{
    if (self.block) {
        self.block(0);
    }
}
@end
