//
//  UserCenterTableViewCell.h
//  iphoneLive
//
//  Created by cat on 16/3/10.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *itemL;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage;


+(UserCenterTableViewCell *)cellWithTableView:(UITableView *)tableView;


@end
