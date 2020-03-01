//
//  zhuanglistcell.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/20.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhuanglistcell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *zhuangname;

@property (weak, nonatomic) IBOutlet UILabel *usernameL;

@property (weak, nonatomic) IBOutlet UILabel *moneyL;

+(zhuanglistcell *)cellWithTableview:(UITableView *)tableview;
-(void)setfirstitem;
-(void)setmodel:(NSDictionary *)dic;
@end
