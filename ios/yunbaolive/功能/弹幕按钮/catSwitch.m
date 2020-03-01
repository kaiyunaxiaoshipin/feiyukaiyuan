//
//  catSwitch.m
//  yunbaolive
//
//  Created by 志刚杨 on 16/7/2.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "catSwitch.h"
@implementation catSwitch
{
    @protected UIButton *selectButton;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        [selectButton setImage:[UIImage imageNamed:@"live_danmu_nor"] forState:UIControlStateNormal];
        [selectButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectButton];
        self.layer.cornerRadius = 3;
        selectButton.layer.cornerRadius = 3;
    }
    return self;
}
-(void)toggle
{
    if(!_state)
    {
        [selectButton setImage:[UIImage imageNamed:@"live_danmu_sel"] forState:UIControlStateNormal];
        _state = YES;
    }
    else
    {
        [selectButton setImage:[UIImage imageNamed:@"live_danmu_nor"] forState:UIControlStateNormal];
        _state = NO;
    }
    [self.delegate switchState:_state];
}
@end
