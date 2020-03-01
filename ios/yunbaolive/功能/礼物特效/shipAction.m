
#import "shipAction.h"

#import "UIImageView+WebCache.h"
#import "SDWebImage/UIButton+WebCache.h"


@interface shipAction ()

{
    
    UIImageView *imageVV;
    UIImageView *imageV;
    UIView *myView;
    UIImageView *imageVVV;
    NSTimer *timer;
    
    UIView *shipView;
    
}


@end


@implementation shipAction


-(instancetype)initWithName:(NSString *)name and:(NSString *)icon{

    self = [super init];
    if (self) {
        
      
        
        //船
        
        imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yacht_hull.png"]];
        
        imageV.userInteractionEnabled = YES;

        
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        
        imageV.frame = CGRectMake(50,30,_window_width/1.5,_window_width);
        
        
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        
        
        imageV.userInteractionEnabled = YES;
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = normalColors.CGColor;
        btn.layer.borderWidth = 1;
        [btn sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal];
        btn.frame = CGRectMake(_window_width*0.4,120, 40, 40);
        btn.layer.cornerRadius = 20.0;
        [imageV addSubview:btn];
        [btn addTarget:self action:@selector(Upmessage) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc]init];
        
        label.text = [NSString stringWithFormat:@"%@赠送了豪华游轮",name];
        label.textColor = normalColors;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.frame = CGRectMake(0,160,_window_width,20);
        [imageV addSubview:label];
        
        [imageV addSubview:btn];

        //海洋
        imageVV = [[UIImageView alloc]initWithFrame:CGRectMake(-_window_width,0,_window_width*2,_window_height*0.6)];
        imageVV.contentMode = UIViewContentModeScaleAspectFit;
        imageVV.image = [UIImage imageNamed:@"yacht_water_one.png"];
        
        imageVVV = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,_window_width*2,_window_height*0.6)];
        imageVVV.contentMode = UIViewContentModeScaleAspectFit;
        imageVVV.image = [UIImage imageNamed:@"yacht_water_one.png"];
        
        myView = [[UIView alloc]initWithFrame:CGRectMake(0,_window_height*0.4,_window_width,_window_height*0.6)];
        
        myView.userInteractionEnabled = YES;
        
        imageVV.userInteractionEnabled = YES;
        
        imageVVV.userInteractionEnabled = YES;
        
   
        
        [myView addSubview:imageVVV];
        
        [myView addSubview:imageVV];
        
        [myView addSubview:imageV];
        
        [self addSubview:myView];
        
        [self timeII];
        
        [self donghua];
        
        
    }
    
    
    return self;
    
}
-(void)donghua{
    
    
    CGFloat yy =80;
    
    
    CGFloat w = _window_width/1.5;
    
    CGFloat ww = _window_width;
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.duration = 9.0;
    
    NSValue *value14 = [NSValue valueWithCGRect:CGRectMake(50,0,ww,ww)];

    NSValue *value15 = [NSValue valueWithCGRect:CGRectMake(50,10,ww,ww)];

    
    NSValue *value1 = [NSValue valueWithCGRect:CGRectMake(50,30,w,w)];
    
    NSValue *value2 = [NSValue valueWithCGRect:CGRectMake(_window_width*0.3,yy,ww,ww)];
    
   // NSValue *value5 = [NSValue valueWithCGRect:CGRectMake(_window_width*0.3,yy,w, w)];
    
    NSValue *value6 = [NSValue valueWithCGRect:CGRectMake(_window_width*0.5,yy+30,w, w)];
    
    NSValue *value12 = [NSValue valueWithCGRect:CGRectMake(_window_width*0.5,yy+10,w, w)];

    NSValue *value7 = [NSValue valueWithCGRect:CGRectMake(_window_width*0.5,yy,w, w)];
    
    NSValue *value9 = [NSValue valueWithCGRect:CGRectMake(_window_width*0.8,yy,w, w)];
    
    NSValue *value10 = [NSValue valueWithCGRect:CGRectMake(_window_width*1.2,yy,w, w)];
    
    NSValue *value13 = [NSValue valueWithCGRect:CGRectMake(_window_width*1.5,yy,w, w)];

    NSValue *value11 = [NSValue valueWithCGRect:CGRectMake(_window_width*2,yy,w, w)];
   
    animation.values = @[value14,value15,value1,value2,value6,value12,value7,value9,value10,value11,value13];
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    [imageV.layer addAnimation:animation forKey:nil];
    
    
    
}

-(void)timeII{
    [UIView animateWithDuration:10.0 animations:^{
        imageVVV.frame = CGRectMake(-_window_width,0,_window_width*2,_window_height*0.6);
        imageVV.frame = CGRectMake(0,0,_window_width*2,_window_height*0.6);
        
    }];
}


-(void)Upmessage{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ship" object:nil];
    
    
}

@end
