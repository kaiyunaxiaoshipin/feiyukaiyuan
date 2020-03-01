//
//  SearchResultView.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/20.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "SearchResultView.h"
#import "LocationCell.h"

@interface SearchResultView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Black_Cor;
         self.pageIndex = 1;
        [self setupTableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:SearchResultGetPoiSearchResult object:nil];
        
    }
    return self;
}

- (NSMutableArray<QMSPoiData *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, _window_width, self.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = Black_Cor;
    [self addSubview:self.tableView];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadPastData)];
    self.tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新数据" forState:MJRefreshStateRefreshing];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [UIColor blackColor];
}

- (void)loadPastData {
    [self.tableView.mj_footer endRefreshing];
    if (self.dataSource.count == 0) {
        self.pageIndex = 1;
    } else {
        self.pageIndex = self.pageIndex + 1;
    }
    self.searchResultsPage(self.pageIndex);
}

- (void)refreshData:(NSNotification *)notification {
    NSArray *array = (notification.userInfo[@"data"]);
    if (self.pageIndex == 1) {
        [self.dataSource removeAllObjects];
        self.dataSource = [NSMutableArray arrayWithArray:array];
        [self.tableView setContentOffset:CGPointMake(0, 0)];
    }else {
        [self.dataSource addObjectsFromArray:array];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LocationCell *cell = [LocationCell cellWithTab:tableView andIndexPath:indexPath];
    cell.addressL.text = self.dataSource[indexPath.row].title;
    cell.infoL.text = self.dataSource[indexPath.row].address;
    cell.backgroundColor = CellRow_Cor;
    cell.falgIV.hidden = YES;
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[PublicObj getImgWithColor:SelCell_Col]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.dismissEvent) {
        self.dismissEvent([self.dataSource objectAtIndex:indexPath.row]);
    }
    
}


@end
