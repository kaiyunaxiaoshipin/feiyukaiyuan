#import "market.h"
#import "Config.h"
@interface market ()<UIWebViewDelegate>
{
    UIWebView *wevView;
    NSURL *url;
    //四个下划线
    UILabel *label1;
    UILabel *label2;
    UILabel *label3;
    UILabel *label4;
}
@end
@implementation market
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
     navtion.backgroundColor = navigationBGColor;
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    [self.view addSubview:navtion];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[YZMsg(@"会员"),@"靓号",@"坐骑"]];
    segment.tintColor = normalColors;
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segment.frame = CGRectMake(_window_width*0.15,25 + statusbarHeight, _window_width*0.7,30);
    UIFont *font1 = [UIFont fontWithName:@"Microsoft YaHei" size:9];
    UIFont *font2 = [UIFont fontWithName:@"Microsoft YaHei" size:11];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font1,NSFontAttributeName,normalColors, NSForegroundColorAttributeName, nil];
    [segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font2,NSFontAttributeName,[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    [segment setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    segment.selectedSegmentIndex = 0;
    [navtion addSubview:segment];
    
}
//segment事件
-(void)change:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        [wevView stopLoading];
        //商城
        NSString *paths = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=Vip&a=index&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
        url = [NSURL URLWithString:paths];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [wevView removeFromSuperview];
        wevView = nil;
        wevView = [[UIWebView alloc] init];
        [wevView loadRequest:request];
        wevView.backgroundColor = [UIColor whiteColor];
        wevView.frame = CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
        wevView.delegate = self;
        [self.view addSubview:wevView];
    }
    //坐骑
    else if (segment.selectedSegmentIndex == 2){
        [wevView stopLoading];
        NSString *paths = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=Car&a=index&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
        url = [NSURL URLWithString:paths];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [wevView removeFromSuperview];
        wevView = nil;
        wevView = [[UIWebView alloc] init];
        [wevView loadRequest:request];
        wevView.backgroundColor = [UIColor whiteColor];
        wevView.frame = CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
        wevView.delegate = self;
        [self.view addSubview:wevView];
    }
    //靓号
    else if (segment.selectedSegmentIndex == 1){
        [wevView stopLoading];
        NSString *paths = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=Liang&a=index&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
        url = [NSURL URLWithString:paths];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [wevView removeFromSuperview];
        wevView = nil;
        wevView = [[UIWebView alloc] init];
        [wevView loadRequest:request];
        wevView.backgroundColor = [UIColor whiteColor];
        wevView.frame = CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
        wevView.delegate = self;
        [self.view addSubview:wevView];
    }
  }
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navtion];
    NSString *paths = [h5url stringByAppendingFormat:@"/index.php?g=Appapi&m=Vip&a=index&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
    url = [NSURL URLWithString:paths];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    wevView = [[UIWebView alloc] init];
    [wevView loadRequest:request];
    wevView.backgroundColor = [UIColor whiteColor];
    wevView.frame = CGRectMake(0,64 + statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
    wevView.delegate = self;
    [self.view addSubview:wevView];
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
