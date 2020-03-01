//
//  gameselected.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/4/13.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "gameselected.h"
#import "gamecell.h"
@interface gameselected ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *items;
    NSMutableArray *images;
    NSMutableArray *action;
}
@end
@implementation gameselected
-(instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)arrays{
    self = [super initWithFrame:frame];
    if (self) {
        self.ganearrays = arrays;
        [self setview];
    }
    return self;
}
-(void)setview{
    //1炸金花  2海盗  3转盘  4牛牛  5二八贝
//    items = @[YZMsg(@"智勇三张"),YZMsg(@"海盗船长"),YZMsg(@"幸运转盘"),@"开心牛仔",@"二八贝"];
//    images = @[@"game图标2",@"game图标3",@"game图标5",@"game图标1",@"game图标4"];
    items = [NSMutableArray array];
    images = [NSMutableArray array];
    action = [NSMutableArray array];
    
    for (int i=0; i<_ganearrays.count; i++) {
        
        int a = [_ganearrays[i] intValue];
        
        switch (a) {
            case 1:
                [items addObject:YZMsg(@"智勇三张")];
                [images addObject:@"game图标2"];
                [action addObject:@"1"];
                break;
            case 2:
                [items addObject:YZMsg(@"海盗船长")];
                [images addObject:@"game图标3"];
                [action addObject:@"2"];
                break;
            case 3:
                [items addObject:YZMsg(@"幸运转盘")];
                [images addObject:@"game图标5"];
                [action addObject:@"3"];
                break;
            case 4:
                [items addObject:YZMsg(@"开心牛仔")];
                [images addObject:@"game图标1"];
                [action addObject:@"4"];
                break;
            case 5:
                [items addObject:YZMsg(@"二八贝")];
                [images addObject:@"game图标4"];
                [action addObject:@"5"];
                break;
            default:
                break;
        }
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self.ganearrays.count <=3) {
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0,_window_height - _window_width/3 - 80,_window_width,_window_width/3 + 80) collectionViewLayout:layout];
    }
    else{
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0,_window_height - _window_width/3*2 - 80,_window_width,_window_width/3*2 + 80) collectionViewLayout:layout];
    
    }
    
    layout.itemSize = CGSizeMake((_window_width-20)/3,(_window_width-20)/3);
    _collectionview.dataSource = self;
    _collectionview.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"gamecell" bundle:nil];
    [_collectionview registerNib:nib forCellWithReuseIdentifier:@"gamecell"];
    [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    _collectionview.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionview];
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
    UITapGestureRecognizer *taps = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    
    
    UIView *hidevc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height - _window_width/3*2 - 80)];
    [hidevc addGestureRecognizer:taps];
    [self addSubview:hidevc];
    
    
}
-(void)hide{
    [self.delegate hideself];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return items.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, 60);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    gamecell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gamecell" forIndexPath:indexPath];
    cell.gameimage.image = [UIImage imageNamed:images[indexPath.row]];
    cell.gamelabel.text = items[indexPath.row];
    return cell;
}
-(UICollectionReusableView*) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _window_width, 40)];
        title.text = YZMsg(@"选择游戏");
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        [view addSubview:title];
        UILabel *imagesssss = [[UILabel alloc]initWithFrame:CGRectMake(_window_width*0.05,40,_window_width*0.9,1)];
        imagesssss.backgroundColor = [UIColor grayColor];
        [view addSubview:imagesssss];
    }
    return view;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    int a = [action[indexPath.row] intValue];
    [self.delegate gameselect:a];
    
}
@end
