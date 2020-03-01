//
//  LocationCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/23.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(LocationCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath {
    
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"LocationCell" owner:nil options:nil]objectAtIndex:0];
       
    }
    return cell;
}




@end
