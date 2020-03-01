//
//  zhuangcell.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/9.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "zhuangcell.h"
@implementation zhuangcell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
  
        
    }
    return self;
}

-(void)setmodel:(NSArray *)array{
    CGFloat x = 0;
    for (int i=0; i<array.count; i++) {
        NSString *path = [NSString stringWithFormat:@"%@",array[i]];
        UIImageView *imagaevcs = [[UIImageView alloc]init];
        imagaevcs.contentMode = UIViewContentModeScaleAspectFit;
        if ([path isEqual:@"1"]) {
            [imagaevcs setImage:[UIImage imageNamed:@"live_hundred_bull_bet_win_icon"]];
        }
        else{
            [imagaevcs setImage:[UIImage imageNamed:@"live_hundred_bull_bet_fail_icon"]];
        }
        imagaevcs.frame = CGRectMake(x,10,self.frame.size.width/array.count,30);
        [self addSubview:imagaevcs];
        x+=self.frame.size.width/array.count;
    }
}
+(zhuangcell *)cellWithTableview:(UITableView *)tableview{
    zhuangcell *cell = [tableview dequeueReusableCellWithIdentifier:@"zhuangcell"];
    if (!cell) {
        cell = [[zhuangcell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zhuangcell"];
    }
    return cell;
}
@end
