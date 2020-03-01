//
//  anchorPKView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol anchorPKViewDelegate <NSObject>
- (void)removePKView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface anchorPKView : UIView
- (instancetype)initWithFrame:(CGRect)frame andTime:(NSString *)time;

- (void)updateProgress:(CGFloat)progress withBlueNum:(NSString *)blueNum withRedNum:(NSString *)redNum;
- (void)showPkResult:(NSDictionary *)dic andWin:(int)win;
@property(nonatomic,assign)id<anchorPKViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
