//
//  UserCenterTableViewCell.m
//  iphoneLive
//
//  Created by cat on 16/3/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import "UserCenterTableViewCell.h"






@implementation UserCenterTableViewCell






-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

+(UserCenterTableViewCell *)cellWithTableView:(UITableView *)tableView{
    UserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"level"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"cell1" owner:self options:nil].lastObject;
    }
    
    return cell;
    
    
}




@end
