//
//  JPLookProgressView.m
//  iphoneLive
//
//  Created by Rookie on 2018/7/8.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "JPLookProgressView.h"

@implementation JPLookProgressView

- (void)layoutThatFits:(CGRect)constrainedRect
nearestViewControllerInViewTree:(UIViewController *_Nullable)nearestViewController
  interfaceOrientation:(JPVideoPlayViewInterfaceOrientation)interfaceOrientation {
    [super layoutThatFits:constrainedRect
nearestViewControllerInViewTree:nearestViewController
     interfaceOrientation:interfaceOrientation];
    
    self.trackProgressView.frame = CGRectMake(0,
                                              constrainedRect.size.height - 1 - 49-ShowDiff,
                                              constrainedRect.size.width,
                                              1);
    self.cachedProgressView.frame = self.trackProgressView.bounds;
    self.elapsedProgressView.frame = self.trackProgressView.frame;
    
    self.cachedProgressView.backgroundColor = [UIColor clearColor];
    self.trackProgressView.backgroundColor = [UIColor clearColor];
    self.elapsedProgressView.backgroundColor = [UIColor grayColor];
    self.elapsedProgressView.tintColor = [UIColor whiteColor];
    self.elapsedProgressView.hidden = YES;
    self.trackProgressView.hidden = YES;
    self.cachedProgressView.hidden = YES;
}

@end
