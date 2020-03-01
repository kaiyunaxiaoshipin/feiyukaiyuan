//
//  RankCell.m
//  yunbaolive
//
//  Created by YunBao on 2018/2/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "RankCell.h"

@implementation RankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
+(RankCell *)cellWithTab:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    RankCell *cell;
//    if (indexPath.row == 0) {
//        cell = [tableView dequeueReusableCellWithIdentifier:@"firstCell"];
//        if (!cell) {
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"RankCell" owner:nil options:nil]objectAtIndex:0];
//        }
//        cell.iconIV.layer.masksToBounds = YES;
//        cell.iconIV.layer.cornerRadius = cell.iconIV.size.width/2;
//
//    }else {
    
        cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RankCell" owner:nil options:nil]objectAtIndex:1];
        }
        cell.iconIV.layer.masksToBounds = YES;
        cell.iconIV.layer.cornerRadius = 20;
//    }
    return cell;
}

-(void)setModel:(RankModel *)model {
    _model = model;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:_model.iconStr] placeholderImage:[UIImage imageNamed:@"bg1"]];
    _nameL.text = _model.unameStr;
    //收益榜-0 消费榜-1
    if ([_model.type isEqual:@"0"]) {
        NSDictionary *levelDic = [common getAnchorLevelMessage:_model.levelStr];
        [_levelIV sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
        _votesL.text = [common name_votes];
    }else {
        NSDictionary *levelDic = [common getUserLevelMessage:_model.levelStr];
        [_levelIV sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];
        _votesL.text = [common name_coin];
    }
    _moneyL.text = _model.totalCoinStr;
    
    if ([_model.sex isEqual:@"1"]) {
        self.sexImgView.image = [UIImage imageNamed:@"sex_man"];
    }else{
        self.sexImgView.image = [UIImage imageNamed:@"sex_woman"];
    }
    if ([_model.isAttentionStr isEqual:@"0"]) {
        self.followBtn.selected = NO;
    }else {
        self.followBtn.selected = YES;
    }
}


@end
