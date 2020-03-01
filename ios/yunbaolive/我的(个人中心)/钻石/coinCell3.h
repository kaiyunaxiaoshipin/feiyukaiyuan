//
//  coinCell3.h
//  yunbaolive
//
//  Created by cat on 16/3/14.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface coinCell3 : UITableViewCell
+(coinCell3 *)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *labCoin;
@property (weak, nonatomic) IBOutlet UIButton *btnPrice;
@property (weak, nonatomic) IBOutlet UILabel *labRemake;
@end
