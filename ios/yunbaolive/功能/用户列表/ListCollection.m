#import "ListCollection.h"
#import "listCell.h"
#import "listModel.h"
#import "Config.h"
@interface ListCollection ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    
}
@end
@implementation ListCollection
-(void)initarrayWithoutReload{
    self.listArray = [NSMutableArray array];
}
-(void)listArrayRemove{
    [self.listArray removeAllObjects];
}
-(void)changeFrame:(CGRect)rect{
    _listCollectionview.frame = rect;
}
-(void)initArray{
    self.listArray = nil;
    self.listArray = [NSMutableArray array];
    [_listCollectionview reloadData];
}
-(void)listarrayAddArray:(NSArray *)array{
    [self.listArray addObjectsFromArray:array];
    [self quickSort1:self.listArray];
    [_listCollectionview reloadData];
}
-(void)userAccess:(NSDictionary *)dic{
    NSString *ID = [[dic valueForKey:@"ct"] valueForKey:@"id"];
    [self.listArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSDictionary *dic in self.listArray) {
                int a = [[dic valueForKey:@"id"] intValue];
                int bsss = [ID intValue];
                if ([[dic valueForKey:@"id"] isEqual:ID] || a == bsss) {
                    [self.listArray removeObject:dic];
                    break;
                }
            }
    }];
    NSDictionary *subdic = [dic valueForKey:@"ct"];
    [self.listArray addObject:subdic];
    [self quickSort1:self.listArray];
    [_listCollectionview reloadData];
}
-(void)userLive:(NSDictionary *)dic{
    NSDictionary *SUBdIC =[dic valueForKey:@"ct"];
    NSString *ID = [SUBdIC valueForKey:@"id"];
    [self.listArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        for (NSDictionary *dic in self.listArray) {
            if ([[dic valueForKey:@"id"] isEqual:ID]) {
                [self.listArray removeObject:dic];
                [_listCollectionview reloadData];
                return ;
            }
        }
    }];
}
//懒加载
-(NSArray *)listModelArray{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in self.listArray) {
        listModel *model = [listModel modelWithDic:dic];
        [array addObject:model];
    }
    _listModelArray = array;
    return _listModelArray;
}
//定时刷新用户列表
-(void)listReloadNoew{
    NSDictionary *userlist = @{
                               @"liveuid":IDs,
                               @"stream":stream
                               };
    [YBToolClass postNetworkWithUrl:@"Live.getUserLists" andParameter:userlist success:^(int code, id  _Nonnull info, NSString * _Nonnull msg) {
        if (code == 0) {
            NSArray *infos = [info firstObject];
            NSArray *list = [infos valueForKey:@"userlist"];
            if ([list isEqual:[NSNull null]]) {
                
                return ;
            }
            [self listArrayRemove];
            for (int i =0; i<list.count; i++) {
                NSDictionary *dic = [list objectAtIndex:i];
                [self.listArray addObject:dic];
            }
            [self quickSort1:self.listArray];
            NSLog(@"%ld------%@",self.listArray.count,[info valueForKey:@"nums"]);
            [_listCollectionview reloadData];

        }
    } fail:^{
        
    }];
}
-(instancetype)initWithListArray:(NSMutableArray *)list andID:(NSString *)ID andStream:(NSString *)streams{
    self = [super init];
    if (self) {
        IDs = [NSString stringWithFormat:@"%@",ID];
        stream = [NSString stringWithFormat:@"%@",streams];
        userCount =list.count;
        self.listArray = [NSMutableArray array];
        _listModelArray = [NSMutableArray array];
        
        self.listArray = [NSMutableArray arrayWithArray:list];
        UICollectionViewFlowLayout *flowlayoutt = [[UICollectionViewFlowLayout alloc]init];
        flowlayoutt.itemSize = CGSizeMake(40,40);
        flowlayoutt.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _listCollectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,_window_width- 130,40) collectionViewLayout:flowlayoutt];
        _listCollectionview.showsHorizontalScrollIndicator = NO;
        _listCollectionview.delegate = self;
        _listCollectionview.dataSource = self;
        [_listCollectionview registerClass:[listCell class] forCellWithReuseIdentifier:@"list"];
        _listCollectionview.backgroundColor = [UIColor clearColor];
        [self addSubview:_listCollectionview];
        
    }
    return self;
}
//用户列表
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listModelArray.count;
}
//定义section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    listCell *cell = (listCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"list" forIndexPath:indexPath];
    listModel *model = self.listModelArray[indexPath.row];
    cell.model = model;
    cell.backgroundColor = [UIColor clearColor];
//    if (indexPath.row == 0) {
//        if ([model.contribution intValue]>0) {
//            cell.kuang.image = [UIImage imageNamed:[NSString stringWithFormat:@"userlist_no1"]];
//        }else{
//            cell.kuang.image = [UIImage new];
//        }
//    }
    if (indexPath.row < 3 && [model.contribution intValue]>0) {
        
        cell.kuang.image = [UIImage imageNamed:[NSString stringWithFormat:@"userlist_no%ld",indexPath.row+1]];
    }else{
        cell.kuang.image = [UIImage new];
    }

    return cell;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    listModel *model = [self.listModelArray objectAtIndex:indexPath.row];
    NSString *ID = model.userID;
    NSDictionary *subdic  = [NSDictionary dictionaryWithObjects:@[ID,model.user_nicename] forKeys:@[@"id",@"name"]];
    [self.delegate GetInformessage:subdic];
}
//每个cell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(40,40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,5,0,5);
}
-(void)quickSort1:(NSMutableArray *)userlist
{
//    for (int i = 0; i<userlist.count; i++)
//    {
//        for (int j=i+1; j<[userlist count]; j++)
//        {
//            int aac = [[[userlist objectAtIndex:i] valueForKey:@"level"] intValue];
//            int bbc = [[[userlist objectAtIndex:j] valueForKey:@"level"] intValue];
//            NSDictionary *da = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:i]];
//            NSDictionary *db = [NSDictionary dictionaryWithDictionary:[userlist objectAtIndex:j]];
//            if (aac >= bbc)
//            {
//                [userlist replaceObjectAtIndex:i withObject:da];
//                [userlist replaceObjectAtIndex:j withObject:db];
//            }else{
//                [userlist replaceObjectAtIndex:j withObject:da];
//                [userlist replaceObjectAtIndex:i withObject:db];
//            }
//        }
//    }
}
@end
