//
//  userItemCell14.m
//  yunbaolive
//
//  Created by cat on 16/3/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "userItemCell5.h"

@implementation userItemCell5

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

+(userItemCell5 *)cellWithTableView:(UITableView *)tableView{
    userItemCell5 *cell = [tableView dequeueReusableCellWithIdentifier:@"userItemCell5"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"userItemCell5" owner:self options:nil].lastObject;
        cell.logOutLabel.text = YZMsg(@"");
    }
    
    return cell;
    
    
}

@end
