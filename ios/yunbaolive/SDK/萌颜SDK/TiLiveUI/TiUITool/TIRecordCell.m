//
//  TIRecordCell.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/26.
//  Copyright © 2019 cat. All rights reserved.
//

#import "TIRecordCell.h"

@implementation TIRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDistortionUICellByIndex:(NSInteger)index {
    NSArray *distortionNameCN = [[NSArray alloc] initWithObjects:YZMsg(@"无"), YZMsg(@"外星人"), YZMsg(@"梨梨脸"), YZMsg(@"瘦瘦脸"), YZMsg(@"方方脸"), nil];
    _titleL.text = [distortionNameCN objectAtIndex:index];

    if (index == 0) {
        _titleL.hidden = YES;
        _thumbTopC.constant = 20;
        _thumbImgV.image = [UIImage imageNamed:@"cancel"];
    }else{
        _titleL.hidden = NO;
        _thumbTopC.constant = 10;
        _thumbImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_record_haha_%ld",(long)index]];
    }
}


- (void)changeCellEffect:(BOOL)isChange {
    if (isChange) {
        [self.titleL setTextColor:[UIColor whiteColor]];
        _seletcImgV.layer.borderColor= [UIColor clearColor].CGColor;
    } else {
        [self.titleL setTextColor:normalColors];
        _seletcImgV.layer.borderColor= normalColors.CGColor;
    }
}

@end
