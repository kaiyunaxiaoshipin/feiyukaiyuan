//
//  zhuangcell.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/9.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhuangcell : UITableViewCell

+(zhuangcell *)cellWithTableview:(UITableView *)tableview;
-(void)setmodel:(NSArray *)array;
@end
