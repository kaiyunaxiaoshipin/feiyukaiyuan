//
//  MessageFansVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageFansVC.h"

#import "MessageFansModel.h"
#import "MessageFansCell.h"
//#import "CenterVC.h"

@interface MessageFansVC ()<UITableViewDelegate,UITableViewDataSource>
{
    int _paging;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSArray *models;

@end

@implementation MessageFansVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateArray = [NSMutableArray array];
    self.models = [NSArray array];
    _paging = 1;
    [self creatNavi];
    [self.view addSubview:self.tableView];
}
- (NSArray *)models {
    
    NSMutableArray *m_array = [NSMutableArray array];
    for (NSDictionary *dic in _dateArray) {
        MessageFansModel *model = [MessageFansModel modelWithDic:dic];
        [m_array addObject:model];
    }
    _models = m_array;
    
    return _models;
}

#pragma mark - 数据
-(void)refreshFooter {
    _paging +=1;
    [self pullData];
}
-(void)pullData {
    NSString *url = [purl stringByAppendingFormat:@"index.php?service=Message.fansLists&uid=%@&p=%d",[Config getOwnID],_paging];
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging==1) {
                [_dateArray removeAllObjects];
            }
            if (infoA.count==0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_dateArray addObjectsFromArray:infoA];
            }
            if (_dateArray.count<=0) {
                [PublicView showTextNoData:_tableView text1:@"" text2:@"你还没有收获粉丝"];
            }else {
                [PublicView hiddenTextNoData:_tableView];
            }
            [_tableView reloadData];
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:msg];
        }else {
//            [MBProgressHUD showError:msg];
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageFansCell *cell = [MessageFansCell cellWithTab:tableView andIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    cell.backgroundColor = CellRow_Cor;
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageFansModel *model = _models[indexPath.row];
//    CenterVC *center = [[CenterVC alloc]init];
//    if ([model.uidStr isEqualToString:[Config getOwnID]]) {
//        center.otherUid = [Config getOwnID];
//    }else {
//        center.otherUid = model.uidStr;
//    }
//    center.isPush = YES;
//    [self.navigationController pushViewController:center animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - set/get
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+statusbarHeight, _window_width, _window_height - 64-statusbarHeight)style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Black_Cor;
        
        YBWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _paging = 1;
            [weakSelf pullData];
        }];
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
        _tableView.mj_footer = footer;
        [footer setTitle:YZMsg(@"数据加载中...") forState:MJRefreshStateRefreshing];
        [footer setTitle:YZMsg(@"没有更多了哦~") forState:MJRefreshStateIdle];
        footer.stateLabel.font = [UIFont systemFontOfSize:15.0f];
        footer.automaticallyHidden = YES;
        
    }
    return _tableView;
}

#pragma mark - 导航
-(void)creatNavi {
    YBNavi *navi = [[YBNavi alloc]init];
    navi.leftHidden = NO;
    navi.rightHidden = YES;
    [navi ybNaviLeft:^(id btnBack) {
        [self.navigationController popViewControllerAnimated:YES];
    } andRightName:@"" andRight:^(id btnBack) {
        
    } andMidTitle:YZMsg(@"粉丝")];
    [self.view addSubview:navi];
}


@end
