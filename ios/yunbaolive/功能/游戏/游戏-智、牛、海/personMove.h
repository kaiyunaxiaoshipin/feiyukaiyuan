//
//  personMove.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface personMove : UIImageView


-(instancetype)initWithImage:(UIImage *)image andRect:(CGRect)rect;
-(void)setNewFrame:(CGRect)rect;
//中途加入的
-(void)continuesetNewFrame:(CGRect)rect;
@end
