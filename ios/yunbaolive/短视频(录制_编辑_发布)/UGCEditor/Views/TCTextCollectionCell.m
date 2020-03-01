//
//  TCTextCollectionCell.m
//  DeviceManageIOSApp
//
//  Created by rushanting on 2017/5/22.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import "TCTextCollectionCell.h"
#import "ColorMacro.h"
#import "UIView+Additions.h"






@implementation TCTextCollectionCell


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = UIColorFromRGB(0x777777).CGColor;
        self.backgroundColor = UIColor.clearColor;
        _textLabel = [UILabel new];
        _textLabel.text = @"点击添加文字";
        _textLabel.font = [UIFont systemFontOfSize:9];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _textLabel.numberOfLines = 2;
        [self.contentView addSubview:_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _textLabel.frame = CGRectMake(5, 6, self.contentView.width - 10, self.contentView.height - 14);
}

- (void)setSelected:(BOOL)selected
{
    if (!selected) {
        _textLabel.textColor = UIColorFromRGB(0xFFFFFF);
        self.layer.borderColor = UIColorFromRGB(0x777777).CGColor;
    } else {
        _textLabel.textColor = Pink_Cor;//UIColorFromRGB(0x0accac);
        self.layer.borderWidth = 1;
        self.layer.borderColor = Pink_Cor.CGColor;//UIColorFromRGB(0x0accac).CGColor;
    }
}

@end
