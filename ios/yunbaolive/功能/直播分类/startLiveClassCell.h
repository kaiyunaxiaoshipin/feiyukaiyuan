//
//  startLiveClassCell.h
//  yunbaolive
//
//  Created by Boom on 2018/9/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface startLiveClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImfView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@end

NS_ASSUME_NONNULL_END
