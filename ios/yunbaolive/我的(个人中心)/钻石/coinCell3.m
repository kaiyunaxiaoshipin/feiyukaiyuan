//
//  coinCell1.m
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "coinCell3.h"
@implementation coinCell3

+(coinCell3 *)cellWithTableView:(UITableView *)tableView{
    coinCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"coinCell3"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"coinCell3" owner:self options:nil].lastObject;
//        cell.selectedBackgroundView.backgroundColor = [UIColor redColor];

    }
    
    return cell;
    
}
-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,20,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width - 40),self.frame.size.height);
    CGContextStrokePath(ctx);
}

- (IBAction)coinClick:(id)sender {
    
    
}
@end
