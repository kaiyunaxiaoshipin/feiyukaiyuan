//
//  YBNoWordView.h
//  yunbaolive
//
//  Created by Boom on 2018/10/31.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refrashBtnBlock)(id msg);

NS_ASSUME_NONNULL_BEGIN

@interface YBNoWordView : UIView
- (instancetype)initWithBlock:(refrashBtnBlock)bbbbb;
@property (nonatomic,copy) refrashBtnBlock block;
@end

NS_ASSUME_NONNULL_END
