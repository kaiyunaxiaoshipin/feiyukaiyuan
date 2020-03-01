#import "hietoryPlay.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "JRPlayerView.h"
#import "JRControlView.h"
#import <ShareSDK/ShareSDK.h>
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#define backcolor [UIColor colorWithRed:52/255.0 green:54/255.0 blue:58/255.0 alpha:1.0];
@interface hietoryPlay () <JRControlViewDelegate,UIAlertViewDelegate>
{
    UIButton *startBTN;
    NetworkStatus remoteHostStatus;
    int setvishis;
    NSTimer *payTheMoneyTimer;
    BOOL playOK;
    NSString *info;
    UIButton *newPlaybtn;
    BOOL firstLogin;
    int playokokokokook;
}
@property (nonatomic, strong)JRPlayerView		*player;
@property(nonatomic,strong)NSArray *listModelArray;//用户列表数组模型
@property(nonatomic,strong)NSString *ismagic;
@property(nonatomic,strong)NSArray *listArray;
@property(nonatomic,copy)NSString *tanChuangID;
@end
@implementation hietoryPlay
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    setvishis = 0;
    [self.player pause];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    setvishis = 1;
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.player = [[JRPlayerView alloc] initWithFrame:CGRectMake(0,0,_window_width,_window_height)
                                                        asset:[NSURL URLWithString:_url]];
    [self.view addSubview:self.player];
    [self.player pause];

    playokokokokook  = 0;
    newPlaybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [newPlaybtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    newPlaybtn.frame = CGRectMake(10, _window_height-ShowDiff-40, 30, 30);
    [newPlaybtn addTarget:self action:@selector(onPlayVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newPlaybtn];
    
    UIButton *returnBtns = [UIButton buttonWithType:0];
    returnBtns.frame = CGRectMake(_window_width-40,_window_height-ShowDiff-40,30,30);
    [returnBtns.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [returnBtns setImage:[UIImage imageNamed:@"直播间观众—关闭"] forState:UIControlStateNormal];
    [returnBtns addTarget:self action:@selector(doReturn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:returnBtns];

    [self creatLeftView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backspace)];
    [self.view addGestureRecognizer:tap];
}
- (void)creatLeftView{
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 30+statusbarHeight, 120, 36)];
    leftView.backgroundColor = RGB_COLOR(@"#000000", 0.5);
    leftView.layer.cornerRadius = 18.0;
    leftView.layer.masksToBounds = YES;
    [self.view addSubview:leftView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 34, 34)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:minstr([_selectDic valueForKey:@"icon"])]];
    imgView.layer.cornerRadius = 18.0;
    imgView.layer.masksToBounds = YES;
    [leftView addSubview:imgView];
    
    UIImageView *levelImgView = [[UIImageView alloc]initWithFrame:CGRectMake(22, 23, 13, 13)];
    NSDictionary *levelDic = [common getAnchorLevelMessage:minstr([_selectDic valueForKey:@"level"])];
    [levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb_mark"])]];
    [leftView addSubview:levelImgView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right+2, 1, leftView.width-20-imgView.right, 17)];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.text = minstr([_selectDic valueForKey:@"name"]);
    [leftView addSubview:nameLabel];
    
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom, nameLabel.width, 17)];
    idLabel.textColor = [UIColor whiteColor];
    idLabel.font = [UIFont systemFontOfSize:11];
    idLabel.text = [NSString stringWithFormat:@"ID:%@",minstr([_selectDic valueForKey:@"id"])];
    [leftView addSubview:idLabel];


}
-(void)backspace{
    [self onPlayVideo];
}
-(void)onPlayVideo{
    if (playokokokokook == 0) {
        [newPlaybtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [self.player play];
        playokokokokook = 1;
        newPlaybtn.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            newPlaybtn.hidden = YES;
        });

    }
    else{
        [newPlaybtn setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.player pause];
        newPlaybtn.hidden = NO;
        playokokokokook =0;

    }
}
- (void)fullScreenDidSelected{
    
}
-(void)doReturn{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
