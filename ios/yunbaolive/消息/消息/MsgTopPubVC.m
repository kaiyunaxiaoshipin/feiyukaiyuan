//
//  MsgTopPubVC.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MsgTopPubVC.h"

#import "MsgTopPubModel.h"
#import "MsgTopPubCell.h"
//#import "CenterVC.h"
#import "commentview.h"
//#import "commectDetails.h"
//#import "SingleVideoVC.h"

@interface MsgTopPubVC ()<UITableViewDelegate,UITableViewDataSource,MsgClickDelegate>
{
    int _paging;
    NSString *_noData2;
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dateArray;
@property(nonatomic,strong)NSArray *models;

@property(nonatomic,strong)commentview *comment;                     //评论


@end

@implementation MsgTopPubVC

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [IQKeyboardManager sharedManager].enable = YES;

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [IQKeyboardManager sharedManager].enable = NO;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
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
        //区分 赞、@我的、评论（有部分字段key值不一样）
        MsgTopPubModel *model = [MsgTopPubModel modelWithDic:dic vcType:_type];
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
    NSString *domain;
    if ([_type isEqual:@"赞"]){
        domain = @"Message.praiseLists";
    }else if ([_type isEqual:@"@我的"]){
       domain = @"Message.atLists";
    }else{//评论
        domain = @"Message.commentLists";
    }
    NSString *url = [purl stringByAppendingFormat:@"index.php?service=%@&uid=%@&p=%d",domain,[Config getOwnID],_paging];
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
                [PublicView showTextNoData:_tableView text1:@"" text2:_noData2];
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

#pragma mark - MsgClickDelegate
-(void)iconClickUid:(NSString *)uid {
//    CenterVC *center = [[CenterVC alloc]init];
//    if ([uid isEqualToString:[Config getOwnID]]) {
//        center.otherUid = [Config getOwnID];
//    }else {
//        center.otherUid = uid;
//    }
//    center.isPush = YES;
//    [self.navigationController pushViewController:center animated:YES];
}
- (void)coverClickVideoid:(NSString *)videoid {
    NSLog(@"播放视频");
    
    //无上下滑动(简洁版的LookVideo)
//    SingleVideoVC *s_vc = [[SingleVideoVC alloc]init];
//    s_vc.videoid = videoid;
//    [self.navigationController pushViewController:s_vc animated:YES];
    
}

#pragma mark - cell 点击事件
-(void)goVideo:(NSString *)videoid {
    [self coverClickVideoid:videoid];
}
-(void)goComment:(NSString *)videoid videoUid:(NSString *)videouid{
    
    YBWeakSelf;
    if (!_comment) {
        _comment = [[commentview alloc]initWithFrame:CGRectMake(0,_window_height, _window_width, _window_height) hide:^(NSString *type) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.comment.frame = CGRectMake(0, _window_height, _window_width, _window_height);
            } ];
        } andvideoid:videoid andhostid:videouid count:0 talkCount:^(id type) {
            
        } detail:^(id type) {
            [weakSelf pushdetails:type];
        } youke:^(id type) {
            [PublicObj warnLogin];
        } andFrom:@"消息事件"];
        
        [self.view addSubview:_comment];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.comment.frame = CGRectMake(0,0,_window_width, _window_height);
    }];
    
}
-(void)pushdetails:(NSDictionary *)type{
    
    /*  废弃
    YBWeakSelf;
    [_comment endEditing:YES];
    _comment.hidden = YES;
    commectDetails *detail = [[commectDetails alloc]init];
    detail.hostDic = type;
    detail.event = ^{
        weakSelf.comment.hidden = NO;
    };
    [self.navigationController pushViewController:detail animated:YES];
     */
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
    MsgTopPubCell *cell = [MsgTopPubCell cellWithTab:tableView andIndexPath:indexPath];
    cell.delegatge = self;
    cell.model = _models[indexPath.row];
    cell.backgroundColor = CellRow_Cor;
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MsgTopPubModel *model = _models[indexPath.row];
    /*
     * 赞 列表区分视频赞，还是评论赞
     * @我的、评论列表消息事件 cell点击都跳评论
     */
    if ([model.pageVC isEqual:@"赞"]&&[model.typeStr isEqual:@"1"]) {
        //跳视频
        [self goVideo:model.videoidStr];
    }else{
        //跳评论
        [self goComment:model.videoidStr videoUid:model.videouidStr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
    } andMidTitle:@""];
    if ([_type isEqual:@"赞"]){
        navi.midTitleL.text = YZMsg(@"赞");
        _noData2 = YZMsg(@"你还没有被赞哦");
    }else if ([_type isEqual:@"@我的"]){
         navi.midTitleL.text = YZMsg(@"@我的");
        _noData2 = YZMsg(@"你还没有被@哦");
    }else{
        //评论
         navi.midTitleL.text = YZMsg(@"评论");
        _noData2 = YZMsg(@"你还没有收到评论");
    }
    [self.view addSubview:navi];
}



@end
