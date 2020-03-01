//
//  MusicHeaderView.h
//  iphoneLive
//
//  Created by YunBao on 2018/7/28.
//  Copyright © 2018年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MusicHeaderBlock)(NSString *type,NSString *title);
typedef void (^MusicSegBlock)(NSString *type); //热门-收藏点击回调

@interface MusicHeaderView : UIView

@property(nonatomic,copy)MusicHeaderBlock headerEvent;
@property(nonatomic,copy)MusicSegBlock segEvent;

- (instancetype)initWithFrame:(CGRect)frame withBlock:(MusicHeaderBlock)callBack;

@end
