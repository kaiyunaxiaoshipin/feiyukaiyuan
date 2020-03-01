//
//  Loginbonus.h
//  yunbaolive
//
//  Created by Rookie on 2017/4/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstLogDelegate <NSObject>

-(void)removeView:(NSDictionary*)dic;

@end

@interface Loginbonus : UIView

@property (nonatomic,assign) id<FirstLogDelegate> delegate;
@property (nonatomic,strong) UICollectionView *firstCollection;


-(instancetype)initWithFrame:(CGRect)frame AndNSArray:(NSArray *)arrays AndDay:(NSString *)day andDayCount:(NSString *)dayCount;

@end
