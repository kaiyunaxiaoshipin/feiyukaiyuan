//
//  linkAlertView.h
//  yunbaolive
//
//  Created by Boom on 2018/10/29.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^linkAlertBlock)(BOOL isAgree);


@interface linkAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame andUserMsg:(NSDictionary *)dic;
@property (nonatomic,copy) linkAlertBlock block;
@property (nonatomic,copy) UILabel *timeL;
- (void)show;

@end

NS_ASSUME_NONNULL_END
