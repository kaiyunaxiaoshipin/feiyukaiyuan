//
//  guardAlertView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^alertBlock)(BOOL isSure);

@interface guardAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame andType:(int)type andMsg:(NSString *)msg;
@property (nonatomic,copy) alertBlock block;

@end

NS_ASSUME_NONNULL_END
