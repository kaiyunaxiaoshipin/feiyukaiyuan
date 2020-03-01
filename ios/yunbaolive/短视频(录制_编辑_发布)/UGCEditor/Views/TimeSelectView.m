//
//  TimeSelectView.m
//  TXLiteAVDemo_Enterprise
//
//  Created by xiang zhang on 2017/10/27.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "TimeSelectView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"
#define EFFCT_COUNT        4
#define EFFCT_IMAGE_WIDTH  60 * kScaleY
#define EFFCT_IMAGE_SPACE  20
//#import <SDWebImage/UIImage+GIF.h>

@implementation TimeSelectView
{
    UIView *_allSub;
    UILabel *_titleL;
    UIScrollView *_effectSelectView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _allSub = [[UIView alloc]initWithFrame:CGRectMake(0, (self.height-55-EFFCT_IMAGE_WIDTH)/2, self.width, 30+5+EFFCT_IMAGE_WIDTH+20)];
        _allSub.backgroundColor = [UIColor clearColor];
        [self addSubview:_allSub];
        
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.width-30, 30)];
        _titleL.text = @"点击选择特效";
        _titleL.font = SYS_Font(16);
        _titleL.textColor = [UIColor whiteColor];
        [_allSub addSubview:_titleL];
        
        //按钮左右空隙
        CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
        _effectSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_titleL.bottom+5, self.width,EFFCT_IMAGE_WIDTH+20)];//动图高度(EFFCT_IMAGE_WIDTH)+标题高度(20)
        _effectSelectView.backgroundColor = [UIColor clearColor];
        [_allSub addSubview:_effectSelectView];
        
        NSArray *effectNameS = @[@"无",@"时光倒流",@"反复",@"慢动作"];
        //无-倒放-反复-慢动作
        UIImage *noImg = [UIImage sd_animatedGIFNamed:@"时间特效－无"];
        UIImage *dlImg = [UIImage sd_animatedGIFNamed:@"时间特效－时光倒流"];
        UIImage *ffImg = [UIImage sd_animatedGIFNamed:@"时间特效－反复"];
        UIImage *mdzImg = [UIImage sd_animatedGIFNamed:@"时间特效－慢动作"];
        NSArray *gifImgs = @[noImg,dlImg,ffImg,mdzImg];
        for (int i = 0 ; i < EFFCT_COUNT ; i ++){
            
            UIImageView *selImg = [[UIImageView alloc]initWithFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i, 0, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH)];
            [selImg setImage:gifImgs[i]];
            
            //gif有白边做个线圈遮挡毛边
            UIImageView *selbg = [[UIImageView alloc]initWithFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i+3.5, 0+3.5, EFFCT_IMAGE_WIDTH-7, EFFCT_IMAGE_WIDTH-7)];
            selbg.layer.masksToBounds = YES;
            selbg.layer.cornerRadius = EFFCT_IMAGE_WIDTH/2-3.5;
            selbg.layer.borderColor = [UIColor whiteColor].CGColor;
            selbg.layer.borderWidth = 1.5;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i+0.5, 0+0.5, EFFCT_IMAGE_WIDTH-1, EFFCT_IMAGE_WIDTH-1);
            [btn setImage:[UIImage imageNamed:@"时间特效-选中"] forState:0];
            btn.tag = i+180705;
            [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.bottom-2, btn.width, 20)];
            title.text = effectNameS[i];
            title.font = SYS_Font(14);
            if (IS_IPHONE_5) {
                title.font = SYS_Font(12);
            }
            title.textAlignment = NSTextAlignmentCenter;
            title.textColor = [UIColor whiteColor];
            
            [_effectSelectView addSubview:selImg];
            [_effectSelectView addSubview:selbg];
            [_effectSelectView addSubview:btn];
            [_effectSelectView addSubview:title];
        }
        
        UIButton *selBtn = (UIButton *)[self viewWithTag:180705];
        [self resetBtnColor:selBtn];
        
    }
    return self;
}

- (void)onBtnClick:(UIButton *)btn {
    if (btn.tag == 180705) {
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsSpeed)]) {
            [_delegate onVideoTimeEffectsClear];
        }
    }
    else if (btn.tag == 180706) {
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsSpeed)]) {
            [_delegate onVideoTimeEffectsBackPlay];
        }
    }
    else if (btn.tag == 180707){
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsBackPlay)]) {
            [_delegate onVideoTimeEffectsRepeat];
        }
    }
    else if (btn.tag == 180708){
        if (_delegate && [_delegate respondsToSelector:@selector(onVideoTimeEffectsRepeat)]) {
            [_delegate onVideoTimeEffectsSpeed];
        }
    }
    [self resetBtnColor:btn];
}

- (void)resetBtnColor:(UIButton *)btn {
    for (UIButton * subBtn in _effectSelectView.subviews) {
        if ([subBtn isKindOfClass:[UIButton class]]) {
            [subBtn setImage:[UIImage imageNamed:@"1"] forState:0];
        }
    }
    [btn setImage:[UIImage imageNamed:@"时间特效-选中"] forState:0];
}

@end
