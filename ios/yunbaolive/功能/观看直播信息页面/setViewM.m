#import "setViewM.h"
#import "Config.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
@implementation setViewM
-(void)leftviews{
    _leftView = [[UIView alloc]init];

    _leftView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    //左上角 直播live
    _leftView.frame = CGRectMake(10,25+statusbarHeight,95,leftW);
    _leftView.layer.cornerRadius = leftW/2;
    UITapGestureRecognizer *tapleft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
    tapleft.numberOfTapsRequired = 1;
    tapleft.numberOfTouchesRequired = 1;
    [_leftView addGestureRecognizer:tapleft];
    //关注主播
    _newattention = [UIButton buttonWithType:UIButtonTypeCustom];
    _newattention.frame = CGRectMake(95,5,40,25);
    _newattention.layer.masksToBounds = YES;
    _newattention.layer.cornerRadius = 12.5;
    [_newattention setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _newattention.titleLabel.font = [UIFont systemFontOfSize:11];
    [_newattention setTitle:YZMsg(@"关注") forState:UIControlStateNormal];
    [_newattention setBackgroundColor:normalColors];
    _newattention.contentMode = UIViewContentModeScaleAspectFit;
    [_newattention addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];
    _newattention.hidden = YES;
    //主播头像button
    _IconBTN = [UIButton buttonWithType:UIButtonTypeCustom];
    [_IconBTN addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];

        _IconBTN.frame = CGRectMake(2.5, 2.5, leftW-5, leftW-5);
        _IconBTN.layer.masksToBounds = YES;
        _IconBTN.layer.borderWidth = 1;
        _IconBTN.layer.borderColor = normalColors.CGColor;
        _IconBTN.layer.cornerRadius = (leftW-5)/2;
    
    //添加主播等级
    _levelimage = [[UIImageView alloc]initWithFrame:CGRectMake(_IconBTN.right - 11,_IconBTN.bottom - 11,13,13)];
    NSDictionary *levelDic = [common getAnchorLevelMessage:minstr([self.zhuboDic valueForKey:@"level_anchor"])];
    [_levelimage sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb_mark"])]];
    
    NSString *path = [self.zhuboDic valueForKey:@"avatar"];
    NSURL *url = [NSURL URLWithString:path];
    [_IconBTN sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head"]];
    //直播live
    UILabel *liveLabel;
    liveLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftW+7,2,50,15)];
    liveLabel.textAlignment = NSTextAlignmentLeft;
    liveLabel.text = minstr([self.zhuboDic valueForKey:@"user_nicename"]);
    liveLabel.textColor = [UIColor whiteColor];
    liveLabel.shadowOffset = CGSizeMake(1,1);//设置阴影
    liveLabel.font = fontMT(10);
    //在线人数
    _onlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _leftView.bottom+10, 80, 20)];
    _onlineLabel.frame = CGRectMake(leftW+10,17,70,15);

    _onlineLabel.textAlignment = NSTextAlignmentLeft;
    _onlineLabel.textColor = [UIColor whiteColor];
    _onlineLabel.font = fontMT(10);
    NSString *liangname = minstr([_zhuboDic valueForKey:@"goodnum"]);
    if ([liangname isEqual:@"0"]) {
        _onlineLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([_zhuboDic valueForKey:@"uid"])];
    }else{
        _onlineLabel.text = [NSString stringWithFormat:@"%@:%@",YZMsg(@"靓"),liangname];
    }
    //魅力值//魅力值
    //修改 魅力值 适应字体 欣
    _yingpiaoLabel  = [[UILabel alloc]init];
    _yingpiaoLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    _yingpiaoLabel.font = [UIFont systemFontOfSize:12];
    _yingpiaoLabel.textAlignment = NSTextAlignmentCenter;
    _yingpiaoLabel.textColor = [UIColor whiteColor];
    _yingpiaoLabel.layer.cornerRadius = 10;
    _yingpiaoLabel.layer.masksToBounds = YES;
    UITapGestureRecognizer *yingpiaoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yingpiao)];
    _yingpiaoLabel.userInteractionEnabled = YES;
    [_yingpiaoLabel addGestureRecognizer:yingpiaoTap];
    
    
    _guardBtn = [UIButton buttonWithType:0];
    _guardBtn.frame = CGRectMake(_yingpiaoLabel.right+5, _yingpiaoLabel.top, 80, _yingpiaoLabel.height);
    _guardBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    [_guardBtn addTarget:self action:@selector(guardBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_guardBtn setTitle:YZMsg(@"守护 虚位以待>") forState:0];
    _guardBtn.layer.cornerRadius = 10;
    _guardBtn.layer.masksToBounds = YES;
    guardWidth = [[YBToolClass sharedInstance] widthOfString:YZMsg(@"守护 虚位以待>") andFont:[UIFont systemFontOfSize:12] andHeight:20];
    _guardBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    _luckyGift = [[AllRoomShowLuckyGift alloc]initWithFrame:CGRectMake(_guardBtn.right+5, _guardBtn.top-2.5, _window_width-(_guardBtn.right+5), _guardBtn.height+5)];
    
    [_leftView addSubview:_onlineLabel];
    [_leftView addSubview:liveLabel];
    [_leftView addSubview:_IconBTN];
    [_leftView addSubview:_levelimage];//主播等级
    [self addSubview:_yingpiaoLabel];//
    [self addSubview:_guardBtn];//
    [self addSubview:_luckyGift];//
    [self addSubview:_leftView];//添加左上角信息
    [_leftView addSubview:_newattention];
}
-(instancetype)initWithDic:(NSDictionary *)playDic{
    self = [super init];
    if (self) {
        self.zhuboDic = playDic;
        //添加遮罩层
        _ZheZhaoBTN = [UIButton buttonWithType:UIButtonTypeSystem];
        _ZheZhaoBTN.frame = CGRectMake(0, 0, _window_width, _window_height);
        _ZheZhaoBTN.backgroundColor = [UIColor clearColor];
        [_ZheZhaoBTN addTarget:self action:@selector(zhezhaoBTN) forControlEvents:UIControlEventTouchUpInside];
        _ZheZhaoBTN.hidden = YES;
        //一开始进入显示的背景
        _bigAvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_height+200)];
        _bigAvatarImageView.image = [UIImage imageNamed:[playDic valueForKey:@"avatar"]];
        [_bigAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[playDic valueForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"loading_bg.png"]];
        _bigAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
        [_bigAvatarImageView addSubview:effectview];

        [self addSubview:_ZheZhaoBTN];//添加遮罩
        [self addSubview:_bigAvatarImageView];//添加背景图
        //*********************************************************************************//
    }
    return self;
}
//点击关注主播
-(void)guanzhuzhubo{
    
    
    
    NSDictionary *subdic = @{
                             @"touid":[self.zhuboDic valueForKey:@"uid"]
                             };
    [YBToolClass postNetworkWithUrl:@"User.setAttent" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [self.frontviewDelegate guanzhuZhuBo];
        }
    } fail:^{
        
    }];
}
//改变左上角 映票数量
-(void)changeState:(NSString *)texts andID:(NSString *)ID{
    if (!_leftView) {
        [self leftviews];
    }
    UIFont *font1 = [UIFont systemFontOfSize:12];
    NSString *str = [NSString stringWithFormat:@"%@ %@ >",[common name_votes],texts];
    CGFloat width = [[YBToolClass sharedInstance] widthOfString:str andFont:font1 andHeight:20];
    _yingpiaoLabel.frame = CGRectMake(10, _leftView.bottom+10, width+30, 20);
    _yingpiaoLabel.text = str;
    _guardBtn.frame = CGRectMake(_yingpiaoLabel.right+5, _yingpiaoLabel.top, guardWidth+20, _yingpiaoLabel.height);
    _luckyGift.frame = CGRectMake(_guardBtn.right+5, _guardBtn.top-2.5, _window_width-(_guardBtn.right+5), _guardBtn.height+5);
}
-(void)changeGuardButtonFrame:(NSString *)nums{
    [_guardBtn setTitle:[NSString stringWithFormat:@"%@ %@%@ >",YZMsg(@"守护"),nums,YZMsg(@"人")] forState:0];

    guardWidth = [[YBToolClass sharedInstance] widthOfString:_guardBtn.titleLabel.text andFont:[UIFont systemFontOfSize:12] andHeight:20];
    _guardBtn.frame = CGRectMake(_yingpiaoLabel.right+5, _yingpiaoLabel.top, guardWidth+20, _yingpiaoLabel.height);
    _luckyGift.frame = CGRectMake(_guardBtn.right+5, _guardBtn.top-2.5, _window_width-(_guardBtn.right+5), _guardBtn.height+5);

}//改变守护按钮适应坐标

//跳魅力值页面
-(void)yingpiao{
    [self.frontviewDelegate gongxianbang];
}
-(void)zhuboMessage{
    [self.frontviewDelegate zhubomessage];
}
-(void)zhezhaoBTN{
    [self.frontviewDelegate zhezhaoBTNdelegate];
}
- (void)guardBtnClick{
    [self.frontviewDelegate showGuardView];
}
@end
