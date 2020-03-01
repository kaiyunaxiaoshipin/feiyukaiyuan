//
//  LocationCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/23.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UIImageView *falgIV;


+(LocationCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath;


@end
