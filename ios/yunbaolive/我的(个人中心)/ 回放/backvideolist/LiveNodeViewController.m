//
//  LiveNodeViewController.m
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "LiveNodeViewController.h"
#import "LiveNodeModel.h"
#import "LiveNodeTableViewCell.h"
#import "hietoryPlay.h"

@interface LiveNodeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int setvisssss;
    UIView *nothingView;
    UIActivityIndicatorView *testActivityIndicator;//菊花
    int page;
    YBNoWordView *noNetwork;

}
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *allArray;
@end
@implementation LiveNodeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisssss = 1;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisssss = 0;
   
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    UILabel *label = [[UILabel alloc]init];
    label.text = @"直播记录";
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
    navtion.backgroundColor = navigationBGColor;
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    page = 1;
    self.allArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getLiveList];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page ++;
        [self getLiveList];
    }];
    
    [self navtion];
    [self createView];
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    [self getLiveList];
}
-(void)getLiveList{
    
    NSDictionary *subdic = @{
                             @"touid":[Config getOwnID],
                             @"p":@(page)
                             };
    
    [YBToolClass postNetworkWithUrl:@"User.getLiverecord" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        noNetwork.hidden = YES;

        if (code == 0) {
            NSArray *infoArr = info;
            if (page == 1) {
                [self.allArray removeAllObjects];
            }
            [self.allArray addObjectsFromArray:infoArr];;
            [self.tableView reloadData];
            if (infoArr.count == 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.allArray.count == 0) {
                [self.tableView removeFromSuperview];
                nothingView.hidden = NO;
            }
            
            [testActivityIndicator stopAnimating]; // 结束旋转
            [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

        }else{
            nothingView.hidden = NO;
            [testActivityIndicator stopAnimating]; // 结束旋转
            [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

        }
    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        nothingView.hidden = YES;
        if (_allArray.count == 0) {
            noNetwork.hidden = NO;
        }
        [MBProgressHUD showError:@"网络请求失败"];

        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    

}
-(void)createView{
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = YZMsg(@"你最近没有开过直播");
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = YZMsg(@"赶快去开场直播体验一下吧～");
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:label2];
    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self getLiveList];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveNodeTableViewCell *cell = [LiveNodeTableViewCell cellWithTV:tableView];
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
    NSDictionary *subDic = self.allArray[indexPath.row];
    LiveNodeModel *model = [[LiveNodeModel alloc]initWithDic:subDic];
    cell.model = model;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSDictionary *subdics = self.allArray[indexPath.row];

    [MBProgressHUD showMessage:@""];
    
    [YBToolClass postNetworkWithUrl:@"User.getAliCdnRecord" andParameter:@{@"id":minstr([subdics valueForKey:@"id"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUD];
        
        if (code == 0) {
            NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:[Config getOwnNicename],@"name",[Config getavatar],@"icon",[Config getOwnID],@"id",[Config level_anchor],@"level", nil];
            hietoryPlay *history = [[hietoryPlay alloc]init];
            history.url = [[info firstObject] valueForKey:@"url"];
            history.selectDic = userDic;
            [self presentViewController:history animated:YES completion:nil];

            
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        [MBProgressHUD hideHUD];
    }];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
}
@end
