//
//  redListCell.h
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "redListModel.h"
@protocol redListCellDelegate <NSObject>
- (void)qiangBtnClickkk:(redListModel *)model andButton:(UIButton *)btn;
- (void)showRedDetails:(redListModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface redListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *contenL;

@property (weak, nonatomic) IBOutlet UIButton *qiangBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (nonatomic,strong) redListModel *model;
@property (nonatomic, strong) CAKeyframeAnimation *animat;
@property (nonatomic,strong)NSString *stream;
@property(nonatomic,assign)id<redListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
