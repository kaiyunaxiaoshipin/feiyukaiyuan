//
//  pkProgressView.m
//  yunbaolive
//
//  Created by Boom on 2018/11/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "pkProgressView.h"

@implementation pkProgressView{
    UIView *redView;
    UIView *blueView;
    UILabel *redLabel;
    UILabel *blueLabel;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI{
    blueView = [[UIView alloc]init];
    blueView.backgroundColor = RGB_COLOR(@"#2889f7", 1);
    [self addSubview:blueView];
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-_window_width/2);
        make.top.height.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    UILabel *woLabel = [[UILabel alloc]init];
    woLabel.font = [UIFont systemFontOfSize:11];
    woLabel.textColor = [UIColor whiteColor];
    woLabel.text = YZMsg(@"我方");
    [blueView addSubview:woLabel];
    [woLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(blueView);
        make.left.equalTo(blueView).offset(5);
    }];
    
    blueLabel = [[UILabel alloc]init];
    blueLabel.font = [UIFont systemFontOfSize:11];
    blueLabel.textColor = [UIColor whiteColor];
    blueLabel.text = @"0";
    [blueView addSubview:blueLabel];
    [blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blueView.mas_top);
//        make.right.equalTo(blueView.mas_right).offset(-3);
        make.left.equalTo(woLabel.mas_right).offset(3);
        make.bottom.equalTo(blueView.mas_bottom);
    }];
    
    redView = [[UIView alloc]initWithFrame:CGRectMake(_window_width, 0, _window_width/2, 20)];
    redView.backgroundColor = RGB_COLOR(@"#f93232", 1);
    [self addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(_window_width/2);
        make.top.height.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    UILabel *duiLabel = [[UILabel alloc]init];
    duiLabel.font = [UIFont systemFontOfSize:11];
    duiLabel.textColor = [UIColor whiteColor];
    duiLabel.text = YZMsg(@"对方");
    [redView addSubview:duiLabel];
    [duiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(redView);
        make.right.equalTo(redView).offset(-5);

    }];
    
    redLabel = [[UILabel alloc]init];
    redLabel.font = [UIFont systemFontOfSize:11];
    redLabel.textColor = [UIColor whiteColor];
    redLabel.text = @"0";
    redLabel.textAlignment = NSTextAlignmentRight;
    [redView addSubview:redLabel];
    [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redView.mas_top);
//        make.left.equalTo(redView.mas_left).offset(3);
        make.right.equalTo(duiLabel.mas_left).offset(-3);
        make.bottom.equalTo(redView.mas_bottom);
    }];
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.8 animations:^{
        [blueView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
        }];
        [redView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
        }];
    }];
    
}
- (void)updateProgress:(CGFloat)progress withBlueNum:(NSString *)blueNum withRedNum:(NSString *)redNum{
    
    blueLabel.text = blueNum;
    redLabel.text = redNum;
    
    [blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_window_width*progress);
        make.left.equalTo(self);
        make.top.height.equalTo(self);

    }];
    [redView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_window_width*(1-progress));
        make.top.height.equalTo(self);
        make.right.equalTo(self);
    }];



}

@end
