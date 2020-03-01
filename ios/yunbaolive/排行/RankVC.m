//
//  RankVC.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/1.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "RankVC.h"

#import "RankModel.h"
#import "RankCell.h"
#import "otherUserMsgVC.h"

@interface RankVC ()<UITableViewDelegate,UITableViewDataSource> {
    UISegmentedControl *segment1;    //收益榜、消费榜榜
    UILabel *line1;                  //收益榜下划线
    UILabel *line2;                  //消费榜榜下划线
    int paging;
    NSArray *oneArr;                  //收益-消费
    NSArray *twoArr;                  //日-周-月-总
    NSMutableArray *btnArray;        //日-周-月-总 按钮数组
    int selectTypeIndex;
    UIImageView  *navi;
    YBNoWordView *noNetwork;

}
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSArray *models;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation RankVC

-(void)pullData {
    
    NSString *postUrl =oneArr[segment1.selectedSegmentIndex];
    NSDictionary *postDic = @{@"uid":[Config getOwnID],
                              @"type":twoArr[selectTypeIndex],
                              @"p":@(paging)
                              };
    postUrl = [purl stringByAppendingFormat:@"?service=%@",postUrl];
    [YBNetworking postWithUrl:postUrl Dic:postDic Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        noNetwork.hidden = YES;
        _tableView.hidden = NO;
        if ([code isEqual:@"0"]) {
            NSArray *infoA = [data valueForKey:@"info"];
            if (paging == 1) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:infoA];
            if (infoA.count <=10) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
            if (paging == 1) {
                [self resetTableHeaderView];
            }
        }else {
            [MBProgressHUD showError:msg];
        }
    } Fail:^(id fail) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (_dataArray.count == 0) {
            noNetwork.hidden = NO;
            _tableView.hidden = YES;
        }
        [MBProgressHUD showError:@"网络请求失败"];
    }];
    
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    oneArr = @[@"Home.profitList",@"Home.consumeList"];
    twoArr = @[@"day",@"week",@"month",@"total"];
    [self creatNavi];
    
    paging = 1;
    [self.view addSubview:self.tableView];
    [self creatTableHeaderView];
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self pullData];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];

}
#pragma mark -
#pragma mark - UISegmentedControl
- (void)segmentChange:(UISegmentedControl *)seg{
    if (segment1.selectedSegmentIndex == 0) {
        line1.hidden = NO;
        line2.hidden = YES;
    }else if (segment1.selectedSegmentIndex == 1){
        line1.hidden = YES;
        line2.hidden = NO;
    }
    
    [self pullData];
}
-(UIImage *)drawBckgroundImage:(CGFloat)r :(CGFloat)g :(CGFloat)b {
    CGSize size = CGSizeMake(2, 35);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, r/255.0, g/255.0, b/255.0, 1);
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark -
#pragma mark - 点击事件
-(void)clickFollowBtn:(UIButton *)btn {
    
    btn.enabled = NO;
    RankModel *model = [[RankModel alloc] initWithDic:[_dataArray objectAtIndex:btn.tag - 10085]];
    if ([model.uidStr isEqual:[Config getOwnID]]) {
        [MBProgressHUD showError:YZMsg(@"不能关注自己")];
        btn.enabled = YES;
        return;
    }
    NSString *postUrl = @"User.setAttent";
    NSDictionary *postDic = @{@"uid":[Config getOwnID],
                              @"touid":model.uidStr
                              };
    postUrl = [purl stringByAppendingFormat:@"?service=%@",postUrl];
    [YBNetworking postWithUrl:postUrl Dic:postDic Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        btn.enabled = YES;
        if ([code isEqual:@"0"]) {
            NSString *isAtt = YBValue([[data valueForKey:@"info"] firstObject], @"isattent");
            NSMutableDictionary *needReloadDic = [NSMutableDictionary dictionaryWithDictionary:_dataArray[btn.tag - 10085]];
            [needReloadDic setValue:isAtt forKey:@"isAttention"];
            NSMutableArray *m_arr = [NSMutableArray arrayWithArray:_dataArray];
            [m_arr replaceObjectAtIndex:(btn.tag - 10085) withObject:needReloadDic];
            _dataArray = [m_arr mutableCopy];
            
            if (btn.tag >= 10088) {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(btn.tag - 10088) inSection:0];
                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                btn.selected = !btn.selected;
            }
            
        }
    } Fail:^(id fail) {
         btn.enabled = YES;
    }];
    
}
#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 ) {
        return 0.01;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        return (_window_width*2/3*296/626 + 50);
//    }
    return 75;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count <= 3) {
        return 0;
    }
    return self.dataArray.count-3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RankModel *model = [[RankModel alloc] initWithDic:[_dataArray objectAtIndex:indexPath.row+3]];
    RankCell *cell = [RankCell cellWithTab:tableView indexPath:indexPath];
    //收益榜-0 消费榜-1
    if (segment1.selectedSegmentIndex==0) {
        model.type = @"0";
    }else{
        model.type = @"1";
    }
    cell.otherMCL.text = [NSString stringWithFormat:@"NO.%ld",indexPath.row+4];
    cell.model = model;
    
    [cell.followBtn addTarget:self action:@selector(clickFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.followBtn.tag = 10088 + indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -
#pragma mark - tableView
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, navi.height, _window_width, _window_height-49-(navi.height)-ShowDiff) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            paging = 1;
            [self pullData];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            paging +=1;
            [self pullData];
        }];
        
        [_tableView.mj_header setBackgroundColor:RGB_COLOR(@"#feca2e", 1)];
    }
    return _tableView;
}
- (void)resetTableHeaderView{
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/75*52)];
    headerImgView.userInteractionEnabled = YES;
    headerImgView.image = [UIImage imageNamed:@"rank_bottom"];
    [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:1]];
    [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:2]];
    [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:3]];
    
    if (_dataArray.count > 2) {
        [headerImgView addSubview:[self creatTopCellWithUserMsg:_dataArray[0] andNum:1]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:_dataArray[1] andNum:2]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:_dataArray[2] andNum:3]];
    }else if (_dataArray.count == 2) {
        [headerImgView addSubview:[self creatTopCellWithUserMsg:_dataArray[0] andNum:1]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:_dataArray[1] andNum:2]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:3]];
    }else if (_dataArray.count == 1) {
        [headerImgView addSubview:[self creatTopCellWithUserMsg:_dataArray[0] andNum:1]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:2]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:3]];
    }else{
        [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:1]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:2]];
        [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:3]];
    }
    
    _tableView.tableHeaderView = headerImgView;

}
- (void)creatTableHeaderView{
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/75*52)];
    headerImgView.userInteractionEnabled = YES;
    headerImgView.image = [UIImage imageNamed:@"rank_bottom"];
    [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:1]];
    [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:2]];
    [headerImgView addSubview:[self creatTopCellWithUserMsg:nil andNum:3]];
    _tableView.tableHeaderView = headerImgView;
}
- (UIView *)creatTopCellWithUserMsg:(NSDictionary *)dic andNum:(int)num{
    UIView *view = [[UIView alloc]init];
    CGFloat width;
    UITapGestureRecognizer *tap;
    if (num == 1) {
        width = (_window_width - 14 -30)*5/13;
        view.frame = CGRectMake(_window_width/2-width/2, 10, width, width*1.61);
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(num1Click:)];
    }
    if (num == 2) {
        width = (_window_width - 14 -30)*4/13;
        view.frame = CGRectMake(15, 25, width, width*1.8);
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(num2Click:)];
        
    }
    if (num == 3) {
        width = (_window_width - 14 -30)*4/13;
        view.frame = CGRectMake(_window_width-width-15, 25, width, width*1.8);
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(num3Click:)];
        
    }
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
    UIImageView *numImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 15, 24)];
    numImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_num%d",num]];
    numImgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:numImgView];
    [view addGestureRecognizer:tap];
    if (dic) {
        //头像边框
        UIImageView *headerImgView = [[UIImageView alloc]init];
        headerImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"rank_header%d",num]];
        //头像
        UIImageView *iconImgView = [[UIImageView alloc]init];
        //名字
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.font = [UIFont boldSystemFontOfSize:15];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = RGB_COLOR(@"#959697", 1);
        nameLabel.text = minstr([dic valueForKey:@"user_nicename"]);
        [view addSubview:nameLabel];
        
        if (num == 1) {
            iconImgView.frame = CGRectMake(view.width/2-view.width*13/25/2, 10+view.width/25*6, view.width*13/25, view.width*13/25);
            if (![PublicObj checkNull:[dic valueForKey:@"avatar_thumb"]]) {
                 [iconImgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"avatar_thumb"]]];
            }
            [view addSubview:iconImgView];
            headerImgView.frame =CGRectMake(view.width/2-view.width*195/250/2, 10, view.width*195/250, view.width*195/250);
            nameLabel.frame = CGRectMake(0, headerImgView.bottom, view.width, view.width/25*5);
        }else{
            iconImgView.frame = CGRectMake(view.width/2-view.width*9/20/2, 10+view.width/200*45, view.width*9/20, view.width*9/20);
            if (![PublicObj checkNull:[dic valueForKey:@"avatar_thumb"]]) {
                [iconImgView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"avatar_thumb"]]];
            }
            [view addSubview:iconImgView];
            headerImgView.frame =CGRectMake(view.width/2-view.width*14/20/2, 10, view.width*14/20, view.width*14/20);
            nameLabel.frame = CGRectMake(0, headerImgView.bottom, view.width, view.width/200*55);
        }
        iconImgView.layer.cornerRadius = iconImgView.width/2;
        iconImgView.layer.masksToBounds = YES;
        [view addSubview:headerImgView];
        
        //等级
        UIImageView *levelImgView = [[UIImageView alloc]init];
        levelImgView.frame = CGRectMake(view.width/2, nameLabel.bottom, _window_width*0.08, _window_width*0.04);
//        levelImgView.image = [UIImage imageNamed:@"leve1"];
        if (segment1.selectedSegmentIndex==0) {
            NSDictionary *levelDic = [common getAnchorLevelMessage:minstr([dic valueForKey:@"level_anchor"])];
            [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
            
        }else {

            NSDictionary *levelDic = [common getUserLevelMessage:minstr([dic valueForKey:@"level"])];
            [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
        }

        [view addSubview:levelImgView];
        //性别
        UIImageView *sexImgView = [[UIImageView alloc]init];
        sexImgView.frame = CGRectMake(levelImgView.left-_window_width*0.04-3, nameLabel.bottom, _window_width*0.04, _window_width*0.04);
        if ([minstr([dic valueForKey:@"sex"]) isEqual:@"1"]) {
            sexImgView.image = [UIImage imageNamed:@"sex_man"];
        }else{
            sexImgView.image = [UIImage imageNamed:@"sex_woman"];
        }
        [view addSubview:sexImgView];
        UILabel *votesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, sexImgView.bottom, view.width, levelImgView.height*2)];
        votesLabel.font = [UIFont systemFontOfSize:12];
        votesLabel.textAlignment = NSTextAlignmentCenter;
        votesLabel.textColor = normalColors;
        [votesLabel setAttributedText:[self setAttStr:minstr([dic valueForKey:@"totalcoin"])]];
        [view addSubview:votesLabel];
        //关注按钮
        UIButton *attionBtn = [UIButton buttonWithType:0];
        attionBtn.frame = CGRectMake(view.width/2-_window_width*0.06, votesLabel.bottom, _window_width*0.12, _window_width*0.12*4/9);
        [attionBtn setImage:[UIImage imageNamed:@"fans_关注"] forState:UIControlStateNormal];
        [attionBtn setImage:[UIImage imageNamed:@"fans_已关注"] forState:UIControlStateSelected];
        if ([minstr([dic valueForKey:@"isAttention"]) isEqual:@"1"]) {
            attionBtn.selected = YES;
        }else{
            attionBtn.selected = NO;
        }
        attionBtn.tag = 10084+num;
        [attionBtn addTarget:self action:@selector(clickFollowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:attionBtn];
    }else{
        UIImageView *nothingImgView = [[UIImageView alloc]initWithFrame:CGRectMake(view.width*0.3, 50, view.width*0.4, view.width*0.4)];
        nothingImgView.image = [UIImage imageNamed:@"rank_nothing"];
        [view addSubview:nothingImgView];
        
        UILabel *nothingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, nothingImgView.bottom+10, view.width, 20)];
        nothingLabel.text = YZMsg(@"暂时空缺");
        nothingLabel.textAlignment = NSTextAlignmentCenter;
        nothingLabel.textColor = RGB_COLOR(@"#c8c8c8", 1);
        nothingLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview:nothingLabel];
    }
    return view;
}
- (NSMutableAttributedString *)setAttStr:(NSString *)votes{
    NSString *name;
    if (segment1.selectedSegmentIndex==0) {
        name = [common name_votes];
    }else{
        name = [common name_coin];
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",votes,name]];
    [att addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(@"#c7c8c9", 1) range:NSMakeRange(votes.length+1, name.length)];
    return att;
}
#pragma mark -
#pragma mark - navi
-(void)creatNavi {
    CGFloat naviHeight = _window_width/75*21+statusbarHeight > 105 ?  _window_width/75*21+statusbarHeight:105;
    navi = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, naviHeight)];
    navi.userInteractionEnabled = YES;
    navi.image = [UIImage imageNamed:@"rank_navi"];
    [self.view addSubview:navi];
    
    NSArray *sgArr1 = [NSArray arrayWithObjects:@"收益榜",YZMsg(@"贡献榜"), nil];
    segment1 = [[UISegmentedControl alloc]initWithItems:sgArr1];
    segment1.frame = CGRectMake(_window_width/2-80, 27+statusbarHeight, 160, 30);
    segment1.tintColor = [UIColor clearColor];
    NSDictionary *nomalC = [NSDictionary dictionaryWithObjectsAndKeys:fontThin(15),NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segment1 setTitleTextAttributes:nomalC forState:UIControlStateNormal];
    NSDictionary *selC = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:16],NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segment1 setTitleTextAttributes:selC forState:UIControlStateSelected];
    segment1.selectedSegmentIndex = 0;
    [segment1 addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    [navi addSubview:segment1];
    
    line1 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-80+25, segment1.bottom, 30, 3)];
    line1.backgroundColor = [UIColor whiteColor];
    line1.hidden = NO;
    line1.layer.cornerRadius = 1.5;
    line1.layer.masksToBounds  =YES;
    [navi addSubview:line1];
    line2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-80+25+80, segment1.bottom, 30, 3)];
    line2.backgroundColor = [UIColor whiteColor];
    line2.layer.cornerRadius = 1.5;
    line2.layer.masksToBounds  =YES;
    line2.hidden = YES;
    [navi addSubview:line2];
    btnArray = [NSMutableArray array];
    NSArray *sgArr2 = [NSArray arrayWithObjects:YZMsg(@"日榜"),YZMsg(@"周榜"),YZMsg(@"月榜"),YZMsg(@"总榜"), nil];
    CGFloat speace = (_window_width*0.84 - 60*4)/3;
    for (int i = 0; i < sgArr2.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(_window_width*0.08+i*(60+speace), line1.bottom+15, 60, 24);
        [btn setTitle:sgArr2[i] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 3.0;
        btn.layer.masksToBounds = YES;
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = [UIColor clearColor].CGColor;
        btn.tag = 1000086+i;
        if (i == 0) {
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        [btn addTarget:self action:@selector(changeRankType:) forControlEvents:UIControlEventTouchUpInside];
        [navi addSubview:btn];
        [btnArray addObject:btn];
    }
}
- (void)changeRankType:(UIButton *)sender{
    selectTypeIndex = (int)sender.tag - 1000086;
    for (UIButton *btn in btnArray) {
        if (btn == sender) {
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
        }else{
            btn.layer.borderColor = [UIColor clearColor].CGColor;
        }
    }
    [self pullData];
}
- (void)num1Click:(id)tap{
    if (_dataArray.count>0) {
        RankModel *model = [[RankModel alloc] initWithDic:[_dataArray objectAtIndex:0]];
        [self pushUserMessageVC:model.uidStr];
    }else{
        [MBProgressHUD showError:YZMsg(@"暂时空缺")];
    }
}

- (void)num2Click:(id)tap{
    if (_dataArray.count>1) {
        RankModel *model = [[RankModel alloc] initWithDic:[_dataArray objectAtIndex:1]];
        [self pushUserMessageVC:model.uidStr];
    }else{
        [MBProgressHUD showError:YZMsg(@"暂时空缺")];
    }
    
}

- (void)num3Click:(id)tap{
    if (_dataArray.count>2) {
        RankModel *model = [[RankModel alloc] initWithDic:[_dataArray objectAtIndex:2]];
        [self pushUserMessageVC:model.uidStr];
    }else{
        [MBProgressHUD showError:YZMsg(@"暂时空缺")];
    }
    
}
- (void)pushUserMessageVC:(NSString *)uid{
    otherUserMsgVC *person = [[otherUserMsgVC alloc]init];
    person.userID = uid;
    [[MXBADelegate sharedAppDelegate] pushViewController:person animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
