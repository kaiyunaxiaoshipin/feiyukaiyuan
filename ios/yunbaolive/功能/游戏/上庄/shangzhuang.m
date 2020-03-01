//
//  shangzhuang.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/9.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "shangzhuang.h"
#import "zhuanglistcell.h"
#import "liushuicell.h"
@interface shangzhuang ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView *backimage;
    UIButton *backbtnzhuang;
    UIImageView *imageBottomVcresulteords;//显示结果文字
    NSTimer *removetimer;
    NSTimer *zhuangpokeranimation;//上庄发牌动画
    NSDictionary *zhuangstartdic;//庄家初始化信息
    NSString *gamecoins;
    UIImageView *tableviewbackimage;
    UIButton *recordbtn;
    BOOL _isHost;
    UIImageView *tableviewbackimageliushui;
    UIAlertView *panduanalert;
    UITextField *txtName;
    NSString *_zhuangjiaid;
}
@property(nonatomic,strong)UIView *MaskV;//遮罩
@property(nonatomic,strong)UIView *MaskVzhezhao;//遮罩
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)UITableView *tableviewliushui;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,strong)NSMutableArray *itemsliushui;
@property(nonatomic,strong)UIButton *iconbtn;
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UILabel *yingpiaoLabel;
@property(nonatomic,strong)UIView *imagebackImage;
@property(nonatomic,strong)UIImageView *zuanshiImage;
@property(nonatomic,assign)CGSize yingpiaoSize;
@end
@implementation shangzhuang
-(void)getNewZhuang:(NSDictionary *)dic{
    _zhuangdic = dic;
    [self doitok];
}
-(void)doitok{
    NSString *game_bankerid = [NSString stringWithFormat:@"%@",[_zhuangdic valueForKey:@"id"]];
    if ([game_bankerid isEqual:@"0"] || [game_bankerid isEqual:@"<null>"] || [game_bankerid isEqual:@"(null)"]) {
        [_iconbtn setImage:[UIImage imageNamed:@"吕布头像.png"] forState:UIControlStateNormal];
    }
    else{
        [_iconbtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[_zhuangdic valueForKey:@"uhead"]]] forState:UIControlStateNormal];
    }
    _nameL.text = [_zhuangdic valueForKey:@"user_nicename"];
    _yingpiaoLabel.text = [NSString stringWithFormat:@"%@",[_zhuangdic valueForKey:@"coin"]];
    if (![_zhuangjiaid isEqual:minstr([_zhuangdic valueForKey:@"id"])]) {
        NSString *path = [NSString stringWithFormat:@"%@%@%@",YZMsg(@"恭喜"),[_zhuangdic valueForKey:@"user_nicename"],YZMsg(@"上庄")];
        [MBProgressHUD showError:path];
    }
    _zhuangjiaid = minstr([_zhuangdic valueForKey:@"id"]);
//    NSString *path = [NSString stringWithFormat:@"恭喜%@上庄",[_zhuangdic valueForKey:@"user_nicename"]];
//    [MBProgressHUD showError:path];
}
//获取庄家初始化信息
-(void)getbanksCoin:(NSDictionary *)zhuangdic{
    NSString *game_bankerid = [NSString stringWithFormat:@"%@",[zhuangdic valueForKey:@"id"]];
    if ([game_bankerid isEqual:@"0"] || [game_bankerid isEqual:@"<null>"] || [game_bankerid isEqual:@"(null)"]) {
        [_iconbtn setImage:[UIImage imageNamed:@"吕布头像.png"] forState:UIControlStateNormal];
    }
    else{
        _zhuangdic = zhuangdic;
        [_iconbtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[zhuangdic valueForKey:@"uhead"]]] forState:UIControlStateNormal];
    }
    if ([game_bankerid isEqual:[Config getcoin]]) {
        _zhuangdic = nil;
    }
    zhuangstartdic = zhuangdic;
    _yingpiaoLabel.text = [NSString stringWithFormat:@"%@",[zhuangdic valueForKey:@"coin"]];
    _nameL.text = [NSString stringWithFormat:@"%@",[zhuangdic valueForKey:@"user_nicename"]];
}
-(instancetype)initWithFrame:(CGRect)frame ishost:(BOOL)ishost withstreame:(NSString *)stream{
    self = [super initWithFrame:frame];
    if (self) {
        _stream = stream;
        _isHost = ishost;
        _items = [NSMutableArray array];
        _itemsliushui = [NSMutableArray array];
        backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width/3.5, _window_width/3.5)];
        backimage.userInteractionEnabled = YES;
        [backimage setImage:[UIImage imageNamed:@"hundred_owner_bg"]];
        backimage.contentMode = UIViewContentModeScaleAspectFill;
        //申请上下庄
        backbtnzhuang = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtnzhuang setImage:[UIImage imageNamed:@"updawonzhuang"] forState:UIControlStateNormal];
        backbtnzhuang.frame = CGRectMake(0,_window_width/3.5 - 5,_window_width/3.5 - 5,_window_width/8);
        [backbtnzhuang addTarget:self action:@selector(doZhuang) forControlEvents:UIControlEventTouchUpInside];
        backbtnzhuang.imageView.contentMode = UIViewContentModeScaleAspectFit;
        backbtnzhuang.selected = NO;
        [self addSubview:backbtnzhuang];
        [self addSubview:backimage];
        _iconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_iconbtn setImage:[UIImage imageNamed:@"吕布头像.png"] forState:UIControlStateNormal];
        //头像
        _iconbtn.frame = CGRectMake(5,15, 25, 25);
        _iconbtn.layer.masksToBounds = YES;
        _iconbtn.layer.cornerRadius = 12.5;
        _iconbtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconbtn.layer.borderWidth = 1.0;
        //名称
        _nameL = [[UILabel alloc]initWithFrame:CGRectMake(_iconbtn.right+2,20, _window_width/3.5 - 30, 20)];
        _nameL.textColor = [UIColor whiteColor];
        _nameL.font = fontMT(9);
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.text = YZMsg(@"吕布");
        [backimage addSubview:_iconbtn];
        [backimage addSubview:_nameL];
        //钱
        _yingpiaoLabel  = [[UILabel alloc]init];
        _yingpiaoLabel.backgroundColor = [UIColor clearColor];
        _yingpiaoLabel.font = fontMT(10);
        _yingpiaoLabel.textAlignment = NSTextAlignmentLeft;
        _yingpiaoLabel.textColor = normalColors;
        _imagebackImage = [[UIView alloc]init];
        _imagebackImage.layer.cornerRadius = 7.5;
        _imagebackImage.userInteractionEnabled = YES;
        _imagebackImage.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
        //流水
        _zuanshiImage = [[UIImageView alloc] initWithFrame:CGRectMake(10,2.5,15,15)];;
        _zuanshiImage.image = [UIImage imageNamed:@"game_hundred_bull_liushui_icon"];
        _zuanshiImage.backgroundColor = [UIColor clearColor];
        _zuanshiImage.contentMode = UIViewContentModeScaleAspectFit;
        [_imagebackImage addSubview:_yingpiaoLabel];
        [_imagebackImage addSubview:_zuanshiImage];
        [backimage addSubview:_imagebackImage];
        _yingpiaoLabel.frame = CGRectMake(10,0,_window_width/3.5 - 30,15);
        _imagebackImage.frame = CGRectMake(0,45,_window_width/3.5 - 10,15);
        _zuanshiImage.frame = CGRectMake(_imagebackImage.frame.size.width - 30,0,30,15);        
        for (int i=0; i<5; i++) {
            UIImageView *imageBottomVc  = (UIImageView *)[self viewWithTag:1000+i];
            if (imageBottomVc) {
                [imageBottomVc removeFromSuperview];
                imageBottomVc = nil;
            }
        }
        if (imageBottomVcresulteords) {
            [imageBottomVcresulteords removeFromSuperview];
            imageBottomVcresulteords = nil;
        }
        //列表
        UITapGestureRecognizer *tapliushuis = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doliushui)];
        _imagebackImage.userInteractionEnabled = YES;
        [_imagebackImage addGestureRecognizer:tapliushuis];
        
    }
    return self;
}
//中途进入
-(void)setpoker{
    [self addpokersanimation];
}
//扑克牌
-(void)addPoker{
    if (_isHost) {
        if (!zhuangpokeranimation) {
            zhuangpokeranimation = [NSTimer scheduledTimerWithTimeInterval:11.0 target:self selector:@selector(addpokersanimation) userInfo:nil repeats:NO];
        }
    }else{
        if (!zhuangpokeranimation) {
            zhuangpokeranimation = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(addpokersanimation) userInfo:nil repeats:NO];
        }
    }
}
-(void)addpokersanimation{
    [zhuangpokeranimation invalidate];
    zhuangpokeranimation = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat shipeiX = -5;
        for (int i = 0; i < 5; i++) {
            UIImageView *imageBottomVc = [[UIImageView alloc]init];
            [imageBottomVc setImage:[UIImage imageNamed:@"poker_back_popbull"]];
            imageBottomVc.contentMode = UIViewContentModeScaleAspectFit;
            imageBottomVc.frame = CGRectMake(shipeiX,67,_window_width/3.5/5,_window_width/3.5 - 70);
            imageBottomVc.tag = 1000 + i;
            shipeiX+=_window_width/3.5/5;
            [backimage addSubview:imageBottomVc];
        }
    });
}
-(void)getresult:(NSArray *)ct{
    /*
     (
     2-11,
     2-2,
     4-7,
     1,显示颜色。 1灰色  2蓝色  3金色
     单牌,
     0,
     1,
     0
     )
     */
    ct = ct[3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<5; i++) {
            UIImageView *imageBottomVc  = (UIImageView *)[self viewWithTag:1000+i];
            [imageBottomVc setImage:[UIImage imageNamed:ct[i]]];
            [UIView beginAnimations:@"View Filp" context:nil];
            [UIView setAnimationDelay:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveLinear];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:imageBottomVc cache:NO];
            [UIView commitAnimations];
        }
        //显示结果文字
        if (imageBottomVcresulteords) {
            [imageBottomVcresulteords removeFromSuperview];
            imageBottomVcresulteords = nil;
        }
        if (!imageBottomVcresulteords) {
            imageBottomVcresulteords = [[UIImageView alloc]init];
            imageBottomVcresulteords.contentMode = UIViewContentModeScaleAspectFit;
            imageBottomVcresulteords.frame = CGRectMake(0,67,_window_width/3.5,_window_width/3.5 - 70);
            [backimage addSubview:imageBottomVcresulteords];
        }
        NSString *names = [NSString stringWithFormat:@"%@",ct[6]];
        NSString *imagename = [NSString stringWithFormat:@"%@2",names];
        [imageBottomVcresulteords setImage:[UIImage imageNamed:imagename]];
        if (zhuangpokeranimation) {
            [zhuangpokeranimation invalidate];
            zhuangpokeranimation = nil;
        }
        if (!zhuangpokeranimation) {
            zhuangpokeranimation = [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(addpokersanimation) userInfo:nil repeats:NO];
        }
        if (!removetimer) {
            removetimer = [NSTimer scheduledTimerWithTimeInterval:14.0 target:self selector:@selector(remopokers) userInfo:nil repeats:NO];
        }
    });
}
-(void)removeall{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    if (zhuangpokeranimation) {
        [zhuangpokeranimation invalidate];
        zhuangpokeranimation = nil;
    }
    [removetimer invalidate];
    removetimer = nil;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (zhuangpokeranimation) {
        [zhuangpokeranimation invalidate];
        zhuangpokeranimation = nil;
    }
    [removetimer invalidate];
    removetimer = nil;
}
-(void)remopokers{

    [removetimer invalidate];
    removetimer = nil;
    for (int i=0; i<5; i++) {
        UIImageView *imageBottomVc  = (UIImageView *)[self viewWithTag:1000+i];
        if (imageBottomVc) {
            [imageBottomVc removeFromSuperview];
            imageBottomVc = nil;
        }
    }
    if (imageBottomVcresulteords) {
        [imageBottomVcresulteords removeFromSuperview];
        imageBottomVcresulteords = nil;
    }
}
//申请上庄列表
-(void)doZhuang{
    [self getnewrecord];
    tableviewbackimage.hidden = NO;
    _MaskV.hidden = NO;
    [self tableviewanimation];
}
-(void)animation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [backbtnzhuang.layer addAnimation:animation forKey:nil];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == panduanalert) {
        if (buttonIndex ==0 ) {
            
            
        }
        else if (buttonIndex ==1){
        txtName = [alertView textFieldAtIndex:0];
            NSString *url = [NSString stringWithFormat:@"Game.setBanker&stream=%@&uid=%@&token=%@&deposit=%@",_stream,[Config getOwnID],[Config getOwnToken],txtName.text];

            [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
                if (code == 0) {
                    NSMutableArray *infos = [info firstObject];
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[infos valueForKey:@"msg"]]];
                    [self getnewrecord];

                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                        panduanalert = [[UIAlertView alloc]initWithTitle:YZMsg(@"上庄押金") message:@"" delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
                        
                        [panduanalert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        txtName = [panduanalert textFieldAtIndex:0];
                        txtName.keyboardType = UIKeyboardTypeNumberPad;
                        NSString *coinlimit = [NSString stringWithFormat:@"%@",[zhuangstartdic valueForKey:@"game_banker_limit"]];
                        txtName.placeholder = [NSString stringWithFormat:@"%@ %@ %@",YZMsg(@"请输入押金,最低"),coinlimit,[common name_coin]];
                        [panduanalert show];
                    });

                }
            } fail:^{
                
            }];
            /*
         NSString *url = [purl stringByAppendingFormat:@"?service=Game.setBanker&stream=%@&uid=%@&token=%@&deposit=%@",_stream,[Config getOwnID],[Config getOwnToken],txtName.text];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSNumber *number = [responseObject valueForKey:@"ret"] ;
                if([number isEqualToNumber:[NSNumber numberWithInt:200]])
                {
                    NSArray *data = [responseObject valueForKey:@"data"];
                    NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
                    if([code isEqual:@"0"])
                    {
                        NSMutableArray *info = [[data valueForKey:@"info"] firstObject];
                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[info valueForKey:@"msg"]]];
                        [self getnewrecord];
                    }
                    else{
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]] message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                        [alert show];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alert dismissWithClickedButtonIndex:0 animated:YES];
                            panduanalert = [[UIAlertView alloc]initWithTitle:YZMsg(@"上庄押金") message:@"" delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
                            
                            [panduanalert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                            txtName = [panduanalert textFieldAtIndex:0];
                            txtName.keyboardType = UIKeyboardTypeNumberPad;
                            NSString *coinlimit = [NSString stringWithFormat:@"%@",[zhuangstartdic valueForKey:@"game_banker_limit"]];
                            txtName.placeholder = [NSString stringWithFormat:@"请输入押金,最低 %@ %@",coinlimit,[common name_coin]];
                            [panduanalert show];
                        });
                    }
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"msg"]] message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    [alert show];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [alert dismissWithClickedButtonIndex:0 animated:YES];
                        panduanalert = [[UIAlertView alloc]initWithTitle:YZMsg(@"上庄押金") message:@"" delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
                        
                        [panduanalert setAlertViewStyle:UIAlertViewStylePlainTextInput];
                        txtName = [panduanalert textFieldAtIndex:0];
                        txtName.keyboardType = UIKeyboardTypeNumberPad;
                        NSString *coinlimit = [NSString stringWithFormat:@"%@",[zhuangstartdic valueForKey:@"game_banker_limit"]];
                        txtName.placeholder = [NSString stringWithFormat:@"请输入押金,最低 %@ %@",coinlimit,[common name_coin]];
                        [panduanalert show];
                    });
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
             */
        }
    }
    else{
       if (buttonIndex == 0) {
          
           [self endEditing:YES];
         
    }else{
         // [self.deleagte downzhuang];
      }
    }
}

-(void)dismissroom{
    //[self dorecord];
}
//隐藏tableview
-(void)dohidetableview{
    [self tableviewanimationhide];
    _MaskV.hidden = YES;
    tableviewbackimage.hidden = YES;
}
-(void)dohidetableviewliushui{
    [self tableviewanimationhideliushui];
    _MaskVzhezhao.hidden = YES;
    tableviewbackimageliushui.hidden = YES;
}


//申请上庄
-(void)dorecord{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [recordbtn.layer addAnimation:animation forKey:nil];
    
    /*
    int coins = [coinlimit intValue];
    int mycoin = [[Config getcoin] intValue];
    if (mycoin < coins) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"您的余额不足%@%@,无法上庄",coinlimit,[common name_coin]]];
        return;
    }
    */
    NSString *coinlimit = [NSString stringWithFormat:@"%@",[zhuangstartdic valueForKey:@"game_banker_limit"]];

    NSString *url;
    if ([recordbtn.titleLabel.text isEqual:YZMsg(@"申请上庄")]) {
        panduanalert = [[UIAlertView alloc]initWithTitle:YZMsg(@"上庄押金") message:@"" delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
        
        [panduanalert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        txtName = [panduanalert textFieldAtIndex:0];
        txtName.keyboardType = UIKeyboardTypeNumberPad;
        txtName.placeholder = [NSString stringWithFormat:@"%@ %@ %@",YZMsg(@"请输入押金,最低"),coinlimit,[common name_coin]];
        [panduanalert show];
    }else{
        url = [NSString stringWithFormat:@"Game.quietBanker&stream=%@&uid=%@",_stream,[Config getOwnID]];
        [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                NSMutableArray *infos = [info firstObject];
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[infos valueForKey:@"msg"]]];
                [self getnewrecord];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:@"" delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                [alert show];

            }
        } fail:^{
            
        }];
//        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    [session POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSNumber *number = [responseObject valueForKey:@"ret"] ;
//        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
//        {
//            NSArray *data = [responseObject valueForKey:@"data"];
//            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
//            if([code isEqual:@"0"])
//            {
//                NSMutableArray *info = [[data valueForKey:@"info"] firstObject];
//                [MBProgressHUD showError:[NSString stringWithFormat:@"%@",[info valueForKey:@"msg"]]];
//                [self getnewrecord];
//            }
//            else{
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]] message:@"" delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
//                [alert show];
//            }
//        }
//        else{
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"msg"]] message:@"" delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    }
}
//打开流水
-(void)doliushui{
    [self getliushui];
    tableviewbackimageliushui.hidden = NO;
    _MaskVzhezhao.hidden = NO;
    [self tableviewanimationliushui];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableviewliushui) {
        return _itemsliushui.count;
    }else{
    return _items.count + 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _tableviewliushui) {
        liushuicell *cell = [liushuicell cellWithTableview:tableView];
        cell.frame = CGRectMake(0,0, _tableviewliushui.frame.size.width, 50);
        
        NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:_itemsliushui[indexPath.row]];
        NSString *path = [NSString stringWithFormat:@"%ld",_itemsliushui.count - indexPath.row];
        if (indexPath.row == 0) {
             [subdic setObject:@"局号" forKey:@"count"];
        }else{
             [subdic setObject:path forKey:@"count"];
        }
        [cell setmodel:subdic andframe:CGRectMake(0,0, _tableviewliushui.frame.size.width, 50)];
        cell.backgroundColor =[UIColor clearColor];
        return cell;
    }
    else
    {
    zhuanglistcell *cell = [zhuanglistcell cellWithTableview:tableView];
    cell.frame = CGRectMake(0,0,_tableview.frame.size.width, 50);
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        
        [cell setfirstitem];
        
    }
    else{
      [cell setmodel:_items[indexPath.row -1]];
        
    }
     return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableviewanimation{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [tableviewbackimage.layer addAnimation:animation forKey:nil];
}
-(void)tableviewanimationhide{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8,0.8,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6,0.6,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4,0.4,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0,0,1.0)]];
    animation.values = values;
    [tableviewbackimage.layer addAnimation:animation forKey:nil];
    
}
-(void)tableviewanimationliushui{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [tableviewbackimageliushui.layer addAnimation:animation forKey:nil];
}
-(void)tableviewanimationhideliushui{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8,0.8,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6,0.6,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4,0.4,1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0,0,1.0)]];
    animation.values = values;
    [tableviewbackimageliushui.layer addAnimation:animation forKey:nil];
    
}
-(void)addtableview{
    _MaskV = [[UIView alloc]initWithFrame:CGRectMake(_window_width,0,_window_width,_window_height)];
    _MaskV.hidden = YES;
    if (_isHost) {
        _MaskV.frame = CGRectMake(0, 0, _window_width, _window_height);
    }
    _MaskV.backgroundColor = [UIColor clearColor];
    [self.superview addSubview:_MaskV];
    tableviewbackimage = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + _window_width*0.15, _window_height*0.2, _window_width*0.7, _window_width*0.9)];
    [tableviewbackimage setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_bg"]];
    if (_isHost) {
        tableviewbackimage.frame = CGRectMake( _window_width*0.15,_window_height*0.2, _window_width*0.7, _window_width*0.9);
    }
    [self.superview addSubview:tableviewbackimage];
    tableviewbackimage.userInteractionEnabled = YES;
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(5,40, tableviewbackimage.frame.size.width - 10, tableviewbackimage.frame.size.height - 100) style:UITableViewStylePlain];
    _tableview.allowsSelection = NO;
    _tableview.delegate   = self;
    _tableview.dataSource = self;
    _tableview.layer.masksToBounds = YES;
    _tableview.layer.cornerRadius = 10;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.backgroundColor = [UIColor clearColor];
    [tableviewbackimage addSubview:_tableview];
    tableviewbackimage.hidden = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dohidetableview) forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [tableviewbackimage addSubview:btn];
    btn.frame =CGRectMake(tableviewbackimage.frame.size.width - 25,-20,40,40);
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dohidetableview)];
    [_MaskV addGestureRecognizer:taps];
    
    
    
    NSString *path = YZMsg(@"上庄列表");
    UILabel *labelslist = [[UILabel alloc]init];
    labelslist.text = path;
    labelslist.textAlignment = NSTextAlignmentCenter;
    labelslist.backgroundColor = [UIColor clearColor];
    labelslist.textColor = [UIColor whiteColor];
    labelslist.frame = CGRectMake(0,10,_tableview.frame.size.width,20);
    [tableviewbackimage addSubview:labelslist];
    
    
    
    recordbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordbtn setBackgroundImage:[UIImage imageNamed:@"live_hundred_bull_apply_to_banker_btn_bg"] forState:UIControlStateNormal];
    [recordbtn addTarget:self action:@selector(dorecord) forControlEvents:UIControlEventTouchUpInside];
    recordbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    recordbtn.frame =CGRectMake(tableviewbackimage.frame.size.width * 0.1,tableviewbackimage.frame.size.height - 60,tableviewbackimage.frame.size.width * 0.8,35);
    [recordbtn setTitle:YZMsg(@"申请上庄") forState:UIControlStateNormal];
    [recordbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [tableviewbackimage addSubview:recordbtn];
 
    
    
    
    _MaskVzhezhao = [[UIView alloc]initWithFrame:CGRectMake(_window_width,0,_window_width,_window_height)];
    _MaskVzhezhao.hidden = YES;
    if (_isHost) {
        _MaskVzhezhao.frame = CGRectMake(0, 0, _window_width, _window_height);
    }
    [self.superview addSubview:_MaskVzhezhao];
    _MaskVzhezhao.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapsss2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dohidetableviewliushui)];
    [_MaskVzhezhao addGestureRecognizer:tapsss2];
    
    
    tableviewbackimageliushui = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + _window_width*0.15, _window_height*0.2, _window_width*0.7, _window_width*0.9)];
    [tableviewbackimageliushui setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_bg"]];
    [self.superview addSubview:tableviewbackimageliushui];
    tableviewbackimageliushui.userInteractionEnabled = YES;
    
    
    if (_isHost) {
        tableviewbackimageliushui.frame = CGRectMake(_window_width*0.15, _window_height*0.2, _window_width*0.7, _window_width*0.9);
    }
    
    UIImageView *imagevcs = [[UIImageView alloc]initWithFrame:CGRectMake(5,40, tableviewbackimageliushui.frame.size.width - 10, tableviewbackimageliushui.frame.size.height - 40)];
    [imagevcs setImage:[UIImage imageNamed:@"live_hundred_bull_history_data_bg"]];
    imagevcs.userInteractionEnabled = YES;
    
    
    _tableviewliushui = [[UITableView alloc]initWithFrame:imagevcs.bounds style:UITableViewStylePlain];
    _tableviewliushui.allowsSelection = NO;
    _tableviewliushui.delegate   = self;
    _tableviewliushui.dataSource = self;
    _tableviewliushui.layer.masksToBounds = YES;
    _tableviewliushui.layer.cornerRadius = 10;
    _tableviewliushui.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableviewliushui.backgroundColor = [UIColor clearColor];
    
    
    
    UILabel *labelsssss = [[UILabel alloc]initWithFrame:CGRectMake(0,10,tableviewbackimageliushui.frame.size.width, 30)];
    labelsssss.font = fontMT(18);
    labelsssss.textAlignment = NSTextAlignmentCenter;
    labelsssss.textColor = [UIColor whiteColor];
    labelsssss.text = YZMsg(@"庄家流水");
    
    
    [tableviewbackimageliushui addSubview:labelsssss];
    [tableviewbackimageliushui addSubview:imagevcs];
    [imagevcs addSubview:_tableviewliushui];
    
    UIButton *btnssss = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnssss setImage:[UIImage imageNamed:@"live_hundred_bull_history_dialog_close"] forState:UIControlStateNormal];
    [btnssss addTarget:self action:@selector(dohidetableviewliushui) forControlEvents:UIControlEventTouchUpInside];
    btnssss.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [tableviewbackimageliushui addSubview:btnssss];
    btnssss.frame =CGRectMake(tableviewbackimageliushui.frame.size.width - 25,-20,40,40);
    
    tableviewbackimageliushui.hidden = YES;

    
    
}
//获取上庄列表
-(void)getnewrecord{
    
    NSString *url = [NSString stringWithFormat:@"%@&stream=%@",@"Game.getBanker",_stream];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            _items = [info mutableCopy];
            if (_items.count >= 2) {
                [_items removeLastObject];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                
                for (NSDictionary *subdic in info) {
                    NSString *uid = [subdic valueForKey:@"id"];
                    if ([uid isEqual:[Config getOwnID]]) {
                        [recordbtn setTitle:YZMsg(@"下庄") forState:UIControlStateNormal];
                        break;
                    }
                    else{
                        [recordbtn setTitle:YZMsg(@"申请上庄") forState:UIControlStateNormal];
                    }
                }
            });

        }
    } fail:^{
        
    }];
}
//获取上庄流水
-(void)getliushui{
    NSString *url = [NSString stringWithFormat:@"%@&stream=%@&bankerid=%@",@"Game.getBankerProfit",_stream,[_zhuangdic valueForKey:@"id"]];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSMutableArray *infos = [NSMutableArray arrayWithArray:info];
            _itemsliushui = infos;
            NSDictionary *subdic = @{
                                     @"banker_card":@"牌型",
                                     @"banker_profit":@"结算"
                                     };
            [_itemsliushui insertObject:subdic atIndex:0];
            [self.tableviewliushui reloadData];
        }
    } fail:^{
        
    }];
    
}
@end
