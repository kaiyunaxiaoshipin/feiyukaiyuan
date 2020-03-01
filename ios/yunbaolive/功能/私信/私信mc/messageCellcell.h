//
//  messageCellcell.h
//  
//
//  Created by zqm on 16/4/8.
//
//

#import <UIKit/UIKit.h>
@class messageModel;
@interface messageCellcell : UITableViewCell


@property(nonatomic,strong)messageModel *model;


+(messageCellcell *)cellWithTableView:(UITableView *)tableView;

@end
