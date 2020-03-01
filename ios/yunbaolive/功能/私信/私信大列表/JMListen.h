//
//  JMListen.h
//  yunbaolive
//
//  Created by 王敏欣 on 2017/12/12.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMListen : UIViewController<JMessageDelegate,JMSGConversationDelegate>

@property(nonatomic,assign)int unRead;
@property(nonatomic,strong)UILabel *unReadLabel;
- (NSString*)iphoneType;
@end
