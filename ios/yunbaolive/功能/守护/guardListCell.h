//
//  guardListCell.h
//  yunbaolive
//
//  Created by Boom on 2018/11/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "guardListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface guardListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *votesL;
@property (weak, nonatomic) IBOutlet UILabel *yingpiaoL;

@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;
@property (nonatomic,strong) guardListModel *model;
@end

NS_ASSUME_NONNULL_END
