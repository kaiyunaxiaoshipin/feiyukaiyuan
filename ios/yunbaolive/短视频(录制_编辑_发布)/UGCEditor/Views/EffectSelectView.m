//
//  VideoEffectSlider.m
//  TXLiteAVDemo
//
//  Created by xiang zhang on 2017/11/3.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "EffectSelectView.h"
#import "UIView+Additions.h"
#import "ColorMacro.h"

#define EFFCT_COUNT        4
#define EFFCT_IMAGE_WIDTH  50
#define EFFCT_IMAGE_SPACE  20

@implementation EffectSelectView
{
    UIView *_allSub;
    UILabel *_titleL;
    UIScrollView *_effectSelectView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _allSub = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 70)];
        _allSub.backgroundColor = [UIColor clearColor];
        [self addSubview:_allSub];
        
//        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.width-30, 30)];
//        _titleL.text = @"长按添加特效";
//        _titleL.font = SYS_Font(16);
//        _titleL.textColor = [UIColor whiteColor];
//        [_allSub addSubview:_titleL];
        
//        _delEffectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _delEffectBtn.backgroundColor = RGB_COLOR(@"#323232", 1);
//        [_delEffectBtn setImage:[UIImage imageNamed:@"撤销"] forState:0];
//        [_delEffectBtn setTitle:@"撤销" forState:0];
//        _delEffectBtn.titleLabel.font = SYS_Font(13);
//        [_delEffectBtn setTitleColor:RGB_COLOR(@"#969696", 1) forState:0];
//        _delEffectBtn.frame = CGRectMake(_allSub.width-70, 0, 55, 26);
//        _delEffectBtn.layer.masksToBounds = YES;
//        _delEffectBtn.layer.cornerRadius = 5;
//        [_delEffectBtn addTarget:self action:@selector(doDelEffectBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_allSub addSubview:_delEffectBtn];
//        _delEffectBtn.hidden = YES;
        
        CGFloat space = (self.width - EFFCT_IMAGE_WIDTH * EFFCT_COUNT) / (EFFCT_COUNT + 1);
        _effectSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.width,70)];//动图高度(EFFCT_IMAGE_WIDTH)+标题高度(20)
        [_allSub addSubview:_effectSelectView];
        
//        NSArray *effectNameS = @[@"抖动",@"黑白",@"灵魂出窍",@"动感分屏"];
        //抖动-黑白-灵魂出窍-动感分屏
//        UIImage *ddImg = [UIImage sd_animatedGIFNamed:@"其他特效－抖动"];
//        UIImage *hbImg = [UIImage sd_animatedGIFNamed:@"其他特效－黑白"];
//        UIImage *lhcqImg = [UIImage sd_animatedGIFNamed:@"其他特效－灵魂出窍"];
//        UIImage *dgfpImg = [UIImage sd_animatedGIFNamed:@"其他特效－动感分屏"];
        UIImage *ddImg = [UIImage imageNamed:@"抖动@3x"];
        UIImage *hbImg = [UIImage imageNamed:@"魔法@3x"];
        UIImage *lhcqImg = [UIImage imageNamed:@"幻觉@3x"];
        UIImage *dgfpImg = [UIImage imageNamed:@"灵魂出窍@3x"];

        NSArray *gifImgs = @[ddImg,lhcqImg,hbImg,dgfpImg];
        
        for (int i = 0 ; i < EFFCT_COUNT ; i ++){
            
            UIImageView *selImg = [[UIImageView alloc]initWithFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i, 0, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH*1.4)];
            [selImg setImage:gifImgs[i]];
            
//            //gif有白边做个线圈遮挡毛边
//            UIImageView *selbg = [[UIImageView alloc]initWithFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i+3.5, 0+3.5, EFFCT_IMAGE_WIDTH-7, EFFCT_IMAGE_WIDTH-7)];
//            selbg.layer.masksToBounds = YES;
//            selbg.layer.cornerRadius = EFFCT_IMAGE_WIDTH/2-3.5;
//            selbg.layer.borderColor = [UIColor whiteColor].CGColor;
//            selbg.layer.borderWidth = 1.5;
//
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(space + (space + EFFCT_IMAGE_WIDTH) * i, 0, EFFCT_IMAGE_WIDTH, EFFCT_IMAGE_WIDTH*1.4)];
            [btn setImage:[UIImage imageNamed:@""] forState:0];
            btn.tag = i;
            [btn addTarget:self action:@selector(beginPress:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(endPress:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//
//            UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(btn.left, btn.bottom-2, btn.width, 20)];
//            title.text = effectNameS[i];
//            title.font = SYS_Font(14);
//            if (IS_IPHONE_5) {
//                title.font = SYS_Font(12);
//            }
//            title.textAlignment = NSTextAlignmentCenter;
//            title.textColor = [UIColor whiteColor];
            
            [_effectSelectView addSubview:selImg];
//            [_effectSelectView addSubview:selbg];
            [_effectSelectView addSubview:btn];
//            [_effectSelectView addSubview:title];
            
            /*
            switch ((TXEffectType)btn.tag) {
                case TXEffectType_ROCK_LIGHT:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0xEC5F9B)];
                }
                    break;
                case TXEffectType_DARK_DRAEM:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0xEC8435)];
                }
                    break;
                case TXEffectType_SOUL_OUT:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0x1FBCB6)];
                }
                    break;
                case TXEffectType_SCREEN_SPLIT:
                {
                    [btn setBackgroundColor:UIColorFromRGB(0x449FF3)];
                }
                    break;
                    
                default:
                    break;
            }
             */
        }
        
    }
    return self;
}
-(void)doDelEffectBtn {
    NSLog(@"del");
    [self.delegate onEffectSelDelete];
}

//响应事件
-(void) beginPress: (UIButton *) button {
    
    if (_delEffectBtn.hidden == YES) {
        _delEffectBtn.hidden = NO;
    }
    TXEffectType type;
    if (button.tag == 1) {
        type = (TXEffectType)2;
    }else if (button.tag == 2){
        type = (TXEffectType)1;
    }else{
        type = (TXEffectType)button.tag;
    }
    [self.delegate onVideoEffectBeginClick:type];
}

//响应事件
-(void) endPress: (UIButton *) button {
    TXEffectType type = (TXEffectType)button.tag;
    [self.delegate onVideoEffectEndClick:type];
}
@end
