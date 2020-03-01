//
//  FrontView.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/9.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "FrontView.h"

@interface FrontView()

@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,copy)FrontBlock frontEvent;

@end

@implementation FrontView

- (instancetype)initWithFrame:(CGRect)frame callBackEvent:(FrontBlock)event {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frontEvent = event;
        [self setUp];
        
    }
    return self;
}

-(void)updateData:(NSDictionary*)dic {
    self.dataDic = [NSDictionary dictionaryWithDictionary:dic];
    
}

-(void)setUp {
    [self addSubview:self.rightView];
    [self addSubview:self.botView];
}

#pragma mark - 点击事件
-(void)zhuboMessage {
    if (self.frontEvent) {
        self.frontEvent(@"头像");
    }
}
-(void)guanzhuzhubo {
    _followBtn.userInteractionEnabled = NO;
    if (self.frontEvent) {
        self.frontEvent(@"关注");
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _followBtn.userInteractionEnabled = YES;
    });
}
-(void)dolike {
    _likebtn.userInteractionEnabled = NO;
    if (self.frontEvent) {
        self.frontEvent(@"点赞");
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _likebtn.userInteractionEnabled = YES;
    });

}
-(void)messgaebtn{
    if (self.frontEvent) {
        self.frontEvent(@"评论");
    }
}
-(void)doenjoy {
    if (self.frontEvent) {
        self.frontEvent(@"分享");
    }
}
#pragma mark - 跑马灯
-(void)setMusicName:(NSString *)str{
    
    _musicL.contentStr = str;
    [_musicL startLamp];
}


#pragma mark - set/get
- (UIView *)rightView{
    if (!_rightView) {
        CGFloat rv_w = 85;
        CGFloat rv_h = 300;//头像+点赞+评论+分享
        CGFloat rv_all_h = 300;//头像+点赞+评论+分享 +唱片
        _rightView = [[UIView alloc]initWithFrame:CGRectMake(_window_width-rv_w, _window_height-rv_all_h-49-ShowDiff, rv_w, rv_all_h)];
        _rightView.backgroundColor = [UIColor clearColor];
        
        CGFloat btnW = 70;
        CGFloat btnH = 70;
        CGFloat spaceW = 15;
        CGFloat specialH = 10;//给头像和点赞之间特意多留
        CGFloat spaceH = (rv_h-specialH-btnH*4)/3;
        
        //主播头像
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.frame = CGRectMake(10+spaceW, 0, 50, 50);
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.layer.borderWidth = 1;
        _iconBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconBtn.layer.cornerRadius = 25;
        _iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconBtn.imageView.clipsToBounds = YES;
        [_iconBtn addTarget:self action:@selector(zhuboMessage) forControlEvents:UIControlEventTouchUpInside];
        [_iconBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_head.png"]];
        
        //关注按钮
        _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _followBtn.frame = CGRectMake(_iconBtn.left+12, _iconBtn.bottom-13, 26, 26);
        [_followBtn setImage:[UIImage imageNamed:@"home_follow"] forState:0];
        [_followBtn addTarget:self action:@selector(guanzhuzhubo) forControlEvents:UIControlEventTouchUpInside];
        
        //点赞
        _likebtn = [UIButton buttonWithType:0];
        _likebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _likebtn.frame = CGRectMake(spaceW, _iconBtn.bottom+spaceH+specialH, btnW, btnH);
        [_likebtn addTarget:self action:@selector(dolike) forControlEvents:UIControlEventTouchUpInside];
        [_likebtn setImage:[UIImage imageNamed:@"home_zan"] forState:0];
        [_likebtn setTitle:@" 0 " forState:0];//空格占位符不要去除
        _likebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _likebtn = [PublicObj setUpImgDownText:_likebtn];
        
        //评论列表
        _commentBtn = [UIButton buttonWithType:0];
        [_commentBtn setImage:[UIImage imageNamed:@"home_comment"] forState:0];
        [_commentBtn setTitle:@" 0 " forState:0];//空格占位符不要去除
        _commentBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _commentBtn.frame = CGRectMake(spaceW, _likebtn.bottom+spaceH, btnW,btnH);
        [_commentBtn addTarget:self action:@selector(messgaebtn) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _commentBtn = [PublicObj setUpImgDownText:_commentBtn];
        
        //分享
        _enjoyBtn = [UIButton buttonWithType:0];
        [_enjoyBtn setImage:[UIImage imageNamed:@"home_share"] forState:0];
        [_enjoyBtn setTitle:@" 0 " forState:0];//空格占位符不要去除
        _enjoyBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _enjoyBtn.frame = CGRectMake(spaceW, _commentBtn.bottom+spaceH, btnW,btnH);
        [_enjoyBtn addTarget:self action:@selector(doenjoy) forControlEvents:UIControlEventTouchUpInside];
        _enjoyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _enjoyBtn = [PublicObj setUpImgDownText:_enjoyBtn];
        
//        //音乐背景+歌曲(作者头像)
//        _discIV = [[UIImageView alloc]init];
//        _discIV.frame = CGRectMake(25, _enjoyBtn.bottom+spaceH+10, 50, 50);
//        [_discIV setImage:[UIImage imageNamed:@"music_disc"]];
//        _musicIV = [[UIImageView alloc]init];
//        CGFloat l_s = (50-20*50/33)/2;
//        _musicIV.frame = CGRectMake(l_s, l_s, 20*50/33, 20*50/33);
//        _musicIV.layer.masksToBounds = YES;
//        _musicIV.layer.cornerRadius = 20*50/33/2;
//
//        //音符A+B
//        _symbolAIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"music_symbolA"]];
//        _symbolAIV.frame = CGRectMake(0, _discIV.top, 12, 12);
//        _symbolBIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"music_symbolB"]];
//        _symbolBIV.frame = CGRectMake(0, _discIV.top, 12, 12);
//        _symbolAIV.hidden = YES;
//        _symbolBIV.hidden = YES;
        
        [_rightView addSubview:_iconBtn];
        [_rightView addSubview:_followBtn];
        [_rightView addSubview:_likebtn];
        [_rightView addSubview:_commentBtn];
        [_rightView addSubview:_enjoyBtn];
//        [_rightView addSubview:_discIV];
//        [_discIV addSubview:_musicIV];
//        [_rightView addSubview:_symbolAIV];
//        [_rightView addSubview:_symbolBIV];
        
    }
    return _rightView;
}

- (UIView *)botView {
    if (!_botView) {
        _botView = [[UIView alloc]initWithFrame:CGRectMake(10, _window_height-49-ShowDiff-110, _window_width*0.75, 100)];
        _botView.backgroundColor = [UIColor clearColor];
        
        //布局顺序从下向上（视频标题最多三行，可没有）
        //音乐（预留-先隐藏）
//        UIImageView *symIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, _botView.height-20, 20, 20)];
//        symIV.image = [UIImage imageNamed:@"music_symbolB"];
//        [_botView addSubview:symIV];
        
//        _musicL = [[RKLampView alloc]initWithFrame:CGRectMake(22, _botView.height-20, _botView.width/2, 20)];
//        _musicL.contentStr = @"eeeeeee";
//        [_botView addSubview:_musicL];
        
        //视频标题
        _titleL = [[UILabel alloc]init];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.textColor = [UIColor whiteColor];
        _titleL.shadowOffset = CGSizeMake(1,1);//设置阴影
        _titleL.numberOfLines = 3;
        _titleL.font = SYS_Font(15);
        [_botView addSubview:_titleL];
        
        //视频作者名称
        _nameL = [[UILabel alloc]init];
        _nameL.textAlignment = NSTextAlignmentLeft;
        _nameL.textColor = [UIColor whiteColor];
        _nameL.shadowOffset = CGSizeMake(1,1);//设置阴影
        _nameL.font = SYS_Font(20);
        UITapGestureRecognizer *nametap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuboMessage)];
        //nametap.numberOfTouchesRequired = 1;
        _nameL.userInteractionEnabled = YES;
        [_nameL addGestureRecognizer:nametap];
        [_botView addSubview:_nameL];
        
    }
    return _botView;
}


@end
