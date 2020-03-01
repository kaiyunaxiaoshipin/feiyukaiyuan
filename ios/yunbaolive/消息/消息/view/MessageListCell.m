//
//  MessageListCell.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageListCell.h"
#import "MessageListModel.h"
#import "JCHATSendMsgManager.h"

@interface MessageListCell()

@end
@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickIconBtn:(UIButton *)sender {
    if (self.iconEvent) {
        self.iconEvent(@"头像");
    }
}

+(MessageListCell*)cellWithTab:(UITableView *)tableView andIndexPath:(NSIndexPath*)indexPath {
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageListCell" owner:nil options:nil]objectAtIndex:0];
//        cell.backgroundColor = CellRow_Cor;
    }
    return cell;
}

-(void)setModel:(MessageListModel *)model {
    _model = model;
    [_iconIV sd_setImageWithURL:[NSURL URLWithString:_model.iconStr]];
    //官方标识
    if ([_model.uidStr isEqual:@"dsp_admin_1"] || [_model.uidStr isEqual:@"dsp_admin_2"]) {
        _iconTag.hidden = NO;
    }else{
        _iconTag.hidden = YES;
    }
    _nameL.text = _model.unameStr;
    
    if ([[[JCHATSendMsgManager ins] draftStringWithConversation:_model.conversation] isEqualToString:@""]) {
        _detailL.text = _model.contentStr;
    } else {
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[草稿] %@",[[JCHATSendMsgManager ins] draftStringWithConversation:_model.conversation]]];
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:NSMakeRange(0, 4)];
        
        _detailL.attributedText = attriString;
    }
    
    _timeL.text = _model.timeStr;
    int num = [_model.unReadStr intValue];
    if (num > 0) {
        _redPoint.hidden = NO;
        _redPoint.text = [NSString stringWithFormat:@"%d",num];
    }else{
        _redPoint.hidden = YES;
    }
    //个位数显示圆点，两位及以上显示椭圆
    if (num < 10) {
        _redPointWidth.constant = _redPoint.frame.size.height;
    }else{
        _redPointWidth.constant = _redPoint.frame.size.width + 10;
    }
    if ([_model.sex isEqual:@"1"]) {
        _sexI.image= [ UIImage imageNamed:@"sex_man"];
    }else if ([_model.sex isEqual:@"2"]){
        _sexI.image = [UIImage imageNamed:@"sex_woman"];
    }else{
        _sexI.image= [ UIImage imageNamed:@"sex_woman"];
    }
    NSDictionary *levelDic = [common getUserLevelMessage:_model.level];
    [_levelI sd_setImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])]];

    
}

@end
