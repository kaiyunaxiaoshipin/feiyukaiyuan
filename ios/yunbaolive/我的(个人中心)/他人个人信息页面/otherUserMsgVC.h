//
//  otherUserMsgVC.h
//  yunbaolive
//
//  Created by Boom on 2018/10/7.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMListen.h"
typedef void (^chatFollowBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface otherUserMsgVC : JMListen
@property(nonatomic,strong)NSString *userID;
@property(nonatomic,strong)NSString *chatname;
@property(nonatomic,strong)NSString *icon;
@property (nonatomic,copy) chatFollowBlock block;

@end

NS_ASSUME_NONNULL_END
