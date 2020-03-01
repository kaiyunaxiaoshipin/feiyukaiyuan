//
//  InfoEdit2TableViewCell.m
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "InfoEdit2TableViewCell.h"

@implementation InfoEdit2TableViewCell

-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,0,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),self.frame.size.height);
    CGContextStrokePath(ctx);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

+(InfoEdit2TableViewCell *)cellWithTableView:(UITableView *)tableView{
    InfoEdit2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCell2"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"editCell2" owner:self options:nil].lastObject;
    }
    
    return cell;
    
    
}

@end
