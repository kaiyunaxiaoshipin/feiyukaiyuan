//
//  allClassView.h
//  yunbaolive
//
//  Created by Boom on 2018/9/22.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^liveClassClick)(NSDictionary *dic);

@interface allClassView : UIView
@property (nonatomic,copy) liveClassClick block;
- (void)showWhiteView;
@end

NS_ASSUME_NONNULL_END
