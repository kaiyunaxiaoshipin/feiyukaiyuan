//
//  redBagView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sendRedSuccess)(NSString *type);
NS_ASSUME_NONNULL_BEGIN

@interface redBagView : UIView<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic,strong) NSDictionary *zhuboDic;
@property (nonatomic,copy) sendRedSuccess block;
@end

NS_ASSUME_NONNULL_END
