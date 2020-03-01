//
//  ProfitViewC.m
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "ProfitViewC.h"
#import "webH5.h"
@interface ProfitViewC ()

@property (weak, nonatomic) IBOutlet UILabel *profitL;
- (IBAction)shouyiBTN:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *prof;

- (IBAction)DoQuestion:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIewH;

@end

@implementation ProfitViewC
- (void)viewDidLoad {
[super viewDidLoad];
    if (self.VIewH.constant<80) {
        self.VIewH.constant+=statusbarHeight;
    }
    _profitL.text = [common name_votes];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self navtion];
    [self cash];
}
-(void)cash{
    self.navigationController.navigationBarHidden = YES;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=User.getProfit&uid=%@&token=%@",[Config getOwnID],[Config getOwnToken]];
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                //获取收益
                self.canwithdraw.text = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"total"]];
                self.withdraw.text = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"todaycash"]];
                self.labVotes.text = [NSString stringWithFormat:@"%@",[[[data valueForKey:@"info"] firstObject] valueForKey:@"votes"]];//收益 魅力值
                NSLog(@"收益数据........%@",data);
            }
        }
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
}
-(void)navtion{    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64+statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = @"我的收益";
//label.font = FNOT;
    [label setFont:navtionTitleFont];

    label.textColor = navigationBGColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
   // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
     UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, +statusbarHeight, _window_width/2, 64)];
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
    btnttttt.frame = CGRectMake(0,statusbarHeight,100,64);
    [navtion addSubview:btnttttt];

    [self.view addSubview:navtion];
}
-(void)doReturn{    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)shouyiBTN:(id)sender {
    self.navigationController.navigationBarHidden = YES;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=User.setCash"];
    NSDictionary *subdic = @{
                             @"uid":[Config getOwnID],
                             @"token":[Config getOwnToken]
                             };
    [session POST:url parameters:subdic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSString *code = [NSString stringWithFormat:@"%@",[data valueForKey:@"code"]];
            if([code isEqual:@"0"])
            {
                [self cash];
                [MBProgressHUD showError:@"提现成功"];
            }
            else{
                [MBProgressHUD showError:[data valueForKey:@"msg"]];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (IBAction)DoQuestion:(id)sender {
    webH5 *VC = [[webH5 alloc]init];
    VC.titles = @"常见问题";
    
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    
    NSLog(@"手机型号：%@",phoneModel);
    
    NSString *strings = [NSString stringWithFormat:@"/index.php?g=portal&m=page&a=newslist&uid=%@&version=%@&model=%@&token=%@",[Config getOwnID],phoneVersion,phoneModel,[Config getOwnToken]];
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)strings,
                                                              NULL,
                                                              (CFStringRef)@" ",
                                                              kCFStringEncodingUTF8));
    
    VC.urls = [h5url stringByAppendingString:outputStr];
    [[MXBADelegate sharedAppDelegate] pushViewController:VC animated:YES];
}
@end

