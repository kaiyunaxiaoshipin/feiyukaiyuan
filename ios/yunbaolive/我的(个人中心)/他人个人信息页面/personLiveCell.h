//
//  personLiveCell.h
//  yunbaolive
//
//  Created by Boom on 2018/10/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface personLiveCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labStartTime;

@property (weak, nonatomic) IBOutlet UILabel *labNums;
@property(nonatomic,strong)LiveNodeModel *model;

@end

NS_ASSUME_NONNULL_END
