//
//  userLoginAnimation.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/2/21.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "userLoginAnimation.h"
@implementation userLoginAnimation
-(instancetype)init{
    self = [super init];
    if (self) {
        _isUserMove = 0;
        _userLogin = [NSMutableArray array];
    }
    return self;
}
-(void)addUserMove:(NSDictionary *)msg{
    
    if (msg == nil) {
        
        
        
    }
    else
    {
        [_userLogin addObject:msg];
    }
    if(_isUserMove == 0){
        [self userLoginOne];
    }
}
-(void)userLoginOne{
    
    if (_userLogin.count == 0 || _userLogin == nil) {
        return;
    }
    NSDictionary *Dic = [_userLogin firstObject];
    [_userLogin removeObjectAtIndex:0];
    [self userPlar:Dic];
}
/*
 vip_type 0表示无VIP，1表示普通VIP，2表示至尊VIP
 
 
 */
-(void)userPlar:(NSDictionary *)dic{
    _isUserMove = 1;
    _userMoveImageV = [[UIImageView alloc]initWithFrame:CGRectMake(_window_width + 20,0, _window_width*0.8,40)];
    [_userMoveImageV setImage:[UIImage imageNamed:@"userlogin_Back"]];
    [self addSubview:_userMoveImageV];
    _msgView = [[UIView alloc]initWithFrame:CGRectMake(-_window_width, 0, _window_width, 40)];
    _msgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_msgView];
    
    NSDictionary *ct = [dic valueForKey:@"ct"];
//    _vipimage = [[UIImageView alloc]init];
//    NSString *vip_type = minstr([ct valueForKey:@"vip_type"]);//vip
//    NSString *car_id = minstr([ct valueForKey:@"car_id"]);//坐骑
    
//    //蓝色至尊
//    if ([vip_type isEqual:@"1"]) {
//        [_vipimage setImage:[UIImage imageNamed:@"vip图标_1"]];
//        _vipimage.frame = CGRectMake(2,-10,40,40);
//        [_userMoveImageV setImage:[UIImage imageNamed:@"vip进场效果"]];
//        nameclor = RGB(243, 94, 217);
//
//        if (![car_id isEqual:@"0"]) {
//             [_userMoveImageV setImage:[UIImage imageNamed:@"坐骑vip都有"]];
//             nameclor = RGB(254, 249,84);
//        }
//    }
//    //红色普通
//    else  if ([vip_type isEqual:@"2"]) {
//        [_vipimage setImage:[UIImage imageNamed:@"vip图标_2"]];
//         _vipimage.frame = CGRectMake(2,-10,40,40);
//        [_userMoveImageV setImage:[UIImage imageNamed:@"vip进场效果"]];
//        nameclor = RGB(243, 94, 217);
//        if (![car_id isEqual:@"0"]) {
//            [_userMoveImageV setImage:[UIImage imageNamed:@"坐骑vip都有"]];
//            nameclor = RGB(254, 249,84);
//
//        }
//
//     }
//    else  if ([vip_type isEqual:@"0"]) {
//        _vipimage.frame = CGRectZero;
//        nameclor = backColor;
//        if ([car_id isEqual:@"0"]) {
//            [_userMoveImageV setImage:[UIImage imageNamed:@"userloginMove"]];
//        }
//        else{
//            [_userMoveImageV setImage:[UIImage imageNamed:@"坐骑进场效果"]];
//        }
//
//     }
    
    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    iconImgView.layer.cornerRadius = 15.0;
    iconImgView.layer.masksToBounds  =YES;
    iconImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    iconImgView.layer.borderWidth = 1;
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:minstr([ct valueForKey:@"avatar"])] placeholderImage:[UIImage imageNamed:@"bg1"]];
    [_msgView addSubview:iconImgView];
    
    UIImageView *starImgView = [[UIImageView alloc]initWithFrame:CGRectMake(34, 19, 8, 8)];
    starImgView.image = [UIImage imageNamed:@"loginStar"];
    [_msgView addSubview:starImgView];
//    UIImageView *levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(iconImgView.right + 4,13,28,14)];
//    NSDictionary *levelDic = [common getUserLevelMessage:minstr([ct valueForKey:@"level"])];
//    [levelImage sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
//    [levelImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"leve%@",[ct valueForKey:@"level"]]]];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@进入了直播间",[ct valueForKey:@"user_nicename"]]];
    UILabel *nameL = [[UILabel alloc]initWithFrame:CGRectMake(iconImgView.right + 3,5,_window_width*0.8-40,30)];
//    nameL.text = [NSString stringWithFormat:@"%@进入了直播间",[ct valueForKey:@"user_nicename"]];
    nameL.textColor = [UIColor whiteColor];
    nameL.font = [UIFont systemFontOfSize:15];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",[ct valueForKey:@"user_nicename"],YZMsg(@"进入了直播间")]];
    NSRange redRange = NSMakeRange(minstr([ct valueForKey:@"user_nicename"]).length, 6);
    
    [noteStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(@"#666666", 1) range:redRange];
    
    [noteStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:12] range:redRange];
    
    NSDictionary *levelDic = [common getUserLevelMessage:minstr([ct valueForKey:@"level"])];
    NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];
    
    
    NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
    shouAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
    shouAttchment.image = [UIImage imageNamed:@"chat_shou_month"];//设置图片
    NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
    
    NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
    vipAttchment.bounds = CGRectMake(0, -2, 30, 15);//设置frame
    vipAttchment.image = [UIImage imageNamed:@"chat_vip"];//设置图片
    NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];
    
    NSTextAttachment *levelAttchment = [[NSTextAttachment alloc]init];
    levelAttchment.bounds = CGRectMake(0, -2, 30, 15);//设置frame
    
    NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
    yearAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
    yearAttchment.image = [UIImage imageNamed:@"chat_shou_year"];//设置图片
    NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];
    
    

    
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            levelAttchment.image = image;
        }
    }];
    
//    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//        if (image) {
//            levelAttchment.image = image;
//        }
//
//    }];
    
    NSAttributedString *levelString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(levelAttchment)];
    NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
    liangAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
    liangAttchment.image = [UIImage imageNamed:@"chat_liang"];//设置图片
    NSAttributedString *liangString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(liangAttchment)];

    //插入靓号图标
    if (![minstr([ct valueForKey:@"liangname"]) isEqual:@"0"] && ![minstr([ct valueForKey:@"liangname"]) isEqual:@"(null)"] && minstr([ct valueForKey:@"liangname"]) !=nil && minstr([ct valueForKey:@"liangname"]) !=NULL) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
    }
    //插入守护图标
    if ([minstr([ct valueForKey:@"guard_type"]) isEqual:@"1"]) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
    }
    if ([minstr([ct valueForKey:@"guard_type"]) isEqual:@"2"]) {
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
    }

    if ([minstr([ct valueForKey:@"vip_type"])isEqual:@"1"]) {
        //插入VIP图标
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
    }
    
    [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
    [noteStr insertAttributedString:levelString atIndex:0];//插入到第几个下标
    
    [nameL setAttributedText:noteStr];
//    [_userMoveImageV addSubview:_vipimage];
//    [_msgView addSubview:levelImage];
    [_msgView addSubview:nameL];
    CGMutablePathRef path = CGPathCreateMutable();
    //CGPathAddArc函数是通过圆心和半径定义一个圆，然后通过两个弧度确定一个弧线。注意弧度是以当前坐标环境的X轴开始的。
    //需要注意的是由于ios中的坐标体系是和Quartz坐标体系中Y轴相反的，所以iOS UIView在做Quartz绘图时，Y轴已经做了Scale为-1的转换，因此造成CGPathAddArc函数最后一个是否是顺时针的参数结果正好是相反的，也就是说如果设置最后的参数为1，根据参数定义应该是顺时针的，但实际绘图结果会是逆时针的！
    //严格的说，这个方法只是确定一个中心点后，以某个长度作为半径，以确定的角度和顺逆时针而进行旋转，半径最低设置为1，设置为0则动画不会执行
    
    CGPathAddArc(path, NULL, iconImgView.centerX, iconImgView.centerY, 16, 0,M_PI * 2, 0);
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path;
    CGPathRelease(path);
    animation.duration = 3;
    animation.repeatCount = 1;
    animation.autoreverses = NO;
    animation.rotationMode =kCAAnimationRotateAuto;
    animation.fillMode =kCAFillModeForwards;

    [UIView animateWithDuration:0.5 animations:^{
//        _userMoveImageV.frame = CGRectMake(-15,10,_window_width*0.8,40);
        _userMoveImageV.x = 80;
        _msgView.x = 80;
    }completion:^(BOOL finished) {
        [starImgView.layer addAnimation:animation forKey:nil];
    }];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.5 animations:^{
//            _userMoveImageV.frame = CGRectMake(-15,10,_window_width*0.8,40);
//            _userMoveImageV.alpha = 0;
            _userMoveImageV.x = 10;
            _msgView.x = 10;

        }] ;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            _userMoveImageV.x = -_window_width;
            _msgView.x = _window_width;
        } completion:^(BOOL finished) {
            [_userMoveImageV removeFromSuperview];
            _userMoveImageV = nil;
            [_msgView removeFromSuperview];
            _msgView = nil;
            _isUserMove = 0;
            if (_userLogin.count >0) {
                [self addUserMove:nil];
            }
        }];

    });
}
@end
