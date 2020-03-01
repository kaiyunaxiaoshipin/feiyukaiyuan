//
//  otherUserMsgVC.m
//  yunbaolive
//
//  Created by Boom on 2018/10/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "otherUserMsgVC.h"
#import "personLiveCell.h"
#import "webH5.h"
#import "LiveNodeModel.h"
#import "impressVC.h"
#import "hietoryPlay.h"
#import "JCHATConversationViewController.h"
#import "fenXiangView.h"
#import "guardRankVC.h"
#import "MessageListModel.h"
#import "mineVideoCell.h"
#import "NearbyVideoModel.h"
#import "LookVideo.h"
#import "fansViewController.h"
#import "attrViewController.h"

@interface otherUserMsgVC ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    //导航栏控件
    UIView *naviView;
    UIButton *returnBtn;
    UIButton *shareBtn;
    UILabel *titleLabel;
    fenXiangView *shareView;

    //底部d三个按钮
    UIButton *attionBtn;
    UIButton *jmsgBtn;
    UIButton *blackBtn;
    //CollectionView
    UICollectionView *personCollection;
    UIView *collectionHeader;
    NSMutableArray *liveArray;
    int livePage;
    
    NSMutableArray *videoArray;
    int videoPage;

    //
    NSDictionary *infoDic;
    
    UIView *switchLine;
    UIView *segmentView;
    
    BOOL isVideo;
}

@end

@implementation otherUserMsgVC
#pragma mark ================ 导航栏 ===============
//创建导航栏
- (void)navigation{
    naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    naviView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:naviView];
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 34+statusbarHeight, _window_width-100, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = navtionTitleFont;
    titleLabel.textColor = [UIColor blackColor];
    [naviView addSubview:titleLabel];

    returnBtn = [UIButton buttonWithType:0];
    returnBtn.frame = CGRectMake(0, 24+statusbarHeight, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"person_back_white"] forState:0];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [naviView addSubview:returnBtn];
    
    shareBtn = [UIButton buttonWithType:0];
    shareBtn.frame = CGRectMake(_window_width-40, 24+statusbarHeight, 40, 40);
    [shareBtn setImage:[UIImage imageNamed:@"person_share_white"] forState:0];
    [shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [naviView addSubview:shareBtn];
}
//分享
- (void)doShare{
    if (infoDic) {
        if (!shareView) {
            shareView = [[fenXiangView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
            [shareView GetDIc:infoDic];
            [self.view addSubview:shareView];
        }else{
            [shareView show];
        }
    }
}
//返回
- (void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ================ 底部按钮 ===============
- (void)creatBottomView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, personCollection.bottom, _window_width, 40+ShowDiff)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, 0, _window_width, 1) andColor:RGB_COLOR(@"#f4f5f6", 1) andView:view];

    NSArray *bottomTitleArr = @[YZMsg(@"关注"),YZMsg(@"私信"),YZMsg(@"拉黑")];
    for (int i = 0; i< bottomTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:0];
        btn.frame = CGRectMake(_window_width/3*i, 0, _window_width/3, 40);
        [btn setTitle:bottomTitleArr[i] forState:0];
        [btn setTitleColor:RGB_COLOR(@"#333333", 1) forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        if (i == 0) {
            attionBtn = btn;
        }
        if (i == 1) {
            jmsgBtn = btn;
        }
        if (i == 2) {
            blackBtn = btn;
        }
        if (i != bottomTitleArr.count - 1) {
            [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(btn.right-0.5, 12, 1, 16) andColor:RGB_COLOR(@"#f4f5f6", 1) andView:view];
        }
    }
}
- (void)bottomBtnClick:(UIButton *)sender{
    //关注
    if (sender == attionBtn) {
        [YBToolClass postNetworkWithUrl:@"User.setAttent" andParameter:@{@"touid":_userID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                NSString *isattent = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"isattent"]];
                NSDictionary *subdic = [info firstObject];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLiveplayAttion" object:subdic];

                if ([isattent isEqual:@"1"]) {
                    [attionBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
                    [blackBtn setTitle:YZMsg(@"拉黑") forState:UIControlStateNormal];
                    NSLog(@"关注成功");
                    if (self.block) {
                        self.block();
                    }
                }
                else
                {
                    [attionBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
                    NSLog(@"取消关注成功");
                }
            }
        } fail:^{
            
        }];

    }
    //私信
    if (sender == jmsgBtn) {
        NSString *name = [NSString stringWithFormat:@"%@%@",JmessageName,self.userID];
        //创建会话
        [JMSGConversation createSingleConversationWithUsername:name completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
                JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                sendMessageCtl.conversation = resultObject;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:minstr(self.icon) forKey:@"avatar"];
                [dic setObject:minstr(self.userID) forKey:@"id"];
                [dic setObject:minstr(self.chatname) forKey:@"user_nicename"];
                [dic setObject:minstr(self.chatname) forKey:@"name"];
                if ([attionBtn.titleLabel.text isEqual:YZMsg(@"关注")]) {
                    [dic setObject:@"0" forKey:@"utot"];
                }else{
                    [dic setObject:@"1" forKey:@"utot"];
                }
                [dic setObject:resultObject forKey:@"conversation"];
                MessageListModel *model = [[MessageListModel alloc]initWithDic:dic];
                sendMessageCtl.userModel = model;
                [self.navigationController pushViewController:sendMessageCtl animated:YES];
            }else{
                [MBProgressHUD showError:YZMsg(@"对方未注册私信")];
            }
        }];

    }
    //拉黑
    if (sender == blackBtn) {
        [YBToolClass postNetworkWithUrl:@"User.setBlack" andParameter:@{@"touid":_userID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                if ([blackBtn.titleLabel.text isEqual:YZMsg(@"拉黑")]) {
                    [blackBtn setTitle:YZMsg(@"已拉黑") forState:UIControlStateNormal];
                    [attionBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
                    [MBProgressHUD showError:YZMsg(@"已拉黑")];
                }
                else{
                    [blackBtn setTitle:YZMsg(@"拉黑") forState:UIControlStateNormal];
                    [MBProgressHUD showError:YZMsg(@"已解除拉黑")];
                }

            }
        } fail:^{
            
        }];
    }
}
#pragma mark ================ viewdidload ===============
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    liveArray = [NSMutableArray array];
    livePage = 1;
    
    videoArray = [NSMutableArray array];
    videoPage = 1;
    isVideo = YES;
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.itemSize = CGSizeMake(_window_width, 50);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.headerReferenceSize = CGSizeMake(_window_width, _window_width/75*92+statusbarHeight);
    
    personCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height-ShowDiff-40) collectionViewLayout:flow];
    personCollection.delegate   = self;
    personCollection.dataSource = self;
    personCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:personCollection];
    [personCollection registerNib:[UINib nibWithNibName:@"personLiveCell" bundle:nil] forCellWithReuseIdentifier:@"personLiveCELL"];
    [personCollection registerNib:[UINib nibWithNibName:@"mineVideoCell" bundle:nil] forCellWithReuseIdentifier:@"mineVideoCELL"];
    [personCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV"];
    
    if (@available(iOS 11.0, *)) {
        personCollection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    personCollection.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (isVideo) {
            videoPage++;
            [self pullVideoList];
        }else{
            livePage ++;
            [self pullInternet];
        }
    }];

    

    [self navigation];
    if ([_userID isEqual:[Config getOwnID]]) {
        personCollection.height = _window_height;
    }else{
        [self creatBottomView];
    }
    [self requestData];
}
//请求直播记录分页
- (void)pullInternet{
    [YBToolClass postNetworkWithUrl:@"User.getLiverecord" andParameter:@{@"touid":_userID,@"p":@(livePage)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [personCollection.mj_footer endRefreshing];
        if (code == 0) {
            [liveArray addObjectsFromArray:info];
            [personCollection reloadData];
            if ([info count] == 0) {
                [personCollection.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } fail:^{
        [personCollection.mj_footer endRefreshing];
    }];
}
- (void)pullVideoList{
    [YBToolClass postNetworkWithUrl:@"video.gethomevideo" andParameter:@{@"touid":_userID,@"p":@(videoPage)} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        [personCollection.mj_footer endRefreshing];
        if (code == 0) {
            [videoArray addObjectsFromArray:info];
            [personCollection reloadData];
            if ([info count] == 0) {
                [personCollection.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } fail:^{
        [personCollection.mj_footer endRefreshing];
    }];

}
- (void)requestData{
    [YBToolClass postNetworkWithUrl:@"User.getUserHome" andParameter:@{@"touid":_userID} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subDic = [info firstObject];
            infoDic = subDic;
            [self creatCollectionHeader:subDic];
            [liveArray addObjectsFromArray:[subDic valueForKey:@"liverecord"]];
            [videoArray addObjectsFromArray:[subDic valueForKey:@"videolist"]];

            [personCollection reloadData];
            self.chatname = [subDic valueForKey:@"user_nicename"];
            self.icon = [subDic valueForKey:@"avatar"];

            if ([[subDic valueForKey:@"isattention"] isEqual:@"0"]) {
                [attionBtn setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
            }
            else{
                [attionBtn setTitle:YZMsg(@"已关注") forState:UIControlStateNormal];
            }
            if ([[subDic valueForKey:@"isblack"] isEqual:@"1"]) {
                [blackBtn setTitle:YZMsg(@"已拉黑") forState:UIControlStateNormal];
            }
            else{
                
                [blackBtn setTitle:YZMsg(@"拉黑") forState:UIControlStateNormal];
            }

        }
    } fail:^{
        
    }];
}
- (void)creatCollectionHeader:(NSDictionary *)dic{
    collectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width/75*92+statusbarHeight)];
    collectionHeader.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
    UIImageView *iconImgView = [[UIImageView alloc]init];
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    iconImgView.contentMode = UIViewContentModeScaleAspectFill;
    iconImgView.clipsToBounds = YES;
    iconImgView.userInteractionEnabled = YES;
    [collectionHeader addSubview:iconImgView];
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(collectionHeader);
        make.width.mas_equalTo(_window_width);
        make.height.mas_equalTo(_window_width/75*46+statusbarHeight);
    }];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = RGB_COLOR(@"#000000", 0.7);
    [iconImgView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(iconImgView);
    }];
    UIImageView *iconImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, statusbarHeight+16.00/46*backView.height, 60, 60)];
    [iconImgView2 sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    iconImgView2.contentMode = UIViewContentModeScaleToFill;
    iconImgView2.clipsToBounds = YES;
    iconImgView2.layer.cornerRadius = 30;
    iconImgView2.layer.masksToBounds = YES;
    [backView addSubview:iconImgView2];
    [iconImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.height.mas_equalTo(60);
        make.top.equalTo(backView).offset(_window_width/75*16+statusbarHeight);
    }];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    nameLabel.text = minstr([dic valueForKey:@"user_nicename"]);
    [backView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView2);
        make.left.equalTo(iconImgView2.mas_right).offset(15);
        make.height.mas_equalTo(25);
    }];
    UIImageView *sexImgView = [[UIImageView alloc]init];
    if ([minstr([dic valueForKey:@"sex"]) isEqual:@"1"]) {
        sexImgView.image = [UIImage imageNamed:@"sex_man"];
    }else{
        sexImgView.image = [UIImage imageNamed:@"sex_woman"];
    }
    [backView addSubview:sexImgView];
    [sexImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(5);
        make.height.width.mas_equalTo(15);
    }];
    UIImageView *hostImgView = [[UIImageView alloc]init];
    NSDictionary *levelDic1 = [common getAnchorLevelMessage:minstr([dic valueForKey:@"level_anchor"])];
    [hostImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic1 valueForKey:@"thumb"])]];

    [backView addSubview:hostImgView];
    [hostImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(sexImgView);
        make.left.equalTo(sexImgView.mas_right).offset(4);
        make.width.equalTo(hostImgView.mas_height).multipliedBy(2);
    }];
    
    UIImageView *levelImgView = [[UIImageView alloc]init];
    NSDictionary *levelDic = [common getUserLevelMessage:minstr([dic valueForKey:@"level"])];
    [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];

    [backView addSubview:levelImgView];
    [levelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(sexImgView);
        make.left.equalTo(hostImgView.mas_right).offset(4);
        make.width.equalTo(hostImgView.mas_height).multipliedBy(2);
    }];
    
    UILabel *IDLabel = [[UILabel alloc]init];
    IDLabel.textColor = [UIColor whiteColor];
    IDLabel.font = [UIFont systemFontOfSize:11];
    NSString *laingname = minstr([[dic valueForKey:@"liang"] valueForKey:@"name"]);
    
    if ([laingname isEqual:@"0"]) {
        IDLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([dic valueForKey:@"id"])];
    }
    else{
        IDLabel.text = [NSString stringWithFormat:@"%@:%@",YZMsg(@"靓"),laingname];
    }

    [backView addSubview:IDLabel];
    [IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexImgView);
        make.top.equalTo(sexImgView.mas_bottom).offset(5);
        make.height.mas_equalTo(15);
    }];

    UIButton *fansBtn = [UIButton buttonWithType:0];
    [fansBtn setTitle:[NSString stringWithFormat:@"%@  %@",minstr([dic valueForKey:@"fans"]),YZMsg(@"粉丝")] forState:0];
    fansBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    fansBtn.tag = 181221;
    [fansBtn addTarget:self action:@selector(fansOrFollowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:fansBtn];
    [fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView2);
        make.top.equalTo(IDLabel.mas_bottom).offset(15);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(fansBtn);
        make.width.mas_equalTo(1);
        make.left.equalTo(fansBtn.mas_right).offset(15);
    }];
    
    UIButton *followBtn = [UIButton buttonWithType:0];
    [followBtn setTitle:[NSString stringWithFormat:@"%@  %@",minstr([dic valueForKey:@"follows"]),YZMsg(@"关注")] forState:0];
    followBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    followBtn.tag = 181222;
    [followBtn addTarget:self action:@selector(fansOrFollowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:followBtn];
    [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(fansBtn);
        make.left.equalTo(lineView.mas_right).offset(15);
    }];

    UILabel *siginLabel = [[UILabel alloc]init];
    siginLabel.textColor = [UIColor whiteColor];
    siginLabel.text = minstr([dic valueForKey:@"signature"]);
    siginLabel.font = [UIFont systemFontOfSize:13];
    siginLabel.numberOfLines = 0;
    [backView addSubview:siginLabel];
    [siginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImgView2);
        make.top.equalTo(fansBtn.mas_bottom).offset(5);
        make.bottom.equalTo(backView);
        make.width.equalTo(backView).offset(-15);
    }];
    //印象
    UIView *impressView = [[UIView alloc]init];
    impressView.backgroundColor = [UIColor whiteColor];
    [collectionHeader addSubview:impressView];
    [impressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(2);
        make.left.width.equalTo(collectionHeader);
        make.height.equalTo(collectionHeader).multipliedBy(18.00/92);
    }];
    UILabel *impressLabel = [[UILabel alloc]init];
    impressLabel.font = [UIFont systemFontOfSize:15];
    impressLabel.text = YZMsg(@"主播印象");
    [impressView addSubview:impressLabel];
    [impressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(impressView).offset(15);
        make.top.equalTo(impressView);
        make.height.equalTo(impressView).multipliedBy(0.5);
    }];
    UIFont *impressFont;
    CGFloat speace;
    if (IS_IPHONE_5) {
        impressFont = [UIFont systemFontOfSize:13];
        speace = 10;
    }else{
        impressFont = [UIFont systemFontOfSize:14];
        speace = 15;
    }
    UIButton *addImpBtn = [UIButton buttonWithType:0];
    [addImpBtn setTitle:YZMsg(@"+添加印象") forState:0];
    [addImpBtn setTitleColor:normalColors forState:0];
    addImpBtn.titleLabel.font = impressFont;
    [addImpBtn addTarget:self action:@selector(addImpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    addImpBtn.layer.cornerRadius = 5;
    addImpBtn.layer.masksToBounds = YES;
    addImpBtn.layer.borderWidth = 1;
    addImpBtn.layer.borderColor = normalColors.CGColor;
    [impressView addSubview:addImpBtn];
    if ([_userID isEqual:[Config getOwnID]]) {
        addImpBtn.hidden = YES;
    }
    NSArray *labelArray = [dic valueForKey:@"label"];
    
    if (labelArray.count>0) {
        CGFloat jianju = 0;
        for (int i = 0; i < labelArray.count; i ++) {
            UILabel *label = [[UILabel alloc]init];
            label.font = impressFont;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            label.text = minstr([labelArray[i] valueForKey:@"name"]);
            UIColor *color = RGB_COLOR(minstr([labelArray[i] valueForKey:@"colour"]), 1);
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = color;
            [impressView addSubview:label];
            CGFloat yinxiangWidth = [[YBToolClass sharedInstance] widthOfString:label.text andFont:impressFont andHeight:30];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(impressView).offset(15+jianju);
                make.width.mas_equalTo(yinxiangWidth + speace);
                make.height.mas_equalTo(30);
                make.top.equalTo(impressLabel.mas_bottom);
            }];
            jianju = yinxiangWidth+ speace + 10 + jianju;
            if (i == labelArray.count - 1) {
                [addImpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(label.mas_right).offset(15);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo(60+speace);
                    make.top.equalTo(label);
                }];
            }
        }
    }else{
        [addImpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(impressView).offset(15);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(80);
            make.top.equalTo(impressLabel.mas_bottom);
        }];
    }
    //排行
    UIView *rankView = [[UIView alloc]init];
    rankView.backgroundColor = [UIColor whiteColor];
    [collectionHeader addSubview:rankView];
    [rankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(collectionHeader);
        make.top.equalTo(impressView.mas_bottom).offset(3);
        make.bottom.equalTo(collectionHeader).offset(-34);
    }];
    NSArray *rankImgArr = @[@"person_rank",@"person_shouhu"];
    NSArray *rankTitleArr = @[[NSString stringWithFormat:@"%@贡献榜",[common name_votes]],YZMsg(@"守护榜")];
    for (int i = 0; i < rankImgArr.count; i++) {
        UIView *viewww = [[UIView alloc]init];
        [rankView addSubview:viewww];
        if (i == 0) {
            [viewww mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.width.equalTo(rankView);
                make.height.equalTo(rankView).multipliedBy(0.5);
            }];
        }else{
            [viewww mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.width.equalTo(rankView);
                make.height.equalTo(rankView).multipliedBy(0.5);
            }];

            UIView *rankLine = [[UIView alloc]init];
            rankLine.backgroundColor = RGB_COLOR(@"#f4f5f6", 1);
            [rankView addSubview:rankLine];
            [rankLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.width.equalTo(rankView);
                make.height.mas_equalTo(1);
            }];
        }
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:rankImgArr[i]];
        [viewww addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(viewww).offset(15);
            make.centerY.equalTo(viewww);
            make.height.equalTo(viewww).multipliedBy(0.4);
            make.width.equalTo(imageView.mas_height).multipliedBy(1);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:15];
        label.text = rankTitleArr[i];
        [viewww addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(10);
            make.centerY.equalTo(imageView);
        }];
        UIImageView *rightImgView = [[UIImageView alloc]init];
        rightImgView.image = [UIImage imageNamed:@"person_right"];
        [viewww addSubview:rightImgView];
        [rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(viewww).offset(-5);
            make.centerY.equalTo(viewww);
            make.height.equalTo(viewww).multipliedBy(0.4);
            make.width.equalTo(imageView.mas_height);
        }];
        NSArray *perpleArr;
        if (i == 0) {
            perpleArr = [dic valueForKey:@"contribute"];
        }else{
            perpleArr = [dic valueForKey:@"guardlist"];
        }
        int maxPerple = perpleArr.count > 3 ? 3:(int)perpleArr.count;
        for (int i = 0; i < maxPerple; i ++ ) {
            UIImageView *icon = [[UIImageView alloc]init];
            [icon sd_setImageWithURL:[NSURL URLWithString:minstr([perpleArr[i] valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
            icon.layer.cornerRadius = 15;
            icon.layer.masksToBounds = YES;
            icon.layer.borderWidth = 1;
            [viewww addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.mas_equalTo(30);
                make.centerY.equalTo(viewww);
            }];
            if (i == 0) {
                [icon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(rightImgView.mas_left).offset(-40*(maxPerple -1));
                }];
                icon.layer.borderColor= RGB_COLOR(@"#ffdd00", 1).CGColor;
            }
            if (i == 1) {
                [icon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(rightImgView.mas_left).offset(-40*(maxPerple -2));
                }];
                icon.layer.borderColor= RGB_COLOR(@"#cbd4da", 1).CGColor;

            }
            if (i == 2) {
                [icon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(rightImgView.mas_left).offset(-40*(maxPerple -3));
                }];
                icon.layer.borderColor= RGB_COLOR(@"#ac6a00", 1).CGColor;

            }

        }
        UIButton *rankBtn = [UIButton buttonWithType:0];
        [rankBtn addTarget:self action:@selector(rankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        rankBtn.tag = 1000+i;
        [viewww addSubview:rankBtn];
        [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.height.equalTo(viewww);
        }];
    }
    //视频+直播
    segmentView = [[UIView alloc]init];
    segmentView.backgroundColor = [UIColor whiteColor];
    [collectionHeader addSubview:segmentView];
    [segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rankView.mas_bottom).offset(4);
        make.left.width.bottom.equalTo(collectionHeader);
    }];
    
    UIButton *videoBtn = [UIButton buttonWithType:0];
    [videoBtn setTitle:[NSString stringWithFormat:@"视频 %@",minstr([dic valueForKey:@"videonums"])] forState:0];
    [videoBtn setTitleColor:[UIColor blackColor] forState:0];
    videoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [videoBtn addTarget:self action:@selector(live_videoSwitch:) forControlEvents:UIControlEventTouchUpInside];
    videoBtn.tag = 1213;
    [segmentView addSubview:videoBtn];
    [videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(segmentView).multipliedBy(0.5);
        make.height.equalTo(segmentView);
        make.centerY.equalTo(segmentView);
    }];

    UIButton *liveBtn = [UIButton buttonWithType:0];
    [liveBtn setTitle:[NSString stringWithFormat:@"直播 %@",minstr([dic valueForKey:@"livenums"])] forState:0];
    [liveBtn setTitleColor:[UIColor blackColor] forState:0];
    liveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [liveBtn addTarget:self action:@selector(live_videoSwitch:) forControlEvents:UIControlEventTouchUpInside];
    liveBtn.tag = 1214;
    [segmentView addSubview:liveBtn];
    [liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(segmentView).multipliedBy(1.5);
        make.height.equalTo(segmentView);
        make.centerY.equalTo(segmentView);
    }];
    switchLine = [[UIView alloc]init];
    switchLine.backgroundColor = normalColors;
    [segmentView addSubview:switchLine];
    [switchLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(2);
//        make.centerX.equalTo(liveBtn);
        make.bottom.equalTo(segmentView).offset(-2);
        make.left.equalTo(videoBtn.mas_left).offset(10);
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isVideo) {
        return videoArray.count;
    }
    return liveArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isVideo) {
        mineVideoCell *cell = (mineVideoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"mineVideoCELL" forIndexPath:indexPath];
        cell.model = [[NearbyVideoModel alloc]initWithDic:videoArray[indexPath.row]];
        return cell;

    }else{
        personLiveCell *cell = (personLiveCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"personLiveCELL" forIndexPath:indexPath];
        cell.model = [[LiveNodeModel alloc]initWithDic:liveArray[indexPath.item]];
        return cell;
    }
    
}
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isVideo) {
        mineVideoCell *cell = (mineVideoCell *)[collectionView cellForItemAtIndexPath:indexPath];
        LookVideo *video = [[LookVideo alloc]init];
        
        video.fromWhere = @"myVideoV";
        video.curentIndex = indexPath.row;
        video.videoList = videoArray;
        video.pages = videoPage;
        video.firstPlaceImage = cell.thumbImgView.image;
        video.requestUrl = [NSString stringWithFormat:@"%@/?service=video.gethomevideo&uid=%@&touid=%@",purl,[Config getOwnID],[Config getOwnID]];
        video.block = ^(NSMutableArray *array, NSInteger page,NSInteger index) {
            videoPage = (int)page;
            videoArray = array;
            [personCollection reloadData];
            [personCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        };
        video.hidesBottomBarWhenPushed = YES;
        [[MXBADelegate sharedAppDelegate] pushViewController:video animated:YES];

    }else{
        NSDictionary *subdics = liveArray[indexPath.item];
        [MBProgressHUD showMessage:@""];

        [YBToolClass postNetworkWithUrl:@"User.getAliCdnRecord" andParameter:@{@"id":minstr([subdics valueForKey:@"id"])} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            [MBProgressHUD hideHUD];

            if (code == 0) {
                NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:minstr([infoDic valueForKey:@"user_nicename"]),@"name",minstr([infoDic valueForKey:@"avatar"]),@"icon",minstr([infoDic valueForKey:@"id"]),@"id",minstr([infoDic valueForKey:@"level_anchor"]),@"level", nil];
                hietoryPlay *history = [[hietoryPlay alloc]init];
                history.url = [[info firstObject] valueForKey:@"url"];
                history.selectDic = userDic;
    //            [self presentViewController:history animated:YES completion:nil];
                [self.navigationController pushViewController:history animated:YES];

            }else{
                [MBProgressHUD showError:msg];
            }
        } fail:^{
            [MBProgressHUD hideHUD];
        }];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isVideo) {
        return CGSizeMake((_window_width-2)/3, (_window_width-2)/3/25*33);
    }else{
        return CGSizeMake(_window_width, 50);

    }
}

#pragma mark ================ collectionview头视图 ===============


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"hotHeaderV" forIndexPath:indexPath];
    header.backgroundColor = [UIColor whiteColor];
    [header addSubview:collectionHeader];
    return header;

}
//添加印象
- (void)addImpBtnClick{
    impressVC *vc = [[impressVC alloc]init];
    vc.isAdd = YES;
    vc.touid = _userID;
    [self.navigationController pushViewController:vc animated:YES];
}
//贡献榜
- (void)rankBtnClick:(UIButton *)sender{
    if (sender.tag == 1000) {
        //贡献榜
        webH5 *rank = [[webH5 alloc]init];
        rank.urls = [NSString stringWithFormat:@"%@/index.php?g=Appapi&m=contribute&a=index&uid=%@",h5url,self.userID];
        [self.navigationController pushViewController:rank animated:YES];
    }else{
        //守护榜
        guardRankVC *rank = [[guardRankVC alloc]init];
        rank.liveUID = self.userID;
        [self.navigationController pushViewController:rank animated:YES];
    }
}
//切换直播视频
- (void)live_videoSwitch:(UIButton *)sender{
    [UIView animateWithDuration:0.3 animations:^{
        [switchLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sender.mas_left).offset(10);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(segmentView).offset(-2);
        }];
    }];

    if (sender.tag == 1213) {
        //视频
        isVideo = YES;
    }else{
        //直播
        isVideo = NO;
    }
    [personCollection reloadData];
}
#pragma mark ================ scrollviewDelegate ===============
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 64+statusbarHeight) {
        naviView.backgroundColor = RGB_COLOR(@"#ffffff", 1);
        [returnBtn setImage:[UIImage imageNamed:@"person_back_black"] forState:0];
        [shareBtn setImage:[UIImage imageNamed:@"person_share_black"] forState:0];
        titleLabel.text = minstr(self.chatname);
    }else{
        naviView.backgroundColor = RGB_COLOR(@"#ffffff", scrollView.contentOffset.y/(64.00000+statusbarHeight));
        [returnBtn setImage:[UIImage imageNamed:@"person_back_white"] forState:0];
        [shareBtn setImage:[UIImage imageNamed:@"person_share_white"] forState:0];
        titleLabel.text = @"";
    }
    
}
#pragma 粉丝 关注
- (void)fansOrFollowBtnClick:(UIButton *)sender{
    if (sender.tag == 181221) {
        fansViewController *fans = [[fansViewController alloc]init];
        fans.fensiUid = _userID;
        [self.navigationController pushViewController:fans animated:YES];
    }else{
        attrViewController *att = [[attrViewController alloc]init];
        att.guanzhuUID = _userID;
        [self.navigationController pushViewController:att animated:YES];
    }
}
@end
