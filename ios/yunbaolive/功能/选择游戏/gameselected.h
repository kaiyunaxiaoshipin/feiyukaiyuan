//
//  gameselected.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/4/13.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol gameselected <NSObject>

-(void)gameselect:(int)gameselectaction;
-(void)hideself;

@end


@interface gameselected : UIView

@property (nonatomic,weak) id<gameselected> delegate;
@property (nonatomic,strong) UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *ganearrays;
-(instancetype)initWithFrame:(CGRect)frame andArray:(NSArray *)arrays;
@end
