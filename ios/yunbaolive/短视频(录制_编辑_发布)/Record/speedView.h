//
//  speedView.h
//  yunbaolive
//
//  Created by Boom on 2018/12/6.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^speedBlock)(int type);

NS_ASSUME_NONNULL_BEGIN

@interface speedView : UIView
@property(nonatomic,copy)speedBlock block;

@end

NS_ASSUME_NONNULL_END
