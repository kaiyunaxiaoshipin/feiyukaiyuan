//
//  animationBtnV.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/10.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface animationBtnV : UIView

@property(nonatomic,strong)UIButton *frontButton;
@property(nonatomic,strong)UIImageView *bottomImage;
@property(nonatomic,strong)NSTimer *timer;

-(void)setAnimation;
-(void)stopAnimation;
@end
