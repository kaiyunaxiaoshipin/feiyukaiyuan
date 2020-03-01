#import "fenXiangView.h"
@implementation fenXiangView
{
    NSMutableArray *picNameArray;
    NSMutableArray *buttonArray;

    UIView *whiteView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        buttonArray = [NSMutableArray array];
        picNameArray = [[common share_type] mutableCopy];
        [picNameArray addObject:@"copy"];
        int page;
        if (picNameArray.count % 4 == 0) {
            page = (int)picNameArray.count/4;
        }else{
            page = (int)picNameArray.count/4+1;
        }
        CGFloat btnWidth = _window_width*14/75;
        whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, _window_height, _window_width, btnWidth*page+40+40)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        UIButton *hidBtn = [UIButton buttonWithType:0];
        hidBtn.frame = CGRectMake(0, 0, _window_width, _window_height-(whiteView.height));
        [hidBtn addTarget:self action:@selector(doHide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hidBtn];
        
        CGFloat speace = _window_width/75*19/5;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 40)];
        label.text = YZMsg(@"分享至");
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGB_COLOR(@"#969696", 1);
        [whiteView addSubview:label];
        for (int i = 0; i < picNameArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:0];
            button.frame = CGRectMake(speace + i%4*(btnWidth+speace) , label.bottom + (i/4)*btnWidth, btnWidth, btnWidth);
            button.tag = i + 3000;
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"liveShare_%@",picNameArray[i]]] forState:0];
            [button setTitle:picNameArray[i] forState:0];
            [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(doSomething:) forControlEvents:UIControlEventTouchUpInside];
            [whiteView addSubview:button];
            [buttonArray addObject:button];
        }
        [UIView animateWithDuration:0.3 animations:^{
            whiteView.y = _window_height-(whiteView.height);
        }];
    }
    return self;
}
-(void)doSomething:(UIButton *)sender{
    NSLog(@"分享到%@",picNameArray[sender.tag-3000]);
    NSDictionary *dic = [NSDictionary dictionaryWithObject:picNameArray[sender.tag-3000] forKey:@"fenxiang"];
    [self FenXiang:dic];
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}
-(void)FenXiang:(NSDictionary *)dic{
    NSString *fenxiang = [dic valueForKey:@"fenxiang"];
    if ([fenxiang isEqual:@"qzone"]) {
        [self simplyShare:SSDKPlatformSubTypeQZone];
    }
    else if([fenxiang isEqual:@"qq"])
    {
        [self simplyShare:SSDKPlatformSubTypeQQFriend];
    }
    else if([fenxiang isEqual:@"wx"])
    {
        [self simplyShare:SSDKPlatformSubTypeWechatSession];
    }
    else if([fenxiang isEqual:@"wchat"])
    {
        [self simplyShare:SSDKPlatformSubTypeWechatTimeline];
    }
    else if([fenxiang isEqual:@"facebook"])
    {
        [self simplyShare:SSDKPlatformTypeFacebook];
    }
    else if([fenxiang isEqual:@"twitter"])
    {
        [self simplyShare:SSDKPlatformTypeTwitter];
    }else if([fenxiang isEqual:@"copy"])
    {
        NSString *copyStr;
        if ([_zhuboDic valueForKey:@"fans"]) {
            copyStr = [NSString stringWithFormat:@"%@/index.php?g=Appapi&m=home&a=index&touid=%@",h5url,[self.zhuboDic valueForKey:@"id"]];
        }else{
            copyStr = [[common wx_siteurl] stringByAppendingFormat:@"%@",[self.zhuboDic valueForKey:@"uid"]];
        }
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = copyStr;
        [MBProgressHUD showError:YZMsg(@"复制成功")];

    }
}
- (void)simplyShare:(int)SSDKPlatformType
{
    /**
     * 在简单分享中，只要设置共有分享参数即可分享到任意的社交平台
     **/
    int SSDKContentType = SSDKContentTypeAuto;
    NSURL *ParamsURL;
    if(SSDKPlatformType == SSDKPlatformTypeSinaWeibo)
    {
        SSDKContentType = SSDKContentTypeImage;
    }
    else if((SSDKPlatformType == SSDKPlatformSubTypeWechatSession || SSDKPlatformType == SSDKPlatformSubTypeWechatTimeline))
    {
        //拼装分享地址
        NSString *strFullUrl = [[common wx_siteurl] stringByAppendingFormat:@"%@",[self.zhuboDic valueForKey:@"uid"]];
        ParamsURL = [NSURL URLWithString:strFullUrl];
    }
    else{//app_ios
        ParamsURL = [NSURL URLWithString:[common app_ios]];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];

    if ([_zhuboDic valueForKey:@"fans"]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        ParamsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/index.php?g=Appapi&m=home&a=index&touid=%@",h5url,[self.zhuboDic valueForKey:@"id"]]];

        //创建分享参数
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"TA%@%@%@",YZMsg(@"有"),minstr([_zhuboDic valueForKey:@"fans"]),YZMsg(@"粉丝，快来围观呀!")]
                                         images:[self.zhuboDic valueForKey:@"avatar_thumb"]
                                            url:ParamsURL
                                          title:[NSString stringWithFormat:@"“%@“%@%@～%@～",minstr([_zhuboDic valueForKey:@"user_nicename"]),YZMsg(@"也在"),[infoDictionary objectForKey:@"CFBundleDisplayName"],YZMsg(@"点击查看TA的故事")]
                                           type:SSDKContentType];
        
        [shareParams SSDKEnableUseClientShare];
    }else if ([minstr([_zhuboDic valueForKey:@"id"]) isEqual:@"fenxiao"]) {
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:[_zhuboDic valueForKey:@"image"]
                                            url:nil
                                          title:nil
                                           type:SSDKContentTypeImage];
        
        [shareParams SSDKEnableUseClientShare];

    }
    else{
        //创建分享参数
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@",[self.zhuboDic valueForKey:@"user_nicename"],[common share_des]]
                                         images:[self.zhuboDic valueForKey:@"avatar_thumb"]
                                            url:ParamsURL
                                          title:[common share_title]
                                           type:SSDKContentType];
        
        [shareParams SSDKEnableUseClientShare];

    }
    //进行分享
    [ShareSDK share:SSDKPlatformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 [MBProgressHUD showError:YZMsg(@"分享成功")];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 [MBProgressHUD showError:YZMsg(@"分享失败")];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 break;
             }
             default:
                 break;
         }
     }];
}
-(void)GetDIc:(NSDictionary *)dic{
    self.zhuboDic = dic;
    if ([minstr([_zhuboDic valueForKey:@"id"]) isEqual:@"fenxiao"]) {
        if (buttonArray.count > 0) {
            UIButton *btn = [buttonArray lastObject];
            btn.hidden = YES;
        }
    }
}
- (void)doHide{
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = _window_height;
        
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)show{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        whiteView.y = _window_height-(whiteView.height);
    }];
}

@end
