//
//  SelPeopleV.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"

typedef void (^SelBlockEvent)(NSString *state,MessageListModel *userModel);

@interface SelPeopleV : UIView

@property(nonatomic,copy)SelBlockEvent selEvent;

//showtype 1-选择联系人  2召唤好友
- (instancetype)initWithFrame:(CGRect)frame showType:(NSString *)showtype selUser:(SelBlockEvent)event;


@end
