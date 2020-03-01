//
//  impressVC.m
//  yunbaolive
//
//  Created by Boom on 2018/9/26.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "impressVC.h"
#import "impressCell.h"
#import "JYEqualCellSpaceFlowLayout.h"

@interface impressVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UICollectionView *impressCollection;
    NSArray *infoArray;
    NSMutableArray *selectMutableArray;
    UILabel *mineL;
}

@end

@implementation impressVC
-(void)navtion{
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 64 + statusbarHeight)];
    navtion.backgroundColor =navigationBGColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = YZMsg(@"主播印象");
    
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
    [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(0, navtion.height-1, _window_width, 1) andColor:RGB(244, 245, 246) andView:navtion];
    if (_isAdd) {
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.backgroundColor = [UIColor clearColor];
        [saveBtn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
        saveBtn.frame = CGRectMake(_window_width-60,24+statusbarHeight,60,40);
        [saveBtn setTitle:YZMsg(@"保存") forState:0];
        [saveBtn setTitleColor:normalColors forState:0];
        saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [navtion addSubview:saveBtn];
    }
    [self.view addSubview:navtion];
}
-(void)doReturn{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navtion];
    mineL = [[UILabel alloc]initWithFrame:CGRectMake(0, 64+statusbarHeight, _window_width, 100)];
    mineL.textAlignment = NSTextAlignmentCenter;
    mineL.textColor = RGB(99, 100, 101);
    if (_isAdd) {
        mineL.text = YZMsg(@"请你选择你对主播的印象");
        selectMutableArray = [NSMutableArray array];
    }else{
        mineL.text = YZMsg(@"你收到的主播印象");
    }
    [self.view addSubview:mineL];
    JYEqualCellSpaceFlowLayout * flowLayout = [[JYEqualCellSpaceFlowLayout alloc]initWithType:AlignWithCenter betweenOfCell:10.0];

    impressCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(_window_width*0.1, 64+statusbarHeight+100, _window_width*0.8, _window_height-(64+statusbarHeight+100)) collectionViewLayout:flowLayout];
    impressCollection.delegate =self;
    impressCollection.dataSource = self;
//    impressCollection.scrollEnabled = NO;
    impressCollection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:impressCollection];
    [impressCollection registerNib:[UINib nibWithNibName:@"impressCell" bundle:nil] forCellWithReuseIdentifier:@"impressCELL"];
//    infoArray = @[@"辅导费(323)",@"豆腐干豆腐(1)",@"电饭锅电饭锅蛋糕(2323)",@"单独 v(1)",@"未(235)",@"为而为(1)"];
//    [impressCollection reloadData];
    [self getMyImpress];
}
- (void)getMyImpress{
    NSString *name;
    NSDictionary *dic;
    if (_isAdd) {
        name = @"User.GetUserLabel";
        dic = @{
                @"touid":_touid
                };
    }else{
        name = @"User.getMyLabel";
        dic = nil;
    }

    [YBToolClass postNetworkWithUrl:name andParameter:dic success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            if (_isAdd) {
                for (NSDictionary *diccc in info) {
                    if ([minstr([diccc valueForKey:@"ifcheck"]) isEqual:@"1"]) {
                        [selectMutableArray addObject:diccc];
                    }
                }
            }else{
                if ([info count] == 0) {
                    mineL.text = YZMsg(@"你暂时还没有收到主播印象");
                    mineL.font = [UIFont systemFontOfSize:13];
                }
            }
            NSArray *list = info;
            
            NSMutableArray *muArr1 = [NSMutableArray array];
            NSMutableArray *muArr2 = [NSMutableArray array];
            NSInteger secionCount;
            if (list.count%5 == 0) {
                secionCount = list.count/5;
            }else{
                secionCount = list.count/5+1;
            }
            for (int i = 0; i < secionCount; i++) {
                NSMutableArray *arr = [NSMutableArray array];
                int aaaaa;
                if ((i+1)*5>list.count) {
                    aaaaa = (int)list.count;
                }else{
                    aaaaa = (i+1)*5;
                }
                for (int j = i*5; j < aaaaa; j++) {
                    [arr addObject:list[j]];
                }
                [muArr1 addObject:arr];
            }
            for (NSArray *arr in muArr1) {
                NSMutableArray *threeArr = [NSMutableArray array];
                NSMutableArray *twoArr = [NSMutableArray array];

                for (int i = 0;i<arr.count;i++) {
                    if (arr.count>3) {
                        if (i<3) {
                            [threeArr addObject:arr[i]];
                        }else{
                            [twoArr addObject:arr[i]];
                        }
                    }else{
                        [threeArr addObjectsFromArray:arr];
                        break;
                    }
                }
                [muArr2 addObject:threeArr];
                [muArr2 addObject:twoArr];
            }
            infoArray = muArr2;

        
            [impressCollection reloadData];
        }
    } fail:^{
        
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [infoArray[section] count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return infoArray.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    impressCell *cell = (impressCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"impressCELL" forIndexPath:indexPath];
    NSDictionary *subDic = infoArray[indexPath.section][indexPath.row];
    UIColor *color = RGB_COLOR(minstr([subDic valueForKey:@"colour"]), 1);
    cell.contentL.layer.borderWidth = 1;
    cell.contentL.layer.borderColor = color.CGColor;
    cell.contentL.textColor = color;
    if (_isAdd) {
        cell.contentL.text = [NSString stringWithFormat:@"%@",minstr([subDic valueForKey:@"name"])];
        cell.contentL.font = [UIFont systemFontOfSize:15];
        BOOL isCons = NO;
        for (NSDictionary *dic in selectMutableArray) {
            if ([minstr([subDic valueForKey:@"id"]) isEqual:minstr([dic valueForKey:@"id"])]) {
                isCons = YES;
            }else{
            }
        }
        if (isCons) {
            cell.contentL.textColor = [UIColor whiteColor];
            cell.contentL.backgroundColor = color;
        }else{
            cell.contentL.textColor = color;
            cell.contentL.backgroundColor = [UIColor clearColor];
        }
    }else{
        cell.contentL.text = [NSString stringWithFormat:@"%@(%@)",minstr([subDic valueForKey:@"name"]),minstr([subDic valueForKey:@"nums"])];
        cell.contentL.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}
// 设置页边距。
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section % 2 == 0) {
        return UIEdgeInsetsMake(5, 0, 5, 0);
    }else{
        return UIEdgeInsetsMake(5, _window_width/8, 5, _window_width/8);
    }
}
// 设置item大小。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width;
    NSDictionary *subDic = infoArray[indexPath.section][indexPath.row];

    if (_isAdd) {
        width = [[YBToolClass sharedInstance] widthOfString:[NSString stringWithFormat:@"%@",minstr([subDic valueForKey:@"name"])] andFont:[UIFont systemFontOfSize:15] andHeight:30] + 20;
    }else{
        width = [[YBToolClass sharedInstance] widthOfString:[NSString stringWithFormat:@"%@(%@)",minstr([subDic valueForKey:@"name"]),minstr([subDic valueForKey:@"nums"])] andFont:[UIFont systemFontOfSize:14] andHeight:30] + 15;
    }
    return CGSizeMake(width, 30);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isAdd) {
        NSDictionary *dic = infoArray[indexPath.section][indexPath.row];
        BOOL isCons = NO;
        for (NSDictionary *dicc in selectMutableArray) {
            if ([minstr([dic valueForKey:@"id"]) isEqual:minstr([dicc valueForKey:@"id"])]) {
                isCons = YES;
            }
        }
        if (isCons) {
            [selectMutableArray removeObject:dic];
        }else{
            if (selectMutableArray.count >= 3) {
                [MBProgressHUD showError:YZMsg(@"最多选择三项")];
                return;
            }
            [selectMutableArray addObject:dic];
        }
        [collectionView reloadData];
    }
    
}
- (void)doSave{
    if (selectMutableArray.count == 0) {
        [MBProgressHUD showError:YZMsg(@"最少选择一项")];
        return;
    }
    NSString *str = @"";
    for (NSDictionary *dic in selectMutableArray) {
        str = [NSString stringWithFormat:@"%@%@,",str,minstr([dic valueForKey:@"id"])];
    }
    NSDictionary *parameter = @{
                                @"touid":_touid,
                                @"labels":str
                                };
    [YBToolClass postNetworkWithUrl:@"User.setUserLabel" andParameter:parameter success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [MBProgressHUD showError:msg];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:msg];
        }
    } fail:^{
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
