//
//  QStyledPolylineView.h
//  QMapKit
//
//  Created by fan on 2016/12/3.
//  Copyright © 2016年 Tencent. All rights reserved.
//

#import "QPolylineView.h"

@interface QStyledPolylineView : QPolylineView


/*!
 *  @brief  线的颜色
 */
@property (nonatomic, strong) UIColor *strokeColor;
/*!
 *  @brief  笔触宽度,默认是6。单位：逻辑像素
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  箭头的样式图片，默认为nil不绘制，请尽量传入nxn的图片
 */
@property (nonatomic, strong) UIImage*  symbolImage;
/**
 *  箭头的间隔，单位：线宽的倍率
 */
@property (nonatomic, assign) CGFloat   symbolGap;

/**
 *  边线的宽度，如果为0则无边线。单位：逻辑像素
 */
@property (nonatomic, assign) CGFloat   borderWidth;

/*!
 *  @brief  边线颜色
 */
@property (nonatomic, strong) UIColor *borderColor;


@end
