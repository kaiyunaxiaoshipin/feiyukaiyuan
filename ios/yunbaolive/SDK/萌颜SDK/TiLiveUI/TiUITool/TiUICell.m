//
//  TiUICell.h
//  TiLive
//
//  Created by Cat66 on 2018/5/8.
//  Copyright © 2018年 Tillurosy Tech. All rights reserved.
//

#import "TiUICell.h"

@interface TiUICell ()

@end

@implementation TiUICell

- (UIImageView *)bgView {
    if (!_bgView) {
        
        _bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_bgView setImage:nil];
    }
    return _bgView;
    
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Helvetica" size:15.f];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_label];
    }
    return _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView = self.bgView;
        self.label.frame = CGRectMake(1, 1, CGRectGetWidth(self.frame) - 2 + 10, CGRectGetWidth(self.frame) - 5);
    }
    return self;
}

- (void)setRockUICellByIndex:(NSInteger)index {
//    NSArray *rockNameCN = [[NSArray alloc] initWithObjects:@"无", @"炫彩抖动",@"灵魂出窍", @"头晕目眩",@"闪动分屏", @"酷炫转屏",@"四分镜头", @"黑白电影",@"自由抖动", @"瞬间石化", @"魔法镜面", nil];
    NSArray *rockNameCN = [[NSArray alloc] initWithObjects:YZMsg(@"无"), YZMsg(@"炫彩抖动"), YZMsg(@"轻彩抖动"), YZMsg(@"头晕目眩"), YZMsg(@"灵魂出窍"),YZMsg(@"暗黑魔法"), YZMsg(@"虚拟镜像"),YZMsg(@"动感分屏"), YZMsg(@"黑白电影"), YZMsg(@"瞬间石化"), YZMsg(@"魔法镜面"), nil];
    self.label.text = [rockNameCN objectAtIndex:index];
}

- (void)setFilterUICellByIndex:(NSInteger)index {
    NSArray *filterNameCN = [[NSArray alloc] initWithObjects:YZMsg(@"无"), YZMsg(@"素描"),YZMsg(@"黑边"), YZMsg(@"卡通"),YZMsg(@"浮雕"), YZMsg(@"胶片"),YZMsg(@"马赛克"), YZMsg(@"半色调"),YZMsg(@"交叉线"), YZMsg(@"那舍尔"), YZMsg(@"咖啡"), YZMsg(@"巧克力"), YZMsg(@"可可"), YZMsg(@"美味"), YZMsg(@"初恋"), YZMsg(@"森林"), YZMsg(@"光泽"), YZMsg(@"禾草"), YZMsg(@"假日"), YZMsg(@"初吻"), YZMsg(@"洛丽塔"), YZMsg(@"回忆"), YZMsg(@"慕斯"), YZMsg(@"标准"), YZMsg(@"氧气"), YZMsg(@"桔梗"), YZMsg(@"赤红"), YZMsg(@"冷日"), YZMsg(@"扭曲"), YZMsg(@"油画"), YZMsg(@"分色"), YZMsg(@"漩涡"), YZMsg(@"光晕"), YZMsg(@"眩晕"), YZMsg(@"圆点"), YZMsg(@"极坐标"), YZMsg(@"水晶球"), YZMsg(@"曝光"), YZMsg(@"水墨"), nil];
    self.label.text = [filterNameCN objectAtIndex:index];
}

- (void)setDistortionUICellByIndex:(NSInteger)index {
    NSArray *distortionNameCN = [[NSArray alloc] initWithObjects:YZMsg(@"无"), YZMsg(@"外星人"), YZMsg(@"梨梨脸"), YZMsg(@"瘦瘦脸"), YZMsg(@"方方脸"), nil];
    self.label.text = [distortionNameCN objectAtIndex:index];
}

- (void)setGreenScreenUICellByIndex:(NSInteger)index {
    NSArray *greenScreenNameCN = [[NSArray alloc] initWithObjects:YZMsg(@"无"), YZMsg(@"星空"), YZMsg(@"黑板"), nil];
    self.label.text = [greenScreenNameCN objectAtIndex:index];
}

- (void)changeCellEffect:(BOOL)isChange {
    if (isChange) {
        [self.label setTextColor:TiRGBA(255, 255, 255, 1)];
    } else {
        [self.label setTextColor:normalColors];
    }
}
@end
