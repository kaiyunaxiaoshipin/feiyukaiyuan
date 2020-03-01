//
//  CSActionSheet.h
//  taishan
//
//  Created by e3mo on 15/7/7.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSActionSheet : UIView {
    UIView *show_view;
    
    UIButton *close_btn;
    
    UIButton *cancal_btn;
    
    BOOL isInAction;
    
    NSArray *titles_array;
}

@property (readwrite, copy) void (^close) (id sender);//结束hideView动画时
@property (readwrite, copy) void (^action) (int index, id sender);//点击选项时

/**
 iOS自带的UIActionSheet不能改变颜色，故写这个
 */

/**
 该控件会有一个黑色半透明的遮罩，点击遮罩选择框将执行hideView动画
 frame：决定遮罩的位置大小和选择框的宽度
 titles：选项文字数组
 cancal：取消按钮的文字
 normal_color：文字普通状态颜色
 highlighted_color：文字点击状态颜色，可为nil
 cellBgColor：选项框背景颜色
 cellLineColor:选择框分隔线颜色
 tips：提示文字，可换行，可为空，为空则隐藏模块
 tipsColor：提示文字颜色，可为空，为空则为默认颜色
 
 */
- (id)initWithFrame:(CGRect)frame titles:(NSArray*)titles cancal:(NSString*)cancal normal_color:(UIColor*)normalColor highlighted_color:(UIColor*)color;
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles cancal:(NSString *)cancal normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color tips:(NSString*)tips tipsColor:(UIColor*)tipsColor;
- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles cancal:(NSString *)cancal normal_color:(UIColor *)normalColor highlighted_color:(UIColor *)color tips:(NSString*)tips tipsColor:(UIColor*)tipsColor cellBgColor:(UIColor*)bgColor cellLineColor:(UIColor*)lineColor;

- (void)setCancalLabelColor:(UIColor*)color highlightedColor:(UIColor*)highColor;//设置取消按钮的颜色，highColor可为空

- (void)showView:(void (^) (int index, id sender))action close:(void (^) (id sender))close;//执行出现动画，初始化后需要执行
- (void)hideView;//执行隐藏动画
- (BOOL)viewIsInAction;//判断当前是否在动画过程中


@end
