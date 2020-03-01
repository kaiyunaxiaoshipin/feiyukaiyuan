//
//  GrounderView.h
//  GrounderDemo
//
//  Created by 贾楠 on 16/3/8.
//  Copyright © 2016年 贾楠. All rights reserved.
//
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#import <UIKit/UIKit.h>

@interface GrounderView : UIView
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL previousIsShow;
@property (nonatomic, assign) NSInteger selfYposition;
@property (nonatomic, assign) NSInteger index;

- (void)setContent:(id)model;
//过场动画，根据长度计算时间
- (void)grounderAnimation:()model;

//固定高度求文字长度
+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height;
@end
