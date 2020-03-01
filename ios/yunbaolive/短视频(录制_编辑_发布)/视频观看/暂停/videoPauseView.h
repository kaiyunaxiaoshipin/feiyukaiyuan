//
//  videoPauseView.h
//  iphoneLive
//
//  Created by Boom on 2017/12/14.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol videoPauseDelegate <NSObject>
- (void)goPlay;

@end

@interface videoPauseView : UIView<UIAlertViewDelegate>
@property(nonatomic,assign) id<videoPauseDelegate> delegate;
@property (nonatomic,strong) NSString *fromWhere;
-(instancetype)initWithFrame:(CGRect)frame andVideoMsg:(NSDictionary *)videoDic;

@end
