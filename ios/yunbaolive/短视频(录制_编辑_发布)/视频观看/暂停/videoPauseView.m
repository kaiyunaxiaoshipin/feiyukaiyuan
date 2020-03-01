//
//  videoPauseView.m
//  iphoneLive
//
//  Created by Boom on 2017/12/14.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "videoPauseView.h"
/******* 分享类头文件 ******/
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>
//#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "XLCircleProgress.h"
@implementation videoPauseView{
    NSDictionary *hostDic;
    UIButton *zanBtn;
    NSArray *picNameArray;
    XLCircleProgress *circle;
    NSString *isFree;
    UIButton *cuiBtn;
}

-(instancetype)initWithFrame:(CGRect)frame andVideoMsg:(NSDictionary *)videoDic{
    self = [super initWithFrame:frame];
    hostDic = videoDic;
    if (self) {
        [self creatUI];
    }
    return self;
}
-(void)creatUI {
    UIButton *btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake((self.width-70)/2, (self.height-70)/2, 70, 70);
    [btn setImage:[UIImage imageNamed:@"ask_play"] forState:UIControlStateNormal];
    btn.tag = 1215;
    [btn addTarget:self action:@selector(goZan:) forControlEvents:UIControlEventTouchUpInside];

    [UIView animateWithDuration:0.2 animations:^{
        btn.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }];
    [self addSubview:btn];
}


/**
 点赞
 */
- (void)goZan:(UIButton *)button{
    
    if (button.tag == 1215) {
        [self.delegate goPlay];
    }
}




@end
