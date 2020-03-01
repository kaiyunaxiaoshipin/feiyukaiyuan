//
//  RKLampView.m
//  iphoneLive
//
//  Created by YunBao on 2018/8/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "RKLampView.h"
#import <QuartzCore/QuartzCore.h>
@interface RKLampView()
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *label2;
@property(nonatomic,strong) UIView *bgView;

@end
@implementation RKLampView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI {
    // 背景视图
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.clipsToBounds = YES;
    
    // 标签视图1
    _label = [[UILabel alloc] init];
    [_bgView addSubview:_label];
    _label.frame = CGRectMake(0.0, 0.0, self.frame.size.width+20, self.frame.size.height);
    _label.textColor = [UIColor whiteColor];
    _label.font = SYS_Font(15);
    
    // 标签视图2
    _label2 = [[UILabel alloc] init];
    [_bgView addSubview:_label2];
    _label2.frame = CGRectMake(_label.frame.size.width+20, 0.0, self.frame.size.width+20, self.frame.size.height);
    _label2.textColor = _label.textColor;
    _label2.font = _label.font;
    
}

-(void)startLamp {
    [self removeAllSubViews];
    [self setUI];
    
    _label.text = _contentStr;
    _label2.text = _label.text;
    
    CGSize sizee = [PublicObj sizeWithString:_label.text andFont:SYS_Font(15)];
    CGFloat withdd = MAX(self.frame.size.width,sizee.width)+20;
    _label.frame = CGRectMake(0.0, 0.0, withdd, self.frame.size.height);
    _label2.frame = CGRectMake(withdd, 0.0, withdd, self.frame.size.height);
    // 动画
    [UIView beginAnimations:@"testAnimation" context:NULL];
    [UIView setAnimationDuration:3.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:999999];
    
    CGRect frame = _label.frame;
    frame.origin.x = -withdd;
    _label.frame = frame;
    
    CGRect frame2 = _label2.frame;
    frame2.origin.x = 0.0;
    _label2.frame = frame2;
    [UIView commitAnimations];
}


@end
