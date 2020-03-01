//
//  GiftEffectView.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "GiftEffectView.h"

@implementation GiftEffectView

-(instancetype)initWithFrame:(CGRect)frame andGiftMsg:(NSDictionary *)giftData{
    if (self = [super initWithFrame:frame]) {
        int uid  = [minstr([giftData valueForKey:@"uid"]) intValue];
        int giftid = [minstr([giftData valueForKey:@"giftid"]) intValue];
        _identification = giftid * 10000 + uid *10000;
        [self creatUI:giftData];
    }
    return self;
}
- (void)creatUI:(NSDictionary *)giftData{
    
}
@end
