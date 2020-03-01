//
//  MessageHeaderV.m
//  iphoneLive
//
//  Created by YunBao on 2018/7/13.
//  Copyright © 2018年 cat. All rights reserved.
//

#import "MessageHeaderV.h"

@implementation MessageHeaderV



- (IBAction)clickFansBtn:(UIButton *)sender {
    if (self.msgEvent) {
        self.msgEvent(YZMsg(@"粉丝"));
    }
}

- (IBAction)clickZanBtn:(UIButton *)sender {
    if (self.msgEvent) {
        self.msgEvent(@"赞");
    }
}

- (IBAction)clickAiTeBtn:(UIButton *)sender {
    if (self.msgEvent) {
        self.msgEvent(@"@我的");
    }
}

- (IBAction)clickCommentBtn:(UIButton *)sender {
    if (self.msgEvent) {
        self.msgEvent(@"评论");
    }
}
@end
