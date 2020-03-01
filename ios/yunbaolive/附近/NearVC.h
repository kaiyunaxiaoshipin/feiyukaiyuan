//
//  NearVC.h
//  yunbaolive
//
//  Created by YunBao on 2018/2/1.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

@interface NearVC : UIViewController
{
    int unRead;//未读消息
    int sendMessage;
    //  EMConversation *em;//会话id;
    UILabel *label;
    
}

@end
