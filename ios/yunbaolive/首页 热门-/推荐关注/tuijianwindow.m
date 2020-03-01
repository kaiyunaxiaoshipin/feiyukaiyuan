//
//  tuijianwindow.m
//  iphoneLive
//
//  Created by 王敏欣 on 2017/5/17.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "tuijianwindow.h"
#import "UIImageView+WebCache.h"
#import "tuijiancell.h"
#import "AppDelegate.h"
#import "MyHeaderViewView.h"
#import "myfootview.h"
@interface tuijianwindow ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton *btn;
}
@property(nonatomic,strong)NSMutableArray *allArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSString *touids;
@end
@implementation tuijianwindow
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _touids = [NSString string];
        self.allArray = [NSMutableArray array];
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake(_window_width/3, _window_width/3);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, _window_width, _window_height) collectionViewLayout:flow];
        [self.collectionView registerNib:[UINib nibWithNibName:@"tuijiancell" bundle:nil] forCellWithReuseIdentifier:@"tuijiancell"];
       [self.collectionView registerClass:[MyHeaderViewView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview"];
        [flow setFooterReferenceSize:CGSizeMake(_window_width,90)];
        [flow setHeaderReferenceSize:CGSizeMake(_window_width,70)];
        self.collectionView.delegate =self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self pullInternetforNew];
        
        self.backgroundColor = [UIColor whiteColor];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)pullInternetforNew{
    [YBToolClass postNetworkWithUrl:@"Home.getRecommend" andParameter:nil success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            self.allArray = [NSMutableArray arrayWithArray:info];
            [self.collectionView reloadData];
            
            if (self.allArray.count == 0) {
                [self.delegate jump];
            }
            else{
                btn.hidden = NO;
            }

        }
    } fail:^{
        
    }];
    
}
#pragma mark - Table view data source
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_window_width/3,_window_width/3 + 10);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    tuijiancell *cell = (tuijiancell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"tuijiancell" forIndexPath:indexPath];
    
    NSDictionary *subdic = self.allArray[indexPath.row];
     //处理null
    if ([[subdic valueForKey:@"avatar"] isEqual:[NSNull null]]) {
        subdic = @{
                   @"avatar":@" ",
                   @"id":@"1",
                   @"isattention":@"0",
                   @"user_nicename":@" "
                   };
      }
    
    NSString *path = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"avatar"]];
    NSString *isattention = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"isattention"]];
    
    if ([isattention isEqual:@"0"]) {
        [cell.duihao setImage:[UIImage imageNamed:@"关注对号"]];
    }
    else{
         [cell.duihao setImage:[UIImage imageNamed:@"未关注对号"]];
    }
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:path]];
    cell.icon.layer.masksToBounds = YES;
    cell.icon.layer.cornerRadius = _window_width/3*0.6 * 0.5;
    cell.name.text = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"user_nicename"]];
    cell.dis.text = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"fans"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];

    NSMutableDictionary *subdic = [NSMutableDictionary dictionaryWithDictionary:self.allArray[indexPath.row]];
    NSString *isattention = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"isattention"]];
    if ([isattention isEqual:@"1"]) {
         isattention = @"0";
    }
    else{
        isattention = @"1";
    }
    [self.allArray removeObject:subdic];
    
    [subdic setObject:isattention forKey:@"isattention"];
    [self.allArray insertObject:subdic atIndex:indexPath.row];
    [self.collectionView reloadData];
    
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableView = nil;
  if (kind == UICollectionElementKindSectionHeader) {
    //定制头部视图的内容
    MyHeaderViewView * headerV =(MyHeaderViewView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
      headerV.frame = CGRectMake(0, 0, _window_width, 64);
      
      UIView *vcs = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width,64)];
      vcs.backgroundColor = navigationBGColor;
      [headerV addSubview:vcs];
      
      UIButton *btnss = [UIButton buttonWithType:UIButtonTypeCustom];
      [btnss setTitle:YZMsg(@"跳过") forState:UIControlStateNormal];
      btnss.titleLabel.font = [UIFont systemFontOfSize:14];
      [btnss setTitleColor:RGB(102, 101, 102) forState:UIControlStateNormal];
      btnss.frame = CGRectMake(_window_width - 60,26,50,30);
      [btnss addTarget:self action:@selector(dojump) forControlEvents:UIControlEventTouchUpInside];
      [btnss setBackgroundColor:RGB(222, 222, 222)];
      btnss.layer.masksToBounds = YES;
      btnss.layer.cornerRadius = 8;
      
      
      UIButton *btnssbig = [UIButton buttonWithType:UIButtonTypeCustom];
      btnssbig.frame = CGRectMake(_window_width - 70,0,64,70);
      [btnssbig addTarget:self action:@selector(dojump) forControlEvents:UIControlEventTouchUpInside];
      
      [vcs addSubview:btnss];
       [vcs addSubview:btnssbig];
      UILabel *labls = [[UILabel alloc]initWithFrame:CGRectMake(0,20, _window_width,44)];
      labls.textAlignment = NSTextAlignmentCenter;
      labls.textColor = [UIColor blackColor];
      labls.font = fontMT(18);
      labls.text = YZMsg(@"为你推荐");
      [vcs addSubview:labls];
      reusableView = headerV;
    }
  if (kind == UICollectionElementKindSectionFooter){
      UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footview" forIndexPath:indexPath];
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:YZMsg(@"点击进入") forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(_window_width*0.1,40,_window_width*0.8,40);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 20;
        btn.backgroundColor = normalColors;
       [btn addTarget:self action:@selector(doatten:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:btn];
        btn.hidden = YES;
        reusableView = footerView;
    }
    return reusableView;
}
-(void)doatten:(UIButton *)attenBtn{
    attenBtn.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        attenBtn.userInteractionEnabled = YES;
    });
    for (int i=0; i<self.allArray.count; i++) {
        NSDictionary *subdic = self.allArray[i];
        NSString *isattention = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"isattention"]];
        if ([isattention isEqual:@"0"]) {
            if (i == self.allArray.count - 1) {
                _touids = [_touids stringByAppendingFormat:@"%@",[subdic valueForKey:@"id"]];
            }else{
                _touids = [_touids stringByAppendingFormat:@"%@,",[subdic valueForKey:@"id"]];
            }
        }
    }
    [YBToolClass postNetworkWithUrl:@"Home.attentRecommend" andParameter:@{@"touid":_touids} success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            [self.delegate jump];
        }
    } fail:^{
        
    }];
}
-(void)dojump{
    [self.delegate jump];
}
@end
