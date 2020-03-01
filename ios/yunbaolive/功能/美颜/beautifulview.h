//
//  beautifulview.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/26.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^minxinblock)(NSString *type);

@interface beautifulview : UIView
{
    UISlider *meiYanTuoDong;
    UIView *meiyanSelectView;
    UIButton *meiyanbtn1;
    UIButton *meiyanbtn2;
    UIButton *meiyanbtn3;
    UIButton *meiyanbtn4;
    UIButton *meiyanbtn5;
    UIButton *btnShow;
}

@property(nonatomic,copy)minxinblock hideblocks;
@property(nonatomic,copy)minxinblock sliderlocks;
@property(nonatomic,copy)minxinblock typeblocks;

-(instancetype)initWithFrame:(CGRect)frame andhide:(minxinblock)hide andslider:(minxinblock)slider andtype:(minxinblock)type;

@end
