#import "adminLists.h"
#import "adminCell.h"
#import "fansModel.h"
@interface adminLists ()<UITableViewDelegate,UITableViewDataSource,adminCellDelegate>
@property(nonatomic,strong)NSArray *fansmodels;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *addAdmins;

@end
@implementation adminLists
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"管理员列表");
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
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height, _window_width, 5) andColor:RGB(244, 245, 246) andView:self.view];

}
-(void)doReturn{
    [self.delegate adminZhezhao];
}

-(NSArray *)fansmodels{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.allArray) {
        fansModel *model = [fansModel modelWithDic:dic];
        [array addObject:model];
    }
    _fansmodels = array;
    return _fansmodels;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adminxin) name:@"adminlist" object:nil];
}
-(void)listMessage{
    
    NSDictionary *subdic = @{
                             @"liveuid":[Config getOwnID]
                             };
    [YBToolClass postNetworkWithUrl:@"Live.getAdminList" andParameter:subdic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            self.allArray = [[info firstObject] valueForKey:@"list"];//关注信息复制给数据源
            self.addAdmins = [[info firstObject] valueForKey:@"total"];//总的管理员
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    } fail:^{
        
    }];
}
-(void)adminxin{
    [self navtion];
    self.allArray = [NSArray array];
    self.fansmodels = [NSArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 69+statusbarHeight, _window_width, _window_height-69-statusbarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    [self listMessage];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 30)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = [NSString stringWithFormat:@"    %@（%ld/%@）",YZMsg(@"当前管理员"),self.allArray.count,self.addAdmins];
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    adminCell *cell = [adminCell cellWithTableView:tableView];
    cell.delegate = self;
    fansModel *model = self.fansmodels[indexPath.row];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //弹窗
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)doGuanzhu:(NSString *)st{
    //关注
    NSString *url = [NSString stringWithFormat:@"User.setAttention&uid=%@&showid=%@&token=%@",[Config getOwnID],st,[Config getOwnToken]];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            
        }
    } fail:^{
        
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)delateAdminUser:(fansModel *)model{
    
    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:YZMsg(@"温馨提示") message:[NSString stringWithFormat:@"%@%@%@？",YZMsg(@"是否确定取消"),model.name,YZMsg(@"的管理员身份")] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:YZMsg(@"不了") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertContro addAction:cancleAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:YZMsg(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *setadmin = @{
                                   @"liveuid":[Config getOwnID],
                                   @"touid":model.uid,
                                   };
        [YBToolClass postNetworkWithUrl:@"Live.setAdmin" andParameter:setadmin success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                NSString *isadmin = [NSString stringWithFormat:@"%@",[[info firstObject] valueForKey:@"isadmin"]];
                [self.delegate setAdminSuccess:isadmin andName:model.name andID:model.uid];
                [self listMessage];
            }else{
                [MBProgressHUD showError:msg];
            }
        } fail:^{
            
        }];

    }];
    [alertContro addAction:sureAction];
    [self presentViewController:alertContro animated:YES completion:nil];
}
@end
