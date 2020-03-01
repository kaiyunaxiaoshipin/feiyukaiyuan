//
//  SelPeopleV.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "SelPeopleV.h"

#import "SelPeopleCell.h"
#import "MessageListModel.h"

@interface SelPeopleV()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *_pubUrl;
    NSString *_showType;            //1-选择联系人  2召唤好友
    BOOL _haveSection;              //用户未搜索时默认显示 关注的人 并且有 header  得到搜索结果后隐藏header
    int _paging;                    //
    NSString *_key;                 //关键词
    NSString *_noData2;
    NSString *_noData1;
}
@property(nonatomic,strong)UIView *topMix;                  //搜索背景
@property(nonatomic,strong)UIButton *closeBtn;              //关闭
@property(nonatomic,strong)UILabel *midTitle;               //标题
@property(nonatomic,strong)UISearchBar *searchBar;          //搜索

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation SelPeopleV

- (instancetype)initWithFrame:(CGRect)frame showType:(NSString *)showtype selUser:(SelBlockEvent)event {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CellRow_Cor;
        _showType = showtype;
        self.selEvent = event;
        _haveSection = YES;
        _paging = 1;
        _noData2 = @"赶快去关注感兴趣的小伙伴吧";
        _noData1 = YZMsg(@"你还没有关注任何人");
        _key = @"";
        _dataArray = [NSMutableArray array];
        [self pullFollow];
        [self addSubview:self.topMix];
        [self addSubview:self.tableView];
        
    }
    return self;
}

-(void)pullFollow {
    _pubUrl = [purl stringByAppendingFormat:@"?service=User.getFollowsList&uid=%@&touid=%@&p=%d&key=%@",[Config getOwnID],[Config getOwnID],_paging,_key];
    
    [self pullData];
}
-(void)pullSearch {
    _pubUrl = [purl stringByAppendingFormat:@"?service=Home.search&key=%@&uid=%@&token=%@&p=%d",_key,[Config getOwnID],[Config getOwnToken],_paging];
    [self pullData];
}

-(void)pullData {
    _pubUrl = [_pubUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [YBNetworking postWithUrl:_pubUrl Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if ([code isEqual:@"0"]) {
            
            NSArray *infoA = [data valueForKey:@"info"];
            if (_paging==1) {
                [_dataArray removeAllObjects];
            }
            if (infoA.count == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [_dataArray addObjectsFromArray:infoA];
            }
            if (_dataArray.count<=0) {
                [PublicView showTextNoData:_tableView text1:_noData1 text2:_noData2];
            }else {
                [PublicView hiddenTextNoData:_tableView];
            }
            [_tableView reloadData];
            
        }else if ([code isEqual:@"700"]){
            [PublicObj tokenExpired:msg];
        }else{
//            [MBProgressHUD showError:msg]
            [MBProgressHUD showError:msg];
        }
        
    } Fail:^(id fail) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (_dataArray.count<=0) {
            [PublicView showTextNoData:_tableView text1:_noData1 text2:_noData2];
        }else {
            [PublicView hiddenTextNoData:_tableView];
        }
        [_tableView reloadData];
    }];
    
}

#pragma mark - 点击事件

-(void)clickCloseBtn {
    _key = @"";
    _paging = 1;
    _haveSection = YES;
    self.selEvent(@"关闭", nil);
}

#pragma mark - UISearchBarDelegate
-(void)clickClearBtn {
    _key = @"";
    _paging = 1;
    _haveSection = YES;
    [self pullFollow];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    _paging = 1;
    _key = searchText;
    //一个一个字清空搜索框的时候
    if (searchText.length==0) {
       _noData2 = @"赶快去关注感兴趣的小伙伴吧";
        _noData1 = YZMsg(@"你还没有关注任何人");
        _haveSection = YES;
        [self pullFollow];
    }else{
       _noData2 = @"搜索为空";
        _noData1 = @"";
        _haveSection = NO;
        if ([_showType isEqual:@"1"]) {
            [self pullFollow];
        }else{
            [self pullSearch];
        }
    }
    
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0 ) {
        
    }
    
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _key = searchBar.text;
    _paging = 1;
    if ([_showType isEqual:@"1"]) {
        [self pullFollow];
    }else{
        [self pullSearch];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self endEditing:YES];
}
#pragma mark - UITableViewDelegate、UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    /**
     * 1019 前后出了一张效果图 把header去掉了
     * 暂时未更改 _haveSection 属性，
     */
    /*
    if (_haveSection==YES) {
        return 40;
    }
     */
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    /*
    if (_haveSection==YES) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
        view.backgroundColor = CellRow_Cor;
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 40)];
        title.textColor = GrayText;
        title.font = SYS_Font(15);
        title.text = @"我关注的人";
        [view addSubview:title];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(15, 39.5, self.width-30, 0.5)];
        line.backgroundColor = RGB_A(255, 255, 255, 0.06);
        [view addSubview:line];
        return view;
    }
     */
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelPeopleCell *cell = [SelPeopleCell cellWithTab:tableView andIndexPath:indexPath];
    cell.backgroundColor = CellRow_Cor;
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *icon_path = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
    [cell.iconBtn sd_setImageWithURL:[NSURL URLWithString:icon_path] forState:0];
    cell.nameL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
    cell.signatureL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"signature"]];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _dataArray[indexPath.row];
    MessageListModel *model = [[MessageListModel alloc]init];
    NSString *uid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
    NSString *uname = [NSString stringWithFormat:@"%@",[dic valueForKey:@"user_nicename"]];
    NSString *icon = [NSString stringWithFormat:@"%@",[dic valueForKey:@"avatar"]];
    model.uidStr = uid;
    model.unameStr = uname;
    model.iconStr = icon;
    /* 创建聊天只用到 uid、name、icon*/
    self.selEvent(@"", model);
}

#pragma mark - set/get
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,_topMix.bottom, self.width,self.height-_topMix.height-20-statusbarHeight-ShowDiff)style:UITableViewStyleGrouped];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = Black_Cor;
        
        YBWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _paging = 1;
            if ([_showType isEqual:@"2"]&&_key.length>0) {
                [weakSelf pullSearch];
            }else{
                [weakSelf pullFollow];
            }
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            _paging +=1;
            if ([_showType isEqual:@"2"]&&_key.length>0) {
                [weakSelf pullSearch];
            }else{
                [weakSelf pullFollow];
            }
        }];
        
    }
    return _tableView;
}

- (UIView *)topMix {
    if (!_topMix) {
        _topMix = [[UIView alloc]initWithFrame:CGRectMake(0, 20+statusbarHeight, self.width, 44+44+10)];//标题+搜索框+空白
        _topMix.backgroundColor = Black_Cor;
        
        UIView *bg_v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44+44+5)];
        bg_v.backgroundColor = CellRow_Cor;
        [_topMix addSubview:bg_v];
        
        //关闭
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(0, 0, 44, 44);
        _closeBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 13, 13, 13);
        [_closeBtn setImage:[UIImage imageNamed:@"gray_close"] forState:0];
        [_closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
        [bg_v addSubview:_closeBtn];
        
        //标题
        _midTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.width/2-50, 0, 100, 44)];
        if ([_showType isEqual:@"1"]) {
            _midTitle.text = @"选择联系人";
        }else{
            _midTitle.text = @"召唤好友";
        }
        _midTitle.font = SYS_Font(17);
        _midTitle.textAlignment = NSTextAlignmentCenter;
        _midTitle.textColor = [UIColor whiteColor];
        [bg_v addSubview:_midTitle];
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,44, self.width,44)];
        _searchBar.backgroundImage = [PublicObj getImgWithColor:CellRow_Cor];
        if ([_showType isEqual:@"1"]) {
            _searchBar.placeholder = @"搜索用户昵称";
        }else{
            _searchBar.placeholder = @"输入您要@的好友昵称";
        }
        _searchBar.delegate = self;
        UITextField *textField = [_searchBar valueForKey:@"_searchField"];
        [textField setBackgroundColor:RGB(33, 28, 55)];
        [textField setValue:GrayText forKeyPath:@"_placeholderLabel.textColor"];
        [textField setValue:[UIFont systemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
        UIButton *clearBtn = [textField valueForKey:@"_clearButton"];
        [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
        textField.textColor = GrayText;
        textField.layer.cornerRadius = 18;
        textField.layer.masksToBounds = YES;
        [bg_v addSubview:_searchBar];
        
    }
    return _topMix;
}

@end
