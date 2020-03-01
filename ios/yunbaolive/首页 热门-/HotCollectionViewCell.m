//
//  HotCollectionViewCell.m
//  yunbaolive
//
//  Created by Boom on 2018/9/21.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "HotCollectionViewCell.h"

@implementation HotCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(hotModel *)model{
    _model = model;
    if (_model.zhuboImage) {
        [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:_model.zhuboImage]];
    }else{
        [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_thumb]];
    }
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.zhuboIcon]];
    _nameLabel.text = _model.zhuboName;
    if (_isNear) {
        _numImgView.image = [UIImage imageNamed:@"live_distence"];
        _numsLabel.text = _model.distance;
    }else{
        _numsLabel.text = _model.onlineCount;
        _numImgView.image = [UIImage imageNamed:@"live_nums"];
    }
    _titleLabel.text = _model.title;
    if (_model.title.length > 0) {
        if (_jianju1.constant == 5) {
            _jianju1.constant += 5;
            _jianju2.constant += 5;

        }
    }else{
        if (_jianju1.constant == 10) {
            _jianju1.constant -= 5;
            _jianju2.constant -= 5;
            
        }
    }
    int type = [_model.type intValue];
    switch (type) {
        case 0:
            [_liveTypeImageView setImage:[UIImage imageNamed:@"live_普通"]];
            break;
        case 1:
            [_liveTypeImageView setImage:[UIImage imageNamed:@"live_密码"]];
            break;
        case 2:
            [_liveTypeImageView setImage:[UIImage imageNamed:@"live_付费"]];
            break;
        case 3:
            [_liveTypeImageView setImage:[UIImage imageNamed:@"live_计时"]];
            break;
        default:
            break;
    }
}
- (void)setVideoModel:(NearbyVideoModel *)videoModel{
    _videoModel = videoModel;
    [_thumbImageView sd_setImageWithURL:[NSURL URLWithString:_videoModel.videoImage]];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_videoModel.userAvatar]];
    _nameLabel.text = _videoModel.userName;
    _numsLabel.text = _videoModel.views;
    _numImgView.image = [UIImage imageNamed:@"我的视频观看人数"];
    _titleLabel.text = _videoModel.videoTitle;
    _liveTypeImageView.image = [UIImage new];
    if (_videoModel.videoTitle.length > 0) {
        if (_jianju1.constant == 5) {
            _jianju1.constant += 5;
            _jianju2.constant += 5;
        }
    }else{
        if (_jianju1.constant == 10) {
            _jianju1.constant -= 5;
            _jianju2.constant -= 5;
            
        }
    }


}
@end
