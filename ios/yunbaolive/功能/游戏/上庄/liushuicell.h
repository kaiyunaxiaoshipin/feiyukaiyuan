//
//  liushuicell.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/6/22.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface liushuicell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;


+(liushuicell *)cellWithTableview:(UITableView *)tableview;


-(void)setmodel:(NSMutableDictionary *)subdic andframe:(CGRect)frame;


@end
