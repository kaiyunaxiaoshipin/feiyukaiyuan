//
//  tuijianwindow.h
//  iphoneLive
//
//  Created by 王敏欣 on 2017/5/17.
//  Copyright © 2017年 cat. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol tuijian <NSObject>
-(void)jump;

@end

@interface tuijianwindow : UIWindow


@property(nonatomic,assign)id<tuijian>delegate;

-(instancetype)initWithFrame:(CGRect)frame;

@end
