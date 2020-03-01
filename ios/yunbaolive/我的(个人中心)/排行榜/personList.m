//
//  personList.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/2/21.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "personList.h"
@interface personList ()
{
    UISegmentedControl *segmentC;
    UIWebView *wevView;
    UILabel *line1;
    UILabel *line2;
}
@end
@implementation personList
-(void)setview{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width,64+statusbarHeight)];
    navtion.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/3,60)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"icon_arrow_leftsssa.png"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    NSArray *array = @[YZMsg(@"周榜"),YZMsg(@"总榜")];
    segmentC = [[UISegmentedControl alloc]initWithItems:array];
    [segmentC addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segmentC.tintColor = [UIColor clearColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(14),NSFontAttributeName,[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7], NSForegroundColorAttributeName, nil];
    [segmentC setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:fontMT(16),NSFontAttributeName,[UIColor blackColor], NSForegroundColorAttributeName, nil];
    [segmentC setTitleTextAttributes:highlightedAttributes forState:UIControlStateSelected];
    segmentC.selectedSegmentIndex = 0;
    [navtion addSubview:segmentC];
    segmentC.frame = CGRectMake(_window_width/4,25+statusbarHeight,_window_width/2,30);
    CGFloat lineW = (_window_width/4)/3;
    line1 = [[UILabel alloc]initWithFrame:CGRectMake(lineW,32,lineW, 3)];
    line1.backgroundColor = [UIColor blackColor];
    line2 = [[UILabel alloc]initWithFrame:CGRectMake(_window_width/4 + lineW,32,lineW, 3)];
    line2.backgroundColor = [UIColor blackColor];
    line2.hidden = YES;
    line1.hidden = NO;
    [segmentC addSubview:line2];
    [segmentC addSubview:line1];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//segment事件
-(void)change:(UISegmentedControl *)segment{
    if (segment.selectedSegmentIndex == 0) {
        line1.hidden = NO;
        line2.hidden = YES;
        if (wevView) {
            [wevView removeFromSuperview];
            wevView = nil;
        }
        wevView = [[UIWebView alloc] init];
        NSString *userBaseUrl = [h5url stringByAppendingFormat:@"/index.php?g=appapi&m=Contribute&a=order&type=week&uid=%@",_userID];
        NSURL *url = [NSURL URLWithString:userBaseUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [wevView loadRequest:request];
        wevView.backgroundColor = [UIColor whiteColor];
        wevView.frame = CGRectMake(0,64+statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
        [self.view addSubview:wevView];
    }
    else if (segment.selectedSegmentIndex == 1){
        line2.hidden = NO;
        line1.hidden = YES;
        if (wevView) {
            [wevView removeFromSuperview];
            wevView = nil;
        }
        wevView = [[UIWebView alloc] init];
        NSString *userBaseUrl = [h5url stringByAppendingFormat:@"/index.php?g=appapi&m=Contribute&a=order&type=all&uid=%@",_userID];
        NSURL *url = [NSURL URLWithString:userBaseUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [wevView loadRequest:request];
        wevView.backgroundColor = [UIColor whiteColor];
        wevView.frame = CGRectMake(0,64 +statusbarHeight, _window_width, _window_height-64 - statusbarHeight);
        [self.view addSubview:wevView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setview];
    wevView = [[UIWebView alloc] init];
    NSString *userBaseUrl = [h5url stringByAppendingFormat:@"/index.php?g=appapi&m=Contribute&a=order&type=week&uid=%@",_userID];
    NSURL *url = [NSURL URLWithString:userBaseUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [wevView loadRequest:request];
    wevView.backgroundColor = [UIColor whiteColor];
    wevView.frame = CGRectMake(0,64+statusbarHeight, _window_width, _window_height-64-statusbarHeight);
    [self.view addSubview:wevView];
}
@end
