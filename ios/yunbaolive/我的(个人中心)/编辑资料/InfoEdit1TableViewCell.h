//
//  InfoEdit1TableViewCell.h
//  yunbaolive
//
//  Created by cat on 16/3/13.
//  Copyright © 2016年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoEdit1TableViewCell : UITableViewCell
+(InfoEdit1TableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (weak, nonatomic) IBOutlet UILabel *labLeftName;

@property (weak, nonatomic) IBOutlet UIImageView *imgRight;

@end
