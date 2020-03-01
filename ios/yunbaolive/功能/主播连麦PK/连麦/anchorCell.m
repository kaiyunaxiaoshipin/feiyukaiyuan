//
//  anchorCell.m
//  yunbaolive
//
//  Created by Boom on 2018/11/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "anchorCell.h"

@implementation anchorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)linkBtnClick:(id)sender {
    [self.delegate startPK:_model];
}
- (void)setModel:(anchorModel *)model{
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_thumb]];
    _nameL.text = _model.user_nicename;
    if ([_model.sex isEqual:@"1"]) {
        _sexImgView.image = [UIImage imageNamed:@"sex_man"];
    }else{
        _sexImgView.image = [UIImage imageNamed:@"sex_woman"];
    }
    NSDictionary *levelDic = [common getAnchorLevelMessage:_model.level];
    [_levelImgView sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
    _linkBtn.layer.borderWidth = 1.0;
    if (![_model.pkuid isEqual:@"0"]) {
        _linkBtn.layer.borderColor = RGB_COLOR(@"#c7c8c9", 1).CGColor;
        [_linkBtn setTitleColor:RGB_COLOR(@"#c7c8c9", 1) forState:0];
        _linkBtn.userInteractionEnabled = NO;
        [_linkBtn setTitle:YZMsg(@"已邀请") forState:0];
    }else{
        _linkBtn.layer.borderColor = normalColors.CGColor;
        [_linkBtn setTitleColor:normalColors forState:0];
        _linkBtn.userInteractionEnabled = YES;
        [_linkBtn setTitle:YZMsg(@"邀请连麦") forState:0];
    }

}
@end
