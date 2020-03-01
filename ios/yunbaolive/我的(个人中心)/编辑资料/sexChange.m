#import "sexChange.h"
@interface sexChange ()
{
    int setvissex;
    UIActivityIndicatorView *testActivityIndicator;//菊花
}
@property (weak, nonatomic) IBOutlet UIButton *manBTN;
@property (weak, nonatomic) IBOutlet UIButton *womanBTN;
- (IBAction)doman:(id)sender;
- (IBAction)dowoman:(id)sender;
- (IBAction)cancle:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *manlabel;
@property (weak, nonatomic) IBOutlet UILabel *womanlabel;
@property(nonatomic,strong)UILabel *titleLab;
@end
@implementation sexChange
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0,0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    self.titleLab = [[UILabel alloc]init];
    self.titleLab.text = @"性别";
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
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];

    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    LiveUser *user = [Config myProfile];
    if ([user.sex isEqualToString:@"1"]) {
        [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_nanren"] forState:UIControlStateNormal];
        [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    }
    else{
        [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_nvren"] forState:UIControlStateNormal];
        [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    }
    [self navtion];
    
}
- (IBAction)doman:(id)sender {
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_nanren"] forState:UIControlStateNormal];
    [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_un_femal"] forState:UIControlStateNormal];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"1"] forKeys:@[@"sex"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];

    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            LiveUser *user = [[LiveUser alloc] init];
            user.sex = @"1";
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults setObject:@"1" forKey:@"sex"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    }];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    setvissex = 1;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    setvissex = 0;
}
- (IBAction)dowoman:(id)sender {
    
    
    [self.manBTN setImage:[UIImage imageNamed:@"choice_sex_un_male"] forState:UIControlStateNormal];
    [self.womanBTN setImage:[UIImage imageNamed:@"choice_sex_nvren"] forState:UIControlStateNormal];

    NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[@"2"] forKeys:@[@"sex"]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *url = [NSString stringWithFormat:@"User.updateFields&uid=%@&token=%@&fields=%@",[Config getOwnID],[Config getOwnToken],jsonStr];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            LiveUser *user = [[LiveUser alloc] init];
            user.sex = @"2";
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"2" forKey:@"sex"];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];

        }
    } fail:^{
        
    }];
}
- (IBAction)cancle:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
