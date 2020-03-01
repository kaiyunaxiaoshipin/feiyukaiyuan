//
//  MessageListCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageListModel;

typedef void (^IconBlock)(NSString *type);

@interface MessageListCell : UITableViewCell

@property(nonatomic,strong)MessageListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIImageView *iconTag;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *redPoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redPointWidth;
@property (weak, nonatomic) IBOutlet UIImageView *sexI;
@property (weak, nonatomic) IBOutlet UIImageView *levelI;
@property (weak, nonatomic) IBOutlet UILabel *siliaoL;

@property(nonatomic,copy)IconBlock iconEvent;
/** 后期添加点击事件 */
- (IBAction)clickIconBtn:(UIButton *)sender;

+(MessageListCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;

@end
