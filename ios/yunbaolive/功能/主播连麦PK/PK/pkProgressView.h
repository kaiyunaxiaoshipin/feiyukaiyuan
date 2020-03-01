//
//  pkProgressView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/14.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface pkProgressView : UIView
- (void)updateProgress:(CGFloat)progress withBlueNum:(NSString *)blueNum withRedNum:(NSString *)redNum;
@end

NS_ASSUME_NONNULL_END
