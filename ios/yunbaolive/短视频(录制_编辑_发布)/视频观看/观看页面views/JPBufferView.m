//
//  JPBufferView.m
//  iphoneLive
//
//  Created by Rookie on 2018/7/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "JPBufferView.h"

@implementation JPBufferView

- (void)layoutThatFits:(CGRect)constrainedRect
nearestViewControllerInViewTree:(UIViewController *_Nullable)nearestViewController
  interfaceOrientation:(JPVideoPlayViewInterfaceOrientation)interfaceOrientation {
    [super layoutThatFits:constrainedRect
nearestViewControllerInViewTree:nearestViewController
     interfaceOrientation:interfaceOrientation];
    self.blurBackgroundView.frame = CGRectMake(0,
                                               constrainedRect.size.height - 50 -1-ShowDiff,
                                               constrainedRect.size.width,
                                               1);
    UIImage *img = [UIImage sd_animatedGIFNamed:@"视频加载"];
    UIImageView *gifImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _window_width, 1)];
    [gifImg setImage:img];
    [self.blurBackgroundView addSubview:gifImg];
    
    
}

@end
