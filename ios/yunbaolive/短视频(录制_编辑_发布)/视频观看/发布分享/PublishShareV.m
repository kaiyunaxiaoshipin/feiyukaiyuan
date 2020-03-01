//
//  PublishShareV.m
//  iphoneLive
//
//  Created by YunBao on 2018/6/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "PublishShareV.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDK/ShareSDK+Base.h>

@interface PublishShareV()
{
    float WW;
    float HH;
    float scrollH;
}
@property(nonatomic,strong)UILabel *desL;
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)NSArray *shareArray;

@end

@implementation PublishShareV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WW = frame.size.width;
        HH = frame.size.height;
        scrollH = HH - 30;
        self.shareArray = [common share_type];
        [self addSubview:self.desL];
        [self addSubview:self.scrollView];
        
    }
    return self;
}

#pragma mark - 点击事件
-(void)clickBtn:(UIButton *)sender {
    
    NSLog(@"====%@",sender.titleLabel.text);
    if (sender.selected == NO) {
        for (UIButton *btn in _scrollView.subviews) {
            if ([btn isKindOfClass:[UIButton class]]) {
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish%@",btn.titleLabel.text]] forState:UIControlStateNormal];
                btn.selected = NO;
            }
        }
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish_%@",sender.titleLabel.text]] forState:UIControlStateNormal];
        sender.selected = YES;
        self.shareEvent(sender.titleLabel.text);
    }else{
        self.shareEvent(@"qx");
        [sender setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish%@",sender.titleLabel.text]] forState:UIControlStateNormal];
        sender.selected = NO;
    }
    
}

#pragma mark - set/get
-(UILabel *)desL {
    if (!_desL) {
        _desL = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, WW-30, 30)];
        _desL.text = YZMsg(@"分享至");
        if (self.shareArray.count>4) {
            _desL.text = YZMsg(@"分享至(左右滑动更多分享)");
        }
        _desL.textColor = RGB_COLOR(@"#666666", 1);
        _desL.font = SYS_Font(15);
        _desL.backgroundColor = [UIColor clearColor];
    }
    return _desL;
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        
        CGFloat btnW = (WW-30)/4;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15, 30, WW-30, scrollH)];
        _scrollView.contentSize = CGSizeMake(btnW*_shareArray.count, scrollH);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        CGFloat x=0;
        for (int i=0; i<_shareArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:0];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"publish%@",_shareArray[i]]] forState:UIControlStateNormal];
            [btn setTitle:_shareArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:_shareArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.frame = CGRectMake(x,0,btnW,btnW);
            btn.selected = NO;
            x+=btnW;
            [_scrollView addSubview:btn];
        }
        
    }
    return _scrollView;
}



@end
