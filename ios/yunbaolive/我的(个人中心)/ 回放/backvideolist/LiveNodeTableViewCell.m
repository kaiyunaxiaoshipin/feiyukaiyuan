//
//  LiveNodeTableViewCell.m
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//
#import "LiveNodeTableViewCell.h"
#import "LiveNodeModel.h"
@implementation LiveNodeTableViewCell
-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,0,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),self.frame.size.height);
    CGContextStrokePath(ctx);
}
-(void)setModel:(LiveNodeModel *)model{
    
    _model = model;
    self.labTitle.text = _model.title;
    self.labStartTime.text = _model.datestarttime;
    self.labNums.text = _model.nums;
}
+(LiveNodeTableViewCell *)cellWithTV:(UITableView *)tv{
    LiveNodeTableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"a"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"showNote" owner:self options:nil].lastObject;
        cell.kanguoL.text = YZMsg(@"人看过直播");
    }
    return cell;
}
@end
