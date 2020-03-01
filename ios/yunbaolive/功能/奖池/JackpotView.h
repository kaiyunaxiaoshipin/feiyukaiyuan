//
//  JackpotView.h
//  yunbaolive
//
//  Created by IOS1 on 2019/4/27.
//  Copyright © 2019 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JackpotViewDelegate <NSObject>

- (void)jackpotViewClose;

@end
@interface JackpotView : UIView
@property (weak, nonatomic) IBOutlet UILabel *levelL;
@property (weak, nonatomic) IBOutlet UILabel *coinL;
@property (nonatomic,weak) id<JackpotViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
