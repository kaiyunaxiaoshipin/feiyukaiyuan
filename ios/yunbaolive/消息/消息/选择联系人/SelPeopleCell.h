//
//  SelPeopleCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelPeopleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *signatureL;


/** 头像点击事件（预留） */
- (IBAction)clickIconBtn:(UIButton *)sender;

+(SelPeopleCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;

@end
