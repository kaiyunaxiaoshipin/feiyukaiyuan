//
//  anchorOnline.m
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "anchorOnline.h"

@implementation anchorOnline{
    UIView *whiteView;
    UITableView *listTable;
    int page;
    NSMutableArray *infoArray;
    UIButton *searchBtn;
    UIButton *closeBtn;
    
    int searchP;
    UITableView *searchTable;
    UILabel *searchNotingL;
    NSMutableArray *searchInfo;

}
//空白按钮
- (void)hideBtnClick{
    [_searchT resignFirstResponder];
}
- (void)cancelSearch{
    _searchT.text = @"";
    _searchT.frame = CGRectMake(_window_width-40, 5, 0, 30);
    searchBtn.hidden = NO;
    CATransition *transition = [CATransition animation];    //创建动画效果类
    transition.duration = 0.3; //设置动画时长
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
    transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};设置动画类型，移入，推出等
    //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
    transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    
    //    transition.delegate = self; 　　　　　　//设置属性依赖
    [searchTable.layer addAnimation:transition forKey:nil];       //在图层增加动画效果
    searchTable.hidden = YES;
    [searchInfo removeAllObjects];
    [searchTable reloadData];
}
//关闭按钮
- (void)hideSelf{
    if (closeBtn.selected) {
        closeBtn.selected = NO;
        [_searchT resignFirstResponder];
        [self cancelSearch];
        return;
    }
    [self.delegate removeShouhuView];
}
//搜索按钮
- (void)searchBtnClick{
    closeBtn.selected = YES;
    searchBtn.hidden = YES;
    [_searchT becomeFirstResponder];
    searchTable.hidden = NO;
    CATransition *transition = [CATransition animation];    //创建动画效果类
    transition.duration = 0.3; //设置动画时长
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
    transition.type = kCATransitionPush;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};设置动画类型，移入，推出等
    //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
    transition.subtype = kCATransitionFromRight;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
    
//    transition.delegate = self; 　　　　　　//设置属性依赖
    [searchTable.layer addAnimation:transition forKey:nil];       //在图层增加动画效果
    
    [UIView animateWithDuration:0.3 animations:^{
        _searchT.frame = CGRectMake(40, 5, _window_width-80, 30);
    }];
}
- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.frame = CGRectMake(0, _window_height*0.45, _window_width, _window_height*0.55);
    }];

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    page = 1;
    searchP = 1;
    infoArray = [NSMutableArray array];
    searchInfo = [NSMutableArray array];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    UIButton *button = [UIButton buttonWithType:0];
    button.frame = CGRectMake(0, 0, _window_width, _window_height*0.45);
    [button addTarget:self action:@selector(hideBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, _window_height*0.55)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:whiteView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = whiteView.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    whiteView.layer.mask = maskLayer;
    
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
    [whiteView addSubview:headerView];
    
    //头部视图
    closeBtn = [UIButton buttonWithType:0];
    closeBtn.frame = CGRectMake(0, 5, 30, 30);
    [closeBtn setImage:[UIImage imageNamed:@"userMsg_close"] forState:0];
    [closeBtn setImage:[UIImage imageNamed:@"sixin_back"] forState:UIControlStateSelected];
    closeBtn.selected = NO;
    [closeBtn addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    [headerView addSubview:closeBtn];
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-80, 0, 160, 40)];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont systemFontOfSize:13];
    titleL.textColor = RGB_COLOR(@"#626364", 1);
    titleL.text = YZMsg(@"当前在线主播");
    [headerView addSubview:titleL];
    
    searchBtn = [UIButton buttonWithType:0];
    searchBtn.frame = CGRectMake(_window_width-30, 5, 30, 30);
    [searchBtn setImage:[UIImage imageNamed:@"searchBar"] forState:0];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

    [headerView addSubview:searchBtn];
    
    _searchT = [[UITextField alloc]initWithFrame:CGRectMake(_window_width-40, 5, 0, 30)];
    _searchT.delegate = self;
    _searchT.placeholder = YZMsg(@"输入您要搜索的主播昵称或ID");
    _searchT.backgroundColor = RGB(241, 241, 241);
    //TextField
    _searchT.layer.cornerRadius = 15;
    _searchT.layer.masksToBounds = YES;
    _searchT.font = [UIFont systemFontOfSize:14];
    _searchT.leftViewMode = UITextFieldViewModeAlways;
    _searchT.keyboardType = UIKeyboardTypeWebSearch;
    [headerView addSubview:_searchT];
    UIImageView *leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    leftImgView.image = [UIImage imageNamed:@"left_search"];
    _searchT.leftView = leftImgView;
    
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 39, _window_width, 1) andColor:RGB_COLOR(@"#f4f5f6", 1) andView:headerView];
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, _window_width, whiteView.height-40) style:0];
    listTable.delegate =self;
    listTable.dataSource = self;
    listTable.separatorStyle = 0;
    [whiteView addSubview:listTable];
    listTable.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestData];
    }];
    listTable.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page ++;
        [self requestData];
    }];
    
    searchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, headerView.bottom, _window_width, whiteView.height-40) style:0];
    searchTable.delegate =self;
    searchTable.dataSource = self;
    searchTable.separatorStyle = 0;
    searchTable.hidden = YES;
    searchTable.backgroundColor = [UIColor whiteColor];
    [whiteView addSubview:searchTable];
    searchTable.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        searchP = 1;
        [self searchAnchorWithText:_searchT.text];
    }];
    searchTable.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        searchP ++;
        [self searchAnchorWithText:_searchT.text];
    }];
    searchNotingL = [[UILabel alloc]initWithFrame:CGRectMake(0, searchTable.height/2-10, searchTable.width, 20)];
    searchNotingL.font = [UIFont systemFontOfSize:13];
    searchNotingL.text = YZMsg(@"没有搜索到相关内容");
    searchNotingL.textAlignment = NSTextAlignmentCenter;
    searchNotingL.textColor = RGB_COLOR(@"#969696", 1);
    searchNotingL.hidden = YES;
    [searchTable addSubview:searchNotingL];
    
    [self requestData];

}
- (void)requestData{
    [YBToolClass postNetworkWithUrl:@"Livepk.GetLiveList" andParameter:@{@"p":@(page)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];
        if (code == 0) {
            if (page == 1) {
                [infoArray removeAllObjects];
            }
            NSArray *infos = info;
            [infoArray addObjectsFromArray:infos];
            [listTable reloadData];
        }
    } fail:^{
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == listTable) {
        return infoArray.count;
    }
    return searchInfo.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    anchorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"anchorCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"anchorCell" owner:nil options:nil] lastObject];
    }
    anchorModel *model;
    if (tableView == listTable) {
        model = [[anchorModel alloc]initWithDic:infoArray[indexPath.row]];
    }else{
        model = [[anchorModel alloc]initWithDic:searchInfo[indexPath.row]];
    }
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark ================ 搜索 ===============
- (void)searchAnchorWithText:(NSString *)text{
    NSString *url = [NSString stringWithFormat:@"Livepk.Search&key=%@&p=%d",text,searchP];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [searchTable.mj_header endRefreshing];
        [searchTable.mj_footer endRefreshing];

        if (code == 0) {
            if (searchP == 1) {
                [searchInfo removeAllObjects];
            }
            NSArray *infos = info;
            [searchInfo addObjectsFromArray:infos];
            if (searchInfo.count > 0) {
                searchNotingL.hidden = YES;
            }else{
                searchNotingL.hidden = NO;
            }
            [searchTable reloadData];
        }else{
            [MBProgressHUD showError:msg];
            searchNotingL.hidden = NO;
        }
    } fail:^{
        searchNotingL.hidden = YES;
        [searchTable.mj_header endRefreshing];
        [searchTable.mj_footer endRefreshing];

    }];
}
#pragma mark ================ searchBar代理 ===============
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideBtnClick];
    [self searchAnchorWithText:_searchT.text];
    return YES;
}


#pragma mark ================ cell按钮点击方法 ===============
- (void)startPK:(anchorModel *)model{
    [YBToolClass postNetworkWithUrl:@"Livepk.CheckLive" andParameter:@{@"stream":minstr(model.stream),@"uid_stream":_myStream} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSString *myNewPull = minstr([[info firstObject] valueForKey:@"pull"]);
            [self.delegate startLink:[anchorModel dicWithModel:model] andMyInfo:@{@"pull":myNewPull}];
            [self.delegate removeShouhuView];
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
@end
