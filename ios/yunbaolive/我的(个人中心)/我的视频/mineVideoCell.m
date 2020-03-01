//
//  mineVideoCell.m
//  yunbaolive
//
//  Created by Boom on 2018/12/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "mineVideoCell.h"

@implementation mineVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(NearbyVideoModel *)model{
    _model = model;
    [_thumbImgView sd_setImageWithURL:[NSURL URLWithString:_model.videoImage]];
    _numsL.text = _model.views;
}
@end
