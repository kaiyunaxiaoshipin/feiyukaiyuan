//
//  YBBaseViewController.m
//  yunbaolive
//
//  Created by IOS1 on 2019/3/18.
//  Copyright © 2019 cat. All rights reserved.
//

#import "YBBaseViewController.h"
#define naviBackColor [UIColor whiteColor]
#define naviTFont 15
#define naviTColor RGB_COLOR(@"#333333", 1)
@interface YBBaseViewController ()

@end

@implementation YBBaseViewController
- (void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)creatNavi{
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    _naviView.backgroundColor = naviBackColor;
    [self.view addSubview:_naviView];
    
    _returnBtn = [UIButton buttonWithType:0];
    _returnBtn.frame = CGRectMake(0, 24+statusbarHeight, 40, 40);
//    _returnBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [_returnBtn setImage:[UIImage imageNamed:@"navi_backImg"] forState:0];
    [_returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [_naviView addSubview:_returnBtn];
    
    _titleL = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/2-80, 34+statusbarHeight, 160, 20)];
    _titleL.font = SYS_Font(naviTFont);
    _titleL.textColor = naviTColor;
    _titleL.textAlignment = NSTextAlignmentCenter;
    [_naviView addSubview:_titleL];
    
    _rightBtn = [UIButton buttonWithType:0];
    [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.hidden = YES;
    _rightBtn.titleLabel.font = SYS_Font(15);
    [_rightBtn setTitleColor:normalColors forState:0];
    [_naviView addSubview:_rightBtn];
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(_titleL);
        make.right.equalTo(_naviView).offset(-10);
    }];
    [[YBToolClass sharedInstance]lineViewWithFrame:CGRectMake(0, _naviView.height-1, _window_width, 1) andColor:RGB_COLOR(@"#f5f5f5", 1) andView:_naviView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    self.navigationController.navigationBar.hidden = YES;
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 11.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatNothingView];
    [self creatNavi];
}

- (void)creatNothingView{
    _nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, _window_height-64-statusbarHeight)];
    _nothingView.backgroundColor = RGB_COLOR(@"#f5f5f5", 1);
    _nothingView.hidden = YES;
    [self.view addSubview:_nothingView];
    _nothingImgV = [[UIImageView alloc]initWithFrame:CGRectMake(_nothingView.width/2-40, 120, 80, 80)];
    [_nothingView addSubview:_nothingImgV];
    _nothingTitleL = [[UILabel alloc]initWithFrame:CGRectMake(0, _nothingImgV.bottom+10, _window_width, 15)];
    _nothingTitleL.font = [UIFont systemFontOfSize:13];
    _nothingTitleL.textAlignment = NSTextAlignmentCenter;
    [_nothingView addSubview:_nothingTitleL];
    
    _nothingMsgL = [[UILabel alloc]initWithFrame:CGRectMake(0, _nothingTitleL.bottom+5, _window_width, 15)];
    _nothingMsgL.textColor = RGB_COLOR(@"#969696", 1);
    _nothingMsgL.font = [UIFont systemFontOfSize:10];
    _nothingMsgL.textAlignment = NSTextAlignmentCenter;
    [_nothingView addSubview:_nothingMsgL];

    _nothingBtn = [UIButton buttonWithType:0];
    _nothingBtn.frame = CGRectMake(_window_width/2-35, _nothingMsgL.bottom+10, 70, 28);
    _nothingBtn.backgroundColor = normalColors;
    _nothingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_nothingBtn addTarget:self action:@selector(nothingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _nothingBtn.hidden = YES;
    _nothingBtn.layer.cornerRadius = 15;
    _nothingBtn.layer.masksToBounds  = YES;
    [_nothingView addSubview:_nothingBtn];
}
- (void)nothingBtnClick{
    
}
- (void)rightBtnClick{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
