//
//  liushuicell.m
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/22.
//  Copyright © 2017年 cat. All rights reserved.
//
#import "liushuicell.h"
@implementation liushuicell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        
    }
    return self;
}
-(void)setmodel:(NSMutableDictionary *)subdic andframe:(CGRect)frames{
    
//    CGFloat x = 0;
//    for (int i=0; i<3; i++) {
//        UILabel *label = [[UILabel alloc]init];
//        label.frame = CGRectMake(x,0,frames.size.width/3,40);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.backgroundColor = [UIColor clearColor];
//        label.font = fontMT(14);
//        NSString *colors = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"banker_card"]];
//        if ([colors isEqual:@"牌型"]) {
//             label.textColor = normalColors;
//        }
//        else{
//        label.textColor = [UIColor whiteColor];
//        }
//        if (i == 0) {
//            label.text = [subdic valueForKey:@"count"];
//        }  if (i == 1) {
//            label.text = [subdic valueForKey:@"banker_card"];
//        }  if (i == 2) {
//            label.text = [subdic valueForKey:@"banker_profit"];
//        }
//        [self addSubview:label];
//        x+=frames.size.width/3;
//    }
    
    NSString *colors = [NSString stringWithFormat:@"%@",[subdic valueForKey:@"banker_card"]];
    if ([colors isEqual:@"牌型"]) {
        _label1.textColor = normalColors;
        _label2.textColor = normalColors;
        _label3.textColor = normalColors;
    }else{
        _label1.textColor = [UIColor whiteColor];
        _label2.textColor = [UIColor whiteColor];
        _label3.textColor = [UIColor whiteColor];
    }
    _label1.text = minstr([subdic valueForKey:@"count"]);
    _label2.text = minstr([subdic valueForKey:@"banker_card"]);
    _label3.text = minstr([subdic valueForKey:@"banker_profit"]);
    
    
}
+(liushuicell *)cellWithTableview:(UITableView *)tableview{
    liushuicell *cell = [tableview dequeueReusableCellWithIdentifier:@"liushuicell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"liushuicell" owner:self options:nil].lastObject;
//      cell = [[liushuicell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"liushuicell"];
    }
    return cell;
}
@end
