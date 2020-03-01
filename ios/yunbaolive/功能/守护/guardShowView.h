//
//  guardShowView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/12.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol guardShowDelegate <NSObject>
@optional;
- (void)buyOrRenewGuard;
- (void)removeShouhuView;
@end
NS_ASSUME_NONNULL_BEGIN

@interface guardShowView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)id<guardShowDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andUserGuardMsg:(NSDictionary *)dic andLiveUid:(NSString *)uid;
- (void)show;
@end

NS_ASSUME_NONNULL_END
