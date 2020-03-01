//
//  chatMsgCell.m
//  yunbaolive
//
//  Created by Boom on 2018/10/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "chatMsgCell.h"
#import "SDWebImageManager.h"
@implementation chatMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(chatModel *)model{
    _model = model;
    if ([_model.titleColor isEqual:@"userLogin"]) {
        _chatLabel.text = [NSString stringWithFormat:@"%@ %@",_model.userName,_model.contentChat];
    }else if ([_model.titleColor isEqual:@"redbag"]){
        _chatLabel.text = [NSString stringWithFormat:@"%@%@",_model.userName,_model.contentChat];
    }else{
        _chatLabel.text = [NSString stringWithFormat:@"%@:%@",_model.userName,_model.contentChat];
    }
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:self.chatLabel.text attributes:nil];
    
    
    _chatLabel.font = [UIFont systemFontOfSize:14];

    //入场消息 开播警告
    if ([_model.titleColor isEqual:@"firstlogin"]) {
        self.chatView.backgroundColor = RGB_COLOR(@"#000000", 0.3);

        _chatLabel.textColor = normalColors;
        noteStr = [[NSMutableAttributedString alloc] initWithString:_model.contentChat attributes:nil];
    }else if ([_model.titleColor isEqual:@"redbag"]){
        _chatLabel.textColor = [UIColor whiteColor];
        _chatLabel.font = [UIFont boldSystemFontOfSize:14];
        self.chatView.backgroundColor = RGB_COLOR(@"#f7501d", 0.9);
    }
    else{
        self.chatView.backgroundColor = RGB_COLOR(@"#000000", 0.3);
        NSDictionary *levelDic = [common getUserLevelMessage:_model.levelI];
        NSAttributedString *speaceString = [[NSAttributedString  alloc]initWithString:@" "];

        NSTextAttachment *adminAttchment = [[NSTextAttachment alloc]init];
        adminAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
        adminAttchment.image = [UIImage imageNamed:@"chat_admin"];//设置图片
        NSAttributedString *adminString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(adminAttchment)];

        NSTextAttachment *shouAttchment = [[NSTextAttachment alloc]init];
        shouAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
        shouAttchment.image = [UIImage imageNamed:@"chat_shou_month"];//设置图片
        NSAttributedString *shouString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(shouAttchment)];
        
        NSTextAttachment *yearAttchment = [[NSTextAttachment alloc]init];
        yearAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
        yearAttchment.image = [UIImage imageNamed:@"chat_shou_year"];//设置图片
        NSAttributedString *yearString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(yearAttchment)];


        NSTextAttachment *vipAttchment = [[NSTextAttachment alloc]init];
        vipAttchment.bounds = CGRectMake(0, -2, 30, 15);//设置frame
        vipAttchment.image = [UIImage imageNamed:@"chat_vip"];//设置图片
        NSAttributedString *vipString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(vipAttchment)];

        NSTextAttachment *levelAttchment = [[NSTextAttachment alloc]init];
        levelAttchment.bounds = CGRectMake(0, -2, 30, 15);//设置frame
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                levelAttchment.image = image;
            }
        }];
//        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:minstr([levelDic valueForKey:@"thumb"])] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//            if (image) {
//                levelAttchment.image = image;
//            }
//
//        }];
        
        NSAttributedString *levelString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(levelAttchment)];

        NSTextAttachment *liangAttchment = [[NSTextAttachment alloc]init];
        liangAttchment.bounds = CGRectMake(0, -2, 15, 15);//设置frame
        liangAttchment.image = [UIImage imageNamed:@"chat_liang"];//设置图片
        NSAttributedString *liangString = [NSAttributedString attributedStringWithAttachment:(NSTextAttachment *)(liangAttchment)];

            /*
             0 青蛙
             1 猴子
             2 小红花
             3 小黄花
             4 心
             */
        NSRange redRange = NSMakeRange(0, _model.userName.length+1);

        if ([_model.titleColor isEqual:@"userLogin"]){
            self.chatLabel.textColor = RGB_COLOR(@"#c7c9c7", 1);
        }else{
            self.chatLabel.textColor = [UIColor whiteColor];
        }
        if ([_model.isAnchor isEqual:@"1"]) {
            [noteStr addAttribute:NSForegroundColorAttributeName value:normalColors range:redRange];
        }else{
            [noteStr addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(minstr([levelDic valueForKey:@"colour"]), 1) range:redRange];
        }
            if ([_model.titleColor isEqual:@"light0"])//青蛙
            {
                self.chatLabel.textColor = RGB_COLOR(@"#c7c9c7", 1);

                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = [UIImage imageNamed:@"plane_heart_cyan.png"];
                // 设置图片大小
                attch.bounds = CGRectMake(0,-4,17,17);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [noteStr appendAttributedString:string];
            }
            else if ([_model.titleColor isEqual:@"light1"])//猴子
            {
                self.chatLabel.textColor = RGB_COLOR(@"#c7c9c7", 1);

                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = [UIImage imageNamed:@"plane_heart_pink.png"];
                // 设置图片大小
                attch.bounds = CGRectMake(0,-4,17,17);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [noteStr appendAttributedString:string];
            }
            else if ([_model.titleColor isEqual:@"light2"])//小红花
            {
                self.chatLabel.textColor = RGB_COLOR(@"#c7c9c7", 1);

                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = [UIImage imageNamed:@"plane_heart_red.png"];
                // 设置图片大小
                attch.bounds = CGRectMake(0,-4,17,17);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [noteStr appendAttributedString:string];
            }
            else if ([_model.titleColor isEqual:@"light3"])//小黄花
            {
                self.chatLabel.textColor = RGB_COLOR(@"#c7c9c7", 1);

                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = [UIImage imageNamed:@"plane_heart_yellow.png"];
                // 设置图片大小
                attch.bounds = CGRectMake(0,-4, 17, 17);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [noteStr appendAttributedString:string];
            }
            else if ([_model.titleColor isEqual:@"light4"])//心
            {
                self.chatLabel.textColor = RGB_COLOR(@"#c7c9c7", 1);

                // 添加表情
                NSTextAttachment *attch = [[NSTextAttachment alloc] init];
                // 表情图片
                attch.image = [UIImage imageNamed:@"plane_heart_heart"];
                // 设置图片大小
                attch.bounds = CGRectMake(0,-4, 17, 17);
                NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
                [noteStr appendAttributedString:string];
            }
        //插入靓号图标
        if (![_model.liangname isEqual:@"0"] && ![_model.liangname isEqual:@"(null)"] && _model.liangname !=nil && _model.liangname !=NULL) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:liangString atIndex:0];//插入到第几个下标
        }
        //插入守护图标
        if ([_model.guardType isEqual:@"1"]) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:shouString atIndex:0];//插入到第几个下标
        }
        if ([_model.guardType isEqual:@"2"]) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:yearString atIndex:0];//插入到第几个下标
        }
        //插入管理图标
        if ([_model.isadmin isEqual:@"1"]) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:adminString atIndex:0];//插入到第几个下标
        }
        //插入VIP图标
        if ([_model.vip_type isEqual:@"1"]) {
            [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
            [noteStr insertAttributedString:vipString atIndex:0];//插入到第几个下标
        }
        
        [noteStr insertAttributedString:speaceString atIndex:0];//插入到第几个下标
        [noteStr insertAttributedString:levelString atIndex:0];//插入到第几个下标

    }
    [self.chatLabel setAttributedText:noteStr];

}

@end
