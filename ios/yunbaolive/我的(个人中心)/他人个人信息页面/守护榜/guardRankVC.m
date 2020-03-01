//
//  guardRankVC.m
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "guardRankVC.h"
#import "guardListCell.h"
@interface guardRankVC ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *listTable;
    NSMutableArray *infoArray;
    int page;
}

@end

@implementation guardRankVC
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"守护榜");
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    infoArray = [NSMutableArray array];
    [self navtion];
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight) style:0];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = 0;
    [self.view addSubview:listTable];
    listTable.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestData];
    }];
    listTable.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        page ++ ;
        [self requestData];
    }];
    [self requestData];
}
- (void)creatTableHeader:(NSDictionary *)dic{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width*0.8/3*2)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.1, 0, _window_width*0.8, backView.height)];
    [backView addSubview:view];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(view.width/4, view.height *3/40, view.width/2, view.height*22/40)];
    
    
    if (dic) {
        imgView.image = [UIImage imageNamed:@"守护之星"];
        UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgView.left+imgView.width*95/300, imgView.top + imgView.height*85/220, imgView.width*110/300, imgView.width*110/300)];
        iconImgView.layer.cornerRadius = imgView.width*110/600;
        iconImgView.layer.masksToBounds = YES;
        [iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"avatar_thumb"])]];
        [view addSubview:iconImgView];
        UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom, view.width, view.height*60/400)];
        nameL.textAlignment = NSTextAlignmentCenter;
        nameL.font = [UIFont boldSystemFontOfSize:15];
        nameL.textColor = RGB_COLOR(@"#333333", 1);
        nameL.text = minstr([dic valueForKey:@"user_nicename"]);
        [view addSubview:nameL];
        
        UIImageView *sexImgView = [[UIImageView alloc]initWithFrame:CGRectMake(view.width/2-view.width*50/600, nameL.bottom, view.width*30/600, view.width*30/600)];
        if ([minstr([dic valueForKey:@"sex"]) isEqual:@"1"]) {
            sexImgView.image = [UIImage imageNamed:@"sex_man"];
        }else{
            sexImgView.image = [UIImage imageNamed:@"sex_woman"];
        }
        [view addSubview:sexImgView];
        
        UIImageView *levelImgView = [[UIImageView alloc]initWithFrame:CGRectMake(sexImgView.right +view.width*20/600, nameL.bottom, view.width*60/600, view.width*30/600)];
        NSDictionary *levelDic = [common getUserLevelMessage:minstr([dic valueForKey:@"level"])];
        [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
        [view addSubview:levelImgView];
        
        UILabel *votesL = [[UILabel alloc]initWithFrame:CGRectMake(0, sexImgView.bottom, view.width, view.height*60/400)];
        votesL.textAlignment = NSTextAlignmentCenter;
        votesL.font = [UIFont systemFontOfSize:13];
        votesL.textColor = RGB_COLOR(@"#C8C9CA", 1);
        [votesL setAttributedText:[self coinLabel:minstr([dic valueForKey:@"contribute"])]];
        [view addSubview:votesL];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(10, votesL.bottom-1, _window_width-20, 1) andColor:RGB_COLOR(@"#F4F5F6", 1) andView:backView];
        
    }else{
        imgView.image = [UIImage imageNamed:@"虚位以待"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+15, view.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = YZMsg(@"成为TA的第一个守护");
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGB_COLOR(@"#959697", 1);
        [view addSubview:label];
    }
    [view addSubview:imgView];
    listTable.tableHeaderView = backView;
}
- (NSMutableAttributedString *)coinLabel:(NSString *)coin{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:YZMsg(@"本周贡献")];
    [attStr appendAttributedString:str1];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:coin];
    [str2 addAttribute:NSForegroundColorAttributeName value:normalColors range:NSMakeRange(0, [coin length])];
    [attStr appendAttributedString:str2];
    NSAttributedString *str3 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@",[common name_votes]]];
    [attStr appendAttributedString:str3];
    return  attStr;
}

- (void)requestData{
    NSDictionary *dic = @{@"liveuid":_liveUID,@"p":@(page)};
    [YBToolClass postNetworkWithUrl:@"Guard.GetGuardList" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];
        if (code == 0) {
            if (page == 1) {
                [infoArray removeAllObjects];
            }
            NSArray *infos = info;
            [infoArray addObjectsFromArray:infos];
            [listTable reloadData];
            if (infoArray.count == 0) {
                [self creatTableHeader:nil];
            }else{
                [self creatTableHeader:[infoArray firstObject]];
            }
        }else{
            if (infoArray.count == 0) {
                [self creatTableHeader:nil];
            }
        }
    } fail:^{
        [listTable.mj_header endRefreshing];
        [listTable.mj_footer endRefreshing];
        [self creatTableHeader:nil];
    }];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArray.count-1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    guardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guardListCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"guardListCell" owner:nil options:nil] lastObject];
    }
    guardListModel *model = [[guardListModel alloc]initWithDic:infoArray[indexPath.row +1]];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
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
