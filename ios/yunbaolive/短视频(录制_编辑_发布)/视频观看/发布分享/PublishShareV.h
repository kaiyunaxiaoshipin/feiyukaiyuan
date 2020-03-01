//
//  PublishShareV.h
//  iphoneLive
//
//  Created by YunBao on 2018/6/25.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PublishShareBlock)(NSString *type);

@interface PublishShareV : UIView

/** 分享回调 */
@property(nonatomic,copy)PublishShareBlock shareEvent;

@end
