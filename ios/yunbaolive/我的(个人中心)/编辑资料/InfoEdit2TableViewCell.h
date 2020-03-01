//
//  InfoEdit2TableViewCell.h
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoEdit2TableViewCell : UITableViewCell
+(InfoEdit2TableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *labContrName;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@end
