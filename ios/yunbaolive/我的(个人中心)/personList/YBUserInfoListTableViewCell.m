//
//  YBUserInfoListTableViewCell.m
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//
#import "YBUserInfoListTableViewCell.h"
@implementation YBUserInfoListTableViewCell
-(void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx,1);
    CGContextSetStrokeColorWithColor(ctx,[UIColor groupTableViewBackgroundColor].CGColor);
    CGContextMoveToPoint(ctx,0,self.frame.size.height);
    CGContextAddLineToPoint(ctx,(self.frame.size.width),self.frame.size.height);
    CGContextStrokePath(ctx);
}
+ (instancetype)cellWithTabelView:(UITableView *)tableView{
    static NSString *cellIdentifier = @"YBUserInfoListTableViewCell";
    YBUserInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        YBUserInfoListTableViewCell *cell = [[YBUserInfoListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YBUserInfoListTableViewCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = UIColorFromRGB(0x4C4C4C);
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UIAccessibilityTraitNone;
    [self setUI];
    return self;
}
-(void)setUI
{
    //右边箭头
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _iconImage = [[UIImageView alloc]init];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    _nameL = [[UILabel alloc]init];
    _nameL.textAlignment = NSTextAlignmentCenter;
    _nameL.textColor = [UIColor blackColor];
    _nameL.font = [UIFont systemFontOfSize:14];
    
    
    [self.contentView addSubview:_nameL];
    [self.contentView addSubview:_iconImage];
    

    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(25);
    }];
    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImage.mas_right).offset(10);
        make.centerY.equalTo(_iconImage.mas_centerY);
    }];

    
    
    
}
@end
