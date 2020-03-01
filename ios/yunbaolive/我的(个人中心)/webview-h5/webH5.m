//
//  webH5.m
//  yunbaolive
//
//  Created by zqm on 16/5/16.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "webH5.h"
#import "LivePlay.h"
#import "CoinVeiw.h"
#import "fenXiangView.h"
#import "shareImgView.h"

@interface webH5 ()<UIWebViewDelegate>
{
    UIWebView *wevView;
    int setvisshenqing;
    UIActivityIndicatorView *testActivityIndicator;//菊花
    fenXiangView *shareView;
    UIImage *shareImage;
}
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation webH5
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    setvisshenqing = 1;
    [self navtion];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = RGB(246, 246, 246);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    wevView = [[UIWebView alloc] init];
    
    
    NSURL *url = [NSURL URLWithString:_urls];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wevView loadRequest:request];
    wevView.backgroundColor = [UIColor whiteColor];
    wevView.frame = CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
    wevView.delegate = self;
    [self.view addSubview:wevView];
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url = request.URL.absoluteString;
    if ([url containsString:@"copy://"]) {
        NSString *results = [url substringFromIndex:7];
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = results;
        [MBProgressHUD showError:YZMsg(@"复制成功")];
        return NO;
    }
    if ([url containsString:@"phonelive://pay"]) {
        CoinVeiw *coins = [[CoinVeiw alloc]init];
        [self.navigationController pushViewController:coins animated:YES];
        return NO;
    }
    return YES;
}
//设置导航栏标题
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [testActivityIndicator stopAnimating]; // 结束旋转
    [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = _titles;
    [self.titleLab setFont:navtionTitleFont];
    
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0,statusbarHeight,_window_width,84);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:self.titleLab];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0,statusbarHeight, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    
    if ([_itemID isEqual:@"8"]) {
        UIButton *shareBtn = [UIButton buttonWithType:0];
        shareBtn.frame = CGRectMake(_window_width-40, 24+statusbarHeight, 40, 40);
        [shareBtn setImage:[UIImage imageNamed:@"web_share"] forState:0];
        [shareBtn addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
        shareBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [navtion addSubview:shareBtn];
    }

    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];

    [self.view addSubview:navtion];
}
-(void)doReturn{
    
    NSString *nowUrl = wevView.request.URL.absoluteString;
    NSLog(@"当前请求url为%@",nowUrl);
    NSString *aboutUrl = _urls;
    
    if([nowUrl isEqualToString:aboutUrl]  || nowUrl.length == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated: YES completion:nil];
        
        if ([_isjingpai isEqual:@"isjingpai"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isjingpai" object:nil];
        }
        
    }else if([self.titleLab.text isEqualToString:YZMsg(@"提交成功")] || [self.titleLab.text isEqualToString:YZMsg(@"申请进度")]|| [self.titleLab.text isEqualToString:YZMsg(@"我的家族")]){
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated: YES completion:nil];
        
        
    }
    else
    {
        [wevView goBack];
    }

}
//分享
- (void)doShare{
    if (!shareImage) {
        [MBProgressHUD showMessage:@""];
        [YBToolClass postNetworkWithUrl:@"Agent.getCode" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                NSDictionary *infoDic = [info firstObject];
                shareImgView *shareV = [[NSBundle mainBundle] loadNibNamed:@"shareImgView" owner:nil options:nil].lastObject;
                shareV.iconImgV.image = [PublicObj getAppIcon];
                shareV.appNameL.text = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[Config getavatarThumb]]]];
                shareV.userIcon.image = img;
                shareV.userIconSmall.image = img;
                shareV.userNameL.text = [Config getOwnNicename];
                shareV.userIDL.text = [NSString stringWithFormat:@"ID:%@",[Config getOwnID]];
                shareV.codeImgV.image = [self creatCodeImage:minstr([infoDic valueForKey:@"href"])];
                shareV.invitationL.text = minstr([infoDic valueForKey:@"code"]);
                [shareV layoutIfNeeded];
                shareImage = [self getImage:shareV];
                [self showShareView];
            }else{
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:msg];
            }
        } fail:^{
            [MBProgressHUD hideHUD];
        }];
    }else{
        [self showShareView];
    }
}
- (void)showShareView{
    [MBProgressHUD hideHUD];
    if (!shareView) {
        shareView = [[fenXiangView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        [shareView GetDIc:@{@"id":@"fenxiao",@"image":shareImage}];
        [self.view addSubview:shareView];
    }else{
        [shareView show];
    }

}
- (UIImage *)creatCodeImage:(NSString *)url{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //将NSString格式转化成NSData格式
    NSData *data = [url dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    return [self createNonInterpolatedUIImageFormCIImage:image withSize:190];//重绘二维码,使其显示清晰

}
/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (UIImage *)getImage:(UIView *)shareView

{
    
 UIGraphicsBeginImageContextWithOptions(CGSizeMake(shareView.frame.size.width,shareView.frame.size.height ), NO, 0.0); //currentView 当前的view  创建一个基于位图的图形上下文并指定大小为
    
     [shareView.layer renderInContext:UIGraphicsGetCurrentContext()];
     //      renderInContext呈现接受者及其子范围到指定的上下文
    
     UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
    
     UIGraphicsEndImageContext();//移除栈顶的基于当前位图的图形上下文
    
//     UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//然后将该图片保存到图片图
    
     return viewImage;
    
}
@end
