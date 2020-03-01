//
//  MessageFansCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageFansCell.h"

@implementation MessageFansCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.cornerRadius = _iconBtn.width/2;
    _iconBtn.userInteractionEnabled = NO;//启用点击事件更改YES
    
    [_iconBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    _iconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _iconBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    _followBtn.layer.masksToBounds = YES;
    _followBtn.layer.cornerRadius = 13;
    _followBtn.layer.borderWidth = 1;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

+(MessageFansCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath {
    MessageFansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageFansCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageFansCell" owner:nil options:nil]objectAtIndex:0];
       
    }
    return cell;
}

-(void)setModel:(MessageFansModel *)model {
    _model = model;
    
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:_model.iconStr] forState:0];
    _contentL.text = [NSString stringWithFormat:@"%@ 关注了你",_model.unameStr];
    NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:_contentL.text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _model.unameStr.length)];
    _contentL.attributedText = attStr;
    _timeL.text = _model.timeStr;
    if ([_model.isAttentStr isEqual:@"0"]) {
        _followBtn.layer.borderColor = Pink_Cor.CGColor;
        [_followBtn setTitle:YZMsg(@"关注") forState:0];
        [_followBtn setTitleColor:Pink_Cor forState:0];
    }else{
        _followBtn.layer.borderColor = RGB(74, 74, 82).CGColor;
        [_followBtn setTitleColor:RGB(74, 74, 82) forState:0];
        [_followBtn setTitle:YZMsg(@"已关注") forState:0];
    }
    
}

- (IBAction)clickIconBtn:(UIButton *)sender {
    //预留-awakeFromNib更改userInteractionEnabled属性
}

- (IBAction)clickFollowBtn:(UIButton *)sender {
    if ([[Config getOwnID] intValue]<=0) {
        [PublicObj warnLogin];
        return;
    }
    if ([[Config getOwnID] isEqual:_model.uidStr]) {
        [MBProgressHUD showError:YZMsg(@"不能关注自己")];
        return;
    }
    NSString *url = [purl stringByAppendingFormat:@"?service=User.setAttent&uid=%@&touid=%@&token=%@",[Config getOwnID],_model.uidStr,[Config getOwnToken]];
    
    [YBNetworking postWithUrl:url Dic:nil Suc:^(NSDictionary *data, NSString *code, NSString *msg) {
        if ([code isEqual:@"0"]) {
            NSString *infoDic = [[data valueForKey:@"info"]firstObject];
            NSString *isattent = [NSString stringWithFormat:@"%@",[infoDic valueForKey:@"isattent"]];
            if ([isattent isEqual:@"0"]) {
                _followBtn.layer.borderColor = Pink_Cor.CGColor;
                [_followBtn setTitle:YZMsg(@"关注") forState:0];
                [_followBtn setTitleColor:Pink_Cor forState:0];
            }else{
                _followBtn.layer.borderColor = RGB(74, 74, 82).CGColor;
                [_followBtn setTitleColor:RGB(74, 74, 82) forState:0];
                [_followBtn setTitle:YZMsg(@"已关注") forState:0];
            }
        }else{
//            [MBProgressHUD showError:msg];
            [MBProgressHUD showError:msg];
        }
    } Fail:nil];
    
}
@end
