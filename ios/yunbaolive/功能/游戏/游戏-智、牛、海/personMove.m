//
//  personMove.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/3/4.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "personMove.h"
@interface personMove ()
{
    NSTimer *moveTimer;
    CGRect rects;
}
@end
@implementation personMove
-(instancetype)initWithImage:(UIImage *)image andRect:(CGRect)rect{
    self = [super init];
    if (self) {
    self.image = image;
    rects = rect;
    self.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    self.contentMode = UIViewContentModeScaleAspectFit;
        [UIView animateWithDuration:1.0 animations:^{
            self.frame = CGRectMake(rects.origin.x,rects.origin.y+5,rects.size.width,rects.size.height-5);
        }];
        [UIView animateWithDuration:2.0 animations:^{
            self.frame = CGRectMake(rects.origin.x,rects.origin.y,rects.size.width,rects.size.height);
        }];
    moveTimer  = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(games) userInfo:nil repeats:YES];
    }
    return self;
}
-(void)games{
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake(rects.origin.x,rects.origin.y+5,rects.size.width,rects.size.height-5);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.frame = CGRectMake(rects.origin.x,rects.origin.y,rects.size.width,rects.size.height);
        }];
    });
}
-(void)setNewFrame:(CGRect)rect{
    [moveTimer invalidate];
    moveTimer = nil;
    rects = rect;
    moveTimer  = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(gamess) userInfo:nil repeats:YES];
}
-(void)gamess{
    
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake(rects.origin.x,rects.origin.y+5,rects.size.width,rects.size.height-5);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.frame = CGRectMake(rects.origin.x,rects.origin.y,rects.size.width,rects.size.height);
        }];
    });
}
//中途加入
-(void)continuesetNewFrame:(CGRect)rect{
    [moveTimer invalidate];
    moveTimer = nil;
    rects = rect;
    moveTimer  = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(gamesss) userInfo:nil repeats:YES];
}
-(void)gamesss{
    
    [UIView animateWithDuration:1.0 animations:^{
        self.frame = CGRectMake(rects.origin.x,rects.origin.y+5,rects.size.width,rects.size.height-5);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.frame = CGRectMake(rects.origin.x,rects.origin.y,rects.size.width,rects.size.height);
        }];
    });
}
-(void)dealloc{
    [moveTimer invalidate];
    moveTimer = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
