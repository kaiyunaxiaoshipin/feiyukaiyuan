//
//  redListView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/16.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "redListCell.h"
@protocol redListViewDelegate <NSObject>
- (void)removeShouhuView;
@end

NS_ASSUME_NONNULL_BEGIN

@interface redListView : UIView<UITableViewDelegate,UITableViewDataSource,redListCellDelegate>
- (instancetype)initWithFrame:(CGRect)frame withZHuboMsg:(NSDictionary *)dic;
@property(nonatomic,assign)id<redListViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
