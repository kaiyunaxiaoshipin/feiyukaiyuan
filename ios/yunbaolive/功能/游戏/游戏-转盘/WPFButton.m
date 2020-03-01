//
//  WPFButton.m
//  01-幸运转盘第二遍
//
//  Created by 王鹏飞 on 16/1/13.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//
#import "WPFButton.h"
@implementation WPFButton
// 取消高亮状态灰一下的效果
- (void)setHighlighted:(BOOL)highlighted {
    
    
    return;
}
// 设置按钮内部图片的大小
- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat y = 0;
    // 判断按钮的类型改变按钮图片大小
        width = 35;
        height = 35;
        if (IS_IPHONE_6P) {
            y = -20;
        }else if (IS_IPHONE_6){
            y = -10;
        }else  {
            y = 10;
        }
    // ********************************
    CGFloat x = (contentRect.size.width - width) * 0.5;
    x=20;
    return CGRectMake(x, y, width, height);
}
@end
