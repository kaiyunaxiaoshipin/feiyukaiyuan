//
//  MsgSysCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/8/3.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MsgSysModel.h"
@interface MsgSysCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIImageView *flagIV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *briefL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property(nonatomic,strong)MsgSysModel *model;

+(MsgSysCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;

@end
