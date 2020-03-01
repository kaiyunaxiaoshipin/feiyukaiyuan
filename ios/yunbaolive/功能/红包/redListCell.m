//
//  redListCell.m
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "redListCell.h"
#define angle2Rad(angle) ((angle) / 180.0 * M_PI)

@implementation redListCell{
    NSTimer *timer;
    int count;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(redListModel *)model{
    _model = model;

    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_model.avatar_thumb]];
    _nameL.text = _model.user_nicename;
    if ([_model.type isEqual:@"1"]) {
        _contenL.text = YZMsg(@"派发了一个延迟红包");
    }else{
        _contenL.text = YZMsg(@"派发了一个即时红包");
    }
    if ([_model.time isEqual:@"qiangguole"]) {
        [_qiangBtn.layer removeAllAnimations];
        _timeL.text = YZMsg(@"抢");
        _timeL.textColor = RGB_COLOR(@"#d43123", 1);
    }else{
        if ([_model.time isEqual:@"0"]) {
            if ([_model.isrob isEqual:@"1"]) {
                _animat = [CAKeyframeAnimation animation];
                _animat.keyPath = @"transform.rotation";
                _animat.values = @[@(angle2Rad(-20)),@(angle2Rad(20)),@(angle2Rad(-20))];
                _animat.duration = 0.5;
                _animat.repeatCount = MAXFLOAT;
                [_qiangBtn.layer addAnimation:_animat forKey:nil];
                _timeL.text = YZMsg(@"抢");
                _timeL.textColor = RGB_COLOR(@"#d43123", 1);
            }else{
                _timeL.text = YZMsg(@"抢");
                _timeL.textColor = RGB_COLOR(@"#d43123", 1);
            }
        }else{
            count = [_model.time intValue];
            _timeL.text = [self seconds:count];
            _timeL.textColor = RGB_COLOR(@"#656567", 1);
            
            if (!timer) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(daojishi) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
            }
        }
    }
}
- (void)daojishi{
    count --;
    _model.time = [NSString stringWithFormat:@"%d",count];
    _timeL.text = [self seconds:count];
    if (count <= 0) {
        [timer invalidate];
        timer = nil;
        _timeL.text = YZMsg(@"抢");
        _timeL.textColor = RGB_COLOR(@"#d43123", 1);
        if ([_model.isrob isEqual:@"1"]){
            _animat = [CAKeyframeAnimation animation];
            _animat.keyPath = @"transform.rotation";
            _animat.values = @[@(angle2Rad(-20)),@(angle2Rad(20)),@(angle2Rad(-20))];
            _animat.duration = 0.5;
            _animat.repeatCount = MAXFLOAT;
            [_qiangBtn.layer addAnimation:_animat forKey:nil];
        }
    }
}
- (NSString *)seconds:(int)s{
    NSString *str;
    str = [NSString stringWithFormat:@"%02d:%02d",s/60,s%60];
    return str;
}
- (IBAction)qiangBtnClick:(id)sender {
    if ([_model.time intValue] <= 0 && ![_model.isrob isEqual:@"1"]) {
        [self.delegate showRedDetails:_model];
    }else{
        [self.delegate qiangBtnClickkk:_model andButton:_qiangBtn];
    }
}
@end
