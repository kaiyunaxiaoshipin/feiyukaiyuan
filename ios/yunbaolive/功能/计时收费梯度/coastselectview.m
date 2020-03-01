//
//  coastselectview.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/1.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "coastselectview.h"
#import "coastselecell.h"
@interface coastselectview ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *maskview;// 遮罩
@property(nonatomic,strong)NSMutableArray *infoArray;//收费金额列表
@property(nonatomic,strong)NSMutableArray *colorarray;//收费金额选中列表
@property(nonatomic,assign)NSInteger selected;//选中
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation coastselectview
-(instancetype)initWithFrame:(CGRect)frame andsureblock:(axinblock)sureblock andcancleblock:(axinblock)cancleblock{
    self = [super initWithFrame:frame];
    if (self) {

        self.sureblock = sureblock;
        self.cancleblock = cancleblock;
        self.infoArray = [NSMutableArray array];
        NSArray *arrays = [common live_time_coin];//获取收费阶梯
        for (int i=0; i<arrays.count; i++) {
            NSString *path = [NSString stringWithFormat:@"%@%@/分钟",arrays[i],[common name_coin]];
            [self.infoArray addObject:path];
        }
        self.colorarray = [NSMutableArray array];
        for (int i=0; i<_infoArray.count; i++) {
            if (i == 0) {
                 [_colorarray addObject:@"1"];
            }else
            [_colorarray addObject:@"0"];
        }
        
        _maskview = [[UIView alloc]initWithFrame:CGRectMake(0,0,_window_width, _window_height)];
        [self addSubview:_maskview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(docancle)];
        tap.delegate = self;
        [_maskview addGestureRecognizer:tap];
        
        UIView *VC = [[UIView alloc]initWithFrame:CGRectMake(_window_width*0.1,_window_height*0.3, _window_width*0.8, _window_width*0.8)];
        VC.userInteractionEnabled = YES;
        [self addSubview:VC];
        VC.backgroundColor = [UIColor whiteColor];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(VC.frame.size.width * 0.45,50,VC.frame.size.width*0.55,VC.frame.size.height - 50) style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.allowsSelection = YES;
        self.tableView.userInteractionEnabled = YES;
        self.tableView.delegate   = self;
        self.tableView.dataSource = self;
        [VC addSubview:self.tableView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0,0,VC.frame.size.width,50)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"收费金额";
        [VC addSubview:title];
        
        //横线
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0,50,VC.frame.size.width,1)];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [VC addSubview:line];
        
        //竖线
        UILabel *linepromit = [[UILabel alloc]initWithFrame:CGRectMake(VC.frame.size.width * 0.45,50,1,VC.frame.size.height - 50)];
        linepromit.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [VC addSubview:linepromit];
        NSArray *titles = @[@"选择收费",YZMsg(@"取消"),YZMsg(@"确定")];
        
        for (int i = 0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            btn.titleLabel.font = fontThin(13);
            if (i == 0) {
                [btn setImage:[UIImage imageNamed:@"docoasessssimage.jpg"] forState:UIControlStateNormal];
                btn.frame = CGRectMake(0,60,VC.frame.size.width*0.45,30);
                btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [btn setTintColor:[UIColor blackColor]];
                [btn setImageEdgeInsets:UIEdgeInsetsMake(5,5,5,5)];
            }
            else if(i == 1){
                [btn setTintColor:[UIColor blackColor]];
                btn.frame = CGRectMake(VC.frame.size.width*0.45 * 0.15,(VC.frame.size.height - 40) * 0.65,VC.frame.size.width*0.45 * 0.7,30);
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 15;
                btn.layer.borderColor = normalColors.CGColor;
                btn.layer.borderWidth = 1.0;
                btn.backgroundColor = [UIColor clearColor];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else if(i == 2){
                [btn setTintColor:[UIColor blackColor]];
                btn.frame = CGRectMake(VC.frame.size.width*0.45 * 0.15,(VC.frame.size.height - 40) * 0.85,VC.frame.size.width*0.45 * 0.7,30);
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 15;
                btn.layer.borderColor = normalColors.CGColor;
                btn.layer.borderWidth = 1.0;
                btn.backgroundColor = normalColors;
                 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(doactions:) forControlEvents:UIControlEventTouchUpInside];
            [VC addSubview:btn];
        }
        self.backgroundColor = [UIColor clearColor];
        VC.layer.masksToBounds = YES;
        VC.layer.cornerRadius = 5;
        VC.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
    }
    return self;
}
//选择收费金额
-(void)doactions:(UIButton *)sender{
    if ([sender.titleLabel.text isEqual:YZMsg(@"确定")]) {
        
        if (_infoArray.count == 0) {
            self.cancleblock(@"");
            return;
        }
        self.sureblock([common live_time_coin][_selected]);
        
    }
    if ([sender.titleLabel.text isEqual:YZMsg(@"取消")]) {
        self.cancleblock(@"");
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.infoArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    coastselecell *cell = [coastselecell cellWithTableView:tableView];
    NSString *colors = _colorarray[indexPath.row];
    
    if ([colors isEqual:@"1"]) {
        
        cell.showlabel.textColor = normalColors;
    }else
        cell.showlabel.textColor = [UIColor blackColor];
    cell.showlabel.text = self.infoArray[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    if (_infoArray.count == 0 || _infoArray == nil) {
        self.cancleblock(@"");
        return;
    }
    coastselecell *cell =  (coastselecell *)[self.tableView cellForRowAtIndexPath:indexPath];
    cell.showlabel.textColor = normalColors;
    _selected = indexPath.row;
    [_colorarray removeAllObjects];
    for (int i=0; i<_infoArray.count; i++) {
        if (i == (int)indexPath.row) {
            [_colorarray addObject:@"1"];
        }else
            [_colorarray addObject:@"0"];
    }
    [self.tableView reloadData];
}
-(void)docancle{
    self.cancleblock(@"");
}
@end
