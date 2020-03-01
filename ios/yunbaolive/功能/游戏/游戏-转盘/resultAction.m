//
//  resultAction.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/4/8.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "resultAction.h"

@interface resultAction ()
{
      CADisplayLink    *_link;     // 定时器
      UIImageView *backimage;
    UIImageView *actionimage;
}
@end

@implementation resultAction

-(instancetype)init{
    
    self = [super init];
    if (self) {
        backimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_width)];
        backimage.image = [UIImage imageNamed:@"sel"];
        backimage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:backimage];
        actionimage = [[UIImageView alloc]initWithFrame:CGRectMake((_window_width-_window_width/2)/2,_window_width/4,_window_width/2, _window_width/2)];
        actionimage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:actionimage];
    }
    return self;
}
-(void)setimage:(NSString *)imagename{
    [actionimage setImage:[UIImage imageNamed:imagename]];
}
-(void)startAction{
    if (nil == _link) {
        // 实例化计时器
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(keepRatate)];
        // 添加到当前运行循环中
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
-(void)keepRatate{
    backimage.transform = CGAffineTransformRotate(backimage.transform, M_PI_4 * 0.01);
}
-(void)stop{
    [_link invalidate];
    _link = nil;
}
-(void)dealloc{
    [_link invalidate];
    _link = nil;
}
@end
