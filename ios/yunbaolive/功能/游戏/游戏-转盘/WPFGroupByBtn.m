//
//  WPFGroupByBtn.m
//  02-网易彩票
//
//  Created by 王鹏飞 on 16/1/15.
//  Copyright © 2016年 王鹏飞. All rights reserved.
//

#import "WPFGroupByBtn.h"



@implementation WPFGroupByBtn

// 只进行一次，比layoutSubviews 方法 早运行
-(void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
//#warning 如果在这里改变子控件布局，那么在layoutSubviews 方法里会打乱重新布局，因此无效
    
    // M_1_PI == 1 / PI
   // self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
    
}

// 手动调整文字和图片的位置，布局子控件，进行多次
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    NSLog(@"layoutSubviews");
    
    // 改变文字和图片的位置
 //   self.titleLabel.x = 0;
  //  self.imageView.x = self.titleLabel.width + 10;
    
    
    
    
}

@end
