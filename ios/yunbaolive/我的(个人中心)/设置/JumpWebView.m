//
//  JumpWebView.m
//  yunbaolive
//
//  Created by cat on 16/4/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "JumpWebView.h"

@interface JumpWebView ()<UIWebViewDelegate>

@property UILabel *titleLab;
@end

@implementation JumpWebView
{
    UIWebView *webview;
}
             - (void)viewDidLoad {
             [super viewDidLoad];
             self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
    NSURL *reqUrl = [NSURL URLWithString:self.url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:reqUrl];
    webview = [[UIWebView alloc] init];
    webview.delegate = self;
    webview.backgroundColor = [UIColor clearColor];
    [webview loadRequest:request];
    webview.frame = CGRectMake(0, 64, _window_width, _window_height - 70);
    
    [self.view addSubview:webview];
        
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
//设置导航栏标题
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = @"";
    self.titleLab.font = navtionTitleFont;
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0, 0,_window_width, 84);
   // self.titleLab.center = navtion.center;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:self.titleLab];
    /*
     UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
     [rightBtn setTitle:@"提现记录" forState:UIControlStateNormal];
     [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [rightBtn addTarget:self action:@selector(money) forControlEvents:UIControlEventTouchUpInside];
     */
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self navtion];
}
-(void)doReturn{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    NSString* phoneModel = [[UIDevice currentDevice] model];

    NSString *nowUrl = webview.request.URL.absoluteString;
    NSLog(@"当前请求url为%@",nowUrl);
    NSString *aboutUrl = [h5url stringByAppendingString:@"/index.php?g=portal&m=page&a=lists"];
    
    NSString *strings = [NSString stringWithFormat:@"/index.php?g=portal&m=page&a=newslist&uid=%@&version=%@&model=%@",[Config getOwnID],phoneVersion,phoneModel];
    

    
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)strings,
                                                              NULL,
                                                              (CFStringRef)@" ",
                                                              kCFStringEncodingUTF8));
   NSString *helpUrl =  [h5url stringByAppendingString:outputStr];
    
    if([nowUrl isEqualToString:aboutUrl] || [nowUrl isEqualToString:helpUrl])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [webview goBack];
    }
    
}


@end
