//
//  guardListCell.m
//  yunbaolive
//
//  Created by Boom on 2018/11/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "guardListCell.h"

@implementation guardListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(guardListModel *)model{
    _model = model;
    if ([_model.type isEqual:@"1"]) {
        _typeImgView.image = [UIImage imageNamed:@"guard_low"];
    }else{
        _typeImgView.image = [UIImage imageNamed:@"guard_heig"];
    }
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_thumb]];
    _nameL.text = _model.user_nicename;
    _votesL.text = _model.contribute;
    _yingpiaoL.text = [common name_votes];
    if ([_model.sex isEqual:@"1"]) {
        _sexImgView.image = [UIImage imageNamed:@"sex_man"];
    }else{
        _sexImgView.image = [UIImage imageNamed:@"sex_woman"];
    }
    NSDictionary *levelDic = [common getUserLevelMessage:_model.level];
    [_levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
}
@end
