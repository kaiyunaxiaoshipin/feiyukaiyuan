//
//  grardButton.m
//  yunbaolive
//
//  Created by Boom on 2018/11/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "grardButton.h"

@implementation grardButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.frame = frame;
    if (self) {
        self.nameL = [[UILabel alloc]init];
        _nameL.textColor = RGB_COLOR(@"#959697", 1);
        _nameL.font = [UIFont systemFontOfSize:12];
        _nameL.textAlignment = NSTextAlignmentCenter;
        _nameL.userInteractionEnabled = NO;
        [self addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.left.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(0.3);
        }];
        UIView *view = [[UIView alloc]init];
        view.userInteractionEnabled = NO;
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameL.mas_bottom);
            make.bottom.left.right.equalTo(self);
        }];
        self.coinL = [[UILabel alloc]init];
        _coinL.textColor = normalColors;
        _coinL.font = [UIFont systemFontOfSize:12];
        _coinL.textAlignment = NSTextAlignmentCenter;
        _coinL.text = @"0";
        [view addSubview:_coinL];
        
        [_coinL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view);
            make.centerX.equalTo(view).offset(6);
            make.height.equalTo(view).multipliedBy(0.7);
        }];
        
        UIImageView *zunashiImgView = [[UIImageView alloc]init];
        zunashiImgView.image = [UIImage imageNamed:@"logFirst_钻石.png"];
        [view addSubview:zunashiImgView];
        

        [zunashiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_coinL);
            make.width.height.mas_equalTo(11);
            make.right.equalTo(_coinL.mas_left).offset (-2);
        }];
        

    }
    return self;
}

@end
