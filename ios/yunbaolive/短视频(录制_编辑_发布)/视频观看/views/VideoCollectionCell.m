//
//  VideoCollectionCell.m
//  iphoneLive
//
//  Created by YangBiao on 2017/9/5.
//  Copyright © 2017年 cat. All rights reserved.
//

#import "VideoCollectionCell.h"

@implementation VideoCollectionCell
{
    UILabel *label;
    UIImageView *imageV;
    UIView *view;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.cornerRadius = self.userAvatar.width / 2;
}

- (void)setModel:(NearbyVideoModel *)model{
    _model = model;
    [self.bgImageV sd_setImageWithURL:[NSURL URLWithString:model.videoImage]];
    self.titleLabel.text = model.videoTitle;
    [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:model.userAvatar]];
    self.usernameLabel.text = model.userName;
    self.distanceLabel.text = model.distance;
    if ([self.isAtten isEqual:@"1"]) {
        self.distanceImage.image = [UIImage imageNamed:@"时间小图标"];
        self.distanceLabel.text = model.time;
    }
    if ([self.isList isEqual:@"1"]) {
        self.distanceImage.image = [UIImage imageNamed:@"评论小图标"];
        self.distanceLabel.text = model.commentNum;
        //添加右上角定位view
        if (view) {
            [view removeFromSuperview];
            view = nil;
            [label removeFromSuperview];
            label = nil;
            [imageV removeFromSuperview];
            imageV = nil;
        }
        NSString *str = model.city;
        if (str.length <= 0 || !str || [str isEqualToString:@"(null)"]) {
            return;
        }
        CGSize size = [str boundingRectWithSize:CGSizeMake(_window_width*0.65, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
        view = [[UIView alloc] initWithFrame:CGRectMake(self.width - 20 - size.width - 9.5, 10, size.width + 16 + 9.5, 19)];
        view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 9.5;
        view.hidden = YES;
        [self.contentView addSubview:view];
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 3, 12, 12)];
        imageV.image = [UIImage imageNamed:@"定位小图标"];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageV];
        label = [[UILabel alloc] initWithFrame:CGRectMake(16 + 2, 2, size.width, 15)];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor whiteColor];
        label.text = str;
        [view addSubview:label];
    }
    
}

@end
