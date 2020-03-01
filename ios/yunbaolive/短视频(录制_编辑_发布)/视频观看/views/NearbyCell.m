//
//  NearbyCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/27.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "NearbyCell.h"

@implementation NearbyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconIV.layer.masksToBounds = YES;
    _iconIV.layer.cornerRadius = _iconIV.width/2;
    
}

-(void)setModel:(NearbyVideoModel *)model {
    _model = model;
    
    [_coverIV sd_setImageWithURL:[NSURL URLWithString:_model.videoImage]];
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:_model.userAvatar]];
    _unameL.text = [NSString stringWithFormat:@"%@",_model.userName];
    _distanceL.text = [NSString stringWithFormat:@"%@",_model.distance];
    
}


@end
