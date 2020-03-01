//
//  beautifulview.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/26.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "beautifulview.h"

@implementation beautifulview

-(instancetype)initWithFrame:(CGRect)frame andhide:(minxinblock)hide andslider:(minxinblock)slider andtype:(minxinblock)type{
    self = [super initWithFrame:frame];
    if (self) {
        
           self.hideblocks = hide;
           self.sliderlocks = slider;
           self.typeblocks = type;
        
            btnShow = [[UIButton alloc] initWithFrame:self.bounds];
            [btnShow addTarget:self action:@selector(hideshowlist) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btnShow];
        
        
            meiYanTuoDong = [[UISlider alloc] initWithFrame:CGRectMake(20, 45 *4 , _window_width-40, 40)];
            [meiYanTuoDong addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            meiYanTuoDong.maximumValue = 5;
            meiYanTuoDong.minimumValue = 1;
            meiyanSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, _window_height/2, _window_width, _window_height/2)];
            
            
            meiyanbtn1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, _window_width-40, 40)];
            [meiyanbtn1 setTitle:YZMsg(@"原始美白") forState:UIControlStateNormal];
            [meiyanbtn1 setTitle:YZMsg(@"原始美白(√)") forState:UIControlStateSelected];
            
            
            meiyanbtn2 = [[UIButton alloc] initWithFrame:CGRectMake(20, 45, _window_width-40, 40)];
            [meiyanbtn2 setTitle:YZMsg(@"美颜") forState:UIControlStateNormal];
            [meiyanbtn2 setTitle:YZMsg(@"美颜(√)") forState:UIControlStateSelected];
            
            
            meiyanbtn3 = [[UIButton alloc] initWithFrame:CGRectMake(20, 45 *2 , _window_width-40, 40)];
            [meiyanbtn3 setTitle:YZMsg(@"白皙") forState:UIControlStateNormal];
            [meiyanbtn3 setTitle:YZMsg(@"白皙(√)") forState:UIControlStateSelected];
            
            
            meiyanbtn4 = [[UIButton alloc] initWithFrame:CGRectMake(20, 45 *3 , _window_width-40, 40)];
            [meiyanbtn4 setTitle:YZMsg(@"美颜+") forState:UIControlStateNormal];
            [meiyanbtn4 setTitle:YZMsg(@"美颜+(√)") forState:UIControlStateSelected];
            
            
            meiyanbtn5 = [[UIButton alloc] initWithFrame:CGRectMake(20, 45 *5 , _window_width-40, 40)];
            [meiyanbtn5 setTitle:YZMsg(@"不使用美颜") forState:UIControlStateNormal];
            [meiyanbtn5 setTitle:YZMsg(@"不使用美颜+(√)") forState:UIControlStateSelected];
            
            
            [meiyanbtn1 setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
            meiyanbtn1.layer.cornerRadius = 20;
            
            [meiyanbtn2 setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
            meiyanbtn2.layer.cornerRadius = 20;
        
            [meiyanbtn3 setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
            meiyanbtn3.layer.cornerRadius = 20;
            
            [meiyanbtn4 setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
            meiyanbtn4.layer.cornerRadius = 20;
            
            [meiyanbtn5 setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:133.0/255.0 blue:255.0/255.0 alpha:1]];
            meiyanbtn5.layer.cornerRadius = 20;
        
        
            [meiyanSelectView addSubview:meiyanbtn1];
            [meiyanSelectView addSubview:meiyanbtn2];
            [meiyanSelectView addSubview:meiyanbtn3];
            [meiyanSelectView addSubview:meiyanbtn4];
            [meiyanSelectView addSubview:meiyanbtn5];
            [meiyanSelectView addSubview:meiYanTuoDong];
            [meiyanbtn1 addTarget:self action:@selector(selectMeiYan1) forControlEvents:UIControlEventTouchUpInside];
            [meiyanbtn2 addTarget:self action:@selector(selectMeiYan2) forControlEvents:UIControlEventTouchUpInside];;
            [meiyanbtn3 addTarget:self action:@selector(selectMeiYan3) forControlEvents:UIControlEventTouchUpInside];;
            [meiyanbtn4 addTarget:self action:@selector(selectMeiYan4) forControlEvents:UIControlEventTouchUpInside];;
            [meiyanbtn5 addTarget:self action:@selector(selectMeiYan5) forControlEvents:UIControlEventTouchUpInside];
            [btnShow addSubview:meiyanSelectView];
            meiyanbtn4.selected = YES;
        
    }
    return self;
}
-(void)hideshowlist{
    self.hideblocks(0);
}
-(void)sliderValueChanged:(UISlider *)slider
{
    float a = slider.value;
    NSString *as = [NSString stringWithFormat:@"%.1f",a];
    self.sliderlocks(as);
}
-(void)selectMeiYan1{
    meiyanbtn1.selected = YES;
    meiyanbtn2.selected = NO;
    meiyanbtn3.selected = NO;
    meiyanbtn4.selected = NO;
    meiyanbtn5.selected = NO;
    self.typeblocks(@"0");
    [meiYanTuoDong setValue:1];
    meiYanTuoDong.hidden = NO;
}
-(void)selectMeiYan2{
    meiyanbtn1.selected = NO;
    meiyanbtn2.selected = YES;
    meiyanbtn3.selected = NO;
    meiyanbtn4.selected = NO;
    meiyanbtn5.selected = NO;
    self.typeblocks(@"1");
    [meiYanTuoDong setValue:1];
    meiYanTuoDong.hidden = NO;
}
-(void)selectMeiYan3{
    meiyanbtn1.selected = NO;
    meiyanbtn2.selected = NO;
    meiyanbtn3.selected = YES;
    meiyanbtn4.selected = NO;
    meiyanbtn5.selected = NO;
    self.typeblocks(@"2");
    [meiYanTuoDong setValue:1];
    meiYanTuoDong.hidden = YES;
}
-(void)selectMeiYan4{
    meiyanbtn1.selected = NO;
    meiyanbtn2.selected = NO;
    meiyanbtn3.selected = NO;
    meiyanbtn4.selected = YES;
    meiyanbtn5.selected = NO;
    self.typeblocks(@"3");
    [meiYanTuoDong setValue:1];
    meiYanTuoDong.hidden = NO;
}
-(void)selectMeiYan5{
    meiyanbtn1.selected = NO;
    meiyanbtn2.selected = NO;
    meiyanbtn3.selected = NO;
    meiyanbtn4.selected = NO;
    meiyanbtn5.selected = YES;
    self.typeblocks(@"4");
    [meiYanTuoDong setValue:1];
    meiYanTuoDong.hidden = YES;
}
@end
