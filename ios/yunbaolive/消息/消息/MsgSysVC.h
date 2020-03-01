//
//  MsgSysVC.h
//  iphoneLive
//
//  Created by YunBao on 2018/8/2.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"
typedef void (^MsgSysVCBlock)(int type);

@interface MsgSysVC : UIViewController

@property(nonatomic,strong)MessageListModel *listModel;
@property (nonatomic,copy) MsgSysVCBlock block;
- (void)reloadSystemView;
@end
