//
//  anchorCell.h
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "anchorModel.h"
@protocol anchorCellDelegate <NSObject>
- (void)startPK:(anchorModel *)model;
@end

NS_ASSUME_NONNULL_BEGIN

@interface anchorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@property (weak, nonatomic) IBOutlet UIImageView *levelImgView;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn;
@property(nonatomic,assign)id<anchorCellDelegate> delegate;
@property (nonatomic,strong) anchorModel *model;
@end

NS_ASSUME_NONNULL_END
