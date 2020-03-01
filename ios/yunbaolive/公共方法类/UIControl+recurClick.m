//
//  UIControl+recurClick.m
//  主要解决按钮的重复点击问题
//
//  Created by King on 16/9/2.
//  Copyright © 2016年 King. All rights reserved.
//

#import "UIControl+recurClick.h"
#import <objc/runtime.h>


@implementation UIControl (recurClick)
- (NSTimeInterval)uxy_acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
- (void)setUxy_acceptEventInterval:(NSTimeInterval)uxy_acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(uxy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)load
{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(__uxy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}
- (void)__uxy_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.uxy_ignoreEvent) return;
    if (self.uxy_acceptEventInterval > 0)
    {
        self.uxy_ignoreEvent = YES;
        
        [self performSelector:@selector(ksksk) withObject:@(NO) afterDelay:self.uxy_acceptEventInterval];
    }
    [self __uxy_sendAction:action to:target forEvent:event];
}

- (void)ksksk
{
    self.uxy_ignoreEvent = NO;
}
- (void)setUxy_ignoreEvent:(BOOL)uxy_ignoreEvent
{
    
    objc_setAssociatedObject(self, BandNameKey, [NSNumber numberWithBool:uxy_ignoreEvent], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)uxy_ignoreEvent
{
    
    return [objc_getAssociatedObject(self, BandNameKey) boolValue];
}

@end
