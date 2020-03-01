//
//  liwuview.h
//  yunbaolive
//
//  Created by 王敏欣 on 2016/11/4.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "liwuModel.h"
@protocol sendGiftDelegate <NSObject>
-(void)sendGift:(NSMutableArray *)myDic andPlayDic:(NSDictionary *)playDic andData:(NSArray *)datas andLianFa:(NSString *)lianfa;
-(void)pushCoinV;
-(void)zhezhaoBTNdelegate;
-(void)luckyBtnClickdelegate;

@end


@interface liwuview : UIView

@property(nonatomic,weak)id<sendGiftDelegate>giftDelegate;

@property (nonatomic , strong) UIPageControl *pageControl;

@property(nonatomic,strong)NSDictionary *pldic;
@property(nonatomic,strong)NSMutableArray *mydic;

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *buttomView;
@property(nonatomic,strong)NSArray *allArray;
@property(nonatomic,strong)NSArray *models;
@property(nonatomic,strong)UILabel *chongzhi;
@property(nonatomic,strong)liwuModel *selectModel;
@property(nonatomic,strong)UIButton *jumpRecharge;
@property(nonatomic,strong)UIButton *continuBTN;
@property(nonatomic,strong)UIButton *push;
@property (nonatomic,strong) UIView *giftCountView;
@property (nonatomic,strong)NSString *guradType;
//重置礼物列表下方的钻石数量
-(void)chongzhiV:(NSString *)coins;
-(instancetype)initWithDic:(NSDictionary *)playdic andMyDic:(NSMutableArray *)myDic;
-(void)reloadPushState;
-(void)setBottomAdd;//如果是iohoneX底部空白补全
- (void)hideGiftCountView;

@end
