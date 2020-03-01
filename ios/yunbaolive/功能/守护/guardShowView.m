//
//  guardShowView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "guardShowView.h"
#import "guardListCell.h"
#import "guardListModel.h"
@implementation guardShowView{
    NSString *liveUID;
    NSDictionary *userMsg;
    int page;
    UIView *whiteView;
    UITableView *listTable;
    UILabel *numL;
    NSMutableArray *infoArray;
}

- (instancetype)initWithFrame:(CGRect)frame andUserGuardMsg:(NSDictionary *)dic andLiveUid:(NSString *)uid{
    self = [super initWithFrame:frame];
    liveUID = uid;
    userMsg = dic;
    infoArray = [NSMutableArray array];
    page = 1;
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf)];
        [self addGestureRecognizer:tap];
        [self creatUI];
        [self requestData];
    }
    return self;
}
- (void)hidKeyBoard{
    
}
- (void)creatUI{
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.1, _window_height, _window_width*0.8, _window_width*0.8*1.4)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 5.0;
    whiteView.layer.masksToBounds = YES;
    [self addSubview:whiteView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
    [whiteView addGestureRecognizer:tap2];

    numL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, whiteView.width, whiteView.height*2/21)];
    numL.textAlignment = NSTextAlignmentCenter;
    numL.font = [UIFont systemFontOfSize:15];
    numL.textColor = RGB_COLOR(@"#333333", 1);
    numL.userInteractionEnabled = YES;
    [whiteView addSubview:numL];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, numL.bottom, whiteView.width, 1) andColor:RGB_COLOR(@"#F4F5F6", 1) andView:whiteView];

    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, numL.bottom+1, whiteView.width, whiteView.height*33/42-2) style:0];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = 0;
    [whiteView addSubview:listTable];
    
    listTable.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        page = 1;
        [self requestData];
    }];
//    listTable.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
//        page ++;
//        [self requestData];
//    }];

    if (![liveUID isEqual:[Config getOwnID]]) {
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, listTable.bottom, whiteView.width, 1) andColor:RGB_COLOR(@"#F4F5F6", 1) andView:whiteView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, listTable.bottom+1, whiteView.width-120, whiteView.height*5/42)];
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGB_COLOR(@"#636465", 1);
        label.userInteractionEnabled = YES;
        label.numberOfLines = 0;
        [whiteView addSubview:label];

        UIButton *button = [UIButton buttonWithType:0];
        button.frame = CGRectMake(whiteView.width-105, label.top + label.height/2-15, 90, 30);
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:normalColors];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:button];
        if ([minstr([userMsg valueForKey:@"type"]) isEqual:@"1"]) {
            label.text = [NSString stringWithFormat:@"%@ %@",YZMsg(@"您是当前主播的月守护\n守护日期截止到"),minstr([userMsg valueForKey:@"endtime"])];
            [button setTitle:YZMsg(@"续费守护") forState:0];
        }else if([minstr([userMsg valueForKey:@"type"]) isEqual:@"2"]){
            label.text = [NSString stringWithFormat:@"%@ %@",YZMsg(@"您是当前主播的年守护\n守护日期截止到"),minstr([userMsg valueForKey:@"endtime"])];
            [button setTitle:YZMsg(@"续费守护") forState:0];
            
        }else{
            label.text = YZMsg(@"快去为喜欢的主播开通守护吧");
            [button setTitle:YZMsg(@"开通守护") forState:0];
        }
    }else{
        listTable.height = whiteView.height*38/42-1;
    }
    
    
}
- (void)buttonClick:(UIButton *)sender{
    [self.delegate buyOrRenewGuard];
}
- (void)requestData{
    NSDictionary *dic = @{@"liveuid":liveUID,@"p":@(page)};
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
            numL.text = [NSString stringWithFormat:@"%@(%ld)",YZMsg(@"守护"),infoArray.count];
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
- (void)creatTableHeader:(NSDictionary *)dic{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, whiteView.width, whiteView.height*40/82)];
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
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, votesL.bottom-1, whiteView.width, 1) andColor:RGB_COLOR(@"#F4F5F6", 1) andView:view];

    }else{
        imgView.image = [UIImage imageNamed:@"虚位以待"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imgView.bottom+15, view.width, 20)];
        label.textAlignment = NSTextAlignmentCenter;
        if ([liveUID isEqual:[Config getOwnID]]) {
            label.text = YZMsg(@"你还没有守护哦");
        }else{
            label.text = YZMsg(@"成为TA的第一个守护");
        }
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = RGB_COLOR(@"#959697", 1);
        [view addSubview:label];
    }
    [view addSubview:imgView];
    listTable.tableHeaderView = view;
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
- (void)show{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = (_window_height-whiteView.height)/2;
    }];
}
- (void)hideSelf{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = _window_height;
    } completion:^(BOOL finished) {
        [self.delegate removeShouhuView];
    }];

}
@end
