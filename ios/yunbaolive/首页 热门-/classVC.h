//
//  classVC.h
//  yunbaolive
//
//  Created by Boom on 2018/9/22.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface classVC : UIViewController

/**
 标题
 */
@property (nonatomic,copy)NSString *titleStr;

/**
 分类ID
 */
@property (nonatomic,copy)NSString *classID;
@end

NS_ASSUME_NONNULL_END
