//
//  Hourglass.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/5/16.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "Hourglass.h"
@interface Hourglass ()<UIAlertViewDelegate>
{
    UIButton *jingpaibtn;//竞拍
    UIButton *jingpaibtnnums;//竞拍
    
    UILabel *timel;//竞拍时间
    UILabel *timenamel;
    UIImageView *jingpaisuccessimage;
    UIButton *shangpinxiangqing;//商品详情
    NSTimer *daojishitimer;//竞拍倒计时
    int alltimes;//竞拍总时间
    NSString *idtype;//竞拍id
    
    UIView *jingpaitopv;
    UIButton *jingpaiiconbtn;
    UILabel *jingpainamel;
    UILabel *jingpaizuanshilabel;
    
    UIView *successview;//显示竞拍成功的人
    UILabel *successnamel;
    UILabel *successbottoml;
    UIButton *paybtn;//立即付款
    UIView *paybottomv;//付款view
    NSDictionary *shangpindic;//竞拍商品信息
    NSTimer *paytimer;//付款倒计时
    int paytimes;//付款时间
    
    NSDictionary *resultdic;//结果dic
    
    UIImageView *iconimage;
    UILabel *namel;
    UILabel *coinl;
    UILabel *timels;
    UIButton  *canclebtn;
    UIButton  *paymentbtn;
    UILabel *line;
}
@property(nonatomic,strong)UIView *MaskV;//遮罩
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIButton *jumpRecharge;
@property(nonatomic,strong)UIImageView *jiantou;
@property(nonatomic,strong)UILabel *chongzhi;
@property(nonatomic,strong)UIImageView *coinImg;
@end
@implementation Hourglass
-(void)removeall{
    

    if (daojishitimer) {
        [daojishitimer invalidate];
        daojishitimer = nil;
    }
    if (paytimer) {
        [paytimer invalidate];
        paytimer = nil;
    }
    
}
-(void)dealloc{

    if (daojishitimer) {
        [daojishitimer invalidate];
        daojishitimer = nil;
    }
    if (paytimer) {

    [paytimer invalidate];
    paytimer = nil;
    }
}

-(instancetype)initWithDic:(NSDictionary *)hostdic andFrame:(CGRect)frame Block:(taskblocks)block andtask:(taskblocks)taskblock andjingpaixiangqingblock:(taskblocks)jingpaiblock andchongzhi:(taskblocks)chongzhiblock{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        shangpindic = [NSDictionary dictionary];
        
        idtype = @"";
        _items = [NSArray array];
        self.blocks = block;//
        self.taskblock = taskblock;//任务block
        self.jingpaiblock = jingpaiblock;//竞拍详情block
        self.chongzhiblock = chongzhiblock;
        
        jingpaibtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jingpaibtn setImage:[UIImage imageNamed:@"拍卖chuizi"] forState:UIControlStateNormal];
        jingpaibtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        jingpaibtn.frame = CGRectMake(0,0,frame.size.width,frame.size.width);
        [jingpaibtn addTarget:self action:@selector(dojingpai) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jingpaibtn];
        
        jingpaibtnnums = [UIButton buttonWithType:UIButtonTypeCustom];
        [jingpaibtnnums setBackgroundImage:[UIImage imageNamed:@"拍卖的副本"] forState:UIControlStateNormal];
        jingpaibtnnums.imageView.contentMode = UIViewContentModeScaleAspectFit;
        jingpaibtnnums.frame = CGRectMake(-20,jingpaibtn.bottom - 5,frame.size.width + 20,20);
        [jingpaibtnnums addTarget:self action:@selector(dojingpai) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:jingpaibtnnums];
        jingpaibtnnums.titleLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:12];
        [jingpaibtnnums setTitleEdgeInsets:UIEdgeInsetsMake(0,5,0,0)];
        
        
        shangpinxiangqing = [UIButton buttonWithType:UIButtonTypeCustom];
        [shangpinxiangqing setTitle:@"商品详情" forState:UIControlStateNormal];
        shangpinxiangqing.layer.masksToBounds = YES;
        shangpinxiangqing.layer.cornerRadius = 10;
        shangpinxiangqing.layer.borderWidth = 1.0;
        shangpinxiangqing.layer.borderColor = [UIColor whiteColor].CGColor;
        shangpinxiangqing.imageView.contentMode = UIViewContentModeScaleAspectFit;
        shangpinxiangqing.frame = CGRectMake(0,jingpaibtnnums.bottom + 10,frame.size.width,20);
        [shangpinxiangqing addTarget:self action:@selector(doshangpin) forControlEvents:UIControlEventTouchUpInside];
        shangpinxiangqing.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        shangpinxiangqing.titleLabel.layer.shadowOffset = CGSizeMake(0,0.5);
        shangpinxiangqing.titleLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:13];
        shangpinxiangqing.backgroundColor = normalColors;
        [self addSubview:shangpinxiangqing];
        
        
        jingpaibtn.hidden = YES;
        jingpaibtnnums.hidden = YES;
        shangpinxiangqing.hidden = YES;
    
        
    }
    return self;
}
//商品详情
-(void)doshangpin{
    
    self.jingpaiblock(idtype);
}
//竞拍 点击竞拍加价
-(void)dojingpai{
    
    //code = 1003 提示交保证金
    //[self addjingpairesultview:1];
    NSString *userBaseUrl = [NSString stringWithFormat:@"Live.setAuction&uid=%@&token=%@&auctionid=%@",[Config getOwnID],[Config getOwnToken],idtype];

    [YBToolClass postNetworkWithUrl:userBaseUrl andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *infoDic = [info firstObject];
            
            self.blocks(minstr([infoDic valueForKey:@"bid_price"]));
            [MBProgressHUD showError:@"竞拍投注成功"];

        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
            [alert show];
        }

    } fail:^{
        
    }];
}
-(void)getcoins{
    [YBToolClass postNetworkWithUrl:@"Live.getCoin" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0 )
        {
            NSDictionary *infoDic = [info firstObject];
            LiveUser *user = [Config myProfile];
            user.coin = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"coin"]];
            [Config updateProfile:user];
        }

    } fail:^{
        
    }];

}
-(void)tasks{
  
    
    
}
//有人竞拍，刷新竞拍信息
-(void)getnewmessage:(NSDictionary *)dic{
    //刷新金额
    [jingpaibtnnums setTitle:minstr([dic valueForKey:@"money"]) forState:UIControlStateNormal];
    //刷新竞拍金额最多的人
    [jingpaiiconbtn sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"uhead"])] forState:UIControlStateNormal];
    jingpainamel.text = minstr([dic valueForKey:@"uname"]);
    jingpaizuanshilabel.text = minstr([dic valueForKey:@"money"]);
    jingpaitopv.hidden = NO;
    
    
    NSString *ID = minstr([dic valueForKey:@"uid"]);
    if ([ID isEqual:@"0"]) {
        jingpaitopv.hidden = YES;
    }
}
//添加竞拍倒数计时
-(void)addtimeL{
    
    if (!timenamel) {
   
    timenamel= [[UILabel alloc]initWithFrame:CGRectMake(_window_width*1.6-10,90,_window_width*0.4,20)];
    timenamel.text = @"竞拍剩余时间";
    timenamel.textColor = [UIColor whiteColor];
    timenamel.font =  [UIFont fontWithName:@"Arial-ItalicMT" size:15];
    timenamel.textAlignment = NSTextAlignmentRight;
    timenamel.shadowColor = [UIColor blackColor];
    timenamel.shadowOffset = CGSizeMake(0,0.5);
    [self.superview addSubview:timenamel];
    }
    if (!timel) {
    timel= [[UILabel alloc]initWithFrame:CGRectMake(_window_width*1.6-10,110,_window_width*0.4,20)];
    timel.textColor = [UIColor whiteColor];
    timel.font =  [UIFont fontWithName:@"Arial-ItalicMT" size:15];;
    timel.textAlignment = NSTextAlignmentRight;
    timel.shadowColor = [UIColor blackColor];
    timel.shadowOffset = CGSizeMake(0,0.5);
    [self.superview addSubview:timel];
   }
}
//获取竞拍信息
-(void)getjingpaimessage:(NSDictionary *)subdic{
    //显示竞拍时间
    [self addtimeL];
    jingpaibtn.hidden = NO;
    jingpaibtnnums.hidden = NO;
    shangpinxiangqing.hidden = NO;
    if (daojishitimer) {
        [daojishitimer invalidate];
        daojishitimer = nil;
    }
    alltimes = [[subdic valueForKey:@"long"] intValue];
    daojishitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dodaojishi) userInfo:nil repeats:YES];
    [jingpaibtnnums setTitle:minstr([subdic valueForKey:@"price_start"]) forState:UIControlStateNormal];
    //竞拍id，根据这个id去竞拍详情页
    idtype = minstr([subdic valueForKey:@"id"]);
    _price_bond = minstr([subdic valueForKey:@"price_bond"] );//获取保证金
    timel.hidden = NO;
    timenamel.hidden = NO;
    shangpindic = subdic;
}
//竞拍倒计时
-(void)dodaojishi{
    jingpaibtn.enabled = YES;
    alltimes -=1;
    timel.text = [self timeFormatted:alltimes];
    if (alltimes <= 0) {
        jingpaibtn.enabled = NO;
        [daojishitimer invalidate];
        daojishitimer = nil;
        timel.hidden = YES;
        timenamel.hidden = YES;
        jingpaitopv.hidden = YES;
        jingpaibtn.hidden = YES;
        jingpaibtnnums.hidden = YES;
        shangpinxiangqing.hidden = YES;
    }
}
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d时:%02d分:%02d秒",hours, minutes, seconds];
}
//竞拍结果显示
-(void)addjingpairesultview:(int)a anddic:(NSDictionary *)dic{
    resultdic = dic;
    _MaskV.hidden = NO;
    if (!jingpaisuccessimage) {
        
    jingpaisuccessimage = [[UIImageView alloc]initWithFrame:CGRectMake( _window_width + _window_width*0.2, _window_height*0.3, _window_width*0.6, _window_width*0.6)];
        
    jingpaisuccessimage.contentMode = UIViewContentModeScaleAspectFit;
    [self.superview addSubview:jingpaisuccessimage];
        
        
        successview = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.2,_window_height*0.3 + _window_width/2 + 20, _window_width*0.6,40)];
        
        successview.layer.masksToBounds = YES;
        successview.layer.cornerRadius = 20;
        successview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.superview addSubview:successview];
        
        successnamel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, successview.frame.size.width,20)];
        successnamel.textAlignment = NSTextAlignmentCenter;
        successnamel.textColor = [UIColor whiteColor];
        [successview addSubview:successnamel];
        
        successbottoml = [[UILabel alloc]initWithFrame:CGRectMake(0,30, successview.frame.size.width,20)];
        successbottoml.textAlignment = NSTextAlignmentCenter;
        successbottoml.textColor = [UIColor whiteColor];
        [successview addSubview:successbottoml];
        
        
        successview.hidden = YES;
        
        
        //立即付款
        paybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        paybtn.frame = CGRectMake(_window_width*0.2 + _window_width, jingpaisuccessimage.bottom - 50, _window_width*0.6, 50);
        [paybtn addTarget:self action:@selector(showpayview) forControlEvents:UIControlEventTouchUpInside];
        paybtn.hidden = YES;
        [self.superview addSubview:paybtn];
        
        
        
    }
    if (a == 3) {
        [jingpaisuccessimage setImage:[UIImage imageNamed:@"竞拍失败-无人参与"]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            jingpaisuccessimage.hidden = YES;
            _MaskV.hidden = YES;
            successview.hidden = YES;
        });
    }
    else if (a == 4){
        
        [jingpaisuccessimage setImage:[UIImage imageNamed:@"竞拍成功我"]];
        NSString *ID = minstr([dic valueForKey:@"bid_uid"]);
        if ([ID isEqual:[Config getOwnID]]) {
            //我竞拍成功
            [jingpaisuccessimage setImage:[UIImage imageNamed:@"竞拍成功"]];
            paybtn.hidden = NO;
        }
        else{
            
            successnamel.text = minstr([dic valueForKey:@"touname"]);
            NSString *path = [NSString stringWithFormat:@"最终出价%@",minstr([dic valueForKey:@"money"])];
            NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:path];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"个人中心(钻石)"];
            attch.bounds = CGRectMake(0,0,20,20);
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:4];
            successbottoml.attributedText = attri;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                jingpaisuccessimage.hidden = YES;
                _MaskV.hidden = YES;
                successview.hidden = YES;
            });
            
        }
    }
    jingpaisuccessimage.hidden = NO;
}
//立即付款页面
-(void)paydaojishi{
    //付款倒计时
    paytimes-=1;
    timels.text = [NSString stringWithFormat:@"剩 %@ 自动关闭",[self timeFormatted:paytimes]];
    if (paytimes<=0) {
        [MBProgressHUD showError:@"付款时间已过，付款失败"];
        [paytimer invalidate];
        paytimer = nil;
        [self dopaycancle];
        return;
    }
}
-(void)showpayview{
    [paybtn removeFromSuperview];
    paybtn = nil;
    jingpaisuccessimage.hidden = YES;
    [self addPayview:shangpindic];
    paytimes = [[shangpindic valueForKey:@"pay_long"] intValue];
    if (!paytimer) {
        paytimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(paydaojishi) userInfo:nil repeats:YES];
    }
    [iconimage sd_setImageWithURL:[NSURL URLWithString:minstr([shangpindic valueForKey:@"thumb"])]];
    namel.text = minstr([shangpindic valueForKey:@"title"]);
    timels.text = [NSString stringWithFormat:@"剩 %@ 自动关闭",[self timeFormatted:paytimes]];
    coinl.text = minstr([resultdic valueForKey:@"money"]);
}
//添加显示目前竞拍价格最高的那一个人
-(void)addnowfirstpersonmessahevc{
    if (!jingpaitopv) {
        
    //底部view
    jingpaitopv = [[UIView alloc]initWithFrame:CGRectMake(_window_width*2 - _window_width*0.45, 140, _window_width*0.5,40)];
    jingpaitopv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    jingpaitopv.layer.masksToBounds = YES;
    jingpaitopv.layer.cornerRadius = 20;
        
    //头像
    jingpaiiconbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jingpaiiconbtn.layer.masksToBounds = YES;
    jingpaiiconbtn.layer.cornerRadius = 20;
    [jingpaitopv addSubview:jingpaiiconbtn];
    jingpaiiconbtn.frame = CGRectMake(0,0,40,40);
                
        
    //名称
    jingpainamel = [[UILabel alloc]initWithFrame:CGRectMake(40,0, _window_width*0.4, 20)];
    jingpainamel.textColor = [UIColor whiteColor];
    [jingpaitopv addSubview:jingpainamel];
    jingpainamel.font = fontMT(12);
        
        
    UIImageView *imagevs = [[UIImageView alloc]initWithFrame:CGRectMake(40, 20, 20, 20)];
    [imagevs setImage:[UIImage imageNamed:@"个人中心(钻石)"]];
    [jingpaitopv addSubview:imagevs];
        
    //钻石数
    jingpaizuanshilabel = [[UILabel alloc]initWithFrame:CGRectMake(60,20, _window_width*0.4, 20)];
    jingpaizuanshilabel.textColor = normalColors;
    jingpaizuanshilabel.font = fontMT(12);
    [jingpaitopv addSubview:jingpaizuanshilabel];
    [self.superview addSubview:jingpaitopv];
    jingpaitopv.hidden = YES;
        
    }
}
//添加付款view
-(void)addPayview:(NSDictionary *)dic{
    _MaskV.hidden = NO;
    if (!paybottomv) {
    paybottomv = [[UIView alloc]initWithFrame:CGRectMake(_window_width, _window_height, _window_width, _window_height*0.2)];
    paybottomv.backgroundColor = [UIColor whiteColor];
    [self.superview addSubview:paybottomv];
    iconimage = [[UIImageView alloc]init];
    iconimage.layer.cornerRadius = 10;
    iconimage.layer.masksToBounds = YES;
    namel = [[UILabel alloc]init];
    namel.textAlignment = NSTextAlignmentLeft;
    coinl = [[UILabel alloc]init];
    coinl.textAlignment = NSTextAlignmentLeft;
    coinl.textColor = normalColors;
    timels = [[UILabel alloc]init];
    timels.font = fontMT(14);
    
        
    if (IS_IPHONE_5) {
        
        timels.font = fontMT(12);
    }
     
        
    timels.textColor = normalColors;
    timels.textAlignment = NSTextAlignmentRight;
    line = [[UILabel alloc]init];
    paymentbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [paymentbtn setTitle:@"付款" forState:UIControlStateNormal];
    [paymentbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paymentbtn.backgroundColor = RGB(245, 100, 62);
    paymentbtn.layer.masksToBounds = YES;
    paymentbtn.layer.cornerRadius = 5;
    paymentbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [paymentbtn addTarget:self action:@selector(dopay) forControlEvents:UIControlEventTouchUpInside];
    canclebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [canclebtn setTitle:YZMsg(@"取消") forState:UIControlStateNormal];
    [canclebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    canclebtn.backgroundColor = normalColors;
    canclebtn.layer.masksToBounds = YES;
    canclebtn.layer.cornerRadius = 5;
    canclebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [canclebtn addTarget:self action:@selector(dopaycancle) forControlEvents:UIControlEventTouchUpInside];
    iconimage.frame = CGRectMake(5,5, _window_height*0.2 * 0.5, _window_height*0.2 * 0.5);
    UIImageView *imagevs = [[UIImageView alloc]initWithFrame:CGRectMake(iconimage.right +5,_window_height*0.2 * 0.5 - 20,20,20)];
    namel.frame = CGRectMake(iconimage.right + 5,20,_window_width/2, 20);
    coinl.frame = CGRectMake(imagevs.right + 5, _window_height*0.2 * 0.5 - 20, _window_width/2, 20);
    timels.frame = CGRectMake(_window_width/2 - 10, _window_height*0.2 * 0.5 - 20, _window_width/2 - 10, 20);
    line.frame = CGRectMake(0, _window_height*0.2 * 0.5 + 10, _window_width, 1);
    canclebtn.frame = CGRectMake(_window_width - 130,line.bottom + 10,50,30);
    paymentbtn.frame = CGRectMake(_window_width - 60,line.bottom + 10,50,30);
    line.backgroundColor = [UIColor grayColor];
    [imagevs setImage:[UIImage imageNamed:@"个人中心(钻石)"]];
    _chongzhi = [[UILabel alloc] init];
    LiveUser *user = [Config myProfile];
    [Config updateProfile:user];
    _chongzhi.textColor = [UIColor lightGrayColor];
    _chongzhi.font = [UIFont systemFontOfSize:14];
    int chongzhi_y = paybottomv.frame.size.height/2-7;
    [paybottomv addSubview:_chongzhi];
    //充值上透明按钮
    _jumpRecharge = [[UIButton alloc] initWithFrame:CGRectMake(5,chongzhi_y,250,40)];
    _jumpRecharge.titleLabel.text = @"";
    [_jumpRecharge setBackgroundColor:[UIColor clearColor]];
    [_jumpRecharge addTarget:self action:@selector(jumpRechargess) forControlEvents:UIControlEventTouchUpInside];
    [paybottomv addSubview:_jumpRecharge];
    //充值图标
    _coinImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"个人中心(钻石)"]];
    [paybottomv addSubview:_coinImg];
    //箭头
    _jiantou = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"room_yingpiao_check"]];
    [self chongzhiV:user.coin];
    [paybottomv addSubview:_jiantou];
    [paybottomv addSubview:canclebtn];
    [paybottomv addSubview:paymentbtn];
    [paybottomv addSubview:line];
    [paybottomv addSubview:timels];
    [paybottomv addSubview:coinl];
    [paybottomv addSubview:namel];
    [paybottomv addSubview:iconimage];
    [paybottomv addSubview:imagevs];
  }
    paybottomv.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        paybottomv.frame = CGRectMake(_window_width, _window_height*0.8, _window_width, _window_height*0.2);
    }];
}
-(void)chongzhiV:(NSString *)coins{
    if (_chongzhi) {
        _chongzhi.text = [NSString stringWithFormat:@"%@ : %@",YZMsg(@"充值"),coins];
        _chongzhi.font = [UIFont systemFontOfSize:14];
        int chongzhi_y = canclebtn.top + 10;
        CGSize size = [_chongzhi.text boundingRectWithSize:CGSizeMake(_window_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_chongzhi.font} context:nil].size;
        _chongzhi.frame = CGRectMake(10, chongzhi_y, size.width, size.height);
        _coinImg.frame = CGRectMake(size.width + 14, chongzhi_y, 14, 14);
        int jiantou_x = _coinImg.frame.origin.x + _coinImg.frame.size.width+4;
        _jiantou.frame = CGRectMake(jiantou_x, chongzhi_y, 14, 14);
        _jumpRecharge.frame = CGRectMake(10, chongzhi_y, _chongzhi.frame.size.width + _coinImg.frame.size.width + _jiantou.frame.size.width + 10, 20);
    }
}
//跳往充值页面
-(void)jumpRechargess{
    self.chongzhiblock(@"");
    [paytimer invalidate];
    paytimer = nil;
}
//取消
-(void)dopaycancle{
    [paytimer invalidate];
    [paytimer invalidate];
    paytimer = nil;
    [UIView animateWithDuration:0.2 animations:^{
        paybottomv.frame = CGRectMake(_window_width, _window_height+10, _window_width, _window_height*0.2);
      
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        paybottomv.hidden = YES;
        [paybottomv removeFromSuperview];
        paybottomv = nil;
        [paybtn removeFromSuperview];
        paybtn = nil;
    });
}
//付款
-(void)dopay{
    NSString *userBaseUrl = [NSString stringWithFormat:@"Live.setBidPrice&auctionid=%@",idtype];
    [YBToolClass postNetworkWithUrl:userBaseUrl andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            NSDictionary *infoDic = [info firstObject];
            LiveUser *user = [Config myProfile];
            user.coin = minstr([infoDic valueForKey:@"coin"]);
            user.level = minstr([infoDic valueForKey:@"level"]);
            [Config updateProfile:user];
            [self dopaycancle];
            
            jingpaisuccessimage.hidden = NO;
            [jingpaisuccessimage setImage:[UIImage imageNamed:@"竞拍成功我s"]];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_window_width,_window_height*0.3 + _window_width/2 + 20,_window_width,40)];
            label.layer.cornerRadius = 20;
            label.layer.masksToBounds = YES;
            label.text = @"恭喜你付款成功";
            label.font = fontMT(20);
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            [self.superview addSubview:label];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                jingpaisuccessimage.hidden = YES;
                [label removeFromSuperview];
                paybottomv.hidden = YES;
                [paybottomv removeFromSuperview];
                paybottomv = nil;
            });
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:YZMsg(@"取消") otherButtonTitles:YZMsg(@"确定"), nil];
            [alert show];
            
        }

    } fail:^{
        
    }];
}
@end
