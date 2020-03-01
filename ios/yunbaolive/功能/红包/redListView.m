//
//  redListView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "redListView.h"
#import "redDetails.h"
@implementation redListView
{
    UIView *redView;
    UITableView *listTable;
    NSMutableArray *listInfo;
    UILabel *numL;
    NSDictionary *zhuboDic;
    UIImageView *qiangView;
    UIView *timerView;
    UILabel *timeL;
    UIButton *qiangBtnn;
    NSTimer *daojishiTimer;
    int daojishiCount;
    redListModel *curModel;
    UIButton *curBuuton;
    
    UIButton *xiangQingBtn;
    UILabel *xiangQingLabel;
    UILabel *desL;
    
    UIImageView *successView;
    
    redDetails *redDetailsView;
}
- (void)hidSelf{
    if (redDetailsView) {
        [redDetailsView removeFromSuperview];
        redDetailsView = nil;
        redView.hidden = NO;
        if (successView) {
            [successView removeFromSuperview];
            successView = nil;
        }
        return;
    }
    if (successView) {
        [successView removeFromSuperview];
        successView = nil;
        redView.hidden = NO;
        return;
    }
    if (qiangView) {
        if (daojishiTimer) {
            [daojishiTimer invalidate];
            daojishiTimer = nil;
        }
        [qiangView removeFromSuperview];
        qiangView = nil;
        return;
    }
    [self.delegate removeShouhuView];
}
- (void)hidKeyBoard{
    
}

- (instancetype)initWithFrame:(CGRect)frame withZHuboMsg:(NSDictionary *)dic{
    self = [super initWithFrame:frame];
    zhuboDic = dic;
    listInfo = [NSMutableArray array];
    if (self) {
        [self creatUI];
        [self requestData];
    }
    return self;
}
- (void)creatUI{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidSelf)];
    [self addGestureRecognizer:tap];
    redView = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.14, _window_height, _window_width*0.72, _window_width*0.72*68/54)];
    redView.layer.cornerRadius = 10.0;
    redView.layer.masksToBounds =YES;
    redView.backgroundColor = [UIColor whiteColor];
    redView.center = self.center;
    [self addSubview:redView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
    [redView addGestureRecognizer:tap2];
    UIImageView *headerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, redView.width, redView.width/54*12)];
    headerImgView.image = [UIImage imageNamed:@"红包列表头部"];
    [redView addSubview:headerImgView];
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, headerImgView.height*1.5/12, headerImgView.width, headerImgView.height/2)];
    titleL.textColor = normalColors;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = YZMsg(@"直播间红包");
    [headerImgView addSubview:titleL];
    
    numL = [[UILabel alloc]initWithFrame:CGRectMake(0, titleL.bottom, headerImgView.width, headerImgView.height*0.25)];
    numL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    numL.textAlignment = NSTextAlignmentCenter;
    numL.font = [UIFont systemFontOfSize:13];
//    numL.text = @"共0个红包";
    [headerImgView addSubview:numL];
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, headerImgView.bottom, redView.width, redView.height-headerImgView.height) style:0];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.separatorStyle = 0;
    [redView addSubview:listTable];
    

}
- (void)requestData{
    NSDictionary *dic = @{
                          @"stream":minstr([zhuboDic valueForKey:@"stream"]),
                          @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"stream=%@&76576076c1f5f657b634e966c8836a06",minstr([zhuboDic valueForKey:@"stream"])]]
                          };
    [YBToolClass postNetworkWithUrl:@"Red.getRedList" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
//            listInfo = info;
            for (NSDictionary *dic in info) {
                redListModel *model = [[redListModel alloc]initWithDic:dic];
                [listInfo addObject:model];
            }
            numL.text = [NSString stringWithFormat:@"%@%ld%@",YZMsg(@"共"),listInfo.count,YZMsg(@"个红包")];

            [listTable reloadData];
        }
    } fail:^{
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listInfo.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"redListCELL";
    // 通过indexPath创建cell实例 每一个cell都是单独的
    redListCell *cell = (redListCell *)[tableView cellForRowAtIndexPath:indexPath];

//    redListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"redListCell" owner:nil options:nil] lastObject];
        redListModel *model = listInfo[indexPath.row];
        cell.model = model;
        cell.stream = minstr([zhuboDic valueForKey:@"stream"]);
        cell.delegate = self;
    }
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)qiangBtnClickkk:(redListModel *)model andButton:(UIButton *)btn{
    curModel = model;
    curBuuton = btn;
    qiangView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.11, _window_height, _window_width*0.78, _window_width*0.78*72/58)];
    qiangView.layer.cornerRadius = 10.0;
    qiangView.layer.masksToBounds =YES;
    qiangView.image = [UIImage imageNamed:@"红包-未抢到"];
    qiangView.userInteractionEnabled = YES;
    qiangView.center = self.center;
    [self addSubview:qiangView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
    [qiangView addGestureRecognizer:tap2];

    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(qiangView.width/2-30, qiangView.height*20/72-30, 60, 60)];
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar_thumb] placeholderImage:[UIImage imageNamed:@"bg1"]];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.clipsToBounds = YES;
    iconImgView.layer.cornerRadius = 30;
    iconImgView.layer.masksToBounds = YES;
    [qiangView addSubview:iconImgView];
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(0, iconImgView.bottom+5, qiangView.width, 20)];
    nameL.textAlignment = NSTextAlignmentCenter;
    nameL.font = [UIFont systemFontOfSize:14];
    nameL.textColor = [UIColor whiteColor];
    nameL.text = model.user_nicename;
    [qiangView addSubview:nameL];
    
    desL = [[UILabel alloc]initWithFrame:CGRectMake(qiangView.width*0.1, nameL.bottom, qiangView.width*0.8, 50)];
    desL.textAlignment = NSTextAlignmentCenter;
    desL.font = [UIFont boldSystemFontOfSize:17];
    desL.textColor = normalColors;
    desL.text = model.des;
    desL.numberOfLines = 2;
    [qiangView addSubview:desL];
    qiangBtnn = [UIButton buttonWithType:0];
    qiangBtnn.frame = CGRectMake(qiangView.width/2-45, qiangView.height*65/72-90, 90, 90);
    [qiangBtnn setBackgroundImage:[UIImage imageNamed:@"抢按钮"] forState:0];
    [qiangBtnn setTitle:YZMsg(@"抢") forState:0];
    qiangBtnn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [qiangBtnn addTarget:self action:@selector(qianghongbaole) forControlEvents:UIControlEventTouchUpInside];
    [qiangBtnn setTitleColor:RGB_COLOR(@"#d3301b", 1) forState:0];
    qiangBtnn.hidden = YES;
    [qiangView addSubview:qiangBtnn];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    //速度控制函数，控制动画运行的节奏
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.3;       //执行时间
    animation.repeatCount = MAXFLOAT;      //执行次数
    animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
    animation.fromValue = [NSNumber numberWithFloat:1];   //初始伸缩倍数
    animation.toValue = [NSNumber numberWithFloat:1.5];     //结束伸缩倍数
    
    [qiangBtnn.titleLabel.layer addAnimation:animation forKey:nil];

    if (![model.time isEqual:@"0"]) {
        daojishiCount = [model.time intValue];
        timerView = [[UIView alloc]initWithFrame:CGRectMake(0, qiangView.height*65/72-60, qiangView.width, 60)];
        [qiangView addSubview:timerView];
        UILabel *lll = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, timerView.width, 20)];
        lll.textAlignment = NSTextAlignmentCenter;
        lll.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        lll.font = [UIFont systemFontOfSize:11];
        lll.text = YZMsg(@"倒计时结束后可抢");
        [timerView addSubview:lll];
        timeL = [[UILabel alloc]initWithFrame:CGRectMake(timerView.width/2-60, 20, 120, 40)];
        timeL.textAlignment = NSTextAlignmentCenter;
        timeL.font = [UIFont boldSystemFontOfSize:20];
        timeL.textColor = normalColors;
        timeL.text = [self seconds:daojishiCount];
        timeL.backgroundColor = RGB_COLOR(@"#d3301b", 1);
        timeL.layer.cornerRadius = 20;
        timeL.layer.masksToBounds = YES;
        [timerView addSubview:timeL];
        if (!daojishiTimer) {
            daojishiTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishile) userInfo:nil repeats:YES];
        }
        qiangBtnn.hidden = YES;
    }else{
        qiangBtnn.hidden = NO;
    }
    xiangQingBtn = [UIButton buttonWithType:0];
    xiangQingBtn.frame = CGRectMake(qiangView.width/2-50, timerView.bottom-20, 100, 20);
    [xiangQingBtn setTitle:YZMsg(@"查看领取详情》") forState:0];
    [xiangQingBtn setTitleColor:normalColors forState:0];
    xiangQingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [xiangQingBtn addTarget:self action:@selector(xiangQingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    xiangQingBtn.hidden = YES;
    [qiangView addSubview:xiangQingBtn];
    
    xiangQingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, qiangView.height/2, qiangView.width, 20)];
    xiangQingLabel.textAlignment = NSTextAlignmentCenter;
    xiangQingLabel.font = [UIFont boldSystemFontOfSize:17];
    xiangQingLabel.textColor = [UIColor whiteColor];
    xiangQingLabel.text = YZMsg(@"手慢了，红包派完了");
    xiangQingLabel.hidden = YES;
    [qiangView addSubview:xiangQingLabel];

}
- (NSString *)seconds:(int)s{
    NSString *str;
    str = [NSString stringWithFormat:@"%02d:%02d",s/60,s%60];
    return str;
}
- (void)daojishile{
    daojishiCount -- ;
    timeL.text = [self seconds:daojishiCount];
    if (daojishiCount <= 0) {
        [timerView removeFromSuperview];
        timerView = nil;
        [daojishiTimer invalidate];
        daojishiTimer = nil;
        qiangBtnn.hidden = NO;
    }
}
- (void)qianghongbaole{
        NSDictionary *dic = @{
                              @"stream":minstr([zhuboDic valueForKey:@"stream"]),
                              @"redid":curModel.redid,
                              @"sign":[[YBToolClass sharedInstance] md5:[NSString stringWithFormat:@"redid=%@&stream=%@&uid=%@&76576076c1f5f657b634e966c8836a06",curModel.redid,minstr([zhuboDic valueForKey:@"stream"]),[Config getOwnID]]]
                              };
        [YBToolClass postNetworkWithUrl:@"Red.robRed" andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            [curBuuton.layer removeAllAnimations];
            curModel.time = @"qiangguole";
            if (code == 0) {
                if ([minstr([[info firstObject] valueForKey:@"win"]) isEqual:@"0"]) {
                    [qiangBtnn removeFromSuperview];
                    qiangBtnn = nil;
                    xiangQingLabel.hidden = NO;
                    xiangQingBtn.hidden = NO;
                    desL.hidden = YES;
                    
                }else{
                    [qiangView removeFromSuperview];
                    qiangView = nil;
                    curModel.isrob = 0;
                    [self showSuccessView:minstr([[info firstObject] valueForKey:@"win"])];
                }
            }
//            [MBProgressHUD showError:msg];
        } fail:^{

        }];

}
- (void)showSuccessView:(NSString *)coin{
    redView.hidden = YES;
    successView = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.11, _window_height, _window_width*0.78, _window_width*0.78*74/58)];
    successView.layer.cornerRadius = 10.0;
    successView.layer.masksToBounds =YES;
    successView.image = [UIImage imageNamed:@"红包拆开"];
    successView.userInteractionEnabled = YES;
    successView.center = self.center;
    [self addSubview:successView];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidKeyBoard)];
    [qiangView addGestureRecognizer:tap2];
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text = YZMsg(@"恭喜你!");
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = normalColors;
    [successView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(successView);
        make.top.equalTo(successView).offset(successView.height*32/74);
        make.height.mas_equalTo(successView.height*7/74);
    }];
    
    UILabel *contentL = [[UILabel alloc]init];
    contentL.text = [NSString stringWithFormat:@"%@ %@ %@%@%@",YZMsg(@"抢到"),curModel.user_nicename,YZMsg(@"派发的"),[common name_coin],YZMsg(@"红包")];
    contentL.font = [UIFont systemFontOfSize:14];
    contentL.textAlignment = NSTextAlignmentCenter;
    contentL.textColor = [UIColor whiteColor];
    [successView addSubview:contentL];
    [contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(successView);
        make.top.equalTo(titleL.mas_bottom);
        make.height.mas_equalTo(successView.height*6/74);
    }];

    UILabel *coinL = [[UILabel alloc]init];
    coinL.text = coin;
    coinL.textAlignment = NSTextAlignmentCenter;
    coinL.textColor = normalColors;
    coinL.font = [UIFont boldSystemFontOfSize:40];
    [successView addSubview:coinL];
    [coinL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentL.mas_bottom);
        make.height.mas_equalTo(successView.height*14/74);
        make.centerX.equalTo(successView);
    }];

    UIImageView *coinImgView = [[UIImageView alloc]init];
    coinImgView.image = [UIImage imageNamed:@"logFirst_钻石"];
    [successView addSubview:coinImgView];
    [coinImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.equalTo(coinL.mas_right).offset(10);
        make.centerY.equalTo(coinL.mas_centerY);
    }];
    
    UIButton *xqBtn = [UIButton buttonWithType:0];
    xqBtn.frame = CGRectMake(successView.width/2-50, successView.height*65/72-20, 100, 20);
    [xqBtn setTitle:YZMsg(@"查看领取详情》") forState:0];
    [xqBtn setTitleColor:normalColors forState:0];
    xqBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [xqBtn addTarget:self action:@selector(xiangQingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [successView addSubview:xqBtn];

}
- (void)xiangQingBtnClick{
    redDetailsView = [[redDetails alloc]initWithFrame:CGRectMake(_window_width*0.13, _window_height, _window_width*0.74, _window_width*0.74*74/54) withZHuboMsg:zhuboDic andRedID:curModel.redid];
    redDetailsView.center =self.center;
    [self addSubview:redDetailsView];
}
- (void)showRedDetails:(redListModel *)model{
    curModel = model;
    [self xiangQingBtnClick];
}

@end

