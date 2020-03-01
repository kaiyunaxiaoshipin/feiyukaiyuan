
#import "profit2.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"
#import "Config.h"

@interface profit2 ()<UITextFieldDelegate>
{
    UITextField *input;
}
@end

@implementation profit2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navtion];

    [self.view setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    
    
    input = [[UITextField alloc] init];
    float NavHeight = 54;//包涵通知栏的20px
    input.frame = CGRectMake(20,NavHeight+20,_window_width-40, 40);
   // input.layer.cornerRadius = 20;
    input.delegate =self;
    input.text = self.money;
    input.layer.masksToBounds = YES;
    input.placeholder = YZMsg(@"请输入提现金额");
    [input setBackgroundColor:[UIColor whiteColor]];
    input.clearButtonMode = UITextFieldViewModeAlways;
    input.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:input];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    
    [self.view addGestureRecognizer:tap];
    
    UIButton *tixian = [UIButton buttonWithType:UIButtonTypeCustom];
    [tixian setTitle:@"提现" forState:UIControlStateNormal];
    [tixian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tixian.backgroundColor = backColor;
    tixian.frame = CGRectMake(_window_width*0.1, 150, _window_width*0.8, 40);
    tixian.layer.masksToBounds = YES;
    tixian.layer.cornerRadius = 20;
    [tixian addTarget:self action:@selector(tixian) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tixian];
    
 
    
}

-(void)tixian{
    
    
    if (input.text.length<=0 || [input.text isEqualToString:@"0"]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入金额" message:nil delegate:self
                                             cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
        
        [alert show];
        
        
        return;
        
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *url = [purl stringByAppendingFormat:@"?service=User.userCash&uid=%@&token=%@&money=%@",[Config getOwnID],[Config getOwnToken],input.text];
    
    
    [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"%@",responseObject);
        NSNumber *number = [responseObject valueForKey:@"ret"] ;
        if([number isEqualToNumber:[NSNumber numberWithInt:200]])
        {
            NSArray *data = [responseObject valueForKey:@"data"];
            NSNumber *code = [data valueForKey:@"code"];
            NSString *msg = [data valueForKey:@"msg"];
            if([code isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                NSString * info = [data valueForKey:@"info"];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:info message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                [alert show];
                input.text = @" ";
                
            }
            else{
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:YZMsg(@"确定") otherButtonTitles:nil, nil];
                
                
                [alert show];
                
            }
        }
        
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         
     }];
    
    
}
-(void)hide{
    
    [input resignFirstResponder];
}

-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64)];
    navtion.backgroundColor = [UIColor whiteColor];
    UILabel *labels = [[UILabel alloc]init];
    labels.text = @"提现";
    //label.font = FNOT;
    [labels setFont:[UIFont fontWithName:@"Heiti SC" size:16]];
    
    labels.textColor = [UIColor blackColor];
    labels.frame = CGRectMake(0, 0,_window_width,84);
    // label.center = navtion.center;
    labels.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:labels];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _window_width/2, 64)];
    [bigBTN addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:bigBTN];
    returnBtn.frame = CGRectMake(8,24 + statusbarHeight,40,40);
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(12.5, 0, 12.5, 25);
    [returnBtn setImage:[UIImage imageNamed:@"me_jiantou"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [navtion addSubview:returnBtn];
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
}
-(void)doReturn{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
