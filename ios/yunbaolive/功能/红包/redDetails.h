//
//  redDetails.h
//  yunbaolive
//
//  Created by Boom on 2018/11/19.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface redDetails : UIView<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithFrame:(CGRect)frame withZHuboMsg:(NSDictionary *)dic andRedID:(NSString *)redid;

@end

NS_ASSUME_NONNULL_END
