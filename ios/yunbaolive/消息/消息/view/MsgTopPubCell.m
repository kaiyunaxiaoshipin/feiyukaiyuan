//
//  MsgTopPubCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/24.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MsgTopPubCell.h"

@implementation MsgTopPubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.cornerRadius = _iconBtn.width/2;
    _iconBtn.imageView.clipsToBounds = YES;
    [_iconBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    _iconBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _iconBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [_coverBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    _coverBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _coverBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
+(MsgTopPubCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath {
    MsgTopPubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MsgTopPubCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MsgTopPubCell" owner:nil options:nil]objectAtIndex:0];
        
    }
    return cell;
}


- (void)setModel:(MsgTopPubModel *)model {
    _model = model;
    
    [_iconBtn sd_setImageWithURL:[NSURL URLWithString:_model.iconStr] forState:0];
    [_coverBtn sd_setImageWithURL:[NSURL URLWithString:_model.coverStr] forState:0];
    _timeL.text = _model.timeStr;
    if ([_model.pageVC isEqual:@"赞"]) {
        if ([_model.typeStr isEqual:@"0"]) {
             _contentL.text = [NSString stringWithFormat:@"%@ 赞了您的评论",_model.unameStr];
        }else{
             _contentL.text = [NSString stringWithFormat:@"%@ 赞了您的作品",_model.unameStr];
        }
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:_contentL.text];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _model.unameStr.length)];
        _contentL.attributedText = attStr;
    }else if ([_model.pageVC isEqual:@"@我的"]){
        NSString *video_title;
        if (_model.videoTitleStr.length <= 0) {
            video_title = YZMsg(@"无标题");
        }else if(_model.videoTitleStr.length <5){
            video_title = _model.videoTitleStr;
        }else {
            video_title = [_model.videoTitleStr stringByReplacingCharactersInRange:NSMakeRange(5, _model.videoTitleStr.length-5) withString:@"..."];
        }
        _contentL.text = [NSString stringWithFormat:@"%@ 在 %@ 的评论中@了你",_model.unameStr,video_title];
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:_contentL.text];
        [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, _model.unameStr.length)];
        _contentL.attributedText = attStr;
    }else{//评论
        _contentL.textColor = [UIColor whiteColor];
        _contentL.text = [NSString stringWithFormat:@"%@ 评论了您的作品 %@",_model.unameStr,_model.commentConStr];
        NSMutableAttributedString *attStr=[[NSMutableAttributedString alloc]initWithString:_contentL.text];
        [attStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(@"#8c8c8c", 1) range:NSMakeRange(_model.unameStr.length,8)];
        _contentL.attributedText = attStr;
    }
    
}

- (IBAction)clickIconBtn:(UIButton *)sender {
    if ([self.delegatge respondsToSelector:@selector(iconClickUid:)]) {
        [self.delegatge iconClickUid:_model.uidStr];
    }
}

- (IBAction)clickCoverBtn:(UIButton *)sender {
    if ([self.delegatge respondsToSelector:@selector(coverClickVideoid:)]) {
        [self.delegatge coverClickVideoid:_model.videoidStr];
    }
    
}
@end
