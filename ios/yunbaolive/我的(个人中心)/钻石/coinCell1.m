//
//  coinCell1.m
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "coinCell1.h"

@implementation coinCell1

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

+(coinCell1 *)cellWithTableView:(UITableView *)tableView{
    coinCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"coinCell1"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"coinCell1" owner:self options:nil].lastObject;
        cell.yueL.text = YZMsg(@"账户余额");
        
    }
    
    return cell;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    }

@end
