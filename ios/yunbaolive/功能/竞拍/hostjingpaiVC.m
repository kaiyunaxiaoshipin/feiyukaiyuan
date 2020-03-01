//
//  hostjingpaiVC.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/29.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "hostjingpaiVC.h"
@interface hostjingpaiVC ()
{
    UILabel *timenamel;
    UILabel *timel;
    NSTimer *daojishitimer;
    int alltimes;
    
    
    UIView *jingpaitopv;
    UIButton *jingpaiiconbtn;
    UILabel *jingpainamel;
    UILabel *jingpaizuanshilabel;
    NSString *jingpaiID;
    
    UIImageView *jingpaisuccessimage;
    UIView *successview;//显示竞拍成功的人
    UILabel *successnamel;
    UILabel *successbottoml;
    
}
@property(nonatomic,strong)UIView *MaskV;//遮罩
@end
@implementation hostjingpaiVC
-(instancetype)initWithFrame:(CGRect)frame andblock:(axinblocks)block andjingpaiid:(NSString *)ID{
    self = [super initWithFrame:frame];
    if (self) {
        jingpaiID = ID;
        self.blocks = block;
        [self addtimeL:frame];
    }
    return self;
}
-(void)addtimeL:(CGRect)frame{
    timenamel= [[UILabel alloc]initWithFrame:CGRectMake(-10,0,_window_width*0.4,20)];
    timenamel.text = @"竞拍剩余时间";
    timenamel.textColor = [UIColor whiteColor];
    timenamel.font =  [UIFont fontWithName:@"Arial-ItalicMT" size:15];
    timenamel.textAlignment = NSTextAlignmentRight;
    timenamel.shadowColor = [UIColor blackColor];
    timenamel.shadowOffset = CGSizeMake(0,0.5);
    [self addSubview:timenamel];
    
    timel= [[UILabel alloc]initWithFrame:CGRectMake(-10,20,_window_width*0.4,20)];
    timel.textColor = [UIColor whiteColor];
    timel.font =  [UIFont fontWithName:@"Arial-ItalicMT" size:15];;
    timel.textAlignment = NSTextAlignmentRight;
    timel.shadowColor = [UIColor blackColor];
    timel.shadowOffset = CGSizeMake(0,0.5);
    [self addSubview:timel];
    
}
//获取竞拍信息
-(void)getjingpaimessage:(NSDictionary *)subdic{
    //显示竞拍时间
    if (!daojishitimer) {
    alltimes = [[subdic valueForKey:@"long"] intValue];
    daojishitimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dodaojishi) userInfo:nil repeats:YES];
    }
    timenamel.hidden = NO;
    timel.hidden = NO;
}
-(void)dodaojishi{
    alltimes -=1;
    timel.text = [self timeFormatted:alltimes];
    if (alltimes <= 0) {
        [daojishitimer invalidate];
        daojishitimer = nil;
        [self getover];
        timenamel.hidden = YES;
        timel.hidden = YES;
        timel.text = @" ";
        jingpaitopv.hidden = YES;
        //竞拍结束
    }
}
-(void)getover{
    
    NSString *url = [NSString stringWithFormat:@"Live.auctionEnd&uid=%@&token=%@&auctionid=%@",[Config getOwnID],[Config getOwnToken],jingpaiID];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary * singleUserArray = [info firstObject];
            self.blocks(singleUserArray);
            jingpaitopv.hidden = YES;

        }
    } fail:^{
        
    }];
}
//时间转换
- (NSString *)timeFormatted:(int)totalSeconds{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d时:%02d分:%02d秒",hours, minutes, seconds];
}
//显示档案竞拍最大的人
-(void)addnowfirstpersonmessahevc{
    if (!jingpaitopv) {
        //底部view
        jingpaitopv = [[UIView alloc]initWithFrame:CGRectMake(_window_width - _window_width*0.45, 140, _window_width*0.5,40)];
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
//有人竞拍，刷新竞拍信息
-(void)getnewmessage:(NSDictionary *)dic{
    //刷新竞拍金额最多的人
    [jingpaiiconbtn sd_setImageWithURL:[NSURL URLWithString:minstr([dic valueForKey:@"uhead"])] forState:UIControlStateNormal];
    jingpainamel.text = minstr([dic valueForKey:@"uname"]);
    jingpaizuanshilabel.text = minstr([dic valueForKey:@"money"]);
    jingpaitopv.hidden = NO;
}
//竞拍结果显示
-(void)addjingpairesultview:(int)a anddic:(NSDictionary *)dic{
    
    _MaskV.hidden = NO;
    if (!jingpaisuccessimage) {
        _MaskV = [[UIView alloc]initWithFrame:CGRectMake(0,0,_window_width,_window_height)];
        
        _MaskV.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        [self.superview addSubview:_MaskV];
        
        UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dohidetableview)];
        
        [_MaskV addGestureRecognizer:taps];
        _MaskV.hidden = YES;
        jingpaisuccessimage = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width*0.2, _window_height*0.3, _window_width*0.6, _window_width*0.6)];
        jingpaisuccessimage.contentMode = UIViewContentModeScaleAspectFit;
        [self.superview addSubview:jingpaisuccessimage];
        
        successview = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.2,_window_height*0.3 + _window_width/2 + 20, _window_width*0.6,40)];
        successview.layer.masksToBounds = YES;
        successview.layer.cornerRadius = 20;
        successview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.superview addSubview:successview];
        
        successnamel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, successview.frame.size.width,20)];
        successnamel.textAlignment = NSTextAlignmentCenter;
        successnamel.font = fontMT(13);
        successnamel.textColor = [UIColor whiteColor];
        [successview addSubview:successnamel];
        successbottoml = [[UILabel alloc]initWithFrame:CGRectMake(0,20,successview.frame.size.width,20)];
        successbottoml.textAlignment = NSTextAlignmentCenter;
        successbottoml.font = fontMT(12);
        successbottoml.textColor = [UIColor whiteColor];
        [successview addSubview:successbottoml];
        successview.hidden = YES;
        
        
    }
    if (a == 3) {
        [jingpaisuccessimage setImage:[UIImage imageNamed:@"竞拍失败-无人参与"]];
        
    }
    if (a == 4){
        successview.hidden = NO;
        [jingpaisuccessimage setImage:[UIImage imageNamed:@"竞拍成功我"]];
        successnamel.text = minstr([dic valueForKey:@"user_nicename"]);
        NSString *path = [NSString stringWithFormat:@"最终出价%@",minstr([dic valueForKey:@"bid_price"])];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:path];
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        attch.image = [UIImage imageNamed:@"个人中心(钻石)"];
        attch.bounds = CGRectMake(0,0,15,15);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        [attri insertAttributedString:string atIndex:4];
        successbottoml.attributedText = attri;

    }
    jingpaisuccessimage.hidden = NO;
    _MaskV.hidden = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        jingpaisuccessimage.hidden = YES;
        _MaskV.hidden = YES;
        successview.hidden = YES;
    });
}
-(void)dohidetableview{
    _MaskV.hidden = YES;
    jingpaisuccessimage.hidden = YES;
    successview.hidden = YES;
    
}
-(void)removeall{
    if (daojishitimer) {
        [daojishitimer invalidate];
        daojishitimer = nil;
    }
    
}
-(void)dealloc{
    if (daojishitimer) {
        [daojishitimer invalidate];
        daojishitimer = nil;
    }
}
@end
