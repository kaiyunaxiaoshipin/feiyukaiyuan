//
//  coinCell1.h
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coinCell1 : UITableViewCell
+(coinCell1 *)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *labCoin;
@property (weak, nonatomic) IBOutlet UILabel *yueL;

@end
