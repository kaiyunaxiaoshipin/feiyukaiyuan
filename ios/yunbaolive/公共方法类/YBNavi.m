//
//  YBNavi.m
//  WaWaJiClient
//
//  Created by Rookie on 2017/11/19.
//  Copyright © 2017年 zego. All rights reserved.
//

#import "YBNavi.h"

#import "UIControl+recurClick.h"

@interface YBNavi ()
{
    BOOL isImg;
}
@property (nonatomic,copy) btnBlock leftBack;
@property (nonatomic,copy) btnBlock rightBack;
@end

@implementation YBNavi

- (instancetype)init
{
    self = [super init];
    if (self) {
        isImg = NO;
//        _H5Title = @"";
        [self creatUI];
    }
    return self;
}

-(void)creatUI {
    self.frame = CGRectMake(0, 0, _window_width, 64+statusbarHeight);

}

//中间图片
-(void)ybNaviLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidImg:(NSString *)imgName {
    isImg = YES;
    [self publicLeftName:@"icon_arrow_leftsssa.png" leftBtn:leftBtn rightName:imgN rightBtn:rightBtn mid:imgName];
}
//中间文字
-(void)ybNaviLeft:(btnBlock)leftBtn andRightName:(NSString *)imgN andRight:(btnBlock)rightBtn andMidTitle:(NSString *)midTitle {
    isImg = NO;
    [self publicLeftName:@"icon_arrow_leftsssa.png" leftBtn:leftBtn rightName:imgN rightBtn:rightBtn mid:midTitle];
}
//公共方法
-(void)publicLeftName:(NSString *)imgL leftBtn:(btnBlock)leftB rightName:(NSString *)imgR rightBtn:(btnBlock)rightB mid:(NSString *)mid{
    
    _leftBack = leftB;
    _rightBack = rightB;//Color.rgb(153, 155, 152)
    
    UIImageView *bgi = [[UIImageView alloc]initWithFrame:self.frame];
//    bgi.image = [self drawBckgroundImage];//[UIImage imageNamed:@"login_navi"];
    bgi.backgroundColor = [UIColor whiteColor];
    bgi.contentMode = UIViewContentModeScaleAspectFill;
    bgi.clipsToBounds = YES;
    bgi.userInteractionEnabled = YES;
//    if (_dynamicChangeNavBgc==YES) {
//        //说明没有背景色或者要动态改变背景色
//        bgi.alpha = 0;
//    }
    [self addSubview:bgi];
    self.naviBGIV = bgi;
    //左
    UIButton *left_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    left_btn.frame = CGRectMake(8, 22+statusbarHeight, 40, 40);
    left_btn.contentEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [left_btn setImage:[UIImage imageNamed:imgL] forState:0];
    if (_haveTitleL == YES) {
        //有标题就把图片隐藏
        left_btn.frame = CGRectMake(10, 22+statusbarHeight, 60, 40);
        left_btn.titleLabel.font = SYS_Font(15);
        [left_btn setImage:nil forState:0];
    }
    [left_btn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:left_btn];
    left_btn.hidden = _leftHidden;
    self.leftBtn = left_btn;
    
    //左shadow
    UIButton *left_s_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    left_s_btn.frame = CGRectMake(0, 0, 64, 64+statusbarHeight);
    [left_s_btn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    left_s_btn.backgroundColor = [UIColor clearColor];
    [self addSubview:left_s_btn];
    left_s_btn.hidden = _leftHidden;
    
    //中
    if (isImg == YES) {//130.7 * 40
        UIImageView * midIV = [[UIImageView alloc]init];
        midIV.frame = CGRectMake((_window_width-130.7)/2, 22+statusbarHeight, 130.7, 40);
        midIV.image = [UIImage imageNamed:mid];
        midIV.contentMode = UIViewContentModeScaleAspectFill;
        midIV.clipsToBounds = YES;
        [self addSubview:midIV];
    }else {
        UILabel *midL = [[UILabel alloc]init];
        midL.text = mid;
        midL.textAlignment = NSTextAlignmentCenter;
        midL.frame = CGRectMake(50, 22+statusbarHeight, _window_width-100, 40);
        midL.textColor = [UIColor blackColor];
        midL.font = SYS_Font(17);
        [self addSubview:midL];
        self.midTitleL = midL; //H5专用
    }
    //右
    UIButton *right_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    right_btn.frame = CGRectMake(_window_width-50, 22+statusbarHeight, 40, 40);
    right_btn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    if (_haveImgR == YES) {
        [right_btn setImage:[UIImage imageNamed:imgR] forState:0];
    }
    if (_haveTitleR == YES) {
        [right_btn setTitle:imgR forState:0];
        //当显示右边按钮为标题而不是图片的时候默认标题右对齐
        right_btn.titleLabel.font = SYS_Font(15);
        [right_btn setTitleColor:Pink_Cor forState:0];//[UIColor whiteColor];
        right_btn.frame = CGRectMake(_window_width-100, 22+statusbarHeight, 90, 40);
        [right_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    right_btn.uxy_acceptEventInterval = 2.0;
    //按钮和shadow、、选择shadow加点击事件不要都加
    //[right_btn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:right_btn];
    right_btn.hidden = _rightHidden;
    //右shadow
    UIButton *right_s_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    right_s_btn.uxy_acceptEventInterval = 2.0;
    right_s_btn.frame = CGRectMake(_window_width-80, 0, 80, 64+statusbarHeight);
    [right_s_btn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    right_s_btn.backgroundColor = [UIColor clearColor];
    [self addSubview:right_s_btn];
    right_s_btn.hidden = _rightHidden;
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, self.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:self];

}
-(void)clickLeftBtn {
    self.leftBack(nil);
}
-(void)clickRightBtn:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
    self.rightBack(nil);
}
-(UIImage *)drawBckgroundImage {
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 21/255.0, 16/255.0, 44/255.0, 1);//黑
    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
