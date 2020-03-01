//
//  redDetails.m
//  yunbaolive
//
//  Created by Boom on 2018/11/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "redDetails.h"
#import "redDetailsCell.h"

@implementation redDetails{
    UIView *whiteView;
    UITableView *listTable;
    NSMutableArray *infoArray;
    NSDictionary *zhuboDic;
    NSString *redID;
    UIView *tableHeader;
}

- (instancetype)initWithFrame:(CGRect)frame withZHuboMsg:(NSDictionary *)dic andRedID:(NSString *)redid{
    self = [super initWithFrame:frame];
    self.backgroundColor = RGB_COLOR(@"#ee4f2f", 1);
    zhuboDic = dic;
    redID = redid;
    infoArray = [NSMutableArray array];
    if (self) {
        [self creatUI];
        [self requestData];
    }
    return self;
}
- (void)hidKeyBoard{
    
}
- (void)creatUI{
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
    [self addGestureRecognizer:tap2];

    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = 0;
    listTable.backgroundColor = [UIColor whiteColor];
    [self addSubview:listTable];
    listTable.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
    [listTable.mj_header setBackgroundColor:RGB_COLOR(@"#ee4f2f", 1)];

}
- (void)creatTableHeader:(NSDictionary *)dic{
    NSDictionary *redinfo = [dic valueForKey:@"redinfo"];
    NSString *win = minstr([dic valueForKey:@"win"]);
    tableHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height*37/74)];
    tableHeader.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, tableHeader.width, tableHeader.height*32/37)];
    imgView.image = [UIImage imageNamed:@"红包领取详情-头部"];
    [tableHeader addSubview:imgView];
    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(tableHeader.width*22/54, tableHeader.height*2/37, tableHeader.width*10/54, tableHeader.width*10/54)];
    iconImgView.layer.cornerRadius = tableHeader.width*5/54;
    iconImgView.layer.masksToBounds =YES;
    iconImgView.contentMode = UIViewContentModeScaleToFill;
    iconImgView.clipsToBounds = YES;
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([redinfo valueForKey:@"avatar_thumb"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    [tableHeader addSubview:iconImgView];
    
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImgView.bottom, tableHeader.width, tableHeader.height*7/37)];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.font = [UIFont systemFontOfSize:15];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = [NSString stringWithFormat:@"%@ %@",minstr([redinfo valueForKey:@"user_nicename"]),YZMsg(@"的红包")];
    [tableHeader addSubview:nameL];
    
    if ([win isEqual:@"0"]) {
        UILabel *weiqiangda0 = [[UILabel alloc]initWithFrame:CGRectMake(0, nameL.bottom, tableHeader.width, tableHeader.height*12/37)];
        weiqiangda0.textColor = normalColors;
        weiqiangda0.text = YZMsg(@"未抢到");
        weiqiangda0.textAlignment = NSTextAlignmentCenter;
        weiqiangda0.font = [UIFont boldSystemFontOfSize:25];
        [tableHeader addSubview:weiqiangda0];

    }else{
        CGFloat coinWidth = [[YBToolClass sharedInstance] widthOfString:win andFont:[UIFont boldSystemFontOfSize:25] andHeight:30];
        UILabel *coinL = [[UILabel alloc]initWithFrame:CGRectMake(tableHeader.width/2-coinWidth/2, nameL.bottom, coinWidth, tableHeader.height*8/37)];
        coinL.textColor = normalColors;
        coinL.text = win;
        coinL.textAlignment = NSTextAlignmentCenter;
        coinL.font = [UIFont boldSystemFontOfSize:25];
        [tableHeader addSubview:coinL];
        
        UIImageView *coinImgView = [[UIImageView alloc]initWithFrame:CGRectMake(coinL.right+8, coinL.top, 18, 18)];
        coinImgView.image = [UIImage imageNamed:@"logFirst_钻石"];
        coinImgView.centerY = coinL.centerY;
        [tableHeader addSubview:coinImgView];
        UILabel *lllAbel = [[UILabel alloc]initWithFrame:CGRectMake(0, coinL.bottom, tableHeader.width, 12)];
        lllAbel.font = [UIFont systemFontOfSize:11];
        lllAbel.textAlignment = NSTextAlignmentCenter;
        lllAbel.textColor = normalColors;
        lllAbel.text = [NSString stringWithFormat:@"%@%@」",YZMsg(@"已存入「我的"),[common name_coin]];
        [tableHeader addSubview:lllAbel];
    }
    UILabel *numL = [[UILabel alloc]initWithFrame:CGRectMake(0, tableHeader.height*32/37, tableHeader.width, tableHeader.height*5/37)];
    numL.textColor = RGB_COLOR(@"#ec562f", 1);
    numL.textAlignment = NSTextAlignmentCenter;
    numL.font = [UIFont systemFontOfSize:13];
    numL.text = [NSString stringWithFormat:@"%@%@/%@%@，%@%@/%@%@",YZMsg(@"已领取"),minstr([redinfo valueForKey:@"nums_rob"]),minstr([redinfo valueForKey:@"nums"]),YZMsg(@"个"),YZMsg(@"共"),minstr([redinfo valueForKey:@"coin_rob"]),minstr([redinfo valueForKey:@"coin"]),[common name_coin]];
    [tableHeader addSubview:numL];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, tableHeader.height-1, tableHeader.width, 1) andColor:RGB_COLOR(@"#f4f5f6", 1) andView:tableHeader];
    listTable.tableHeaderView = tableHeader;
}
- (void)requestData{
    NSDictionary *dic = @{
                          @"stream":minstr([zhuboDic valueForKey:@"stream"]),
                          @"redid":redID,
                          @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"redid=%@&stream=%@&76576076c1f5f657b634e966c8836a06",redID,minstr([zhuboDic valueForKey:@"stream"])]]
                          };

    [YBToolClass postNetworkWithUrl:@"Red.GetRedRobList" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [listTable.mj_header endRefreshing];
        if (!tableHeader) {
            [self creatTableHeader:[info firstObject]];
        }
        NSArray *list = [[info firstObject] valueForKey:@"list"];
        infoArray = list.mutableCopy;
        [listTable reloadData];
    } fail:^{
        [listTable.mj_header endRefreshing];

    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    redDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"redDetailsCELL"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"redDetailsCell" owner:nil options:nil] lastObject];
    }
    NSDictionary *subDic = infoArray[indexPath.row];
    [cell.iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([subDic valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    cell.nameL.text = minstr([subDic valueForKey:@"user_nicename"]);
    cell.timeL.text = minstr([subDic valueForKey:@"time"]);
    cell.coinL.text = minstr([subDic valueForKey:@"win"]);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@end
