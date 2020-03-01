//
//  LiveNodeTableViewCell.h
//  yunbaolive
//
//  Created by cat on 16/4/6.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveNodeModel.h"
@interface LiveNodeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labStartTime;

@property (weak, nonatomic) IBOutlet UILabel *labNums;
@property (weak, nonatomic) IBOutlet UILabel *kanguoL;


@property(nonatomic,strong)LiveNodeModel *model;

+(LiveNodeTableViewCell *)cellWithTV:(UITableView *)tv;

@end
