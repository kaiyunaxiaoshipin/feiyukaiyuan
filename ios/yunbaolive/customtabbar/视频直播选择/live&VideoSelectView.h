//
//  live&VideoSelectView.h
//  yunbaolive
//
//  Created by Boom on 2018/11/3.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol liveVideoDelegate <NSObject>
- (void)clickLive:(BOOL)islive;
- (void)hideSelctView;
@end

@interface live_VideoSelectView : UIView
@property (nonatomic,weak) id<liveVideoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
