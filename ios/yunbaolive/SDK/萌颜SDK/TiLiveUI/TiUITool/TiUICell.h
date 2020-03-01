//
//  TiUICell.h
//  TiLive
//
//  Created by Cat66 on 2018/5/8.
//  Copyright © 2018年 Tillurosy Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TiUICellIdentifier = @"TiUICellIdentifier";

#define TiScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define TiScreenWidth  ([[UIScreen mainScreen] bounds].size.width)
#define TiRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define STICKER_CELL_COUNTER 19 // 贴纸特效数量
#define FILTER_CELL_COUNTER 37 // 滤镜特效数量
#define ROCK_CELL_COUNTER 10 // Rock特效数量
#define DISTORTION_CELL_COUNTER 4 // 哈哈镜特效数量
#define GREEN_SCREEN_CELL_COUNTER 2 // 绿幕特效数量

@interface TiUICell : UICollectionViewCell

@property(nonatomic, strong) UIImageView *bgView;

@property(nonatomic, strong) UILabel *label;

// 初始化
- (instancetype)initWithFrame:(CGRect)frame;

// Rock特效
- (void)setRockUICellByIndex:(NSInteger)index;

// 滤镜特效
- (void)setFilterUICellByIndex:(NSInteger)index;

// 哈哈镜特效
- (void)setDistortionUICellByIndex:(NSInteger)index;

// 绿幕特效
- (void)setGreenScreenUICellByIndex:(NSInteger)index;

// 切换cell时特效更改
- (void)changeCellEffect:(BOOL)isChange;

@end
