#import "fansViewController.h"
#import "fans.h"
#import "fansModel.h"
#import "otherUserMsgVC.h"
@interface  fansViewController()<UITableViewDelegate,UITableViewDataSource,guanzhu>
{
    NSInteger a;
    int setvisfans;
    otherUserMsgVC *person;
    UIView *nothingView;
    UIActivityIndicatorView *testActivityIndicator;//菊花
    YBNoWordView *noNetwork;

}
@property(nonatomic,strong)NSArray *fansmodels;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation fansViewController
-(NSArray *)fansmodels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        fansModel *model = [fansModel modelWithDic:dic];
        [array addObject:model];
    }
    _fansmodels = array;
    return _fansmodels;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    setvisfans = 1;
    [self request];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    setvisfans = 0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.allArray = [NSArray array];
    self.tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0,64 + statusbarHeight, _window_width, _window_height - 64 - statusbarHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self navtion];
    [self createView];

    [self request];
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
    [testActivityIndicator startAnimating]; // 开始旋转
}
-(void)createView{
    
    nothingView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, _window_width, 40)];
    nothingView.hidden = YES;
    nothingView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nothingView];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = YZMsg(@"你还没有粉丝");
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = RGB_COLOR(@"#333333", 1);
    [nothingView addSubview:label1];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, _window_width, 20)];
    label2.font = [UIFont systemFontOfSize:13];
    label2.text = YZMsg(@"完善个人信息会让更多的人关注到你～");
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = RGB_COLOR(@"#969696", 1);
    [nothingView addSubview:label2];

    noNetwork = [[YBNoWordView alloc]initWithBlock:^(id msg) {
        [self request];
    }];
    noNetwork.hidden = YES;
    [self.view addSubview:noNetwork];

    
}
-(void)request
{

    NSString *url = [NSString stringWithFormat:@"User.getFansList&uid=%@&touid=%@&p=%@",[Config getOwnID],self.fensiUid,@"1"];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if(code == 0)
        {
            self.allArray = info;//关注信息复制给数据源
            [self.tableView reloadData];
            //如果数据为空
            if (self.allArray.count == 0) {
                [self.tableView removeFromSuperview];
                nothingView.hidden = NO;
            }else{
                nothingView.hidden = YES;
            }
        }
        else{
            
            nothingView.hidden = NO;
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏
        nothingView.hidden = YES;
        if (self.allArray.count == 0) {
            noNetwork.hidden = NO;
        }

    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.fansmodels.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    fans *cell = [fans cellWithTableView:tableView];
    fansModel *model = self.fansmodels[indexPath.row];
    cell.model = model;
    cell.guanzhuDelegate = self;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor = navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"粉丝");
    [label setFont:navtionTitleFont];
    label.textColor = navtionTitleColor;
    label.frame = CGRectMake(0, statusbarHeight,_window_width,84);
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *bigBTN = [[UIButton alloc]initWithFrame:CGRectMake(0, statusbarHeight, _window_width/2, 64)];
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
    btnttttt.frame = CGRectMake(0,0,100,64);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];

}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    person = [[otherUserMsgVC alloc]init];
    fansModel *model = self.fansmodels[indexPath.row];
    person.userID = model.uid;
    [self.navigationController pushViewController:person animated:YES];
 //   [self presentViewController:person animated:YES completion:nil];
}
-(void)doGuanzhu:(NSString *)st{
    [YBToolClass postNetworkWithUrl:@"User.setAttent" andParameter:@{@"touid":st} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSDictionary *subdic = [info firstObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadLiveplayAttion" object:subdic];
            [self request];
        }
    } fail:^{
        
    }];
    
}
@end
