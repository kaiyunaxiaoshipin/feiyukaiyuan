//
//  lastview.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/31.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "lastview.h"

@implementation lastview

-(instancetype)initWithFrame:(CGRect)frame block:(xinblocks)blocks andavatar:(NSString *)avatar{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.blocks = blocks;
        
        UIImageView  *lastViewssss = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, _window_height)];
        lastViewssss.userInteractionEnabled = YES;
        [lastViewssss sd_setImageWithURL:[NSURL URLWithString:avatar]];
        
        [self addSubview:lastViewssss];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0,_window_width,_window_height);
        [lastViewssss addSubview:effectview];

        
        UILabel *labell= [[UILabel alloc]initWithFrame:CGRectMake(0,_window_height*0.2, _window_width, 60)];
        labell.textColor = [UIColor whiteColor];
        labell.text = YZMsg(@"直播结束");
        labell.textAlignment = NSTextAlignmentCenter;
        labell.font = [UIFont systemFontOfSize:30];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(_window_width*0.2, _window_height *0.75, _window_width*0.6, 40);
        [button setTitle:YZMsg(@"返回首页") forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 20;
        button.backgroundColor = [UIColor grayColor];
        [button addTarget:self action:@selector(dissmissVC) forControlEvents:UIControlEventTouchUpInside];
        [lastViewssss addSubview:button];
        [lastViewssss addSubview:labell];
        [self addSubview:lastViewssss];
                
    }
    return self;
    
}

-(void)dissmissVC{
    
    self.blocks(@"");
    
}
@end
