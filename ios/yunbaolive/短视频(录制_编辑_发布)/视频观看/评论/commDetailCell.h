//
//  commDetailCell.h
//  yunbaolive
//
//  Created by Boom on 2018/12/17.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailmodel.h"

NS_ASSUME_NONNULL_BEGIN

@interface commDetailCell : UITableViewCell
@property (strong, nonatomic)  UILabel *nameL;
@property (strong, nonatomic)  UILabel *contentL;
@property(nonatomic,strong)detailmodel *model;

@end

NS_ASSUME_NONNULL_END
