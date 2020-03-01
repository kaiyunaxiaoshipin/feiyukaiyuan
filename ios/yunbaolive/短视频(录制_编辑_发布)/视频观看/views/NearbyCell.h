//
//  NearbyCell.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NearbyVideoModel.h"

@interface NearbyCell : UICollectionViewCell

@property(nonatomic,strong)NearbyVideoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UILabel *unameL;
@property (weak, nonatomic) IBOutlet UILabel *distanceL;


@end
