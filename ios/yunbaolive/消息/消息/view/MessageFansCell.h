//
//  MessageFansCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFansModel.h"

@interface MessageFansCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property(nonatomic,strong)MessageFansModel *model;


/** 预留点击事件 */
- (IBAction)clickIconBtn:(UIButton *)sender;


- (IBAction)clickFollowBtn:(UIButton *)sender;


+(MessageFansCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;


@end
