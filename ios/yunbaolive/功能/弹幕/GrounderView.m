//
//  GrounderView.m
//  GrounderDemo
//
//  Created by 贾楠 on 16/3/8.
//  Copyright © 2016年 贾楠. All rights reserved.
//
#import "GrounderView.h"
#import "SDWebImage/SDImageCache.h"
#import "SDWebImage/UIButton+WebCache.h"
@interface GrounderView()<UIGestureRecognizerDelegate>
{
    UILabel * titleLabel;
    UIButton * headImage;
    UILabel * nameLabel;
    UIView * titleBgView;
    float viewWidth;
    UITapGestureRecognizer* singleTap;


}
@end
@implementation GrounderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 30/2;
        
        titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [self addSubview:titleBgView];
        
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:titleLabel];
        
        nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:nameLabel];
     
        
        headImage = [[UIButton alloc] init];
        headImage.clipsToBounds = YES;
        headImage.frame = CGRectMake(0, 0, 30, 30);
        headImage.layer.cornerRadius = 30/2;
        headImage.layer.borderWidth = 0.5;
        headImage.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:headImage];
        

    }
    return self;
}
- (void)setContent:(id)model{
        NSLog(@"%@",model);
        nameLabel.text = [model valueForKey:@"name"];
        nameLabel.frame = CGRectMake(35, 2, [GrounderView calculateMsgWidth:nameLabel.text andWithLabelFont:[UIFont systemFontOfSize:10] andWithHeight:10], 10);
        titleLabel.text = [model valueForKey:@"title"];
        titleLabel.frame = CGRectMake(35, 12, [GrounderView calculateMsgWidth:titleLabel.text andWithLabelFont:[UIFont systemFontOfSize:12] andWithHeight:18]+20, 18);
        titleBgView.frame = CGRectMake(5, 12, [GrounderView calculateMsgWidth:titleLabel.text andWithLabelFont:[UIFont systemFontOfSize:12] andWithHeight:18]+55, 18);        titleBgView.layer.cornerRadius = 9;
        viewWidth = titleLabel.frame.size.width + 55;
        if (nameLabel.frame.size.width > titleLabel.frame.size.width) {
            viewWidth = nameLabel.frame.size.width + 55;
        }
        [headImage sd_setImageWithURL:[NSURL URLWithString:[model valueForKey:@"icon"]] forState:UIControlStateNormal placeholderImage:nil];
       [headImage addTarget:self action:@selector(clickIcon) forControlEvents:UIControlEventTouchUpInside];
        self.frame = CGRectMake(kScreenWidth + 20, self.selfYposition, viewWidth, 30);
}
-(void)clickIcon
{
    NSLog(@"icon click");
}
- (void)grounderAnimation:(id)model{
    
    
    float second = 0.0;
    if (titleLabel.text.length < 30){
        second = 10.0f;
    }else{
        second = titleLabel.text.length/2.5;
    }
    
    self.userInteractionEnabled = YES;
    
    
    [UIView animateWithDuration:second delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.frame = CGRectMake( - viewWidth - 20, self.frame.origin.y, viewWidth, 30);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.isShow = NO;
      
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextView" object:nil];
        
        
    }];


 
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"nextView" object:nil];
}
+ (CGFloat)calculateMsgWidth:(NSString *)msg andWithLabelFont:(UIFont*)font andWithHeight:(NSInteger)height {
    if ([msg isEqual:@""]) {
        return 0;
    }
    CGFloat messageLableWidth = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:font}
                                                  context:nil].size.width;
    return messageLableWidth + 1;
}

@end
