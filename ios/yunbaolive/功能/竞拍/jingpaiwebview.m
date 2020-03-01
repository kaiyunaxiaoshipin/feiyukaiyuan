//
//  jingpaiwebview.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/28.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "jingpaiwebview.h"

@interface jingpaiwebview ()<UIWebViewDelegate>

@property(nonatomic,strong)aaaxinblock blocks;

@property(nonatomic,strong)aaaxinblock cancleblock;

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,copy)NSString *titles;

@end

@implementation jingpaiwebview
-(instancetype)initWithFrame:(CGRect)frame andblock:(aaaxinblock)blocks andcancle:(aaaxinblock)cancleblock{
    self = [super initWithFrame:frame];
    if (self) {
        self.blocks  = blocks;
        self.cancleblock = cancleblock;
        jingpaiweb = [[UIWebView alloc]initWithFrame:CGRectMake(0,40 + statusbarHeight, _window_width, _window_height-40-statusbarHeight)];
        jingpaiweb.delegate = self;
        [self addSubview:jingpaiweb];
        jingpaiweb.scrollView.bounces = NO;
        [self navtion];
    }
    return self;
}
-(void)loadrequest:(NSString *)stream{
    
    userBaseUrl =[h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=Auction&a=index&uid=%@&token=%@&addr=%@&stream=%@",[Config getOwnID],[Config getOwnToken],[cityDefault getaddr],stream];
    userBaseUrl = [userBaseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:userBaseUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [jingpaiweb loadRequest:request];
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = request.URL.absoluteString;
    
    
    
   if ([url containsString:@"phonelive://auction/"]) {
        //phonelive://auction/1
        //_method_ : auction  action:55  发布 auctionid
        //取标志后面的作为ID
        NSString *results = [url substringFromIndex:20];
        self.blocks(results);
        return NO;
     }
     return YES;
}
//设置导航栏标题
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.titleLab.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 60 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = _titles;
    [self.titleLab setFont:navtionTitleFont];
    self.titleLab.textColor = navtionTitleColor;
    self.titleLab.frame = CGRectMake(0, statusbarHeight,_window_width,80);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:self.titleLab];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 60)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,60);
    [navtion addSubview:btnttttt];
    [self addSubview:navtion];
}
-(void)doReturn{
    self.cancleblock(@"");
}

@end
