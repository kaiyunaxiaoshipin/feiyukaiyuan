//
//  YBUserInfoListTableViewCell.h
//  TCLVBIMDemo
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>





/**
 *  个人中心列表cell
 */
@interface YBUserInfoListTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *nameL;

+ (instancetype)cellWithTabelView:(UITableView *)tableView;

@end
