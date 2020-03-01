//
//  JackpotView.m
//  yunbaolive
//
//  Created by IOS1 on 2019/4/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import "JackpotView.h"

@implementation JackpotView
- (IBAction)closeBtnClick:(id)sender {
    [self.delegate jackpotViewClose];
}

@end
