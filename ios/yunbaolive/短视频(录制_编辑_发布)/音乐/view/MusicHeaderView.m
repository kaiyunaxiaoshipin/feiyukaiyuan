//
//  MusicHeaderView.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MusicHeaderView.h"

#import "MusicHeaderCell.h"

@interface MusicHeaderView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)UIView *segView;
@property(nonatomic,strong)UIButton *hotBtn;        //热门top10
@property(nonatomic,strong)UIButton *collBtn;       //收藏

@end

@implementation MusicHeaderView


- (instancetype)initWithFrame:(CGRect)frame withBlock:(MusicHeaderBlock)callBack {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.headerEvent = callBack;
        self.dataArray = [NSArray array];
        [self pullData];
        [self addSubview:self.collectionView];
        [self addSubview:self.segView];
    }
    return self;
}

-(void)pullData {
    NSString *url = [purl stringByAppendingFormat:@"?service=Music.classify_list"];

    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            _dataArray = [data valueForKey:@"info"];
            [_collectionView reloadData];
        }
    } Fail:nil];
}

#pragma mark - 点击事件
-(void)clickHotBtn {
    _hotBtn.selected = YES;
    _collBtn.selected = NO;
    if (self.segEvent) {
        self.segEvent(YZMsg(@"热门"));
    }
}
-(void)clickCollBtn {
    _hotBtn.selected = NO;
    _collBtn.selected = YES;
    if (self.segEvent) {
        self.segEvent(@"收藏");
    }
    
}
#pragma mark - CollectionView 代理
/*
 * minimumLineSpacing、minimumInteritemSpacing去设置
 -(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 return CGSizeMake(0,0);
 }
 -(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
 {
 return UIEdgeInsetsMake(0,0,0,0);
 }
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.01;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MusicHeaderCell *cell = (MusicHeaderCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"MusicHeaderCell" forIndexPath:indexPath];
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *coverStr = [NSString stringWithFormat:@"%@",[dic valueForKey:@"img_url"]];
    [cell.coverIV sd_setImageWithURL:[NSURL URLWithString:coverStr]];
    cell.titleL.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _dataArray[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@",[dic valueForKey:@"title"]];
    NSString *class_id = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
    self.headerEvent(class_id, title);
}

#pragma mark - set/get
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow.itemSize = CGSizeMake(self.width/5,self.width/5);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,10, self.width, self.width/5.5) collectionViewLayout:flow];
        [_collectionView registerNib:[UINib nibWithNibName:@"MusicHeaderCell" bundle:nil] forCellWithReuseIdentifier:@"MusicHeaderCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UIView *)segView {
    if (!_segView) {
        _segView = [[UIView alloc]initWithFrame:CGRectMake(0, _collectionView.bottom, self.width, 50)];
        _segView.backgroundColor = [UIColor whiteColor];
        //热门
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _hotBtn.frame = CGRectMake(0, 0, self.width/2, 50);
        [_hotBtn setTitle:@"热门歌曲" forState:UIControlStateNormal];
        _hotBtn.titleLabel.font = SYS_Font(15);
//        [_hotBtn setImage:[UIImage imageNamed:@"music_topten"] forState:0];
//        [_hotBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - _hotBtn.imageView.image.size.width, 0, _hotBtn.imageView.image.size.width)];
//        [_hotBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _hotBtn.titleLabel.bounds.size.width, 0, -_hotBtn.titleLabel.bounds.size.width)];
        [_hotBtn setTitleColor:RGB_COLOR(@"#c7c8c9", 1) forState:0];
        [_hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_hotBtn addTarget:self action:@selector(clickHotBtn) forControlEvents:UIControlEventTouchUpInside];
        [_segView addSubview:_hotBtn];
        _hotBtn.selected = YES;
        //我的收藏
        _collBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collBtn.frame = CGRectMake(self.width/2, 0, self.width/2, 50);
        [_collBtn setTitle:@"我的收藏" forState:UIControlStateNormal];
        _collBtn.titleLabel.font = SYS_Font(15);
        [_collBtn setTitleColor:RGB_COLOR(@"#c7c8c9", 1) forState:0];
        [_collBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [_collBtn addTarget:self action:@selector(clickCollBtn) forControlEvents:UIControlEventTouchUpInside];
        [_segView addSubview:_collBtn];
        [[YBToolClass sharedInstance] lineViewWithFrame:CGRectMake(15, _segView.height-1, _segView.width-30, 1) andColor:RGB_COLOR(@"#f4f5f6", 1) andView:_segView];
        
    }
    return _segView;
}

@end
