//
//  CSActionPicker.h
//  NotePad
//
//  Created by e3mo on 16/8/5.
//  Copyright © 2016年 e3mo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSActionPicker : UIView {
    UIView *show_view;
    
    UIButton *close_btn;
    
    BOOL isInAction;
    
    NSArray *titles_array;
}

@property (readwrite, copy) void (^close) (id sender);//结束hideView动画时
@property (readwrite, copy) void (^action) (int index, id sender);//点击选项时

/**
 从上往下的文字选择框，无取消按钮，点击周围取消，一般用于Navigation下方，如果条目过多会会变为scrollview可滑动
 */

/**
 该控件会有一个黑色半透明的遮罩，点击遮罩选择框将执行hideView动画
 frame：决定遮罩的位置大小和选择框的宽度
 titles：选项文字数组
 normal_color：文字普通状态颜色
 highlighted_color：文字点击状态颜色，可为nil
 cellBgColor：选项框背景颜色
 cellLineColor:选择框分隔线颜色
 */
- (id)initWithFrame:(CGRect)frame titles:(NSArray*)titles normal_color:(UIColor*)normalColor highlighted_color:(UIColor*)color;
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color cellBgColor:(UIColor*)bgColor cellLineColor:(UIColor*)lineColor;

- (void)showView:(void (^) (int index, id sender))action close:(void (^) (id sender))close;//执行出现动画，初始化后需要执行
- (void)hideView;//执行隐藏动画
- (BOOL)viewIsInAction;//判断当前是否在动画过程中

@end
