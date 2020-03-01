//
//  searchVC.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/2/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "searchVC.h"
#import "HXSearchBar.h"
#import "fansModel.h"
#import "fans.h"
#import "LivePlay.h"
#import "otherUserMsgVC.h"
@interface searchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,guanzhu>
{
    UIImageView *imageView;
    HXSearchBar *searchBars;
    int page;

}
@property (strong, nonatomic)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *allArray;
@end

@implementation searchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    page = 1;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60 + statusbarHeight, _window_width, _window_height-60 -statusbarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellStyleDefault;
    [self.view addSubview:_tableView];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self getIN];
    }];
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page ++;
        [self getIN];
    }];
    self.view.backgroundColor = [UIColor whiteColor];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.3 * _window_width, 0.25 * _window_height, 0.4 * _window_width,  0.4 * _window_width)];
    imageView.image = [UIImage imageNamed:@"搜索（无）"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.hidden = YES;
    [self.view addSubview:imageView];
    self.allArray = [NSMutableArray array];
    [self addSearchBar];
}
//添加搜索条
- (void)addSearchBar {
    //加上 搜索栏
    searchBars = [[HXSearchBar alloc] initWithFrame:CGRectMake(10,10 + statusbarHeight, self.view.frame.size.width -20,60)];
    searchBars.backgroundColor = [UIColor clearColor];
    searchBars.delegate = self;
    //输入框提示
    searchBars.placeholder = YZMsg(@"请输入您要搜索的昵称或ID");
    //光标颜色
    searchBars.cursorColor = normalColors;
    //TextField
    searchBars.searchBarTextField.layer.cornerRadius = 16;
    searchBars.searchBarTextField.layer.masksToBounds = YES;
//    searchBars.searchBarTextField.layer.borderColor = [UIColor grayColor].CGColor;
//    searchBars.searchBarTextField.layer.borderWidth = 1.0;
    searchBars.searchBarTextField.backgroundColor = RGB(241, 241, 241);
    //清除按钮图标
    //searchBar.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
    //去掉取消按钮灰色背景
    searchBars.hideSearchBarBackgroundImage = YES;
    searchBars.searchBarTextField.font = [UIFont systemFontOfSize:14];
    [searchBars becomeFirstResponder];
    [self.view addSubview:searchBars];
}
//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //取消按钮
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:YZMsg(@"取消") forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
}
//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.allArray removeAllObjects];
    [self.tableView reloadData];
    page = 1;
    [self getIN];
    [searchBar resignFirstResponder];

}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self.allArray removeAllObjects];
    [self.tableView reloadData];
    page = 1;
    [self getIN];
}
//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    fans *cell = [fans cellWithTableView:tableView];
    fansModel *model = [[fansModel alloc]initWithDic:self.allArray[indexPath.row]];
    cell.model = model;
    cell.guanzhuDelegate = self;
    if (cell.model.uid ==[Config getOwnID] || [cell.model.uid isEqualToString:[Config getOwnID]])
    {
        cell.guanzhubtn.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
//    personMessage *person = [[personMessage alloc]init];
//    person.userID = [self.models[indexPath.row] valueForKey:@"uid"];
    //[self presentViewController:person animated:YES completion:nil];
    otherUserMsgVC *person = [[otherUserMsgVC alloc]init];
    person.userID = [self.allArray[indexPath.row] valueForKey:@"id"];
    [self.navigationController pushViewController:person animated:YES];
}
-(void)getIN{
    
     NSString *url = [NSString stringWithFormat:@"Home.search&key=%@&uid=%@&token=%@&p=%d",searchBars.text,[Config getOwnID],[Config getOwnToken],page];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        if (code == 0) {
            NSArray *infos = info;
            if (page == 1) {
                [self.allArray removeAllObjects];
            }
            [self.allArray addObjectsFromArray:infos];
            [self.tableView reloadData];
            imageView.hidden = YES;
            if ([infos count] == 0) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.allArray.count == 0) {
                imageView.hidden = NO;
            }
        }else{
            imageView.hidden = NO;
        }
    } fail:^{
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];

        imageView.hidden = NO;
    }];
//    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//     NSNumber *ret = [responseObject valueForKey:@"ret"];
//     if ([ret isEqualToNumber:[NSNumber numberWithInt:200]]) {
//     NSArray *data = [responseObject valueForKey:@"data"];
//     NSNumber *code = [data valueForKey:@"code"] ;
//     if([code isEqualToNumber:[NSNumber numberWithInt:0]])
//     {
//     NSArray *info = [data valueForKey:@"info"];
//     self.allArray = info;
//     [self.tableView reloadData];
//     imageView.hidden = YES;
//     if (self.allArray.count == 0) {
//     imageView.hidden = NO;
//     }
//     }
//     else
//     {
//     imageView.hidden = NO;
//     }
//     }
//     }
//     failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//
//         imageView.hidden = NO;
//     }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)doGuanzhu:(NSString *)st{
    
    NSDictionary *subdic = @{@"uid":[Config getOwnID],
                             @"touid":st
                             };
    [YBToolClass postNetworkWithUrl:@"User.setAttent" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSString *isattent = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"isattent"]];
            for (int i = 0; i<self.allArray.count; i++) {
                NSMutableDictionary *muDic = [self.allArray[i] mutableCopy];
                if ([minstr([muDic valueForKey:@"id"]) isEqual:st]) {
                    [muDic setObject:isattent forKey:@"isattention"];
                    [self.allArray replaceObjectAtIndex:i withObject:muDic];
                    break;
                }
            }
            [_tableView reloadData];
        }
    } fail:^{
        
    }];
    
}
@end
