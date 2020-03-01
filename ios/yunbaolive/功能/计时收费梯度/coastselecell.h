//
//  coastselecell.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/7/1.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coastselecell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *showlabel;

+(coastselecell *)cellWithTableView:(UITableView *)tableview;

@end
