//
//  SelPeopleCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "SelPeopleCell.h"

@implementation SelPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconBtn.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+(SelPeopleCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath {
    SelPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelPeopleCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelPeopleCell" owner:nil options:nil]objectAtIndex:0];
        
    }
    cell.iconBtn.layer.masksToBounds = YES;
    cell.iconBtn.layer.cornerRadius = cell.iconBtn.width/2;
    return cell;
}


- (IBAction)clickIconBtn:(UIButton *)sender {
    //预留 (使用更改-awakeFromNib-userInteractionEnableds属性)
    
}
@end
