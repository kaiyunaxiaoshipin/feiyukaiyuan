//
//  anchorPKAlert.h
//  yunbaolive
//
//  Created by Boom on 2018/11/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol anchorPKAlertDelegate <NSObject>
@optional;
- (void)removeShouhuView;
- (void)agreePKClick;
- (void)notAgreeClick;
@end

NS_ASSUME_NONNULL_BEGIN

@interface anchorPKAlert : UIView
- (instancetype)initWithFrame:(CGRect)frame andIsStart:(BOOL)start;
@property(nonatomic,assign)id<anchorPKAlertDelegate> delegate;
- (void)removeTimer;
@end

NS_ASSUME_NONNULL_END
