//
//  mineVideoCell.h
//  yunbaolive
//
//  Created by Boom on 2018/12/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NearbyVideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface mineVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImgView;
@property (weak, nonatomic) IBOutlet UILabel *numsL;
@property (nonatomic,strong) NearbyVideoModel *model;
@end

NS_ASSUME_NONNULL_END
