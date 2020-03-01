
#import "musicView.h"
#import "hunyinCell.h"
#import "NSString+StringSize.h"
#import "hunyinModel.h"
@interface musicView ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableData *musicData;
    long long allLength;
    float currentLength;
    UIImageView *imageView;
    UIButton *btn;
    UIView *myview ;
    NSString *lrc;
    NSArray *lrcArray;
    UIActivityIndicatorView *testActivityIndicator;//菊花
}
@property(nonatomic,strong)UISearchBar *search;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)NSArray *downloadArray;
@end
@implementation musicView
static int music = 0;//下载的歌曲 ，未下载的歌曲
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    music = 0;
}
-(NSArray *)models{
    NSMutableArray *array = [NSMutableArray array];
    
    
    if (music == 0) {
        NSFileManager *manager=[NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSArray *arrayy=[manager subpathsAtPath:docDir];
        NSMutableArray *mp3Array = [NSMutableArray array];
        for (NSString *str in arrayy) {
            BOOL isMp3 = [str hasSuffix:@"mp3"];
            if (isMp3) {
                NSArray *subArray = [str componentsSeparatedByString:@"*"];
                NSString *songID = [subArray objectAtIndex:0];
                NSString *songName = [subArray objectAtIndex:1];
                NSString *name = [subArray objectAtIndex:2];
                NSArray *nameArray = [name componentsSeparatedByString:@"."];
                name = [nameArray objectAtIndex:0];
                NSDictionary *dic = [NSDictionary dictionaryWithObjects:@[songID,songName,name] forKeys:@[@"audio_id",@"audio_name",@"artist_name"]];
        
                [mp3Array addObject:dic];
            }
        }
        self.allArray = mp3Array;
        for (NSDictionary *dic in self.allArray) {
            hunyinModel *model = [hunyinModel modelWithDic:dic];
            [array addObject:model];
            
        }

    }
    else
    {
    for (NSDictionary *dic in self.allArray) {
        hunyinModel *model = [hunyinModel modelWithDic:dic];
        [array addObject:model];
       }
    }
    _models = array;
    return _models;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(musiccancle) name:@"cancle" object:nil];
    self.tableView.editing = YES;
    self.downloadArray = [NSArray array];
    self.allArray = [NSArray array];
    self.models = [NSArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,24+statusbarHeight, _window_width, _window_height-20 - statusbarHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:self.tableView];
    myview = [[UIView alloc]initWithFrame:CGRectMake(0,0,_window_width,64+statusbarHeight)];
    myview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myview];
    btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setTitle:YZMsg(@"取消") forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.frame = CGRectMake(_window_width - 50,20+statusbarHeight,50,30);
    [btn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [myview addSubview:btn];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0,13, _window_width, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [myview addSubview:label];
    self.search = [[UISearchBar alloc]initWithFrame:CGRectMake(0,15+statusbarHeight, _window_width-50,44)];
    self.search.searchBarStyle = UISearchBarStyleMinimal;
    self.search.tintColor = normalColors;
    self.search.delegate = self;
    [self.search becomeFirstResponder];
    [myview addSubview:self.search];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, _window_width, _window_height-44)];
    imageView.image = [UIImage imageNamed:@"default_search.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.hidden = YES;
    [self.view addSubview:imageView];
    UITextField *textField =  [self.search valueForKey:@"_searchField"];
    [textField setValue:normalColors forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:[UIFont systemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
    self.search.tintColor = [UIColor whiteColor];
    UISwipeGestureRecognizer *swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(keyHide)];
    swip.direction = UISwipeGestureRecognizerDirectionDown|UISwipeGestureRecognizerDirectionUp;
    [self.tableView addGestureRecognizer:swip];
    self.navigationController.navigationBarHidden = YES;
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = self.view.center;
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor];
}
-(void)deleteMusic{
    
    
    
}
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = [self.allArray objectAtIndex:indexPath.row];
    hunyinModel *model = [hunyinModel modelWithDic:dic];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/%@*%@*%@.mp3",model.songid,model.songname,model.artistname];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:loadPath];
    if (blHave) {
         [fileManager removeItemAtPath:loadPath error:nil];
        [self.tableView reloadData];
    }
    
    

}
 -(void)cancle{
     [self.view endEditing:YES];
       [self dismissViewControllerAnimated:YES completion:nil];
       music = 0;
       [self.tableView reloadData];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
        [self.search resignFirstResponder];
}
-(void)musiccancle{
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)keyHide{
    
    [self.search resignFirstResponder];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.models.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [self.allArray objectAtIndex:indexPath.row];
//    hunyinCell *cell = [hunyinCell cellWithTableView:tableView];
//    hunyinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music"];
    NSString*cellID = [NSString stringWithFormat:@"music%zd", indexPath.row];
    
    hunyinCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if(cell ==nil) {
        
        cell = [[hunyinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
//    hunyinCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if(!cell){
//        cell = [[hunyinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"music"];
//    }
    hunyinModel *model = [hunyinModel modelWithDic:dic];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    [testActivityIndicator startAnimating]; // 开始旋转
        NSDictionary *dic = self.allArray[indexPath.row];
    hunyinCell *cell = (hunyinCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *songid = [NSString stringWithFormat:@"%@",[dic valueForKey:@"audio_id"]];
    NSString *songname = [NSString stringWithFormat:@"%@",[dic valueForKey:@"audio_name"]];
    NSString *artistname = [NSString stringWithFormat:@"%@",[dic valueForKey:@"artist_name"]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *loadPath = [docDir stringByAppendingFormat:@"/%@*%@*%@.mp3",songid,songname,artistname];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:loadPath]) {
          [cell musicDownLoad];
    }
    else{
        NSString *url = [NSString stringWithFormat:@"Livemusic.getDownurl&audio_id=%@",[dic valueForKey:@"audio_id"]];
        [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
            if (code == 0) {
                NSDictionary *infos = [info firstObject];
                //下载歌曲
                NSString *path = [NSString stringWithFormat:@"%@",[infos valueForKey:@"audio_link"]];
                cell.path = path;
                cell.songName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"lrc_title"]];
                [self.tableView reloadData];
                //保存歌词
                NSString *lrcLink = [NSString stringWithFormat:@"%@",[infos valueForKey:@"lrc_content"]];
                [self saveLRC:lrcLink and:dic];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    cell.isDown = YES;
                    [cell musicDownLoad];
                });
            }
            [testActivityIndicator stopAnimating]; // 结束旋转
            [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

        } fail:^{
            [testActivityIndicator stopAnimating]; // 结束旋转
            [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

        }];
        
    }
}
//获取歌词
-(void)saveLRC:(NSString *)LRC and:(NSDictionary *)dic{
  //  NSURL *url = [NSURL URLWithString:LRC];
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
//    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
//    lrc = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *lrcPath = [docDir stringByAppendingFormat:@"/%@.lrc",[dic valueForKey:@"audio_id"]];
    if([LRC writeToFile:lrcPath atomically:YES encoding:NSUTF8StringEncoding error:nil]){
        NSLog(@"保存LRC成功");
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.tableView reloadData];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [testActivityIndicator startAnimating]; // 开始旋转
    [searchBar resignFirstResponder];
    self.allArray = nil;
    self.allArray = [NSArray array];
    [self.tableView reloadData];
    music = 1;
    NSString *url = [NSString stringWithFormat:@"Livemusic.searchMusic&key=%@",self.search.text];
    [YBToolClass postNetworkWithUrl:url andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            self.allArray = info;
            [self.tableView reloadData];
            if (self.allArray.count ==0) {
                imageView.hidden = NO;
            }else{
                imageView.hidden = YES;
            }
        }else{
            imageView.hidden = NO;
        }
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    } fail:^{
        [testActivityIndicator stopAnimating]; // 结束旋转
        [testActivityIndicator setHidesWhenStopped:YES]; //当旋转结束时隐藏

    }];
}
@end
