//
//  TiStickerCell.h
//  TiSDK
//
//  Created by Cat66 on 18/5/15.
//  Copyright © 2018年 Tillusory Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *TiStickerCellIdentifier = @"TiStickerCellIdentifier";

@class TiSticker;

@interface TiIndicatorView : UIView

- (id)initWithTintColor:(UIColor *)tintColor size:(CGFloat)size;

@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic) CGFloat size;

@property(nonatomic, readonly) BOOL animating;

- (void)startAnimating;

- (void)stopAnimating;

@end

@interface TiStickerCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setSticker:(TiSticker *)sticker index:(NSInteger)index;

/**
是否隐藏背景框
 */
- (void)hideBackView:(BOOL)hidden;

/**
 开启动画
 */
- (void)startDownload;


@end
