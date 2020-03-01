//
//  ListCollection.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/1/10.
//  Copyright © 2017年 cat. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol listDelegate <NSObject>

-(void)GetInformessage:(NSDictionary *)subdic;

@end
@interface ListCollection : UIView
{
    long long userCount;//用户数量
    NSString *IDs;
    NSString *stream;
}
@property(nonatomic,strong)UICollectionView *listCollectionview;
@property(nonatomic,weak)id<listDelegate>delegate;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSMutableArray *listModelArray;
@property(nonatomic,strong)NSMutableArray *listArray;
-(void)changeFrame:(CGRect)rect;
-(instancetype)initWithListArray:(NSMutableArray *)list andID:(NSString *)ID andStream:(NSString *)streams;
-(void)initArray;
-(void)initarrayWithoutReload;
-(void)userAccess:(NSDictionary *)dic;
-(void)userLive:(NSDictionary *)dic;
-(void)listArrayRemove;
-(void)listarrayAddArray:(NSArray *)array;
-(void)listReloadNoew;
@end
